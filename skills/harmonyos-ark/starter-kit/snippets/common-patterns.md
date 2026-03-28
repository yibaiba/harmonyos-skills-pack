# ArkTS / ArkUI 常用代码片段

> 随取随用。复制粘贴，按注释替换业务字段。

<!-- Agent 摘要：1017 行，23 个代码模式。按编号搜索（如 "## 一"/"## 十四"）定位。
     模式覆盖：HTTP/JSON/路由/弹窗/权限/图片缓存/文件存储/Deep Link/生命周期/错误边界/埋点。 -->

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

## 六、CustomDialog 完整生命周期

```typescript
// 1. 定义弹窗组件
@CustomDialog
struct ConfirmDialog {
  controller: CustomDialogController
  title: string = ''
  message: string = ''
  onConfirm: () => void = () => {}

  build() {
    Column({ space: 16 }) {
      Text(this.title).fontSize(18).fontWeight(FontWeight.Bold)
      Text(this.message).fontSize(14).fontColor('#666')
      Row({ space: 12 }) {
        Button('取消').onClick(() => this.controller.close())
          .backgroundColor('#F5F5F5').fontColor('#333')
        Button('确认').onClick(() => {
          this.onConfirm()
          this.controller.close()
        })
      }.width('100%').justifyContent(FlexAlign.End)
    }.padding(24)
  }
}

// 2. 在页面中创建 controller 并调用
@Entry
@Component
struct DemoPage {
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      title: '删除确认',
      message: '确定要删除这条记录吗？',
      onConfirm: () => this.handleDelete()
    }),
    autoCancel: true,       // 点击蒙层关闭
    alignment: DialogAlignment.Center,
    customStyle: true       // 使用自定义样式
  })

  handleDelete(): void {
    // 执行删除逻辑
  }

  build() {
    Button('删除').onClick(() => this.dialogController.open())
  }
}
```

> **V2 替代方案**：API 12+ 推荐使用 `UIContext.getPromptAction().openCustomDialog()`，无需 controller，支持 Promise 返回结果。

---

## 七、@Builder 可复用 UI 片段

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

## 八、LazyForEach + IDataSource（大列表性能优化）

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

## 九、权限申请模板

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

## 十、HttpUtil 401 全局拦截 + 跳登录

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

## 十一、表单验证模式

```typescript
// 通用验证规则接口
interface ValidationRule {
  validate: (value: string) => boolean
  message: string
}

// 常用正则验证器
const Validators = {
  required: (msg = '此项为必填'): ValidationRule => ({
    validate: (v: string) => v.trim().length > 0,
    message: msg
  }),
  phone: (): ValidationRule => ({
    validate: (v: string) => /^1[3-9]\d{9}$/.test(v),
    message: '请输入有效的手机号'
  }),
  email: (): ValidationRule => ({
    validate: (v: string) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v),
    message: '请输入有效的邮箱地址'
  }),
  minLength: (n: number): ValidationRule => ({
    validate: (v: string) => v.length >= n,
    message: `长度不能少于 ${n} 个字符`
  }),
  match: (other: string, label: string): ValidationRule => ({
    validate: (v: string) => v === other,
    message: `与${label}不一致`
  })
}

// 执行验证
function runValidation(value: string, rules: ValidationRule[]): string {
  for (const rule of rules) {
    if (!rule.validate(value)) {
      return rule.message
    }
  }
  return ''
}

// 在组件中使用
@Entry
@Component
struct FormExample {
  @State phone: string = ''
  @State phoneError: string = ''

  build() {
    Column({ space: 12 }) {
      TextInput({ placeholder: '手机号', text: this.phone })
        .onChange((value: string) => {
          this.phone = value
          this.phoneError = runValidation(value, [
            Validators.required(),
            Validators.phone()
          ])
        })
      if (this.phoneError) {
        Text(this.phoneError).fontSize(12).fontColor('#FF4444')
      }
    }
  }
}
```

---

## 十二、常用动画片段

