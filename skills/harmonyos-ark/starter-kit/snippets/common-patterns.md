# ArkTS / ArkUI 常用代码片段

> 随取随用。复制粘贴，按注释替换业务字段。

<!-- Agent 摘要：约 1400 行，33 个代码模式。按编号搜索（如 "## 一"/"## 十四"）定位。
     模式覆盖：HTTP/JSON/路由/弹窗/权限/图片缓存/文件存储/Deep Link/生命周期/错误边界/埋点/
     下拉刷新/搜索防抖/RDB/通知/Worker/定时器/主题切换/国际化/生物认证/WebSocket。 -->

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
@StorageLink('key')  // 持久化 AppStorage 双向绑定（仅基础/可序列化状态，不绑定 @ObservedV2 class）
@LocalStorageLink    // LocalStorage 双向绑定（HAP 内）

// ── 新版（API 12+）推荐 ─────────────────────────────────
@ObservedV2   // 替代 @Observed，类级别
@Trace        // 替代 @ObjectLink，字段级别
```

---

## 三、Navigation 页面路由（推荐）

```typescript
// 声明 NavPathStack（在根 @Entry 组件中）
@Provide('navStack') navStack: NavPathStack = new NavPathStack()

// 在子组件中获取
@Consume('navStack') navStack: NavPathStack

// 跳转（压栈，可返回）
this.navStack.pushPath({ name: 'DetailPage', param: { id: '123' } as Record<string, string> })

// 替换栈顶（无法返回）
this.navStack.replacePath({ name: 'HomePage' })

// 返回上一页
this.navStack.pop()

// 返回到指定页
this.navStack.popToName('HomePage')

// 清空导航栈
this.navStack.clear()
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
const res = await promptAction.showDialog({
  title: '确认',
  message: '确定要删除吗？',
  buttons: [
    { text: '取消', color: '#999' },
    { text: '删除', color: '#FF3B30' }
  ]
})
if (res.index === 1) {
  // 用户点了"删除"
}
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
  const result = await atManager.requestPermissionsFromUser(getContext(this), permissions)
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
  @Provide('navStack') navStack: NavPathStack = new NavPathStack()
  @StorageLink('forceLogout') forceLogoutTs: number = 0
  private lastLogout: number = 0

  build() { /* ... */ }

  // forceLogoutTs 变化时触发跳转
  onForceLogout() {
    if (this.forceLogoutTs !== this.lastLogout && this.forceLogoutTs !== 0) {
      this.lastLogout = this.forceLogoutTs
      promptAction.showToast({ message: '登录已过期，请重新登录' })
      this.navStack.clear()
      this.navStack.pushPath({ name: 'LoginPage' })
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
    this.getUIContext()?.animateTo({ duration: 300, curve: Curve.EaseOut }, () => {
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

async function showRetryDialog(message: string, onRetry: () => void): Promise<void> {
  const result = await promptAction.showDialog({
    title: '操作失败',
    message: message,
    buttons: [
      { text: '取消', color: '#999' },
      { text: '重试', color: '#007AFF' }
    ]
  })
  if (result.index === 1) {
    onRetry()
  }
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

## 二十四、下拉刷新 + 上拉加载

```typescript
// pages/RefreshListPage.ets
import { http } from '@kit.NetworkKit'

interface ListItem {
  id: number
  title: string
}

interface PageResponse {
  list: ListItem[]
  hasMore: boolean
}

@Entry
@Component
struct RefreshListPage {
  @State isRefreshing: boolean = false
  @State isLoadingMore: boolean = false
  @State currentPage: number = 1
  @State dataList: ListItem[] = []
  @State hasMore: boolean = true

  aboutToAppear(): void {
    this.loadData(1, false)
  }

  async loadData(page: number, append: boolean): Promise<void> {
    let req = http.createHttp()
    try {
      const resp: http.HttpResponse = await req.request(`https://api.example.com/items?page=${page}`, {
        method: http.RequestMethod.GET,
      })
      let body: PageResponse = JSON.parse(resp.result as string) as PageResponse
      if (append) {
        this.dataList = this.dataList.concat(body.list)
      } else {
        this.dataList = body.list
      }
      this.currentPage = page
      this.hasMore = body.hasMore
    } catch (e) {
      // 请求失败静默处理
    } finally {
      this.isRefreshing = false
      this.isLoadingMore = false
      req.destroy()
    }
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List({ space: 12 }) {
        ForEach(this.dataList, (item: ListItem) => {
          ListItem() {
            Text(item.title)
              .fontSize(16)
              .padding(16)
          }
        }, (item: ListItem) => item.id.toString())
      }
      .onReachEnd(() => {
        if (!this.isLoadingMore && this.hasMore) {
          this.isLoadingMore = true
          this.loadData(this.currentPage + 1, true)
        }
      })
    }
    .onRefreshing(() => {
      this.loadData(1, false)
    })
  }
}
```

> 💡 **Tips**: `Refresh` 组件自动处理下拉手势；`onReachEnd` 在列表滚到底时触发上拉加载。务必用 `isLoadingMore` 标志位防止重复请求。

---

## 二十五、搜索防抖

```typescript
// pages/SearchPage.ets

