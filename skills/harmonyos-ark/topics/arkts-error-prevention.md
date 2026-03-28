# ArkTS 历史错误防回归档案（CodeWrench）

## Scope
- 记录本仓已真实出现过的 ArkTS 编译错误、运行时崩溃与高频告警
- 给出“错误现象 -> 根因模式 -> 固化修复动作 -> 防回归门禁”
- 作为 `topics/arkts.md` 的故障复盘补充，不替代官方 API 文档

## 历史错误档案（按优先级）

| 等级 | 现象/错误码 | 根因模式 | 固化修复动作 |
| --- | --- | --- | --- |
| P0 | 运行时崩溃：`Illegal variable value error with decorated variable @Prop 'onTap'` | `@Prop` 修饰函数回调（如 `@Prop onTap: () => void`） | 函数回调改为普通成员（不加 `@Prop`），调用方继续传函数 |
| P0 | `10605999`：`void & Promise<Preferences>`、`Property 'get/put/flush' does not exist` | 直接 `await preferences.getPreferences(...)` + `hostContext` 可空 | 统一封装 `getPrefsStore()`：先判空 `hostContext`，再 `.then(...)` 获取 `Preferences`，并在调用前判空 |
| P0 | `10605999`：`Property 'get' does not exist on type 'never'` | `.then()` 闭包内赋值变量（`store = value`），ArkTS 不追踪闭包赋值，变量类型仍为初始 `null`；经 `if (!store) return` 收窄后变成 `never` | 提取 `getPrefsStore()` 方法通过 `return` 返回值，不用闭包赋值；调用方 `const store = await this.getPrefsStore()` 获得正确类型 |
| P0 | `10905210`：`@Entry` 组件 `build` 仅允许一个容器根节点 | DSL 解析错位或 `build` 结构被局部声明干扰 | `build()` 内只保留 UI DSL；辅助变量/逻辑抽到私有方法 |
| P1 | `10505001`：属性冲突/类型不匹配（如 `size`、`onClick`、`ResourceStr -> Resource`） | 组件字段与链式 API 冲突，或资源参数类型不匹配 | `size -> ringSize`、`onClick -> onTap`，`SymbolGlyph` 参数使用 `Resource` |
| P1 | `10505001`：`Property 'Black' does not exist on type 'typeof FontWeight'` | ArkTS `FontWeight` 枚举无 `Black`，Web/CSS 值照搬不兼容；同类问题：枚举成员名与 Web 端不一致 | 使用 ArkTS 可用值：`Lighter`/`Normal`/`Regular`/`Medium`/`Bold`/`Bolder`；`Black` → `Bolder`；写前先查 IDE 补全或官方 API 参考确认枚举成员 |
| P1 | `10505001`：`'LengthMetrics' only refers to a type, but is being used as a value here` | 将类型当构造函数调用（如 `LengthMetrics.vp(16)`），但 ArkTS 中该符号仅为类型别名，不可直接实例化 | 改用对应的数值字面量或工厂函数；如 `LengthMetrics.vp(16)` → 直接传 `16`（单位默认 vp），或使用 `{ value: 16, unit: LengthUnit.VP }` 构造 |
| P1 | `10605034` | 泛型推断受限（`Array.from({length...})`） | 改显式 `number[]` 构造，再 `ForEach` |
| P1 | `10605038` / `10605040` | 未命名对象类型或对象字面量直接作为类型 | 抽离 `interface/type`，避免内联对象类型声明 |
| P1 | `10605074`：`arkts-no-destruct-decls` | 解构声明（`const { a, b } = obj`）ArkTS 不支持 | 改为逐个赋值：`const a = obj.a; const b = obj.b;` |
| P1 | `10605008`：`arkts-no-any-unknown` | 使用了 `any` / `unknown` 类型 | 替换为具体类型或 `interface`；泛型场景用 `<T>` 约束 |
| P1 | `10605099` | spread 刷新状态（`{ ...state }`、`[...arr]`） | 改显式字段复制或 `slice()/concat()` |
| P2 | `10903329`：`Unknown resource name 'xxx'` | 动态 `$r(...)`、不兼容 `sys.symbol.*` 名称；或使用了系统中不存在的符号资源名（如 `trophy`、`target`、`doc_on_doc`、`book_closed`） | 静态资源字面量；使用前在 DevEco 搜索确认符号名存在；不存在的改为已验证可用名或改用本地图片资源 |
| P2 | deprecated 告警漂移：`animateTo`、`replaceUrl`、`getContext`、`AlertDialog.show`、`pushUrl`、`showDialog`、`showToast` | SDK 升级导致旧 API 逐步废弃 | 每次升级后先跑 guard 扫描，再按当前 SDK 推荐 API 迁移 |
| P1 | WARN：`Function may throw exceptions. Special handling is required.` | 调用可能抛异常的函数（如 Preferences 读写、文件 I/O、网络请求）未用 try-catch 包裹 | 所有可能抛异常的调用必须 try-catch 或 async/await + catch；不可忽略此告警，累积后会导致运行时崩溃 |