```typescript
// 1. 淡入动画 — 页面/组件出现
@Entry
@Component
struct FadeInDemo {
  @State opacity: number = 0

  aboutToAppear(): void {
    animateTo({ duration: 300, curve: Curve.EaseOut }, () => {
      this.opacity = 1
    })
  }

  build() {
    Column() {
      Text('淡入内容').opacity(this.opacity)
    }
  }
}

// 2. 缩放 + 弹性 — 按钮点击反馈
Button('点击我')
  .scale({ x: this.pressed ? 0.95 : 1, y: this.pressed ? 0.95 : 1 })
  .animation({ duration: 150, curve: Curve.FastOutSlowIn })
  .onTouch((event: TouchEvent) => {
    this.pressed = event.type === TouchType.Down
  })

// 3. 列表项滑入 — staggered animation
ForEach(this.items, (item: string, index: number) => {
  Text(item)
    .translate({ x: this.loaded ? 0 : 100 })
    .opacity(this.loaded ? 1 : 0)
    .animation({
      duration: 300,
      delay: index * 50,
      curve: Curve.EaseOut
    })
})

// 4. 转场动画 — 页面进出
// 在 NavDestination 中使用
.transition(TransitionEffect.SLIDE_RIGHT
  .combine(TransitionEffect.OPACITY)
  .animation({ duration: 350, curve: Curve.FastOutSlowIn }))
```

---

## 十三、错误处理与重试

```typescript
// 1. 统一错误处理包装
async function safeFetch<T>(fn: () => Promise<T>, fallback: T): Promise<T> {
  try {
    return await fn()
  } catch (err) {
    const msg = (err as Error)?.message ?? '未知错误'
    console.error(`[safeFetch] ${msg}`)
    return fallback
  }
}

// 使用
const data = await safeFetch(() => HttpUtil.get<UserInfo>('/api/user'), defaultUser)

// 2. 带重试的请求（指数退避）
const MAX_RETRIES = 3

async function fetchWithRetry<T>(fn: () => Promise<T>): Promise<T> {
  let lastErr: Error | undefined
  for (let i = 0; i < MAX_RETRIES; i++) {
    try {
      return await fn()
    } catch (err) {
      lastErr = err as Error
      const delay = Math.pow(2, i) * 500
      await new Promise<void>((resolve) => setTimeout(resolve, delay))
    }
  }
  throw lastErr
}

// 3. 用户提示封装
import { promptAction } from '@kit.ArkUI'

function showError(message: string): void {
  promptAction.showToast({ message, duration: 2000 })
}

function showRetryDialog(message: string, onRetry: () => void): void {
  promptAction.showDialog({
    title: '操作失败',
    message: message,
    buttons: [
      { text: '取消', color: '#999' },
      { text: '重试', color: '#007AFF' }
    ]
  }).then((result) => {
    if (result.index === 1) {
      onRetry()
    }
  })
}
```

---

## 十四、图片加载与缓存管道

```typescript
// utils/ImageCacheUtil.ets
import { image } from '@kit.ImageKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { http } from '@kit.NetworkKit';

export class ImageCacheUtil {
  private static cacheDir: string = '';

  static init(context: Context): void {
    ImageCacheUtil.cacheDir = context.cacheDir + '/img_cache';
    if (!fs.accessSync(ImageCacheUtil.cacheDir)) {
      fs.mkdirSync(ImageCacheUtil.cacheDir);
    }
  }

  /** 带缓存的图片加载 → PixelMap */
  static async load(url: string): Promise<image.PixelMap> {
    const hash = ImageCacheUtil.hashCode(url);
    const cachePath = `${ImageCacheUtil.cacheDir}/${hash}`;

    // 命中缓存
    if (fs.accessSync(cachePath)) {
      const source = image.createImageSource(cachePath);
      const pm = await source.createPixelMap({ editable: true });
      source.release();
      return pm;
    }

    // 网络下载
    const req = http.createHttp();
    const resp = await req.request(url, {
      expectDataType: http.HttpDataType.ARRAY_BUFFER,
    });
    req.destroy();

    const buffer = resp.result as ArrayBuffer;
    const file = fs.openSync(cachePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE);
    fs.writeSync(file.fd, buffer);
    fs.closeSync(file);

    const source = image.createImageSource(buffer);
    const pm = await source.createPixelMap({ editable: true });
    source.release();
    return pm;
  }

  private static hashCode(str: string): string {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash) + str.charCodeAt(i);
      hash |= 0;
    }
    return Math.abs(hash).toString(16);
  }
}
```

---

## 十五、本地文件存储 (FileIO + Preferences)

