# TabBar 底部导航模板

> ⚠️ **Router 废弃提醒**: 本模板使用 `router` API，新项目推荐使用 `Navigation` 组件替代（见 `snippets/common-patterns.md` 模式三十四）。

> 覆盖：4 Tab 标准结构 / 图标 + 文字 / 激活态样式 / 深色适配 / 多端响应

## MainPage.ets — 完整 TabBar 页

```typescript
// pages/MainPage.ets
import { router } from '@kit.ArkUI'
import { AppStorage, promptAction } from '@kit.ArkUI'
import { HomePage } from '../tabs/HomePage'
import { DiscoverPage } from '../tabs/DiscoverPage'
import { PublishPage } from '../tabs/PublishPage'
import { ProfilePage } from '../tabs/ProfilePage'

@Entry
@Component
struct MainPage {
  @State private activeTab: number = 0
  @StorageLink('forceLogout') forceLogoutTs: number = 0
  private lastLogout: number = 0

  // ── 401 全局拦截响应 ─────────────────────────────
  onForceLogout(): void {
    if (this.forceLogoutTs !== this.lastLogout && this.forceLogoutTs !== 0) {
      this.lastLogout = this.forceLogoutTs
      promptAction.showToast({ message: '登录已过期，请重新登录' })
      router.clear()
      router.replaceUrl({ url: 'pages/LoginPage' })
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.activeTab }) {
      // ── Tab 1: 首页 ──────────────────────────────
      TabContent() {
        HomePage()
      }
      .tabBar(this.buildTabBar(0, $r('app.media.ic_home'), $r('app.media.ic_home_active'), '首页'))

      // ── Tab 2: 发现 ──────────────────────────────
      TabContent() {
        DiscoverPage()
      }
      .tabBar(this.buildTabBar(1, $r('app.media.ic_discover'), $r('app.media.ic_discover_active'), '发现'))

      // ── Tab 3: 发布（中间大按钮变体） ───────────────
      TabContent() {
        PublishPage()
      }
      .tabBar(this.buildTabBar(2, $r('app.media.ic_publish'), $r('app.media.ic_publish_active'), '发布'))

      // ── Tab 4: 我的 ──────────────────────────────
      TabContent() {
        ProfilePage()
      }
      .tabBar(this.buildTabBar(3, $r('app.media.ic_profile'), $r('app.media.ic_profile_active'), '我的'))
    }
    .barMode(BarMode.Fixed)
    .barHeight(56)
    .onChange((index: number) => {
      this.activeTab = index
      this.onForceLogout()
    })
    .animationDuration(200)
    .scrollable(false)
  }

  @Builder
  buildTabBar(index: number, icon: Resource, activeIcon: Resource, label: string) {
    Column({ space: 3 }) {
      Image(this.activeTab === index ? activeIcon : icon)
        .width(24).height(24)
        .objectFit(ImageFit.Contain)

      Text(label)
        .fontSize(11)
        .fontColor(this.activeTab === index
          ? $r('app.color.primary')
          : $r('app.color.text_secondary'))
    }
    .width('100%').height(56)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.card_background'))
  }
}
```

## 中间发布按钮变体（凸出样式）

```typescript
// 替换 Tab 3 的 .tabBar(...)
.tabBar(this.buildPublishTabBar())

@Builder
buildPublishTabBar() {
  Column() {
    Stack() {
      Circle()
        .width(52).height(52)
        .fill($r('app.color.primary'))
      Image($r('app.media.ic_add'))
        .width(28).height(28)
        .fillColor(Color.White)
    }
  }
  .width('100%').height(56)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .backgroundColor($r('app.color.card_background'))
  // 悬浮凸出：使用 offset 向上偏移
  .offset({ y: -12 })
}
```

## TabBar 上方徽章（消息红点）

