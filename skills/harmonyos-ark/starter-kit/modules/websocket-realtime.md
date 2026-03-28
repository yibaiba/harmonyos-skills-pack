# 实时通信模块

> 覆盖：WebSocket 连接管理 / 自动重连（指数退避）/ 心跳保活 / 离线消息缓存 / 完整管理器类

> 来源：HarmonyOS V5 (API 12) Net Kit WebSocket 官方文档

## 完整 WebSocket 管理器

```typescript
// network/WebSocketManager.ets
import { webSocket } from '@kit.NetworkKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'WebSocket'

/** 连接状态 */
export enum WSState {
  DISCONNECTED = 'disconnected',
  CONNECTING = 'connecting',
  CONNECTED = 'connected',
  RECONNECTING = 'reconnecting'
}

/** 消息回调类型 */
export type WSMessageCallback = (data: string | ArrayBuffer) => void
export type WSStateCallback = (state: WSState) => void

/** 重连配置 */
interface ReconnectConfig {
  maxRetries: number       // 最大重试次数
  baseDelay: number        // 基础延迟（毫秒）
  maxDelay: number         // 最大延迟（毫秒）
}

const DEFAULT_RECONNECT: ReconnectConfig = {
  maxRetries: 10,
  baseDelay: 1000,
  maxDelay: 30000
}

/** 心跳配置 */
interface HeartbeatConfig {
  interval: number         // 心跳间隔（毫秒）
  timeout: number          // 响应超时（毫秒）
  message: string          // 心跳消息体
}

const DEFAULT_HEARTBEAT: HeartbeatConfig = {
  interval: 30000,
  timeout: 10000,
  message: '{"type":"ping"}'
}

@ObservedV2
export class WebSocketManager {
  @Trace state: WSState = WSState.DISCONNECTED

  private ws: webSocket.WebSocket | null = null
  private url: string = ''
  private retryCount: number = 0
  private reconnectTimer: number = -1
  private heartbeatTimer: number = -1
  private heartbeatTimeoutTimer: number = -1
  private reconnectConfig: ReconnectConfig
  private heartbeatConfig: HeartbeatConfig

  // 回调
  private onMessage: WSMessageCallback | null = null
  private onStateChange: WSStateCallback | null = null

  // 离线消息队列
  private offlineQueue: string[] = []
  private static readonly MAX_QUEUE_SIZE = 100

  constructor(
    reconnect?: Partial<ReconnectConfig>,
    heartbeat?: Partial<HeartbeatConfig>
  ) {
    this.reconnectConfig = { ...DEFAULT_RECONNECT, ...reconnect }
    this.heartbeatConfig = { ...DEFAULT_HEARTBEAT, ...heartbeat }
  }

  /** 注册消息回调 */
  setOnMessage(callback: WSMessageCallback): void {
    this.onMessage = callback
  }

  /** 注册状态变更回调 */
  setOnStateChange(callback: WSStateCallback): void {
    this.onStateChange = callback
  }

  /** 建立连接 */
  async connect(url: string): Promise<void> {
    this.url = url
    this.updateState(WSState.CONNECTING)

    this.ws = webSocket.createWebSocket()
    this.setupListeners()

    try {
      await this.ws.connect(url)
    } catch (e) {
      hilog.error(0x0000, TAG, '连接失败: %{public}s', JSON.stringify(e))
      this.scheduleReconnect()
    }
  }

  /** 发送消息 — 离线时自动入队 */
  send(data: string): boolean {
    if (this.state === WSState.CONNECTED && this.ws) {
      try {
        this.ws.send(data)
        return true
      } catch (e) {
        hilog.error(0x0000, TAG, '发送失败: %{public}s', JSON.stringify(e))
        this.enqueue(data)
        return false
      }
    }
    this.enqueue(data)
    return false
  }

  /** 主动断开 — 不触发重连 */
  close(): void {
    this.stopHeartbeat()
    this.clearReconnectTimer()
    this.retryCount = this.reconnectConfig.maxRetries // 阻止重连
    if (this.ws) {
      try {
        this.ws.close()
      } catch {
        // 忽略关闭异常
      }
      this.ws = null
    }
    this.updateState(WSState.DISCONNECTED)
  }

  /** 获取离线消息队列（只读） */
  getOfflineQueue(): readonly string[] {
    return this.offlineQueue
  }

  // ─── 内部方法 ─────────────────────────────────────

  private setupListeners(): void {
    if (!this.ws) return

    this.ws.on('open', () => {
      hilog.info(0x0000, TAG, '连接已建立')
      this.retryCount = 0
      this.updateState(WSState.CONNECTED)
      this.startHeartbeat()
      this.flushOfflineQueue()
    })

    this.ws.on('message', (err, data) => {
      if (err) {
        hilog.error(0x0000, TAG, '消息接收错误: %{public}s', JSON.stringify(err))
        return
      }
      // 心跳响应处理
      if (typeof data === 'string' && data.includes('"pong"')) {
        this.onPongReceived()
        return
      }
      this.onMessage?.(data)
    })

    this.ws.on('close', () => {
      hilog.info(0x0000, TAG, '连接已关闭')
      this.stopHeartbeat()
      this.scheduleReconnect()
    })

    this.ws.on('error', (err) => {
      hilog.error(0x0000, TAG, '连接错误: %{public}s', JSON.stringify(err))
      this.stopHeartbeat()
      this.scheduleReconnect()
    })
  }

  // ─── 自动重连（指数退避） ──────────────────────────

  private scheduleReconnect(): void {
    if (this.retryCount >= this.reconnectConfig.maxRetries) {
      hilog.warn(0x0000, TAG, '已达最大重连次数，停止重连')
      this.updateState(WSState.DISCONNECTED)
      return
    }

    this.updateState(WSState.RECONNECTING)
    // 指数退避：delay = min(baseDelay * 2^retry, maxDelay) + 随机抖动
    const delay = Math.min(
      this.reconnectConfig.baseDelay * Math.pow(2, this.retryCount),
      this.reconnectConfig.maxDelay
    )
    const jitter = Math.random() * 1000
    const finalDelay = delay + jitter

    hilog.info(0x0000, TAG, '第 %{public}d 次重连，%{public}d ms 后执行',
      this.retryCount + 1, Math.floor(finalDelay))

    this.reconnectTimer = setTimeout(async () => {
      this.retryCount++
      await this.connect(this.url)
    }, finalDelay)
  }

  private clearReconnectTimer(): void {
    if (this.reconnectTimer !== -1) {
      clearTimeout(this.reconnectTimer)
      this.reconnectTimer = -1
    }
  }

  // ─── 心跳保活 ─────────────────────────────────────

  private startHeartbeat(): void {
    this.stopHeartbeat()
    this.heartbeatTimer = setInterval(() => {
      this.sendPing()
    }, this.heartbeatConfig.interval)
  }

  private sendPing(): void {
    if (this.state !== WSState.CONNECTED) return
    try {
      this.ws?.send(this.heartbeatConfig.message)
      // 启动超时检测
      this.heartbeatTimeoutTimer = setTimeout(() => {
        hilog.warn(0x0000, TAG, '心跳超时，触发重连')
        this.ws?.close()
      }, this.heartbeatConfig.timeout)
    } catch {
      hilog.error(0x0000, TAG, '心跳发送失败')
    }
  }

  private onPongReceived(): void {
    if (this.heartbeatTimeoutTimer !== -1) {
      clearTimeout(this.heartbeatTimeoutTimer)
      this.heartbeatTimeoutTimer = -1
    }
  }

  private stopHeartbeat(): void {
    if (this.heartbeatTimer !== -1) {
      clearInterval(this.heartbeatTimer)
      this.heartbeatTimer = -1
    }
    if (this.heartbeatTimeoutTimer !== -1) {
      clearTimeout(this.heartbeatTimeoutTimer)
      this.heartbeatTimeoutTimer = -1
    }
  }

  // ─── 离线消息队列 ──────────────────────────────────

  private enqueue(data: string): void {
    if (this.offlineQueue.length >= WebSocketManager.MAX_QUEUE_SIZE) {
      this.offlineQueue.shift() // 丢弃最早的消息
    }
    this.offlineQueue.push(data)
  }

  private flushOfflineQueue(): void {
    while (this.offlineQueue.length > 0) {
      const msg = this.offlineQueue.shift()!
      this.send(msg)
    }
    hilog.info(0x0000, TAG, '离线消息队列已清空')
  }

  // ─── 状态管理 ──────────────────────────────────────

  private updateState(newState: WSState): void {
    if (this.state !== newState) {
      this.state = newState
      this.onStateChange?.(newState)
    }
  }
}
```

