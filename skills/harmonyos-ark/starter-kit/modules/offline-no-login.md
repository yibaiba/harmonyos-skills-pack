# 单机离线 / 免登录模块

> 覆盖：无账号启动 / 本地数据存储 / 首次引导 / 可选后续登录升级

## 适用场景
- 工具类 App（计算器、笔记、清单、习惯追踪）
- 纯本地数据处理，不依赖云端账号体系
- 希望降低审核与合规复杂度，先快速上线 MVP

## 设计目标
- 启动即用：不出现登录拦截页
- 数据本地可持久化：Preferences 或 RelationalStore
- 支持后续平滑升级：未来可增加“登录同步”而不破坏现有结构

## 推荐导航结构

```text
Index（启动页）
  -> 首次启动：GuidePage（可选）
  -> 非首次启动：HomePage

MainPage（TabBar）
  ├── 功能主页
  ├── 历史记录/本地列表
  └── 设置（主题、导入导出、关于）
```

## Index.ets（免登录自动路由）

```typescript
// pages/Index.ets
import { router } from '@kit.ArkUI'
import { StorageUtil } from '../utils/StorageUtil'

const KEY_FIRST_LAUNCH_DONE = 'first_launch_done'

@Entry
@Component
struct Index {
  async aboutToAppear(): Promise<void> {
    const firstLaunchDone = await StorageUtil.get<boolean>(KEY_FIRST_LAUNCH_DONE)
    if (firstLaunchDone) {
      router.replaceUrl({ url: 'pages/HomePage' })
    } else {
      router.replaceUrl({ url: 'pages/GuidePage' })
    }
  }

  build() {
    Column() {
      LoadingProgress().width(48).height(48)
      Text('初始化中...').margin({ top: 12 })
    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

## GuidePage.ets（首次引导，可选）

```typescript
// pages/GuidePage.ets
import { router } from '@kit.ArkUI'
import { StorageUtil } from '../utils/StorageUtil'

const KEY_FIRST_LAUNCH_DONE = 'first_launch_done'

@Entry
@Component
struct GuidePage {
  build() {
    Column({ space: 16 }) {
      Text('欢迎使用')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)

      Text('本应用支持离线使用，无需登录即可开始')
        .fontSize(15)
        .opacity(0.75)

      Button('立即开始')
        .width('100%')
        .onClick(async () => {
          await StorageUtil.put(KEY_FIRST_LAUNCH_DONE, true)
          router.replaceUrl({ url: 'pages/HomePage' })
        })

      Button('登录后同步（可选）')
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => {
          // 后续如接入账号体系，可跳转登录页
          router.pushUrl({ url: 'pages/LoginPage' })
        })
    }
    .padding({ left: 24, right: 24 })
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

## 数据层建议

1. 轻量配置：`Preferences`
2. 结构化数据：`RelationalStore`
3. 导入导出：通过 `DocumentViewPicker` + JSON/CSV

建议在 `repository` 层抽象一个离线仓库：

```typescript
// repository/NoteRepository.ets
export class NoteRepository {
  async listLocal(): Promise<NoteModel[]> {
    // 从本地数据库读取
    return []
  }

  async saveLocal(note: NoteModel): Promise<void> {
    // 保存到本地数据库
  }
}
```

## 架构兼容建议（为后续登录预留）

- 保留 `UserSession` 抽象，但默认实现为 `GuestSession`
- 网络层允许“无 token 模式”工作
- 同步功能作为可选能力，避免把登录写成强依赖

## 审核与合规注意

- 离线工具类通常风险较低，但仍需遵循最小权限原则
- 不收集手机号/账号数据时，隐私政策应明确说明“仅本地处理”
- 如提供云同步入口，必须在 UI 中明确标注“可选登录”

## 与现有模块的关系

- 替代：`modules/auth-login.md`（在单机场景）
- 搭配：`modules/tabbar-navigation.md`、`modules/dark-multi.md`
- 参考：`pipeline/app-type-checklist.md` 类型 A 分支

---

## See Also

- [./data-persistence.md](./data-persistence.md) — 数据持久化（本地存储）
- [./tabbar-navigation.md](./tabbar-navigation.md) — 底部导航
- [./optional-login-upgrade.md](./optional-login-upgrade.md) — 游客升级登录
