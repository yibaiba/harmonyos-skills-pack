# HarmonyOS ACL 受限权限申请指南

<!-- Agent 摘要：~280 行。ACL 权限完整列表、申请流程、module.json5 配置、替代方案建议、审核避坑。搜索: ACL permission restricted system_basic AGC 受限权限。 -->

> **⚠️ Agent 行为规范（MUST READ）**
>
> 当用户需求涉及可能需要 ACL 权限的功能时，Agent **必须**遵循以下流程：
>
> 1. **先询问**：告知用户该功能需要 ACL 受限权限，说明申请成本（AGC 审批 1-2 天、审核风险）
> 2. **推荐替代方案**：优先推荐 Picker / 安全控件等无需 ACL 的实现方式（见下方决策树）
> 3. **确认后再用 ACL**：仅当用户明确表示替代方案不满足需求时，才采用 ACL 权限方案
>
> **禁止**：未经用户确认直接在代码中添加 system_basic 级权限声明。

## 什么是 ACL

ACL（Access Control List，访问控制列表）是鸿蒙权限管控的核心机制。**普通应用（normal 级别）**默认无法使用 **system_basic** 级别的敏感权限，必须通过 ACL 机制向华为 AGC 平台申请审批后才能使用。

**关键原则**：华为鼓励优先使用系统 Picker / 安全控件等替代方案，仅在确实无替代时才申请 ACL 权限。

## 权限等级体系

| 等级 | 说明 | 申请方式 |
|------|------|----------|
| **normal** | 普通权限，风险低 | module.json5 声明即可，无需 ACL |
| **system_basic** | 敏感权限，需 ACL | AGC 申请审批 + Profile 签名 |
| **system_core** | 系统核心权限 | 仅系统应用，第三方应用不可申请 |

## 需要 ACL 申请的常见权限

### 📸 媒体与文件类

| 权限 | 授权方式 | 场景 | 替代方案 |
|------|----------|------|----------|
| `ohos.permission.READ_IMAGEVIDEO` | user_grant | 读取图片/视频 | **PhotoViewPicker**（推荐） |
| `ohos.permission.WRITE_IMAGEVIDEO` | user_grant | 写入图片/视频 | **PhotoViewPicker**（推荐） |
| `ohos.permission.READ_AUDIO` | user_grant | 读取音频文件 | **AudioViewPicker**（推荐） |
| `ohos.permission.WRITE_AUDIO` | user_grant | 写入音频文件 | **AudioViewPicker**（推荐） |
| `ohos.permission.READ_DOCUMENT` | user_grant | 读取文档文件 | **DocumentViewPicker**（推荐） |
| `ohos.permission.WRITE_DOCUMENT` | user_grant | 写入文档文件 | **DocumentViewPicker**（推荐） |
| `ohos.permission.READ_MEDIA` | user_grant | 读取公共媒体目录 | 安全控件 / Picker |
| `ohos.permission.WRITE_MEDIA` | user_grant | 写入公共媒体目录 | 安全控件 / Picker |
| `ohos.permission.MEDIA_LOCATION` | user_grant | 读取媒体地理位置 | 无替代 |

> ⚠️ **审核重点**：仅克隆/备份/同步类 App 才被允许申请 READ/WRITE_IMAGEVIDEO，普通展示/编辑场景必须用 Picker。

### 📞 通讯类

| 权限 | 授权方式 | 场景 | 替代方案 |
|------|----------|------|----------|
| `ohos.permission.READ_CONTACTS` | user_grant | 读取联系人 | 系统联系人选择器 |
| `ohos.permission.WRITE_CONTACTS` | user_grant | 写入联系人 | — |
| `ohos.permission.READ_CALL_LOG` | user_grant | 读取通话记录 | — |
| `ohos.permission.WRITE_CALL_LOG` | user_grant | 写入通话记录 | — |
| `ohos.permission.SEND_MESSAGES` | user_grant | 发送短信 | — |
| `ohos.permission.RECEIVE_WAP_MESSAGES` | user_grant | 接收 WAP 消息 | — |
| `ohos.permission.PLACE_CALL` | system_grant | 拨打电话 | — |
| `ohos.permission.GET_TELEPHONY_STATE` | system_grant | 读取电话状态 | — |

### 🪟 系统能力类