```typescript
// utils/StorageUtil.ets — Preferences 封装
import { preferences } from '@kit.ArkData';

const STORE_NAME = 'app_prefs';

export class StorageUtil {
  private static store: preferences.Preferences | null = null;

  static async init(context: Context): Promise<void> {
    StorageUtil.store = await preferences.getPreferences(context, STORE_NAME);
  }

  static async put<T>(key: string, value: T): Promise<void> {
    await StorageUtil.store!.put(key, JSON.stringify(value));
    await StorageUtil.store!.flush();
  }

  static async get<T>(key: string, defaultVal?: T): Promise<T | undefined> {
    const raw = await StorageUtil.store!.get(key, '') as string;
    return raw ? JSON.parse(raw) as T : defaultVal;
  }

  static async remove(key: string): Promise<void> {
    await StorageUtil.store!.delete(key);
    await StorageUtil.store!.flush();
  }
}
```

```typescript
// utils/FileUtil.ets — 文件读写
import { fileIo as fs } from '@kit.CoreFileKit';

export class FileUtil {
  static writeText(context: Context, name: string, content: string): void {
    const path = context.filesDir + '/' + name;
    const file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.WRITE);
    fs.writeSync(file.fd, content);
    fs.closeSync(file);
  }

  static readText(context: Context, name: string): string {
    const path = context.filesDir + '/' + name;
    const file = fs.openSync(path, fs.OpenMode.READ_ONLY);
    const stat = fs.statSync(path);
    const buf = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, buf);
    fs.closeSync(file);
    const decoder = new util.TextDecoder();
    return decoder.decodeSync(new Uint8Array(buf));
  }
}
```

---

## 十六、多权限请求链

```typescript
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';

/** 批量检查并申请权限，返回全部已授权的权限列表 */
async function requestPermissions(
  context: Context,
  permissions: Permissions[]
): Promise<Permissions[]> {
  const atManager = abilityAccessCtrl.createAtManager();
  const granted: Permissions[] = [];

  for (const perm of permissions) {
    const status = await atManager.checkAccessToken(
      (await bundleManager.getBundleInfoForSelf(0)).appInfo.accessTokenId,
      perm
    );
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      granted.push(perm);
    }
  }

  const needRequest = permissions.filter(p => !granted.includes(p));
  if (needRequest.length === 0) return granted;

  const result = await atManager.requestPermissionsFromUser(context, needRequest);
  result.permissions.forEach((perm, i) => {
    if (result.authResults[i] === 0) granted.push(perm as Permissions);
  });

  return granted;
}

// 用法
const perms = await requestPermissions(context, [
  'ohos.permission.CAMERA',
  'ohos.permission.MICROPHONE',
  'ohos.permission.APPROXIMATELY_LOCATION',
]);
```

---

## 十七、Deep Link / URL Scheme 路由

```typescript
// EntryAbility.ets — 处理 Deep Link
import { UIAbility, Want } from '@kit.AbilityKit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want): void {
    this.handleDeepLink(want);
  }

  onNewWant(want: Want): void {
    this.handleDeepLink(want);
  }

  private handleDeepLink(want: Want): void {
    const uri = want.uri;  // e.g. "myapp://product/123"
    if (!uri) return;

    const url = new URL(uri);
    switch (url.hostname) {
      case 'product':
        const id = url.pathname.replace('/', '');
        // 跳转到商品详情
        AppStorage.setOrCreate('deepLinkTarget', { page: 'ProductDetail', id });
        break;
      case 'settings':
        AppStorage.setOrCreate('deepLinkTarget', { page: 'Settings' });
        break;
    }
  }
}

// 页面中消费 Deep Link
@StorageProp('deepLinkTarget') deepLink: Record<string, string> = {};

aboutToAppear(): void {
  if (this.deepLink?.page === 'ProductDetail') {
    this.navStack.pushPath({ name: 'ProductDetail', param: this.deepLink.id });
    AppStorage.setOrCreate('deepLinkTarget', {});
  }
}
```

---

## 十八、应用生命周期管理

```typescript
// EntryAbility.ets — 完整生命周期
import { UIAbility, AbilityConstant } from '@kit.AbilityKit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 初始化全局资源（数据库、网络、日志）
    hilog.info(0x0, 'App', 'onCreate');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 加载首页
    windowStage.loadContent('pages/Index');
  }

  onForeground(): void {
    // 恢复定时器、刷新数据
    hilog.info(0x0, 'App', 'onForeground');
  }

  onBackground(): void {
    // 暂停定时器、保存状态
    hilog.info(0x0, 'App', 'onBackground');
  }

  onWindowStageDestroy(): void {
    // 释放窗口资源
  }

  onDestroy(): void {
    // 释放全局资源
    hilog.info(0x0, 'App', 'onDestroy');
  }
}
```

---

## 十九、剪贴板操作