interface SearchResult {
  id: string
  name: string
}

@Entry
@Component
struct SearchPage {
  @State searchText: string = ''
  @State searchResults: SearchResult[] = []
  private debounceTimer: number = -1
  private readonly DEBOUNCE_MS: number = 300

  doSearch(keyword: string): void {
    if (keyword.length === 0) {
      this.searchResults = []
      return
    }
    // 替换为真实 API 调用
    console.info(`Searching: ${keyword}`)
    let mockResults: SearchResult[] = [
      { id: '1', name: `Result for ${keyword}` },
    ]
    this.searchResults = mockResults
  }

  onInputChange(value: string): void {
    this.searchText = value
    if (this.debounceTimer !== -1) {
      clearTimeout(this.debounceTimer)
    }
    this.debounceTimer = setTimeout(() => {
      this.doSearch(value)
      this.debounceTimer = -1
    }, this.DEBOUNCE_MS)
  }

  build() {
    Column({ space: 12 }) {
      TextInput({ placeholder: '请输入搜索关键词', text: this.searchText })
        .onChange((value: string) => {
          this.onInputChange(value)
        })
        .width('100%')

      List({ space: 8 }) {
        ForEach(this.searchResults, (item: SearchResult) => {
          ListItem() {
            Text(item.name).fontSize(14).padding(12)
          }
        }, (item: SearchResult) => item.id)
      }
    }
    .padding(16)
  }
}
```

> 💡 **Tips**: 防抖核心是 `clearTimeout` + `setTimeout`，避免每次按键都发起请求。300ms 是常见阈值；对即时性要求高的场景可缩短至 150ms。

---

## 二十六、RDB 关系型数据库

```typescript
// utils/DbHelper.ets
import { relationalStore } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'

const DB_NAME = 'app.db'
const TABLE_USER = 'user'

interface UserRow {
  id: number
  name: string
  age: number
}

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: DB_NAME,
  securityLevel: relationalStore.SecurityLevel.S1,
}

const CREATE_TABLE_SQL: string =
  `CREATE TABLE IF NOT EXISTS ${TABLE_USER} (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age INTEGER NOT NULL)`

export class DbHelper {
  private static store: relationalStore.RdbStore | null = null

  static async init(context: common.UIAbilityContext): Promise<void> {
    DbHelper.store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    await DbHelper.store.executeSql(CREATE_TABLE_SQL)
  }

  static async insert(name: string, age: number): Promise<number> {
    let bucket: relationalStore.ValuesBucket = { name: name, age: age }
    let rowId: number = await DbHelper.store!.insert(TABLE_USER, bucket)
    return rowId
  }

  static async queryAll(): Promise<UserRow[]> {
    let predicates = new relationalStore.RdbPredicates(TABLE_USER)
    let resultSet = await DbHelper.store!.query(predicates, ['id', 'name', 'age'])
    let list: UserRow[] = []
    while (resultSet.goToNextRow()) {
      let row: UserRow = {
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        age: resultSet.getLong(resultSet.getColumnIndex('age')) as number,
      }
      list.push(row)
    }
    resultSet.close()
    return list
  }