## 固化防回归流程（必做）

1. 改动前扫描：
```bash
bash .codex/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

2. 改动后扫描（必须 `passed`）：
```bash
bash .codex/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

3. 编译验收（DevEco Studio 或 CLI）：
```bash
hvigor :entry:default@CompileArkTS
```

4. 最小运行时回归（至少）：
- 进入首页，确认 `SafetyBanner` 可渲染且点击不崩溃
- 进入设置页，确认 `SettingNavigate` 点击不崩溃
- 走一遍 `CodesTab/LearningTab/SettingsTab` 的 Preferences 读写路径

## 快速诊断矩阵

- 日志含 `Illegal variable value ... @Prop ... function`
- 先查：是否把函数回调写成 `@Prop`
- 处理：去掉 `@Prop`，保留默认空函数

- 日志含 `void & Promise<Preferences>`
- 先查：是否 `await preferences.getPreferences(...)`
- 处理：替换为 `getPrefsStore()` 封装模式

- 日志含 `does not exist on type 'never'`（Preferences 相关）
- 先查：是否在 `.then()` 闭包内赋值后用 `if (!store) return` 收窄
- 处理：提取 `getPrefsStore()` 方法，通过 return 返回值而非闭包赋值

- 日志含 `In an '@Entry' decorated component, the 'build' method can have only one root node`
- 先查：`build()` 内是否混入局部变量声明/非 DSL 语句
- 处理：抽出辅助方法，保持单容器根节点

- 告警含 `Function may throw exceptions`
- 先查：该行调用的函数是否涉及 Preferences/文件/网络等 I/O 操作
- 处理：用 `try { ... } catch (err) { ... }` 包裹；async 函数中用 `await + try-catch`

- 日志含 `Property 'Xxx' does not exist on type 'typeof EnumName'`
- 先查：是否照搬了 Web/CSS 枚举值（如 `FontWeight.Black`）
- 处理：查 IDE 补全或官方 API 参考确认 ArkTS 可用枚举成员；`FontWeight` 可用值为 `Lighter`/`Normal`/`Regular`/`Medium`/`Bold`/`Bolder`

- 日志含 `only refers to a type, but is being used as a value here`
- 先查：是否把类型别名当构造函数调用（如 `LengthMetrics.vp(16)`）
- 处理：改用数值字面量（默认 vp）或 `{ value: 16, unit: LengthUnit.VP }` 结构

- 日志含 `Unknown resource name`
- 先查：`$r('sys.symbol.xxx')` 中的符号名是否在当前 SDK 中存在
- 处理：在 DevEco 搜索确认符号名，不存在的改为已验证可用名或本地图片资源

## 快速诊断流程图

遇到编译/运行时错误时，按以下路径快速定位：

```
编译错误
├─ 含 "does not exist on type" ?
│  ├─ 枚举成员 → 查 P1 FontWeight 等枚举范围
│  └─ 属性/方法 → 检查 SDK API 版本是否匹配
├─ 含 "not assignable to type 'never'" ?
│  └─ 在 .then() 闭包内？ → P0 闭包类型收窄陷阱
├─ 含 "used as a value" ?
│  └─ 类型当构造器用 → P1 LengthMetrics 等纯类型
├─ 含 "Unknown resource name" ?
│  └─ sys.symbol 名不存在 → P2 查 DevEco 符号表
├─ 含 "may throw exceptions" ?
│  └─ 缺 try-catch → P1 异常函数必须捕获
└─ 其他
   └─ 复制完整错误码 → 查下方诊断矩阵或官方文档
```

## 关联资产
- 守卫入口：`../arkts-modernization-guard/SKILL.md`
- 错误映射：`../arkts-modernization-guard/references/error-to-fix-map.md`
- 扫描脚本：`../arkts-modernization-guard/scripts/scan-arkts-modernization.sh`
- 替换模板：`../arkts-modernization-guard/snippets/replacement-patterns.md`


---

## See Also

- [ArkTS 主题](arkts.md)
- [测试、签名与发布](testing-release.md)