```typescript
import { pasteboard } from '@kit.BasicServicesKit';

/** 复制文本到剪贴板 */
function copyText(text: string): void {
  const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
  const board = pasteboard.getSystemPasteboard();
  board.setData(pasteData);
  promptAction.showToast({ message: '已复制' });
}

/** 从剪贴板读取文本 */
async function pasteText(): Promise<string> {
  const board = pasteboard.getSystemPasteboard();
  const data = await board.getData();
  if (data.hasType(pasteboard.MIMETYPE_TEXT_PLAIN)) {
    return data.getPrimaryText();
  }
  return '';
}
```

---

## 二十、系统分享

```typescript
import { common } from '@kit.AbilityKit';

/** 调用系统分享面板 */
function shareText(context: common.UIAbilityContext, title: string, text: string): void {
  const want: Want = {
    action: 'ohos.want.action.select',
    type: 'text/plain',
    parameters: {
      'ability.want.params.INTENT': {
        action: 'ohos.want.action.sendData',
        type: 'text/plain',
        parameters: {
          'shareTitle': title,
          'ability.want.params.TEXT': text,
        }
      } as Want
    }
  };
  context.startAbility(want);
}
```

---

## 二十一、版本检测与更新提示

```typescript
import { bundleManager } from '@kit.AbilityKit';

interface VersionInfo {
  latestVersion: string;
  forceUpdate: boolean;
  downloadUrl: string;
}

async function checkUpdate(): Promise<void> {
  const bundleInfo = await bundleManager.getBundleInfoForSelf(0);
  const currentVersion = bundleInfo.versionName;

  // 调用后端获取最新版本
  const info: VersionInfo = await HttpUtil.get('/api/app/version');

  if (compareVersion(currentVersion, info.latestVersion) < 0) {
    if (info.forceUpdate) {
      // 强制更新弹窗（不可关闭）
      showForceUpdateDialog(info);
    } else {
      // 可选更新弹窗
      showOptionalUpdateDialog(info);
    }
  }
}

function compareVersion(v1: string, v2: string): number {
  const a = v1.split('.').map(Number);
  const b = v2.split('.').map(Number);
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    const diff = (a[i] || 0) - (b[i] || 0);
    if (diff !== 0) return diff;
  }
  return 0;
}
```

---

## 二十二、全局错误边界

```typescript
// ErrorBoundary.ets — 全局错误捕获 + 降级 UI
@Component
struct ErrorBoundary {
  @Prop childBuilder: () => void;
  @State hasError: boolean = false;
  @State errorMsg: string = '';

  build() {
    if (this.hasError) {
      Column() {
        Image($r('app.media.error_icon'))
          .width(80).height(80).margin({ bottom: 16 })
        Text('页面出现异常')
          .fontSize(18).fontColor('#333')
        Text(this.errorMsg)
          .fontSize(12).fontColor('#999').margin({ top: 8 })
        Button('重试')
          .onClick(() => { this.hasError = false; })
          .margin({ top: 24 })
      }
      .width('100%').height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      this.childBuilder();
    }
  }
}

// 全局未捕获异常处理（EntryAbility）
import { errorManager } from '@kit.AbilityKit';

// 注册全局错误监听
const observerId = errorManager.on('error', {
  onUnhandledException(errMsg: string): void {
    hilog.error(0x0, 'GlobalError', 'Unhandled: %{public}s', errMsg);
    // 上报 + 降级
  }
});
```

---

## 二十三、事件埋点 / 分析追踪

```typescript
// utils/Analytics.ets
import { hiAppEvent } from '@kit.PerformanceAnalysisKit';

export class Analytics {
  /** 自定义事件埋点 */
  static track(event: string, params: Record<string, string | number> = {}): void {
    hiAppEvent.write({
      domain: 'app_event',
      name: event,
      eventType: hiAppEvent.EventType.BEHAVIOR,
      params: params,
    });
  }

  /** 页面曝光 */
  static pageView(pageName: string): void {
    Analytics.track('page_view', { page: pageName, ts: Date.now() });
  }

  /** 点击事件 */
  static click(element: string, extra?: Record<string, string>): void {
    Analytics.track('click', { element, ...extra });
  }
}

// 用法
Analytics.pageView('ProductDetail');
Analytics.click('buy_button', { productId: '123' });
```

---

## 官方参考
- ArkTS 语言指南: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-get-started
- ArkUI 组件参考: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-components-summary
- http 网络: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/http-request
- 权限申请: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/request-user-authorization
- AppStorage: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-appstorage
