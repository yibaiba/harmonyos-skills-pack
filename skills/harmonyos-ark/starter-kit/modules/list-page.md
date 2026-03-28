# 列表页模块

> 覆盖：网络加载 / 下拉刷新 / 上拉加载更多 / 空态 / 错误态 / Skeleton 占位

## 数据模型

```typescript
// model/ContentModel.ets
export interface ContentItem {
  id: string
  title: string
  coverUrl: string
  summary: string
  createTime: number
}

export interface PageResult<T> {
  list: T[]
  pageNum: number
  pageSize: number
  total: number
  hasMore: boolean
}
```

## ListView ViewModel

```typescript
// viewmodel/HomeViewModel.ets
import { ContentRepository } from '../repository/ContentRepository'
import { ContentItem } from '../model/ContentModel'

const PAGE_SIZE = 20

@ObservedV2
export class HomeViewModel {
  @Trace items: ContentItem[] = []
  @Trace isLoading: boolean = false       // 首次加载
  @Trace isRefreshing: boolean = false    // 下拉刷新
  @Trace isLoadingMore: boolean = false   // 加载更多
  @Trace hasMore: boolean = true
  @Trace errorMsg: string = ''

  private pageNum: number = 1
  private repo = new ContentRepository()

  /** 首次加载 */
  async load(): Promise<void> {
    this.isLoading = true
    this.errorMsg = ''
    try {
      const result = await this.repo.getList(1, PAGE_SIZE)
      this.items = result.list
      this.hasMore = result.hasMore
      this.pageNum = 1
    } catch (e) {
      this.errorMsg = e?.message ?? '加载失败'
    } finally {
      this.isLoading = false
    }
  }

  /** 下拉刷新 */
  async refresh(): Promise<void> {
    this.isRefreshing = true
    try {
      const result = await this.repo.getList(1, PAGE_SIZE)
      this.items = result.list
      this.hasMore = result.hasMore
      this.pageNum = 1
    } catch (e) {
      this.errorMsg = e?.message ?? '刷新失败'
    } finally {
      this.isRefreshing = false
    }
  }

  /** 上拉加载更多 */
  async loadMore(): Promise<void> {
    if (!this.hasMore || this.isLoadingMore) return
    this.isLoadingMore = true
    try {
      const next = this.pageNum + 1
      const result = await this.repo.getList(next, PAGE_SIZE)
      this.items = [...this.items, ...result.list]
      this.hasMore = result.hasMore
      this.pageNum = next
    } catch (e) {
      // 静默失败，保留现有数据
    } finally {
      this.isLoadingMore = false
    }
  }
}
```

## HomePage.ets — 完整列表页

```typescript
// pages/HomePage.ets
import { router } from '@kit.ArkUI'
import { HomeViewModel } from '../viewmodel/HomeViewModel'
import { ContentItem } from '../model/ContentModel'
import { ContentCard } from '../components/business/ContentCard'
import { EmptyView } from '../components/common/EmptyView'
import { ErrorView } from '../components/common/ErrorView'
import { SkeletonList } from '../components/common/SkeletonList'

@Entry
@Component
struct HomePage {
  @State private vm: HomeViewModel = new HomeViewModel()

  aboutToAppear(): void {
    this.vm.load()
  }

  build() {
    Column() {
      // ── 标题栏 ─────────────────────────────────────
      Row() {
        Text('首页').fontSize(20).fontWeight(FontWeight.Bold)
      }
      .width('100%').height(56)
      .padding({ left: 16, right: 16 })

      // ── 内容区域 ───────────────────────────────────
      if (this.vm.isLoading) {
        SkeletonList()
      } else if (this.vm.errorMsg && this.vm.items.length === 0) {
        ErrorView({ msg: this.vm.errorMsg, onRetry: () => this.vm.load() })
      } else if (this.vm.items.length === 0) {
        EmptyView({ tip: '暂无内容' })
      } else {
        this.buildList()
      }
    }
    .width('100%').height('100%')
    .backgroundColor($r('app.color.background'))
  }

  @Builder
  buildList() {
    Refresh({ refreshing: $$this.vm.isRefreshing }) {
      List({ space: 12 }) {
        ForEach(this.vm.items, (item: ContentItem) => {
          ListItem() {
            ContentCard({
              item: item,
              onClick: () => {
                router.pushUrl({
                  url: 'pages/DetailPage',
                  params: { id: item.id }
                })
              }
            })
          }
        }, (item: ContentItem) => item.id)

        // 加载更多 Footer
        ListItem() {
          if (this.vm.isLoadingMore) {
            Row() {
              LoadingProgress().width(24).height(24)
              Text('加载中...').margin({ left: 8 }).fontColor($r('app.color.text_secondary'))
            }
            .width('100%').height(48).justifyContent(FlexAlign.Center)
          } else if (!this.vm.hasMore) {
            Text('已经到底了').width('100%').height(48)
              .textAlign(TextAlign.Center).fontColor($r('app.color.text_secondary'))
          }
        }
      }
      .onReachEnd(() => this.vm.loadMore())
      .padding({ left: 16, right: 16 })
      .layoutWeight(1)
    }
    .onRefreshing(() => this.vm.refresh())
  }
}
```

## ContentCard.ets — 列表卡片组件

```typescript
// components/business/ContentCard.ets
import { ContentItem } from '../../model/ContentModel'

@Component
export struct ContentCard {
  item!: ContentItem
  onClick: () => void = () => {}

  build() {
    Row({ space: 12 }) {
      Image(this.item.coverUrl)
        .width(80).height(80)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)

      Column({ space: 4 }) {
        Text(this.item.title)
          .fontSize(16).fontWeight(FontWeight.Medium)
          .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.item.summary)
          .fontSize(13).fontColor($r('app.color.text_secondary'))
          .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
    }
    .padding(12)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .width('100%')
    .onClick(this.onClick)
  }
}
```

## EmptyView / ErrorView / SkeletonList 通用组件

```typescript
// components/common/EmptyView.ets
@Component
export struct EmptyView {
  tip: string = '暂无数据'

  build() {
    Column({ space: 12 }) {
      Image($r('app.media.ic_empty')).width(120).height(120)
      Text(this.tip).fontColor($r('app.color.text_secondary'))
    }
    .width('100%').layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }
}

// components/common/ErrorView.ets
@Component
export struct ErrorView {
  msg: string = '加载失败'
  onRetry: () => void = () => {}

  build() {
    Column({ space: 16 }) {
      Text(this.msg).fontColor($r('app.color.text_secondary'))
      Button('重试').onClick(this.onRetry)
    }
    .width('100%').layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }
}
```

## ContentRepository.ets

```typescript
// repository/ContentRepository.ets
import { HttpUtil } from '../utils/HttpUtil'
import { PageResult, ContentItem } from '../model/ContentModel'

export class ContentRepository {
  async getList(pageNum: number, pageSize: number): Promise<PageResult<ContentItem>> {
    return HttpUtil.get<PageResult<ContentItem>>('/api/content/list', { pageNum, pageSize })
  }

  async getDetail(id: string): Promise<ContentItem> {
    return HttpUtil.get<ContentItem>(`/api/content/${id}`)
  }
}
```

## 官方参考
- List 组件: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-list
- Refresh 组件: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-refresh
- ForEach 键值规则: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-foreach

---

## See Also

- [../../topics/state-management.md](../../topics/state-management.md) — 状态管理
- [./detail-page.md](./detail-page.md) — 详情页模板
- [../snippets/common-patterns.md](../snippets/common-patterns.md) — HTTP 请求模式
