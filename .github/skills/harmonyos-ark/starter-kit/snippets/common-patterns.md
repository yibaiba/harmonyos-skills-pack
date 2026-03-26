# ArkTS / ArkUI 常用代码片段

> 随取随用。复制粘贴，按注释替换业务字段。

---

## 一、HttpUtil — 网络请求封装

```typescript
// utils/HttpUtil.ets
import { http } from '@kit.NetworkKit'
import { StorageUtil } from './StorageUtil'

const BASE_URL = 'https://your-api.example.com'
const TIMEOUT_MS = 10_000

/** 统一业务异常 */
class ApiError extends Error {
  constructor(
    public code: number,
    message: string
  ) {
    super(message)
  }
}

export class HttpUtil {
  private static async getHeaders(): Promise<Record<string, string>> {
    const token = await StorageUtil.get<string>('user_token')
    return {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {})
    }
  }

  static async get<T>(path: string, params?: Record<string, string | number>): Promise<T> {
    const query = params
      ? '?' + Object.entries(params).map(([k, v]) => `${k}=${encodeURIComponent(v)}`).join('&')
      : ''
    const req = http.createHttp()
    try {
      const resp = await req.request(BASE_URL + path + query, {
        method: http.RequestMethod.GET,
        header: await HttpUtil.getHeaders(),
        connectTimeout: TIMEOUT_MS,
        readTimeout: TIMEOUT_MS,
      })
      return HttpUtil.handleResponse<T>(resp)
    } finally {
      req.destroy()
    }
  }

  static async post<T>(path: string, body: object): Promise<T> {
    const req = http.createHttp()
    try {
      const resp = await req.request(BASE_URL + path, {
        method: http.RequestMethod.POST,
        header: await HttpUtil.getHeaders(),
        extraData: JSON.stringify(body),
        connectTimeout: TIMEOUT_MS,
        readTimeout: TIMEOUT_MS,
      })
      return HttpUtil.handleResponse<T>(resp)
    } finally {
      req.destroy()
    }
  }

  static async uploadFile(path: string, localUri: string): Promise<string> {
    // 使用 @ohos.request.uploadFile，返回 CDN URL
    // 此处为示意，实际需按文件上传 API 填写
    const result = await HttpUtil.post<{ url: string }>(path, { fileUri: localUri })
    return result.url
  }

  private static handleResponse<T>(resp: http.HttpResponse): T {
    if (resp.responseCode === 401) {
      // 401 → 清 token，抛异常（调用方再跳登录）
      StorageUtil.remove('user_token')
      throw new ApiError(401, '登录已过期，请重新登录')
    }
    if (resp.responseCode < 200 || resp.responseCode >= 300) {
      throw new ApiError(resp.responseCode, `请求失败 (${resp.responseCode})`)
    }
    const data = JSON.parse(resp.result as string)
    if (data.code !== 0 && data.code !== 200) {
      throw new ApiError(data.code, data.message ?? '服务器错误')
    }
    return data.data as T
  }
}
```

---

## 二、常用 ArkTS 装饰器速查

```typescript
// ── 组件状态 ──────────────────────────────────────────────
@State     // 组件私有状态，变化触发 UI 刷新
@Prop      // 父→子单向传递（值拷贝）
@Link      // 父↔子双向绑定
@Provide   // 祖先组件提供值
@Consume   // 后代组件消费

// ── 跨组件/全局状态 ─────────────────────────────────────
@StorageLink('key')  // 持久化 AppStorage 双向绑定
@LocalStorageLink    // LocalStorage 双向绑定（HAP 内）

// ── 新版（API 12+）推荐 ─────────────────────────────────
@ObservedV2   // 替代 @Observed，类级别
@Trace        // 替代 @ObjectLink，字段级别
```

---

## 三、Router 常用操作

```typescript
import { router } from '@kit.ArkUI'

// 跳转（可从历史回退）
router.pushUrl({ url: 'pages/DetailPage', params: { id: '123' } })

// 跳转（替换栈顶，无法回退）
router.replaceUrl({ url: 'pages/HomePage' })

// 回退
router.back()

// 获取传参
const params = router.getParams() as { id: string }

// 清空路由栈（退出登录后跳登录页）
router.clear()
router.replaceUrl({ url: 'pages/LoginPage' })
```

---

## 四、常用布局片段

### 水平两端对齐
```typescript
Row() {
  Text('左侧').layoutWeight(1)
  Text('右侧')
}
.width('100%').justifyContent(FlexAlign.SpaceBetween)
```

### 全屏居中
```typescript
Column() {
  Text('居中内容')
}
.width('100%').height('100%')
.justifyContent(FlexAlign.Center)
.alignItems(HorizontalAlign.Center)
```

### 底部固定按钮
```typescript
Column() {
  Scroll() { /* 内容 */ }.layoutWeight(1)
  Button('确认').width('100%').margin({ left: 16, right: 16, bottom: 32 })
}
.width('100%').height('100%')
```