  static async update(id: number, name: string, age: number): Promise<number> {
    let bucket: relationalStore.ValuesBucket = { name: name, age: age }
    let predicates = new relationalStore.RdbPredicates(TABLE_USER)
    predicates.equalTo('id', id)
    let affected: number = await DbHelper.store!.update(bucket, predicates)
    return affected
  }

  static async deleteById(id: number): Promise<number> {
    let predicates = new relationalStore.RdbPredicates(TABLE_USER)
    predicates.equalTo('id', id)
    let affected: number = await DbHelper.store!.delete(predicates)
    return affected
  }
}
```

> 💡 **Tips**: `relationalStore` 是 HarmonyOS 的轻量关系型数据库，适合结构化本地数据。务必在 `EntryAbility.onCreate` 中调用 `DbHelper.init(context)` 完成初始化。

---

## 二十七、本地通知

```typescript
// utils/NotifyUtil.ets
import { notificationManager } from '@kit.NotificationKit'

export class NotifyUtil {
  /** 请求通知授权 */
  static async requestPermission(): Promise<void> {
    await notificationManager.requestEnableNotification()
  }

  /** 发布基础文本通知 */
  static async publishText(title: string, body: string): Promise<void> {
    let request: notificationManager.NotificationRequest = {
      id: Date.now() % 100000,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: title,
          text: body,
          additionalText: '',
        },
      },
    }
    await notificationManager.publish(request)
  }

  /** 发布进度通知 */
  static async publishProgress(title: string, percent: number): Promise<void> {
    let template: notificationManager.NotificationTemplate = {
      name: 'downloadTemplate',
      data: { title: title, fileName: title, progressValue: percent },
    }
    let request: notificationManager.NotificationRequest = {
      id: 9999,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: title,
          text: `${percent}%`,
          additionalText: '',
        },
      },
      template: template,
    }
    await notificationManager.publish(request)
  }
}

// 用法
// await NotifyUtil.requestPermission()
// await NotifyUtil.publishText('下载完成', '文件已保存到本地')
// await NotifyUtil.publishProgress('正在下载...', 45)
```

> 💡 **Tips**: 首次发送通知前必须调用 `requestEnableNotification()` 获取授权。通知 ID 相同时会覆盖旧通知，适合进度更新场景。

---

## 二十八、Worker 线程

```typescript
// pages/WorkerDemo.ets — 主线程侧
import { worker } from '@kit.ArkTS'

interface WorkerResult {
  sum: number
}

@Entry
@Component
struct WorkerDemo {
  @State result: string = '等待计算...'
  private myWorker: worker.ThreadWorker | null = null

  aboutToAppear(): void {
    this.myWorker = new worker.ThreadWorker('entry/ets/workers/CalcWorker.ets')
    this.myWorker.onmessage = (event: MessageEvents) => {
      let data: WorkerResult = event.data as WorkerResult
      this.result = `计算结果: ${data.sum}`
    }
    this.myWorker.onerror = (err: ErrorEvent) => {
      this.result = `Worker 错误: ${err.message}`
    }
  }

  aboutToDisappear(): void {
    if (this.myWorker !== null) {
      this.myWorker.terminate()
      this.myWorker = null
    }
  }

  build() {
    Column({ space: 16 }) {
      Text(this.result).fontSize(18)
      Button('开始计算')
        .onClick(() => {
          this.myWorker?.postMessage({ start: 1, end: 1000000 })
        })
    }
    .padding(24)
  }
}
```

```typescript
// workers/CalcWorker.ets — Worker 侧
import { worker, MessageEvents } from '@kit.ArkTS'

const workerPort = worker.workerPort

interface CalcTask {
  start: number
  end: number
}

workerPort.onmessage = (event: MessageEvents) => {
  let task: CalcTask = event.data as CalcTask
  let sum: number = 0
  for (let i: number = task.start; i <= task.end; i++) {
    sum += i
  }
  workerPort.postMessage({ sum: sum })
}
```

> 💡 **Tips**: Worker 运行在独立线程，适合 CPU 密集计算（大数组排序、加密等）。记得在页面销毁时 `terminate()`，否则线程泄漏。Worker 文件路径需在 `build-profile.json5` 中注册。

---

## 二十九、倒计时 / 定时器

```typescript
// pages/CountdownPage.ets

