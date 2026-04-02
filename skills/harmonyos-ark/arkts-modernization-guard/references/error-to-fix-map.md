# ArkTS 错误码→修复方案映射表

<!-- Agent 摘要：错误码到修复动作的快速查表。覆盖 P0-P2 共 15+ 编译错误/运行时崩溃模式。搜索: error code fix map 10605999 10505001。 -->

## 使用方式

1. 从 DevEco 编译输出复制错误码（如 `10505001`）
2. 在下表搜索错误码或关键词
3. 按修复动作处理

## P0 — 必须立即修复

| 错误码/现象 | 根因 | 修复动作 |
|-------------|------|----------|
| 运行时崩溃：`Illegal variable value error with decorated variable @Prop` | `@Prop` 修饰函数回调 | 移除 `@Prop`，改为普通成员 `onTap: () => void` |
| `10605999`：`void & Promise<Preferences>` | 直接 `await preferences.getPreferences()` | 封装 `getPrefsStore()` 方法，先判空 hostContext |
| `10605999`：`Property 'get' does not exist on type 'never'` | `.then()` 闭包内赋值导致类型收窄为 never | 提取为 `return` 返回值的方法，不用闭包赋值 |
| `10905210`：`build` 仅允许一个容器根节点 | build 结构被非 DSL 代码干扰 | build() 内只保留 UI DSL，辅助逻辑抽到私有方法 |
| `10505001`：连锁语法报错（`;` expected / `Declaration or statement expected` / `Cannot find name 'width'`） | `build()` / `@Builder` 中组件闭合丢失、属性链断裂，或混入命令式语句，导致 `.width()` 等链式属性脱离组件表达式 | 优先回看首个报错点前 10-20 行；补齐缺失 `}` / `)`；确保 `.width()` / `.height()` / `.onClick()` 紧跟组件表达式；辅助逻辑移出 `build()` / `@Builder` |
| **RollupError: Unexpected token** — 列出所有 .ets 文件无行号 | 某 `.ets` 文件严重语法错误，Rollup 无法解析模块图 | 优先检查最近修改的文件；IDE 逐个排查语法异常；常见：缺闭合 `}`、import 错误、`as` 位置错误 |

## P1 — 本次提交前修复

| 错误码/现象 | 根因 | 修复动作 |
|-------------|------|----------|
| `10505001`：属性冲突 `size`/`onClick` | 组件字段与链式 API 冲突 | 重命名字段：`size→ringSize`，`onClick→onTap` |
| `10505001`：`FontWeight.Black` does not exist | ArkTS FontWeight 枚举无 Black | 改用 `FontWeight.Bolder` |
| `10505001`：`LengthMetrics` used as value | 类型别名不可实例化 | 直接传数值（默认 vp），或 `{ value: 16, unit: LengthUnit.VP }` |
| `10605034`：泛型推断受限 | `Array.from({length...})` 推断失败 | 显式 `number[]` 构造 + `ForEach` |
| `10605038`/`10605040`：未命名对象类型 | 内联对象字面量作为类型 | 抽离为 `interface` / `type` |
| `10605074`：`arkts-no-destruct-decls` | `const { a, b } = obj` 解构声明 | 逐个赋值：`const a = obj.a; const b = obj.b;` |
| `10605008`：`arkts-no-any-unknown` | 使用 `any` / `unknown` | 替换为具体类型 / `interface` / 泛型 `<T>` |
| `10605087`：`arkts-limited-throw` | `throw` 了 string / number / object 等任意值 | 统一改为 `throw new Error(...)` 或抛出 `Error` 子类实例；捕获后重抛时先归一化为 `Error` |
| `10605099`：spread 触发全量重渲染 | `{ ...state }` / `[...arr]` 创建新引用 | 改用 `slice()` / `concat()` / 显式字段复制 |
| WARN：`Function may throw exceptions` | 可抛异常函数缺 try-catch | 包裹 try-catch 或 async/await + catch |
| `10605038`：`arkts-no-untyped-obj-literals` | `Record<>` 泛型初始化对象字面量 | 声明 `interface` 替代 `Record`，字面量与 interface 对应 |
| `10905209`：`@Builder` 内 `let` 声明 | @Builder 仅允许 UI DSL | 计算提取为 private 方法，@Builder 内联 `this.method()` |
| `10905209`：`@Builder` 内 ForEach 写内联 UI | Flex/Grid 中 ForEach 回调直接写 Column/Text 等内联组件 | 提取为独立 `@Builder` 方法，ForEach 内仅调用 `this.buildXxx()` |
| `10905348`：`The type of the '@StorageLink' property cannot be a class decorated with '@ObservedV2'` | 用 `@StorageLink` / `@LocalStorageLink` 绑定 `@ObservedV2` ViewModel / 类实例 | Storage 装饰器仅绑定基础字段、数组或可序列化快照；`@ObservedV2` ViewModel 保持页面级实例，跨页只同步 `id` / `title` / `count` 等快照字段 |
| `10505001`：`Target requires 2 element(s)` ParticleTuple | Particle `color.range` 要求 2 元素元组，传入 `string[]` 长度不匹配 | 改为固定元组：`['#FFD700', '#FF6347'] as [ResourceColor, ResourceColor]` |
| `10505001`：`setWindowColorMode` does not exist | HarmonyOS NEXT API 12+ 已移除 `Window.setWindowColorMode()` 和 `window.ColorMode` | 改用 `context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.XXX)` |
| `10505001`：`accessibilityLabel` does not exist on `XxxAttribute` | ArkUI 无 `.accessibilityLabel()` 链式属性，跨框架误用 | 改用 `.accessibilityText("标签")` / `.accessibilityDescription("描述")` |
| `10505001`：`LAYOUT_TYPE_TIMER` / `title not in LayoutData` / `number not assignable to LiveView` | LiveView 实况窗 API 枚举+接口猜测错误 | 必须查官方文档确认 `LayoutType` 枚举、`LayoutData` 字段、方法签名 |

