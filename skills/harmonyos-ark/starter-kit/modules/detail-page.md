# 详情页模块

> 本模板使用 Navigation (NavPathStack) 路由。需在根组件中 @Provide('navStack') navStack。

> 覆盖：路由传参 / 详情加载 / 导航返回 / 分享 / 骨架屏

## 路由跳转（从列表页）

```typescript
// 在列表页或任意页面跳转到详情
this.navStack.pushPath({
  name: 'DetailPage',
  param: { id: 'content_001', title: '可选预填标题' } as Record<string, string>
})
```

## DetailPage.ets — 完整详情页

```typescript
// pages/DetailPage.ets
import { DetailViewModel } from '../viewmodel/DetailViewModel'

interface DetailParams {
  id: string
  title?: string
}

@Component
struct DetailPage {
  @Consume('navStack') navStack: NavPathStack
  @State private vm: DetailViewModel = new DetailViewModel()

  build() {
    NavDestination() {
      // ── 导航栏 ─────────────────────────────────────
      Row() {
        Image($r('app.media.ic_back'))
          .width(24).height(24)
          .onClick(() => this.navStack.pop())

        Text(this.vm.pageTitle)
          .fontSize(18).fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })

        Image($r('app.media.ic_share'))
          .width(24).height(24)
          .onClick(() => this.vm.share())
      }
      .width('100%').height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.background'))

      Divider()

      // ── 内容区域 ───────────────────────────────────
      if (this.vm.isLoading) {
        this.buildSkeleton()
      } else if (this.vm.errorMsg) {
        Column({ space: 16 }) {
          Text(this.vm.errorMsg).fontColor($r('app.color.text_secondary'))
          Button('重试').onClick(() => this.vm.load())
        }
        .width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        this.buildContent()
      }
    }
    .width('100%').height('100%')
    .backgroundColor($r('app.color.background'))
    }
    .title('详情')
    .onReady((context: NavDestinationContext) => {
      const param = context.pathInfo.param as Record<string, string>
      this.vm.init(param?.id ?? '', param?.title)
      this.vm.load()
    })
  }

  @Builder
  buildContent() {
    Scroll() {
      Column({ space: 16 }) {
        // 封面图
        Image(this.vm.detail?.coverUrl ?? '')
          .width('100%')
          .aspectRatio(16 / 9)
          .objectFit(ImageFit.Cover)
          .borderRadius({ bottomLeft: 0, bottomRight: 0, topLeft: 0, topRight: 0 })

        Column({ space: 8 }) {
          // 标题
          Text(this.vm.detail?.title ?? '')
            .fontSize(20).fontWeight(FontWeight.Bold)
            .width('100%')

          // 时间
          Text(this.vm.formattedTime)
            .fontSize(12).fontColor($r('app.color.text_secondary'))

          // 正文
          Text(this.vm.detail?.description ?? '')
            .fontSize(15).lineHeight(24)
            .width('100%')
        }
        .padding({ left: 16, right: 16 })
      }
    }
    .scrollBar(BarState.Off)
    .layoutWeight(1)
  }

  @Builder
  buildSkeleton() {
    Column({ space: 16 }) {
      // 封面骨架
      Row()
        .width('100%').height(220)
        .backgroundColor($r('app.color.skeleton'))

      Column({ space: 8 }) {
        Row().width('70%').height(20).borderRadius(4).backgroundColor($r('app.color.skeleton'))
        Row().width('40%').height(14).borderRadius(4).backgroundColor($r('app.color.skeleton'))
        ForEach([1, 2, 3, 4], (_: number) => {
          Row().width('100%').height(14).borderRadius(4).backgroundColor($r('app.color.skeleton'))
        })
      }
      .padding({ left: 16, right: 16 })
      .alignItems(HorizontalAlign.Start)
    }
    .layoutWeight(1)
  }
}
```

## DetailViewModel.ets

```typescript
// viewmodel/DetailViewModel.ets
import { ContentRepository } from '../repository/ContentRepository'
import { ContentItem } from '../model/ContentModel'
import { systemShare } from '@kit.ShareKit'

@ObservedV2
export class DetailViewModel {
  @Trace detail: ContentItem | null = null
  @Trace isLoading: boolean = false
  @Trace errorMsg: string = ''
  @Trace pageTitle: string = ''

  private contentId: string = ''
  private repo = new ContentRepository()

  init(id: string, preTitle?: string): void {
    this.contentId = id
    this.pageTitle = preTitle ?? '详情'  // 先用传入的标题占位，加载完后替换
  }

  async load(): Promise<void> {
    this.isLoading = true
    this.errorMsg = ''
    try {
      this.detail = await this.repo.getDetail(this.contentId)
      this.pageTitle = this.detail.title
    } catch (e) {
      this.errorMsg = e?.message ?? '加载失败'
    } finally {
      this.isLoading = false
    }
  }

  get formattedTime(): string {
    if (!this.detail) return ''
    return new Date(this.detail.createTime).toLocaleDateString('zh-CN')
  }

  async share(): Promise<void> {
    if (!this.detail) return
    try {
      const shareData: systemShare.SharedData = new systemShare.SharedData({
        utd: 'general.plain-text',
        content: `${this.detail.title}\n${this.detail.description}`
      })
      const controller = new systemShare.ShareController(shareData)
      // 调用系统分享面板（需传入 UIContext）
      // controller.show(getContext(this) as common.UIAbilityContext, ...)
    } catch (e) {
      // 分享失败静默处理
    }
  }
}
```

## 带 Tab 切换的详情变体（如商品详情）

```typescript
// 在 build() 内的 buildContent 中替换
@Builder
buildTabbedContent() {
  Tabs({ barPosition: BarPosition.Start }) {
    TabContent() {
      this.buildMainInfo()
    }.tabBar('详情')

    TabContent() {
      this.buildComments()
    }.tabBar('评论')

    TabContent() {
      this.buildRelated()
    }.tabBar('相关推荐')
  }
  .barMode(BarMode.Fixed)
  .layoutWeight(1)
}
```

## 官方参考
- Navigation 路由: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/navigation-overview
- Scroll 组件: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-scroll
- 系统分享: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/share-overview

---

## See Also

- [../../topics/routing-lifecycle.md](../../topics/routing-lifecycle.md) — 路由与页面跳转
- [./list-page.md](./list-page.md) — 列表页模板
- [../snippets/common-patterns.md](../snippets/common-patterns.md) — 常用代码模式
