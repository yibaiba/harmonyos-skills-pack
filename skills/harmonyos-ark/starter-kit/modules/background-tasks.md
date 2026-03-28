# 后台任务模块

> 覆盖：短时任务 / 长时任务 / 延迟任务 / 选型决策 / 后台限制策略

> 来源：HarmonyOS V5 (API 12) Background Tasks Kit 官方文档

## 任务类型选择决策表

| 场景 | 推荐方案 | 存活时间 | 示例 |
|------|---------|---------|------|
| 页面退后台仍需短暂完成的操作 | 短时任务 | ~3 分钟 | 保存草稿、上传小文件 |
| 需要持续运行的前台可感知服务 | 长时任务 | 无限制（有通知） | 音乐播放、导航、文件下载 |
| 非实时性的定期执行任务 | 延迟任务 | 系统调度 | 数据同步、日志上报、缓存清理 |
| 精准定时触发 | 提醒代理 | 系统唤醒 | 闹钟、定时提醒 |

## 一、短时任务（requestSuspendDelay）

```typescript
// utils/ShortTaskUtil.ets
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'ShortTask'

export class ShortTaskUtil {
  private static delayInfo: backgroundTaskManager.DelaySuspendInfo | null = null

  /**
   * 申请短时任务 — 在即将退后台时调用
   * 典型场景：onBackground 中保存数据、完成网络请求
   */
  static requestDelay(context: Context, callback: () => Promise<void>): void {
    try {
      ShortTaskUtil.delayInfo = backgroundTaskManager.requestSuspendDelay(
        '数据保存任务',
        () => {
          // 超时回调 — 系统即将挂起，必须立即清理
          hilog.warn(0x0000, TAG, '短时任务即将超时，执行清理')
          ShortTaskUtil.cancel()
        }
      )
      hilog.info(0x0000, TAG, '短时任务已申请，剩余时间: %{public}d ms',
        ShortTaskUtil.delayInfo.actualDelayTime)

      // 执行实际任务
      callback().then(() => {
        ShortTaskUtil.cancel()
      }).catch(() => {
        ShortTaskUtil.cancel()
      })
    } catch (e) {
      hilog.error(0x0000, TAG, '申请短时任务失败: %{public}s', JSON.stringify(e))
    }
  }

  /** 查询剩余时间 */
  static async getRemainingTime(): Promise<number> {
    if (!ShortTaskUtil.delayInfo) return 0
    return await backgroundTaskManager.getRemainingDelayTime(ShortTaskUtil.delayInfo.requestId)
  }

  /** 取消短时任务 */
  static cancel(): void {
    if (ShortTaskUtil.delayInfo) {
      backgroundTaskManager.cancelSuspendDelay(ShortTaskUtil.delayInfo.requestId)
      ShortTaskUtil.delayInfo = null
      hilog.info(0x0000, TAG, '短时任务已取消')
    }
  }
}
```

### 在 UIAbility 中使用

```typescript
// entryability/EntryAbility.ets — onBackground 片段
import { ShortTaskUtil } from '../utils/ShortTaskUtil'

export default class EntryAbility extends UIAbility {
  onBackground(): void {
    ShortTaskUtil.requestDelay(this.context, async () => {
      // 保存草稿、flush 缓存等
      await this.saveDraft()
    })
  }
}
```

## 二、长时任务（startBackgroundRunning）

```typescript
// service/MusicBackgroundService.ets
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { wantAgent, WantAgent } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'BgMusic'

export class MusicBackgroundService {
  /**
   * 启动长时任务 — 音乐播放场景
   * 前提：module.json5 中声明 backgroundModes
   */
  static async start(context: Context): Promise<void> {
    // 构建点击通知后的跳转意图
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [{
        bundleName: context.abilityInfo.bundleName,
        abilityName: 'EntryAbility'
      }],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    }
    const agent: WantAgent = await wantAgent.getWantAgent(wantAgentInfo)

    await backgroundTaskManager.startBackgroundRunning(context, {
      bgMode: backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,
      wantAgent: agent
    })
    hilog.info(0x0000, TAG, '长时任务已启动：音频播放模式')
  }

  /** 停止长时任务 */
  static async stop(context: Context): Promise<void> {
    await backgroundTaskManager.stopBackgroundRunning(context)
    hilog.info(0x0000, TAG, '长时任务已停止')
  }
}
```

### module.json5 配置（必须）

```json5
// module.json5 — abilities 节点
{
  "abilities": [{
    "name": "EntryAbility",
    "backgroundModes": ["audioPlayback"]
  }]
}
```

### BackgroundMode 枚举一览

