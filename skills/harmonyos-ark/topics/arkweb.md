# ArkWeb 方舟 Web（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V5/API 12）
> 覆盖：Web 组件基础、JS Bridge 双向调用、Cookie 管理、深色模式、同层渲染、离线 Web、DevTools 调试


## 目录

- [ArkWeb 简介](#arkweb-简介)
- [Web 组件基础](#web-组件基础)
- [JS Bridge 双向通信](#js-bridge-双向通信)
- [Cookie 与数据存储](#cookie-与数据存储)
- [深色模式](#深色模式)
- [同层渲染](#同层渲染)
- [离线 Web 组件](#离线-web-组件)
- [DevTools 调试](#devtools-调试)
- [常见陷阱与最佳实践](#常见陷阱与最佳实践)

---

## ArkWeb 简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-component-overview-V5

ArkWeb（方舟 Web）提供 Web 组件，用于在应用中显示 Web 页面内容。基于 Chromium M114 内核。

### 典型场景

| 场景 | 说明 |
|------|------|
| 应用集成 H5 | 嵌入 Web 页面降低开发成本 |
| 浏览器 | 打开三方网页、无痕模式、广告拦截 |
| 小程序宿主 | 渲染小程序页面 |
| 混合开发 | 原生 + Web 混合架构 |

### 能力范围

- Web 页面加载（声明式加载 / 离屏加载）
- 生命周期管理与加载状态通知
- 常用属性：UserAgent、Cookie、深色模式、权限管理
- App ↔ Web 的 JavaScript 交互（JavaScriptProxy）
- 安全隐私：无痕模式、广告拦截
- 调试维测：DevTools 工具
- 同层渲染、网络托管、媒体播放托管

### 原生 vs ArkWeb 方案选择

| 维度 | 原生 ArkUI | ArkWeb（WebView） |
|------|-----------|------------------|
| **性能** | ⭐⭐⭐ 原生渲染最快 | ⭐⭐ Web 内核开销较大 |
| **开发效率** | ⭐⭐ 需学习 ArkTS | ⭐⭐⭐ 复用已有 H5 |
| **动态更新** | ⭐ 需发版 | ⭐⭐⭐ 服务端即时更新 |
| **系统能力** | ⭐⭐⭐ 完整 API | ⭐⭐ 需 Bridge 桥接 |
| **审核风险** | ⭐⭐⭐ 低 | ⭐⭐ 纯 WebView 套壳可能被拒 |

> 💡 **决策建议**：核心页面用原生 → 运营页/活动页用 ArkWeb → 混合架构用同层渲染。

### 约束限制

- 基于 Chromium M114
- 部分 Web 标准能力可能与最新 Chrome 有差异

---

## Web 组件基础

### 最简用法

```typescript
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebPage {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: 'https://example.com', controller: this.controller })
        .width('100%')
        .height('100%')
    }
  }
}
```

### 加载本地 HTML

```typescript
// 加载 rawfile 目录下的 HTML
Web({ src: $rawfile('index.html'), controller: this.controller })

// 加载 HTML 字符串
this.controller.loadData(
  '<html><body><h1>Hello</h1></body></html>',
  'text/html',
  'UTF-8'
);
```

### 生命周期事件

```typescript
Web({ src: 'https://example.com', controller: this.controller })
  .onPageBegin((event) => {
    console.info('Page begin: ' + event?.url);
  })
  .onPageEnd((event) => {
    console.info('Page end: ' + event?.url);
  })
  .onErrorReceive((event) => {
    console.error('Error: ' + event?.error.getErrorInfo());
  })
  .onProgressChange((event) => {
    console.info('Progress: ' + event?.newProgress);
  })
```

### 页面导航

```typescript
// 后退
this.controller.backward();
// 前进
this.controller.forward();
// 刷新
this.controller.refresh();
// 停止加载
this.controller.stop();
// 检查是否可后退
this.controller.accessBackward();
```

---

## JS Bridge 双向通信

### 应用侧调用前端 JS 函数

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-in-app-frontend-page-function-invoking-V5

```typescript
// 调用 Web 页面中的 JavaScript 函数
this.controller.runJavaScript('callFromNative("Hello from ArkTS")')
  .then((result) => {
    console.info('JS result: ' + result);
  });
```

### 前端 JS 调用应用侧函数

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-in-page-app-function-invoking-V5

**方式一：JavaScriptProxy（推荐）**

```typescript
// 定义供 JS 调用的对象
class NativeBridge {
  showToast(message: string): string {
    console.info('JS called showToast: ' + message);
    return 'received: ' + message;
  }

  getUserInfo(): string {
    return JSON.stringify({ name: 'User', id: 123 });
  }
}

// 注册到 Web 组件
Web({ src: $rawfile('index.html'), controller: this.controller })
  .javaScriptProxy({
    object: new NativeBridge(),
    name: 'nativeBridge',    // JS 中通过 window.nativeBridge 访问
    methodList: ['showToast', 'getUserInfo'],
    controller: this.controller,
  })
```

前端 JS 调用：

```javascript
// index.html 中
const result = window.nativeBridge.showToast('Hello from JS');
const userInfo = JSON.parse(window.nativeBridge.getUserInfo());
```

**方式二：registerJavaScriptProxy（动态注册）**

```typescript
const bridge = new NativeBridge();
this.controller.registerJavaScriptProxy(
  bridge, 'nativeBridge', ['showToast', 'getUserInfo']
);
// 注册后需要刷新页面才能生效
this.controller.refresh();
```

> ⚠️ **关键区别**：`javaScriptProxy` 在组件声明时注册，立即生效；`registerJavaScriptProxy` 动态注册后需要 `refresh()`。

### 建立数据通道

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-app-page-data-channel-V5

```typescript
import { webview } from '@kit.ArkWeb';

// 创建消息端口
const ports = this.controller.createWebMessagePorts();
// port[0] 给应用侧用，port[1] 发给 Web 页面

// 应用侧监听消息
ports[0].onMessageEvent((result) => {
  console.info('Received from Web: ' + result.getMessage());
});

// 发送端口给 Web 页面
this.controller.postMessage(
  'transferPort', [ports[1]], '*'
);

// 应用侧发送消息
let msg = new webview.WebMessage();
msg.setString('Hello from Native');
ports[0].postMessageEvent(msg);
```

前端 JS 接收：

```javascript
window.addEventListener('message', (event) => {
  if (event.data === 'transferPort') {
    const port = event.ports[0];
    port.onmessage = (e) => {
      console.log('From Native:', e.data);
    };
    port.postMessage('Hello from Web');
  }
});
```

---

## Cookie 与数据存储

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-cookie-and-data-storage-mgmt-V5

### Cookie 管理

```typescript
import { webview } from '@kit.ArkWeb';

// 设置 Cookie
webview.WebCookieManager.setCookie(
  'https://example.com',
  'key=value; path=/; secure'
);

// 获取 Cookie
const cookies = webview.WebCookieManager.getCookie('https://example.com');

// 清除所有 Cookie
webview.WebCookieManager.clearAllCookies();

// 保存 Cookie 到磁盘（持久化）
webview.WebCookieManager.saveCookieAsync();
```

### Web Storage

```typescript
// 清除 Web Storage
webview.WebStorage.deleteAllData();

// 获取 Origin 列表
webview.WebStorage.getOrigins()
  .then((origins) => {
    for (const origin of origins) {
      console.info('Origin: ' + origin.origin + ', usage: ' + origin.usage);
    }
  });
```

### 缓存管理

```typescript
// 清除缓存
this.controller.removeCache(true);  // true = 包含磁盘缓存

// 设置缓存模式
Web({ src: url, controller: this.controller })
  .cacheMode(CacheMode.Default)  // Default / None / Online / Only
```

---

## 深色模式

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-set-dark-mode-V5

```typescript
import { WebDarkMode } from '@kit.ArkWeb';

Web({ src: 'https://example.com', controller: this.controller })
  .darkMode(WebDarkMode.Auto)         // Auto / On / Off
  .forceDarkAccess(false)              // true = 强制深色（即使网页不支持）
```

| 模式 | 说明 |
|------|------|
| `Off` | 关闭深色模式 |
| `On` | 开启深色模式 |
| `Auto` | 跟随系统设置（推荐） |

> ⚠️ `forceDarkAccess(true)` 会强制反色，可能导致已适配深色的网页显示异常。

---

## 同层渲染

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-same-layer-V5

同层渲染允许将原生组件（如 Video、Map）嵌入 Web 页面中，与 Web 内容同层显示。

### 使用场景

- 在 H5 页面中嵌入原生视频播放器
- 在 Web 页面中嵌入原生地图组件
- 小程序中使用原生组件

### 基本用法

前端 HTML 中使用 embed 标签：

```html
<embed id="nativeVideo" type="native/video"
  style="width: 100%; height: 300px;"
  src="video_url" />
```

应用侧注册同层渲染节点：

```typescript
Web({ src: $rawfile('same-layer.html'), controller: this.controller })
  .enableNativeEmbedMode(true)
  .onNativeEmbedLifecycleChange((embed) => {
    if (embed.status === NativeEmbedStatus.CREATE) {
      // 创建原生组件
    } else if (embed.status === NativeEmbedStatus.DESTROY) {
      // 销毁原生组件
    }
  })
```

> ⚠️ 同层渲染性能开销较大，建议仅在必要场景使用。

---

## 离线 Web 组件

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-offline-mode-V5

离线 Web 组件允许在后台预加载和缓存 Web 页面，提升首屏加载速度。

### 离屏渲染

```typescript
// 在后台预创建 Web 组件
webview.WebviewController.prepareForPageLoad(
  'https://example.com', true, 2
);
```

### 网络拦截（本地资源替代）

```typescript
Web({ src: url, controller: this.controller })
  .onInterceptRequest((event) => {
    const url = event?.request.getRequestUrl();
    if (url?.endsWith('.js')) {
      // 返回本地缓存的 JS 文件
      let response = new WebResourceResponse();
      response.setResponseData($rawfile('cached.js'));
      response.setResponseEncoding('UTF-8');
      response.setResponseMimeType('application/javascript');
      response.setResponseCode(200);
      return response;
    }
    return null;  // 不拦截，走正常网络
  })
```

---

## DevTools 调试

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-debugging-with-devtools-V5

### 启用调试

```typescript
Web({ src: url, controller: this.controller })
  .webDebuggingAccess(true)  // 启用 DevTools 调试
```

### 连接调试

1. USB 连接设备到开发机
2. 执行端口转发：`hdc fport tcp:9222 tcp:9222`
3. 在 Chrome 浏览器访问 `chrome://inspect`
4. 选择对应的 Web 页面进行调试

> ⚠️ `webDebuggingAccess` 仅在 debug 包中启用，release 包应关闭。

---

## 常见陷阱与最佳实践

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| JS Bridge 调用无响应 | 页面未加载完成就调用 | 在 `onPageEnd` 后调用 |
| registerJavaScriptProxy 不生效 | 注册后未刷新 | 调用 `controller.refresh()` |
| Cookie 丢失 | 未持久化 | 调用 `saveCookieAsync()` |
| 深色模式异常 | forceDarkAccess 强制反色 | 网页已适配时设为 false |
| 内存占用高 | Web 内核开销大 | 及时销毁不用的 Web 实例 |
| 混合内容被阻止 | HTTPS 页面加载 HTTP 资源 | 配置 mixedMode 允许 |

### 性能优化建议

1. **预加载**：使用 `prepareForPageLoad` 预热常用页面
2. **离线资源**：用 `onInterceptRequest` 拦截静态资源，使用本地缓存
3. **减少 Bridge 调用**：批量传输数据，减少 JS ↔ Native 通信次数
4. **UserAgent**：设置合理的 UA 避免服务端下发重量级页面

---

## See Also

- [network-data.md](./network-data.md) — 网络请求与数据持久化
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) — 常用代码模式
- [routing-lifecycle.md](./routing-lifecycle.md) — 页面路由与生命周期