@Entry
@Component
struct CountdownPage {
  @State countdown: number = 120 // 总秒数
  private timerId: number = -1

  aboutToAppear(): void {
    this.startTimer()
  }

  aboutToDisappear(): void {
    this.stopTimer()
  }

  startTimer(): void {
    this.timerId = setInterval(() => {
      if (this.countdown <= 0) {
        this.stopTimer()
        return
      }
      this.countdown--
    }, 1000)
  }

  stopTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
    }
  }

  formatTime(totalSeconds: number): string {
    let minutes: number = Math.floor(totalSeconds / 60)
    let seconds: number = totalSeconds % 60
    let mm: string = minutes < 10 ? `0${minutes}` : `${minutes}`
    let ss: string = seconds < 10 ? `0${seconds}` : `${seconds}`
    return `${mm}:${ss}`
  }

  build() {
    Column({ space: 24 }) {
      Text(this.formatTime(this.countdown))
        .fontSize(48)
        .fontWeight(FontWeight.Bold)

      Row({ space: 16 }) {
        Button('重置')
          .onClick(() => {
            this.stopTimer()
            this.countdown = 120
          })
        Button('开始')
          .onClick(() => {
            this.stopTimer()
            this.startTimer()
          })
      }
    }
    .padding(24)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

> 💡 **Tips**: 必须在 `aboutToDisappear` 中清理定时器，否则页面销毁后回调仍会执行导致异常。`setInterval` 返回值用于后续 `clearInterval`。

---

## 三十、主题切换（深色 / 浅色）

```typescript
// pages/ThemeSwitchPage.ets

const THEME_KEY: string = 'currentTheme'

type ThemeMode = 'light' | 'dark'

@Entry
@Component
struct ThemeSwitchPage {
  @StorageProp(THEME_KEY) currentTheme: ThemeMode = 'light'

  aboutToAppear(): void {
    let saved: ThemeMode | undefined = AppStorage.get<ThemeMode>(THEME_KEY)
    if (saved === undefined) {
      AppStorage.setOrCreate<ThemeMode>(THEME_KEY, 'light')
    }
  }

  toggleTheme(): void {
    let next: ThemeMode = this.currentTheme === 'light' ? 'dark' : 'light'
    AppStorage.setOrCreate<ThemeMode>(THEME_KEY, next)
  }

  build() {
    Column({ space: 20 }) {
      Text('主题切换示例')
        .fontSize(22)
        .fontColor(this.currentTheme === 'dark' ? Color.White : Color.Black)

      Button(this.currentTheme === 'dark' ? '切换到浅色' : '切换到深色')
        .onClick(() => {
          this.toggleTheme()
        })

      Text('当前主题: ' + this.currentTheme)
        .fontSize(14)
        .fontColor(Color.Gray)
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.currentTheme === 'dark' ? '#1a1a1a' : '#ffffff')
  }
}

// 在子组件中获取主题
@Component
struct ThemedCard {
  @StorageProp(THEME_KEY) currentTheme: ThemeMode = 'light'

  build() {
    Column() {
      Text('卡片内容')
        .fontColor(this.currentTheme === 'dark' ? '#e0e0e0' : '#333333')
    }
    .padding(16)
    .borderRadius(8)
    .backgroundColor(this.currentTheme === 'dark' ? '#2c2c2c' : '#f5f5f5')
  }
}
```

> 💡 **Tips**: `@StorageProp` 实现全局主题响应——任意组件修改 `AppStorage` 值后，所有绑定该 key 的组件自动刷新。系统颜色可用 `$r('sys.color.ohos_id_color_background')` 获取。

---

## 三十一、多语言 / 国际化

```typescript
// pages/I18nPage.ets
import { common } from '@kit.AbilityKit'
import { resourceManager } from '@kit.LocalizationKit'

@Entry
@Component
struct I18nPage {
  @State greeting: string = ''
  @State itemCount: string = ''

  aboutToAppear(): void {
    this.loadStrings()
  }

  loadStrings(): void {
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
    let resMgr: resourceManager.ResourceManager = context.resourceManager
    // 同步获取字符串资源
    this.greeting = resMgr.getStringSync($r('app.string.hello_message').id)
    // 带参数的字符串（资源定义: "共 %d 件商品"）
    this.itemCount = resMgr.getStringSync($r('app.string.item_count').id, 5)
  }

  build() {
    Column({ space: 16 }) {
      // 方式一：直接使用 $r 引用（推荐，自动跟随系统语言）
      Text($r('app.string.app_name'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)

      // 方式二：动态获取后赋值
      Text(this.greeting)
        .fontSize(18)

      Text(this.itemCount)
        .fontSize(14)
        .fontColor(Color.Gray)

      // 图片国际化：按 qualifier 目录自动加载
      Image($r('app.media.banner'))
        .width('100%')
        .height(120)
        .objectFit(ImageFit.Cover)
    }
    .padding(24)
  }
}

// resources/base/element/string.json   — 默认（中文）
// { "string": [{ "name": "hello_message", "value": "你好，欢迎使用" }] }
//
// resources/en_US/element/string.json  — 英文
// { "string": [{ "name": "hello_message", "value": "Hello, welcome" }] }
```

> 💡 **Tips**: 优先用 `$r('app.string.xxx')` 静态引用，框架自动按系统语言匹配资源。仅在需要动态拼接时使用 `getStringSync()`。多语言资源按 `resources/<locale>/element/` 目录组织。

---

## 三十二、生物认证

```typescript
// utils/BiometricAuth.ets
import { userAuth } from '@kit.UserAuthenticationKit'

interface AuthResult {
  success: boolean
  message: string
}

export class BiometricAuth {
  /** 检查设备是否支持指纹/面部认证 */
  static checkAvailability(): boolean {
    try {
      let mgr = userAuth.getUserAuthInstance({
        authType: [userAuth.UserAuthType.FINGERPRINT],
        authTrustLevel: userAuth.AuthTrustLevel.ATL3,
      })
      return mgr !== null
    } catch (e) {
      console.error(`BiometricAuth check failed: ${(e as Error).message}`)
      return false
    }
  }

  /** 发起认证 */
  static authenticate(): Promise<AuthResult> {
    return new Promise<AuthResult>((resolve) => {
      let authParam: userAuth.AuthParam = {
        challenge: new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8]),
        authType: [userAuth.UserAuthType.FINGERPRINT],
        authTrustLevel: userAuth.AuthTrustLevel.ATL3,
      }
      let widgetParam: userAuth.WidgetParam = {
        title: '请验证身份',
      }

      try {
        let auth = userAuth.getUserAuthInstance(authParam, widgetParam)

        auth.on('result', (result: userAuth.UserAuthResult) => {
          if (result.result === userAuth.UserAuthResultCode.SUCCESS) {
            resolve({ success: true, message: '认证成功' })
          } else {
            resolve({ success: false, message: `认证失败: ${result.result}` })
          }
        })

        auth.start()
      } catch (e) {
        resolve({ success: false, message: `认证异常: ${(e as Error).message}` })
      }
    })
  }
}

// 用法
// let available: boolean = BiometricAuth.checkAvailability()
// if (available) {
//   let result: AuthResult = await BiometricAuth.authenticate()
//   console.info(result.message)
// }
```

> 💡 **Tips**: 生物认证需要在 `module.json5` 声明 `ohos.permission.ACCESS_BIOMETRIC`。`AuthTrustLevel` 从 ATL1 到 ATL4，级别越高安全要求越严（ATL3 适合支付场景）。

---

## 三十三、WebSocket 实时通信

```typescript
// utils/WsClient.ets
import { webSocket } from '@kit.NetworkKit'

interface WsMessage {
  type: string
  data: string
}

export class WsClient {
  private ws: webSocket.WebSocket | null = null
  private url: string = ''
  private retryCount: number = 0
  private readonly MAX_RETRIES: number = 5
  private readonly RETRY_DELAY_MS: number = 3000
  onMessage: (msg: WsMessage) => void = () => {}
  onStatusChange: (connected: boolean) => void = () => {}

  connect(url: string): void {
    this.url = url
    this.retryCount = 0
    this.doConnect()
  }

  private doConnect(): void {
    this.ws = webSocket.createWebSocket()

    this.ws.on('open', () => {
      console.info('WebSocket connected')
      this.retryCount = 0
      this.onStatusChange(true)
    })

    this.ws.on('message', (err: Error, value: string | ArrayBuffer) => {
      if (typeof value === 'string') {
        let msg: WsMessage = JSON.parse(value) as WsMessage
        this.onMessage(msg)
      }
    })

    this.ws.on('close', () => {
      console.info('WebSocket closed')
      this.onStatusChange(false)
      this.tryReconnect()
    })

    this.ws.on('error', (err: Error) => {
      console.error(`WebSocket error: ${err.message}`)
      this.onStatusChange(false)
    })

    this.ws.connect(this.url)
  }

  send(msg: WsMessage): void {
    if (this.ws !== null) {
      this.ws.send(JSON.stringify(msg))
    }
  }

  private tryReconnect(): void {
    if (this.retryCount >= this.MAX_RETRIES) {
      console.error('WebSocket max retries reached')
      return
    }
    this.retryCount++
    console.info(`WebSocket reconnecting (${this.retryCount}/${this.MAX_RETRIES})...`)
    setTimeout(() => {
      this.doConnect()
    }, this.RETRY_DELAY_MS)
  }

  close(): void {
    if (this.ws !== null) {
      this.ws.off('close')
      this.ws.close()
      this.ws = null
    }
  }
}

// 用法
// let client = new WsClient()
// client.onMessage = (msg: WsMessage) => { console.info(msg.data) }
// client.connect('ws://your-server.example.com/ws')
// client.send({ type: 'chat', data: 'Hello!' })
```

> 💡 **Tips**: 断线重连是 WebSocket 必备——使用递增计数 + 最大重试次数防止无限重连。`close()` 前先 `off('close')` 避免关闭时触发重连逻辑。记得在页面 `aboutToDisappear` 中调用 `client.close()`。

---

## 三十四、Navigation 页面路由（推荐替代 Router）

> ⚠️ HarmonyOS 推荐使用 Navigation 组件替代 router API。Navigation 支持标题栏、工具栏、路由管理一体化。

```typescript
// 1. 入口页：使用 Navigation 作为根容器
@Entry
@Component
struct Index {
  private navStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navStack) {
      Column() {
        Button('去详情')
          .onClick(() => {
            this.navStack.pushPath({ name: 'DetailPage', param: { id: '123' } as Record<string, string> })
          })
        Button('去设置')
          .onClick(() => {
            this.navStack.pushPath({ name: 'SettingsPage' })
          })
      }
    }
    .navDestination(this.pageBuilder)
    .title('首页')
  }

  @Builder
  pageBuilder(name: string, param: Object): void {
    if (name === 'DetailPage') {
      DetailPage()
    } else if (name === 'SettingsPage') {
      SettingsPage()
    }
  }
}

// 2. 子页面：使用 NavDestination
@Component
struct DetailPage {
  build() {
    NavDestination() {
      Column() {
        Text('详情页内容')
      }
    }
    .title('详情')
  }
}

// 3. 常用导航操作
// navStack.pushPath({ name: 'Page', param: data })  // 跳转
// navStack.replacePath({ name: 'Page' })             // 替换栈顶
// navStack.pop()                                     // 返回上一页
// navStack.clear()                                   // 清空导航栈
// navStack.popToName('Page')                         // 回退到指定页
```

> 💡 **Tips**: Navigation 替代 Router 的关键优势——支持嵌套子导航、系统返回手势自动处理、标题栏/工具栏声明式配置。Router 仍可用但新项目请优先 Navigation。

---

## 官方参考
- ArkTS 语言指南: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-get-started
- ArkUI 组件参考: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-components-summary
- http 网络: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/http-request
- 权限申请: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/request-user-authorization
- AppStorage: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-appstorage