| bgMode | module.json5 值 | 典型场景 |
|--------|----------------|---------|
| DATA_TRANSFER | dataTransfer | 文件上传/下载 |
| AUDIO_PLAYBACK | audioPlayback | 音乐/有声书播放 |
| AUDIO_RECORDING | audioRecording | 录音 |
| LOCATION | location | 导航/运动轨迹 |
| BLUETOOTH_INTERACTION | bluetoothInteraction | 蓝牙设备通信 |
| MULTI_DEVICE_CONNECTION | multiDeviceConnection | 跨设备协同 |

## 三、延迟任务（WorkScheduler）

```typescript
// scheduler/SyncWorkScheduler.ets
import { workScheduler } from '@kit.BackgroundTasksKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'WorkScheduler'
const SYNC_WORK_ID = 1001

export class SyncWorkScheduler {
  /** 注册延迟任务 — 数据同步 */
  static register(): void {
    const workInfo: workScheduler.WorkInfo = {
      workId: SYNC_WORK_ID,
      bundleName: 'com.example.myapp',
      abilityName: 'SyncWorkAbility',
      isPersisted: true,        // 重启后保留
      isRepeat: true,           // 重复执行
      repeatCycleTime: 30 * 60 * 1000, // 最短 30 分钟
      networkType: workScheduler.NetworkType.NETWORK_TYPE_ANY,
      chargerType: workScheduler.ChargingType.CHARGING_PLUGGED_ANY,
      batteryLevel: 20          // 电量 > 20% 时才执行
    }

    try {
      workScheduler.startWork(workInfo)
      hilog.info(0x0000, TAG, '延迟任务已注册')
    } catch (e) {
      hilog.error(0x0000, TAG, '注册失败: %{public}s', JSON.stringify(e))
    }
  }

  /** 取消延迟任务 */
  static cancel(): void {
    workScheduler.stopWork({ workId: SYNC_WORK_ID } as workScheduler.WorkInfo, false)
  }

  /** 查询任务状态 */
  static async isRunning(): Promise<boolean> {
    try {
      return await workScheduler.isLastWorkTimeOut(SYNC_WORK_ID)
    } catch {
      return false
    }
  }
}
```

### WorkSchedulerExtensionAbility（任务执行入口）

```typescript
// abilities/SyncWorkAbility.ets
import { WorkSchedulerExtensionAbility, workScheduler } from '@kit.BackgroundTasksKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

export default class SyncWorkAbility extends WorkSchedulerExtensionAbility {
  onWorkStart(work: workScheduler.WorkInfo): void {
    hilog.info(0x0000, 'SyncWork', '延迟任务开始执行, workId=%{public}d', work.workId)
    // 执行数据同步逻辑
    this.doSync()
  }

  onWorkStop(work: workScheduler.WorkInfo): void {
    hilog.info(0x0000, 'SyncWork', '延迟任务被终止, workId=%{public}d', work.workId)
  }

  private async doSync(): Promise<void> {
    // 实际的数据同步逻辑
  }
}
```

## 后台限制策略约束

| 约束 | 说明 |
|------|------|
| 短时任务时长 | 通常 ~180 秒，低电量时可能缩短 |
| 长时任务通知 | 系统强制显示前台通知，不可隐藏 |
| 长时任务审核 | 审核时需说明 backgroundMode 的合理性 |
| 延迟任务最小间隔 | repeatCycleTime ≥ 30 分钟 |
| 延迟任务执行窗口 | 系统根据电量/网络/空闲状态统一调度，不保证精确时间 |
| 同时运行上限 | 每个应用最多 10 个延迟任务 |

## 常见陷阱

| 陷阱 | 说明 | 正确做法 |
|------|------|---------|
| 短时任务中做耗时操作 | 超过剩余时间被强制挂起 | 先 getRemainingTime 判断，超时前保存进度 |
| 忘记取消短时任务 | 浪费系统配额 | 任务完成后立即 cancel |
| 长时任务未声明 backgroundModes | 运行时 crash | module.json5 必须声明对应 mode |
| 延迟任务当定时器用 | 期望精确触发但实际延迟很大 | 延迟任务是"条件满足时执行"，非定时器 |
| 后台播放未持有音频焦点 | 被系统回收 | 配合 AVSession 管理焦点 |

## 官方参考
- 短时任务: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/transient-task
- 长时任务: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/continuous-task
- 延迟任务: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/work-scheduler

---

## See Also

- [Background Tasks Kit](../../topics/background-tasks-kit.md)
- [通知处理](notification-handling.md)
- [通知 Kit](../../topics/notification-kit.md)