```typescript
@Builder
buildBadgeTabBar(index: number, icon: Resource, activeIcon: Resource, label: string, badgeCount: number) {
  Column({ space: 3 }) {
    Badge({
      count: badgeCount,
      maxCount: 99,
      style: { color: Color.White, fontSize: 10, badgeSize: 16 }
    }) {
      Image(this.activeTab === index ? activeIcon : icon)
        .width(24).height(24)
    }

    Text(label)
      .fontSize(11)
      .fontColor(this.activeTab === index
        ? $r('app.color.primary')
        : $r('app.color.text_secondary'))
  }
  .width('100%').height(56)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .backgroundColor($r('app.color.card_background'))
}
```

## 多端适配：平板/PC 改为侧边导航

```typescript
// 与 BreakpointSystem 配合，平板及以上使用侧边栏导航
import { bp } from '../utils/BreakpointUtil'

@Entry
@Component
struct MainPage {
  @State private activeTab: number = 0

  build() {
    if (bp.current === 'phone') {
      // 手机：底部 TabBar
      this.buildPhoneLayout()
    } else {
      // 平板/PC：左侧 NavigationRail
      this.buildTabletLayout()
    }
  }

  @Builder buildPhoneLayout() {
    // 同上 TabBar 代码
  }

  @Builder buildTabletLayout() {
    Row() {
      // 左侧导航栏
      Column({ space: 8 }) {
        ForEach(this.tabItems, (item: TabItem, index: number) => {
          Column({ space: 4 }) {
            Image(this.activeTab === index ? item.activeIcon : item.icon)
              .width(28).height(28)
            Text(item.label).fontSize(12)
              .fontColor(this.activeTab === index
                ? $r('app.color.primary')
                : $r('app.color.text_secondary'))
          }
          .padding(12).borderRadius(12)
          .backgroundColor(this.activeTab === index
            ? $r('app.color.primary_light')
            : Color.Transparent)
          .onClick(() => { this.activeTab = index })
        })
      }
      .width(72).height('100%').padding({ top: 16 })
      .backgroundColor($r('app.color.card_background'))

      Divider().vertical(true).height('100%')

      // 右侧内容区
      this.buildContent()
    }
    .width('100%').height('100%')
  }
}

interface TabItem {
  icon: Resource
  activeIcon: Resource
  label: string
}
```

## Tab 切换时的状态保留与丢失

| 行为 | 默认表现 | 原因 |
|------|----------|------|
| 切换 Tab 后返回 | ✅ 页面状态保留 | Tabs 内 TabContent 不会被销毁 |
| 切换 Tab 后列表滚动位置 | ✅ 保留 | 组件实例持续存在 |
| Tab 内 Navigation 跳转子页后切回 | ⚠️ 子页可能被回收 | 取决于 NavDestination 缓存策略 |
| 应用后台回前台 | ⚠️ 可能重建 | 系统内存回收时 TabContent 重建 |

**避坑要点**：

1. **不要在 `aboutToAppear` 里无条件请求数据** — Tab 切换时 `aboutToAppear` 不会重复调用（组件未销毁），但从后台恢复时会。用 `onPageShow()` 做刷新更可靠。
2. **每个 Tab 的 Navigation 栈是独立的** — 使用 `NavPathStack` 时，每个 Tab 需要独立实例，不要共享同一个 stack。
3. **LazyForEach 数据源跨 Tab 共享时注意线程安全** — 多个 Tab 监听同一数据源变更，需确保 `totalCount()` 和 `getData()` 一致性。
4. **状态恢复**：关键数据（如草稿、筛选条件）应通过 `@StorageLink` 或 `Preferences` 持久化，不要仅依赖组件 `@State`。

## 在 module.json5 路由表中注册 MainPage

```json
{
  "src": [
    "pages/Index",
    "pages/LoginPage",
    "pages/MainPage",
    "pages/DetailPage",
    "pages/FormPage"
  ]
}
```

## 官方参考
- Tabs 组件: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-tabs
- Badge 组件: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-badge
- Navigation 导航: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/navigation-overview

---

## See Also

- [../../topics/routing-lifecycle.md](../../topics/routing-lifecycle.md) — 路由与导航
- [./drawer-navigation.md](./drawer-navigation.md) — 侧边栏抽屉导航
- [./dark-multi.md](./dark-multi.md) — 深色模式与多端适配
