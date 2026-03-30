# 通知处理模块

> 覆盖：通知权限申请 / 基础文本通知 / 进度条通知 / 按钮交互通知 / 渠道管理 / 角标更新

> 来源：HarmonyOS V5 (API 12) Notification Kit 官方文档

## 一、通知权限申请

```typescript
// utils/NotificationUtil.ets
import { notificationManager } from '@kit.NotificationKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'Notification'

export class NotificationUtil {
  /** 检查并申请通知权限 */
  static async requestPermission(): Promise<boolean> {
    try {
      const granted = await notificationManager.isNotificationEnabled()
      if (granted) return true
      // 拉起系统授权弹窗
      await notificationManager.requestEnableNotification()
      return true
    } catch (e) {
      hilog.warn(0x0000, TAG, '通知权限申请失败或被拒绝: %{public}s', JSON.stringify(e))
      return false
    }
  }

  /** 检查是否已授权 */
  static async isEnabled(): Promise<boolean> {
    try {
      return await notificationManager.isNotificationEnabled()
    } catch {
      return false
    }
  }
}
```

## 二、基础文本通知

```typescript
// 发送普通文本通知
import { notificationManager } from '@kit.NotificationKit'

export async function sendTextNotification(
  id: number,
  title: string,
  text: string
): Promise<void> {
  const request: notificationManager.NotificationRequest = {
    id: id,
    content: {
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: {
        title: title,
        text: text,
        additionalText: ''
      }
    },
    notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION
  }
  await notificationManager.publish(request)
}

// 使用示例
// await sendTextNotification(1001, '新消息', '你收到了一条新的聊天消息')
```

## 三、进度条通知

```typescript
// 文件下载进度通知
import { notificationManager } from '@kit.NotificationKit'

const DOWNLOAD_NOTIFY_ID = 2001

export class DownloadNotification {
  /** 发送进度通知 */
  static async updateProgress(
    fileName: string,
    current: number,
    total: number
  ): Promise<void> {
    const percent = Math.floor((current / total) * 100)
    const request: notificationManager.NotificationRequest = {
      id: DOWNLOAD_NOTIFY_ID,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: `正在下载：${fileName}`,
          text: `${percent}%`,
          additionalText: `${(current / 1024 / 1024).toFixed(1)}MB / ${(total / 1024 / 1024).toFixed(1)}MB`
        }
      },
      notificationSlotType: notificationManager.SlotType.CONTENT_INFORMATION
    }
    await notificationManager.publish(request)
  }

  /** 下载完成通知 */
  static async complete(fileName: string): Promise<void> {
    const request: notificationManager.NotificationRequest = {
      id: DOWNLOAD_NOTIFY_ID,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '下载完成',
          text: fileName,
          additionalText: '点击查看'
        }
      },
      notificationSlotType: notificationManager.SlotType.CONTENT_INFORMATION
    }
    await notificationManager.publish(request)
  }

  /** 取消下载通知 */
  static async cancel(): Promise<void> {
    await notificationManager.cancel(DOWNLOAD_NOTIFY_ID)
  }
}
```

## 四、按钮交互通知（WantAgent）

```typescript
// 带操作按钮的通知 — 点击跳转到指定页面
import { notificationManager } from '@kit.NotificationKit'
import { wantAgent, WantAgent } from '@kit.AbilityKit'

export async function sendActionNotification(
  context: Context,
  id: number,
  title: string,
  text: string,
  targetPage: string
): Promise<void> {
  // 构建点击通知后的跳转意图
  const agentInfo: wantAgent.WantAgentInfo = {
    wants: [{
      bundleName: context.abilityInfo.bundleName,
      abilityName: 'EntryAbility',
      parameters: { targetPage: targetPage }
    }],
    actionType: wantAgent.OperationType.START_ABILITY,
    requestCode: 0,
    actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  }
  const agent: WantAgent = await wantAgent.getWantAgent(agentInfo)

  const request: notificationManager.NotificationRequest = {
    id: id,
    content: {
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: {
        title: title,
        text: text,
        additionalText: ''
      }
    },
    notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
    wantAgent: agent
  }
  await notificationManager.publish(request)
}

// 在 EntryAbility.onCreate 中接收参数并路由
// const targetPage = want?.parameters?.targetPage as string
// if (targetPage) navStack.pushPath({ name: targetPage })
```

## 五、通知渠道管理

```typescript
// 创建自定义通知渠道（Slot）
import { notificationManager } from '@kit.NotificationKit'

export async function setupNotificationSlots(): Promise<void> {
  // 聊天消息渠道 — 高优先级，弹窗+声音
  const chatSlot: notificationManager.NotificationSlot = {
    notificationType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
    level: notificationManager.SlotLevel.LEVEL_HIGH,
    vibrationEnabled: true,
    sound: ''  // 使用系统默认音效
  }

  // 内容推送渠道 — 低优先级，仅通知栏
  const contentSlot: notificationManager.NotificationSlot = {
    notificationType: notificationManager.SlotType.CONTENT_INFORMATION,
    level: notificationManager.SlotLevel.LEVEL_LOW,
    vibrationEnabled: false
  }

  await notificationManager.addSlot(chatSlot)
  await notificationManager.addSlot(contentSlot)
}

// 在 EntryAbility.onCreate 中调用
// await setupNotificationSlots()
```

## 六、角标更新

```typescript
// 更新桌面图标角标数字
import { notificationManager } from '@kit.NotificationKit'

export async function updateBadge(count: number): Promise<void> {
  await notificationManager.setBadgeNumber(count)
}

// 清除角标
export async function clearBadge(): Promise<void> {
  await notificationManager.setBadgeNumber(0)
}

// 使用场景：
// 收到新消息时 — await updateBadge(unreadCount)
// 用户进入消息页 — await clearBadge()
```

## 通知类型选择表

| 场景 | ContentType | SlotType | 说明 |
|------|------------|----------|------|
| 聊天消息 | BASIC_TEXT | SOCIAL_COMMUNICATION | 弹窗 + 声音 + 震动 |
| 系统公告 | BASIC_TEXT | SERVICE_INFORMATION | 静默通知栏 |
| 下载进度 | BASIC_TEXT | CONTENT_INFORMATION | 低优先级进度 |
| 运营推送 | BASIC_TEXT | CONTENT_INFORMATION | 不打扰用户 |
| 长时任务状态 | BASIC_TEXT | OTHER_TYPES | 系统强制显示 |

## 常见陷阱

| 陷阱 | 说明 | 正确做法 |
|------|------|---------|
| 不检查通知权限 | publish 静默失败，无任何提示 | 发通知前先 requestPermission |
| 相同 id 覆盖通知 | 多次 publish 同一 id 只显示最新 | 需多条通知时使用不同 id |
| SlotType 不匹配 | 渠道优先级影响通知展示行为 | 按场景选择正确的 SlotType |
| 角标不清零 | 用户进入 app 后角标仍显示 | 在首页 aboutToAppear 中 clearBadge |
| 通知过多被限频 | 系统限制同一应用短时间通知数 | 合并同类通知，控制发送频率 |
| 审核被拒 | 滥用通知权限 | 仅在用户明确预期时发送通知 |

## 官方参考
- 通知概述: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/notification-overview
- NotificationManager: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-notificationmanager
- WantAgent: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-wantagent

---

## See Also

- [Notification Kit](../../topics/notification-kit.md)
- [后台任务](background-tasks.md)
- [Background Tasks Kit](../../topics/background-tasks-kit.md)