| 权限 | 授权方式 | 场景 | 替代方案 |
|------|----------|------|----------|
| `ohos.permission.SYSTEM_FLOAT_WINDOW` | system_grant | 悬浮窗 | 无替代（需强业务理由） |
| `ohos.permission.READ_PASTEBOARD` | system_grant | 读取剪贴板 | **粘贴控件** PasteButton（推荐） |
| `ohos.permission.PRIVACY_WINDOW` | system_grant | 隐私窗口/脱敏 | — |
| `ohos.permission.CUSTOM_SCREEN_CAPTURE` | system_grant | 自定义截屏 | — |
| `ohos.permission.CUSTOM_SCREEN_RECORDING` | system_grant | 自定义录屏 | — |

### 🌐 网络与分布式

| 权限 | 授权方式 | 场景 | 替代方案 |
|------|----------|------|----------|
| `ohos.permission.DISTRIBUTED_DATASYNC` | user_grant | 跨设备数据同步 | — |
| `ohos.permission.GET_WIFI_INFO` | system_grant | 获取 WiFi 信息 | — |

### 📍 位置（补充说明）

| 权限 | 授权方式 | 说明 |
|------|----------|------|
| `ohos.permission.LOCATION` | user_grant | 精确定位（normal 级，无需 ACL） |
| `ohos.permission.APPROXIMATELY_LOCATION` | user_grant | 模糊定位（normal 级，无需 ACL） |
| `ohos.permission.LOCATION_IN_BACKGROUND` | user_grant | 后台定位（**需 ACL**） |

> 注：LOCATION 和 APPROXIMATELY_LOCATION 本身是 normal 级，不需要 ACL。但 LOCATION_IN_BACKGROUND 是 system_basic 级，需要 ACL 申请。

## 不需要 ACL 的常见权限（normal 级）

以下权限在 module.json5 中声明即可使用，无需额外申请：

| 权限 | 场景 |
|------|------|
| `ohos.permission.INTERNET` | 网络访问（几乎所有 App 需要） |
| `ohos.permission.CAMERA` | 相机（user_grant，但 normal 级） |
| `ohos.permission.MICROPHONE` | 麦克风 |
| `ohos.permission.LOCATION` | 精确定位 |
| `ohos.permission.APPROXIMATELY_LOCATION` | 模糊定位 |
| `ohos.permission.KEEP_BACKGROUND_RUNNING` | 后台运行 |
| `ohos.permission.VIBRATE` | 震动 |
| `ohos.permission.ACCESS_NOTIFICATION_POLICY` | 通知策略 |

## ACL 申请流程

```
确认需要 ACL 权限（无替代方案）
    ↓
① AGC 平台创建项目 + 生成 APP ID
    ↓
② 生成签名证书（p12 + csr）
    ↓
③ 提交 ACL 申请
   - 在 AGC → 我的项目 → 管理 ACL 权限
   - 或发送邮件至 agconnect@huawei.com
   - 包含：应用包名、APP ID、权限名称、使用场景详细描述
    ↓
④ 审核通过（1-2 个工作日）
    ↓
⑤ 在 Profile 签名中勾选已批准的受限权限
    ↓
⑥ 下载带 ACL 的 Profile
    ↓
⑦ 在 module.json5 中声明权限
    ↓
⑧ 代码中动态请求（user_grant 类型）
```

## module.json5 配置

```json
{
  "module": {
    "requestPermissions": [
      {
        "name": "ohos.permission.INTERNET"
      },
      {
        "name": "ohos.permission.CAMERA",
        "reason": "$string:camera_reason",
        "usedScene": {
          "abilities": ["EntryAbility"],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.READ_IMAGEVIDEO",
        "reason": "$string:read_image_reason",
        "usedScene": {
          "abilities": ["EntryAbility"],
          "when": "inuse"
        }
      }
    ]
  }
}
```

**必填字段说明**：
- `name`：权限全名
- `reason`：**user_grant 必填**，使用资源引用（`$string:xxx`），需要多语言
- `usedScene.when`：`inuse`（使用时）或 `always`（始终，如后台定位）

## 动态权限请求代码