### 网格布局（自适应列数）
```typescript
Grid() {
  ForEach(items, (item) => {
    GridItem() { ItemCard({ item }) }
  }, item => item.id)
}
.columnsTemplate('1fr 1fr')      // 固定2列
.columnsGap(12)
.rowsGap(12)
.padding(16)
```

---

## 五、Toast / Dialog / BottomSheet

```typescript
import { promptAction } from '@kit.ArkUI'

// Toast
promptAction.showToast({ message: '操作成功', duration: 2000 })

// 确认 Dialog
promptAction.showDialog({
  title: '确认',
  message: '确定要删除吗？',
  buttons: [
    { text: '取消', color: '#999' },
    { text: '删除', color: '#FF3B30' }
  ]
}).then(res => {
  if (res.index === 1) {
    // 用户点了"删除"
  }
})
```

---

## 六、@Builder 可复用 UI 片段

```typescript
@Entry
@Component
struct SomePage {
  build() {
    Column() {
      this.buildHeader()
      this.buildContent()
    }
  }

  @Builder buildHeader() {
    Row() {
      Text('标题').fontSize(20).fontWeight(FontWeight.Bold)
    }
    .width('100%').height(56).padding({ left: 16 })
  }

  @Builder buildContent() {
    Text('内容区域')
  }
}
```

---

## 七、LazyForEach + IDataSource（大列表性能优化）

```typescript
// 实现 IDataSource
class ContentDataSource implements IDataSource {
  private items: ContentItem[] = []
  private listeners: DataChangeListener[] = []

  constructor(items: ContentItem[]) { this.items = items }
  totalCount(): number { return this.items.length }
  getData(index: number): ContentItem { return this.items[index] }
  registerDataChangeListener(l: DataChangeListener): void { this.listeners.push(l) }
  unregisterDataChangeListener(l: DataChangeListener): void {
    this.listeners = this.listeners.filter(x => x !== l)
  }

  appendItems(newItems: ContentItem[]): void {
    const start = this.items.length
    this.items = [...this.items, ...newItems]
    this.listeners.forEach(l => l.onDataAdd(start))
  }

  reload(newItems: ContentItem[]): void {
    this.items = newItems
    this.listeners.forEach(l => l.onDataReloaded())
  }
}

// 在 Page 中使用
@State private dataSource = new ContentDataSource([])

List() {
  LazyForEach(this.dataSource, (item: ContentItem) => {
    ListItem() { ContentCard({ item }) }
  }, (item: ContentItem) => item.id)
}
.cachedCount(5)   // 预加载 5 条
```

---

## 八、权限申请模板

```typescript
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit'

async function requestPermission(permissions: Permissions[]): Promise<boolean> {
  const atManager = abilityAccessCtrl.createAtManager()
  const result = await atManager.requestPermissionsFromUser(getContext(), permissions)
  return result.authResults.every(r => r === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
}

// 用法示例（相机权限）
const granted = await requestPermission(['ohos.permission.CAMERA'])
if (!granted) {
  promptAction.showToast({ message: '需要相机权限' })
  return
}
```

---

## 九、HttpUtil 401 全局拦截 + 跳登录

> 统一在 `HttpUtil.handleResponse` 中处理 401，并通过 AppStorage 通知 EntryAbility 强制跳转。

```typescript
// utils/HttpUtil.ets — 在 handleResponse 中加拦截
import { AppStorage } from '@kit.ArkUI'

// 约定：监听 'forceLogout' 信号
const FORCE_LOGOUT_KEY = 'forceLogout'

private static handleResponse<T>(resp: http.HttpResponse): T {
  if (resp.responseCode === 401) {
    StorageUtil.remove('user_token')
    // 发出全局信号，任意页面均可监听
    AppStorage.setOrCreate(FORCE_LOGOUT_KEY, Date.now())
    throw new ApiError(401, '登录已过期，请重新登录')
  }
  // ... 其余逻辑不变
}
```

```typescript
// pages/任意持久页面 (如 MainPage / TabPage) —— 监听强制退出信号
@Entry
@Component
struct MainPage {
  @StorageLink('forceLogout') forceLogoutTs: number = 0
  private lastLogout: number = 0

  build() { /* ... */ }

  // forceLogoutTs 变化时触发跳转
  onForceLogout() {
    if (this.forceLogoutTs !== this.lastLogout && this.forceLogoutTs !== 0) {
      this.lastLogout = this.forceLogoutTs
      promptAction.showToast({ message: '登录已过期，请重新登录' })
      router.clear()
      router.replaceUrl({ url: 'pages/LoginPage' })
    }
  }
}
```

> **说明：** 使用 `AppStorage` 作为事件总线，任何页面持有 `@StorageLink('forceLogout')` 就可响应退出信号，无需在每个页面单独处理 401。

---

## 官方参考
- ArkTS 语言指南: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-get-started
- ArkUI 组件参考: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-components-summary
- http 网络: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/http-request
- 权限申请: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/request-user-authorization
- AppStorage: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-appstorage
