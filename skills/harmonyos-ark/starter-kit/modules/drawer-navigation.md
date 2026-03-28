# 侧边栏 / 抽屉导航模板

## Scope

提供 SideBarContainer 实现的侧边栏导航完整模板，适用于设置页、管理后台、内容分类等需要抽屉式导航的场景。

## 完整实现

```typescript
@Entry
@Component
struct DrawerPage {
  @State isOpen: boolean = false
  @State selectedIndex: number = 0

  private menuItems: DrawerMenuItem[] = [
    { icon: $r('app.media.ic_home'), label: '首页', route: 'pages/HomePage' },
    { icon: $r('app.media.ic_profile'), label: '个人中心', route: 'pages/ProfilePage' },
    { icon: $r('app.media.ic_settings'), label: '设置', route: 'pages/SettingsPage' },
    { icon: $r('app.media.ic_about'), label: '关于', route: 'pages/AboutPage' }
  ]

  build() {
    SideBarContainer(SideBarContainerType.Embed) {
      // ---- 侧边栏内容 ----
      Column() {
        // 用户头像区域
        this.buildUserHeader()
        // 菜单列表
        this.buildMenuList()
        // 底部操作
        Blank()
        this.buildFooter()
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')

      // ---- 主内容区 ----
      Column() {
        // 顶部标题栏
        Row() {
          Image($r('app.media.ic_menu'))
            .width(24).height(24)
            .onClick(() => { this.isOpen = !this.isOpen })
          Text(this.menuItems[this.selectedIndex].label)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 16 })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .alignItems(VerticalAlign.Center)

        // 页面内容（根据选中菜单切换）
        this.buildContent()
      }
      .width('100%')
      .height('100%')
    }
    .showSideBar(this.isOpen)
    .sideBarWidth(280)
    .minSideBarWidth(240)
    .maxSideBarWidth(320)
    .showControlButton(false)
    .onChange((value: boolean) => { this.isOpen = value })
  }

  @Builder
  buildUserHeader() {
    Column({ space: 8 }) {
      Image($r('app.media.ic_avatar'))
        .width(64).height(64)
        .borderRadius(32)
      Text('用户名')
        .fontSize(16).fontWeight(FontWeight.Medium)
      Text('user@example.com')
        .fontSize(12).fontColor('#999')
    }
    .width('100%')
    .padding({ top: 48, bottom: 24 })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildMenuList() {
    ForEach(this.menuItems, (item: DrawerMenuItem, index: number) => {
      Row({ space: 12 }) {
        Image(item.icon).width(22).height(22)
          .fillColor(this.selectedIndex === index ? '#007AFF' : '#333')
        Text(item.label)
          .fontSize(15)
          .fontColor(this.selectedIndex === index ? '#007AFF' : '#333')
          .fontWeight(this.selectedIndex === index ? FontWeight.Medium : FontWeight.Normal)
      }
      .width('100%')
      .height(48)
      .padding({ left: 24, right: 16 })
      .backgroundColor(this.selectedIndex === index ? '#E8F0FE' : Color.Transparent)
      .borderRadius(8)
      .margin({ left: 8, right: 8 })
      .onClick(() => {
        this.selectedIndex = index
        this.isOpen = false
      })
    })
  }

  @Builder
  buildFooter() {
    Divider().margin({ left: 24, right: 24 })
    Row({ space: 12 }) {
      Image($r('app.media.ic_logout')).width(20).height(20).fillColor('#FF4444')
      Text('退出登录').fontSize(14).fontColor('#FF4444')
    }
    .width('100%')
    .height(48)
    .padding({ left: 24 })
    .margin({ bottom: 24 })
    .onClick(() => {
      // 退出登录逻辑
    })
  }

  @Builder
  buildContent() {
    // 根据 selectedIndex 切换内容
    if (this.selectedIndex === 0) {
      Text('首页内容').fontSize(24)
    } else if (this.selectedIndex === 1) {
      Text('个人中心内容').fontSize(24)
    } else if (this.selectedIndex === 2) {
      Text('设置内容').fontSize(24)
    } else {
      Text('关于内容').fontSize(24)
    }
  }
}

interface DrawerMenuItem {
  icon: Resource
  label: string
  route: string
}
```

## 手势支持

```typescript
// 从左边缘滑入打开抽屉
.gesture(
  PanGesture({ direction: PanDirection.Right, distance: 20 })
    .onActionStart(() => { this.isOpen = true })
)
```

## 与 TabBar 组合

适合主 Tab + 侧边栏的混合导航：

```
┌──────────────────────────┐
│ ☰ 标题          🔔  👤   │  ← 标题栏（左侧菜单按钮）
├──────────────────────────┤
│                          │
│      主内容区域           │  ← Navigation 或 Tab 内容
│                          │
├──────────────────────────┤
│  🏠  📋  ➕  💬  👤     │  ← 底部 TabBar
└──────────────────────────┘
```

> 侧边栏负责低频功能（设置、关于、切换账号），TabBar 负责高频切换。

## 关键注意事项

1. **SideBarContainer 默认宽度**：`sideBarWidth` 建议 240-320，过宽会挤压主内容
2. **状态保持**：切换菜单时主内容区不会自动销毁，需手动管理状态重置
3. **折叠屏适配**：宽屏（>840vp）下可常驻展示侧边栏，窄屏下叠加显示
4. **深色模式**：背景色使用 `$r('sys.color.ohos_id_color_sub_background')` 自动适配

## 官方参考

- SideBarContainer: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-sidebarcontainer

---

## See Also

- [底部导航模板](tabbar-navigation.md)
- [深色模式 + 多端适配](dark-multi.md)
- [路由与生命周期](../../topics/routing-lifecycle.md)