## 页面中使用示例

```typescript
// pages/ChatPage.ets
import { WebSocketManager, WSState } from '../network/WebSocketManager'

@Entry
@Component
struct ChatPage {
  private wsManager = new WebSocketManager(
    { maxRetries: 5, baseDelay: 2000 },
    { interval: 20000 }
  )
  @State messages: string[] = []
  @State connectionState: WSState = WSState.DISCONNECTED

  aboutToAppear(): void {
    this.wsManager.setOnMessage((data) => {
      if (typeof data === 'string') {
        this.messages.push(data)
      }
    })
    this.wsManager.setOnStateChange((state) => {
      this.connectionState = state
    })
    this.wsManager.connect('wss://example.com/ws/chat')
  }

  aboutToDisappear(): void {
    this.wsManager.close()
  }

  build() {
    Column() {
      // 连接状态指示
      Row() {
        Circle({ width: 8, height: 8 })
          .fill(this.connectionState === WSState.CONNECTED ? Color.Green : Color.Red)
        Text(this.connectionState)
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
          .margin({ left: 4 })
      }.padding(8)

      // 消息列表
      List({ space: 8 }) {
        ForEach(this.messages, (msg: string, index: number) => {
          ListItem() {
            Text(msg).fontSize(14).padding(12)
          }
        }, (msg: string, index: number) => `${index}_${msg}`)
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
  }
}
```

## 常见陷阱

| 陷阱 | 说明 | 正确做法 |
|------|------|---------|
| 页面退出未关闭连接 | 内存泄漏 + 无效重连 | aboutToDisappear 中调用 close() |
| 无心跳机制 | 运营商 NAT 超时断连（通常 60s） | 30s 内发一次心跳 |
| 重连无上限 | 服务器宕机时疯狂重连 | 设置 maxRetries 并使用指数退避 |
| 离线队列无限增长 | 长时间离线导致 OOM | 限制队列长度，丢弃旧消息 |
| 未处理 ArrayBuffer | 二进制消息被忽略 | onMessage 回调区分 string / ArrayBuffer |
| 明文 ws:// 协议 | 不安全 + 审核风险 | 生产环境必须使用 wss:// |

## 官方参考
- WebSocket: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-websocket
- Net Kit 概述: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/net-overview

---

## See Also

- [网络数据](../../topics/network-data-network.md)
- [通用模式](../snippets/common-patterns.md)
- [状态管理](../../topics/state-management.md)