```typescript
import { abilityAccessCtrl, bundleManager, Permissions } from '@kit.AbilityKit'

// 检查权限
async function checkPermission(permission: Permissions): Promise<boolean> {
  const atManager = abilityAccessCtrl.createAtManager()
  const bundleInfo = await bundleManager.getBundleInfoForSelf(
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
  )
  const tokenId = bundleInfo.appInfo.accessTokenId
  const result = atManager.checkAccessTokenSync(tokenId, permission)
  return result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
}

// 请求权限
async function requestPermissions(
  context: Context,
  permissions: Permissions[]
): Promise<boolean> {
  const atManager = abilityAccessCtrl.createAtManager()
  try {
    const result = await atManager.requestPermissionsFromUser(context, permissions)
    return result.authResults.every(r => r === 0)
  } catch (err) {
    console.error('Permission request failed:', JSON.stringify(err))
    return false
  }
}

// 使用示例
const granted = await requestPermissions(context, [
  'ohos.permission.CAMERA',
  'ohos.permission.READ_IMAGEVIDEO'
])
if (granted) {
  // 执行需要权限的操作
} else {
  // 引导用户到设置页开启权限
}
```

## 审核避坑清单

| # | 避坑项 | 说明 |
|---|--------|------|
| 1 | **优先用 Picker** | 图片/音频/文档优先用系统 Picker，不要直接申请 READ/WRITE 权限 |
| 2 | **reason 必须有意义** | 审核员会看 reason 字段，写清楚用途（不要写 "需要此权限"） |
| 3 | **reason 必须多语言** | 至少提供中文和英文版本 |
| 4 | **不要过度申请** | 只申请实际使用的权限，未使用的权限会被驳回 |
| 5 | **场景对应** | 申请时描述的场景必须与实际代码逻辑一致 |
| 6 | **user_grant 必须动态请求** | 不能只在 json5 声明，代码中必须有 requestPermissionsFromUser 调用 |
| 7 | **处理拒绝场景** | 用户拒绝后不要死循环弹窗，应提供替代体验 |
| 8 | **后台权限单独申请** | LOCATION_IN_BACKGROUND 等后台权限审核更严格 |
| 9 | **粘贴用安全控件** | 读剪贴板优先用 PasteButton 安全控件，而非 READ_PASTEBOARD |
| 10 | **悬浮窗需强理由** | SYSTEM_FLOAT_WINDOW 审核极严，需要明确无替代方案 |

## 权限分级快速决策

> **Agent 决策流程**：遇到下列场景时，先向用户推荐 ✅ 方案。仅当用户确认 ✅ 方案不满足需求后，才使用 ⚠️ ACL 方案。

```
需要读取用户图片/视频?
├─ ✅ 仅展示/选择 → PhotoViewPicker（无需任何权限声明）
├─ ⚠️ 需要克隆/备份/批量同步 → 申请 ACL: READ_IMAGEVIDEO
└─ ⚠️ 需要修改/保存到相册 → 申请 ACL: WRITE_IMAGEVIDEO

需要读取文件?
├─ ✅ 选择文件 → DocumentViewPicker（无需权限）
└─ ⚠️ 扫描/备份整个目录 → 申请 ACL: READ_DOCUMENT

需要读取剪贴板?
├─ ✅ 粘贴按钮场景 → PasteButton 安全控件（无需权限）
└─ ⚠️ 自动读取剪贴板 → 申请 ACL: READ_PASTEBOARD

需要定位?
├─ ✅ 前台定位 → LOCATION / APPROXIMATELY_LOCATION（normal 级，无需 ACL）
└─ ⚠️ 后台持续定位 → 申请 ACL: LOCATION_IN_BACKGROUND

需要悬浮窗?
├─ ✅ 画中画（PiP）→ 系统 PiP 组件（无需权限）
└─ ⚠️ 自定义悬浮窗 → 申请 ACL: SYSTEM_FLOAT_WINDOW（审核极严）
```

## 官方参考链接

- [受限开放权限列表](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/restricted-permissions)
- [应用权限列表](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/permissions-for-all)
- [管理 ACL 权限（AGC）](https://developer.huawei.com/consumer/cn/doc/app/agc-help-acl-overview-0000002394052270)
- [申请使用受限权限](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/declare-permissions-in-acl)

> ⚠️ 权限列表会随 SDK 版本更新，以华为官方最新文档和 AGC 审核要求为准。

---

## See Also

- [stage-ability.md](stage-ability.md) — Stage 模型与 UIAbility
- [media-device.md](media-device.md) — 媒体与设备能力
- [testing-release.md](testing-release.md) — 测试、签名与发布
- [incentive-review-2025.md](incentive-review-2025.md) — 2025 创作激励审核
- [network-data.md](network-data.md) — 网络与数据存储