## P2 — 计划修复

| 错误码/现象 | 根因 | 修复动作 |
|-------------|------|----------|
| `10903329`：`Unknown resource name` | 动态 `$r()`、sys.symbol 名不存在，或未验证的 `ohos_ic_public_*` 系统图标资源名 | 使用静态字面量；在 DevEco 资源面板 / 当前 SDK 搜索确认资源名存在；不确定时改用本地图标资源 |
| deprecated 告警漂移 | SDK 升级导致旧 API 废弃 | 按 SDK 推荐 API 迁移（见替换模板） |

## deprecated API 迁移表

| 旧 API | 替代 API | 最低 SDK |
|--------|----------|----------|
| `animateTo()` | `UIContext.animateTo()` | API 11 |
| `router.replaceUrl()` | `Navigation` + `NavPathStack.replacePathByName()` | API 12 |
| `router.pushUrl()` | `Navigation` + `NavPathStack.pushPathByName()` | API 12 |
| `getContext(this)` | `UIAbility.context` / `UIExtensionAbility.context` | API 10 |
| `AlertDialog.show()` | `this.getUIContext().showAlertDialog()` | API 12 |
| `promptAction.showDialog()` | `UIContext.getPromptAction().showDialog()` | API 12 |
| `promptAction.showToast()` | `UIContext.getPromptAction().showToast()` | API 12 |
| `Window.setWindowColorMode()` | `context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.XXX)` | API 12 |

#### 常见修复代码片段

**Router → Navigation:**
```typescript
// ❌ 旧写法
import router from '@ohos.router'
router.pushUrl({ url: 'pages/Detail', params: { id: '123' } })

// ✅ 新写法（API 12+）
@Provide('navStack') navStack: NavPathStack = new NavPathStack()
this.navStack.pushPath({ name: 'DetailPage', param: { id: '123' } as Record<string, string> })
```

**Window.setWindowColorMode → ConfigurationConstant.setColorMode:**
```typescript
// ❌ 旧写法（API 12+ 已移除）
import window from '@ohos.window'
let win = await window.getLastWindow(getContext(this))
win.setWindowColorMode(window.ColorMode.COLOR_MODE_DARK)

// ✅ 新写法（API 12+）
import { ConfigurationConstant } from '@kit.AbilityKit'
let ctx = getContext(this)
ctx.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
// 可选值：COLOR_MODE_LIGHT / COLOR_MODE_DARK / COLOR_MODE_NOT_SET（跟随系统）
```

> 完整 Navigation 模式 → `starter-kit/snippets/common-patterns.md` 模式三十四

---

## See Also

- [../snippets/replacement-patterns.md](../snippets/replacement-patterns.md) — 替换代码模板
- [../../topics/arkts-error-prevention.md](../../topics/arkts-error-prevention.md) — 历史报错防回归档案
