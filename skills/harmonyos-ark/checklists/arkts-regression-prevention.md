# ArkTS 防回归快速清单（CodeWrench）

> 本清单配合 `arkts-modernization-guard` 脚本和 `arkts-error-prevention.md` 使用。
> 每次涉及 `entry/src/main/ets/**` 的改动，按以下流程逐项确认。

## 改动前

### 环境确认
- [ ] 运行 guard 扫描并保存输出（作为基线对比）
- [ ] 确认当前分支已同步主线最新代码
- [ ] 确认 DevEco Studio / hvigor 版本与项目要求一致

### 高风险模式排查
- [ ] `@Prop` 函数回调（ArkTS 不支持 `@Prop` 传递函数类型）
- [ ] `await preferences.getPreferences(...)` 直 await（需 try-catch 包裹）
- [ ] spread 刷新（`this.list = [...this.list]` 触发全量重渲染）
- [ ] 动态 `$r(...)` 构造资源引用（编译器要求静态字面量）
- [ ] deprecated API 调用（扫描 `@deprecated` 标记的 import）
- [ ] `FontWeight.Black`（不存在，仅 Lighter/Normal/Regular/Medium/Bold/Bolder）
- [ ] `LengthMetrics` 作为值使用（仅可用于类型注解，不可 new 或调用）
- [ ] 未验证的 `sys.symbol.*` 资源名（编译时 Unknown resource name）

## 改动中

### build() 规范
- [ ] `build()` 内仅保留 DSL，辅助逻辑抽私有方法
- [ ] `build()` 内不出现 `console.log`、`await`、赋值语句
- [ ] 条件渲染使用 `if/else`，不在 DSL 内写三元嵌套超过 1 层

### 命名与类型
- [ ] 组件字段避免与链式 API 冲突（`size`、`onClick`、`width` 等内置属性名）
- [ ] 新增类/接口用 PascalCase，方法/变量用 camelCase
- [ ] 布尔变量用 `is/has/can/should` 前缀

### 资源与引用
- [ ] 资源参数使用静态 `Resource` / `$r('xxx.yyy.zzz')` 字面量
- [ ] 颜色使用系统 token（`$r('sys.color.xxx')`），禁止硬编码 `#FFFFFF`
- [ ] 图标优先 `SymbolGlyph($r('sys.symbol.xxx'))`，使用前确认名称存在

### 异步与错误处理
- [ ] `hostContext`、`Preferences` 调用均做空值保护
- [ ] 所有 `async` 函数标注返回类型，避免 `Promise<void>` 遗漏 catch
- [ ] `.then()` 闭包内不依赖外部类型收窄（ArkTS 不追踪闭包内赋值→类型变 `never`）
- [ ] 可能抛异常的函数调用已包裹 try-catch（编译器 WARN: Function may throw exceptions）

### 列表与滚动
- [ ] 长列表用 `List` + `LazyForEach`（≥ 50 项禁止 `ForEach`）
- [ ] `LazyForEach` 的 `keyGenerator` 返回稳定唯一值（禁用 index）
- [ ] 可滚动区域设置 `.edgeEffect(EdgeEffect.Spring)`

## 改动后

### 编译验证
- [ ] guard 扫描输出 `passed`（无新增违规）
- [ ] `CompileArkTS` 已执行并记录结果（0 error, 0 warning 为目标）
- [ ] 若有新 warning，已判断是否需要修复或记录豁免理由

### 运行时冒烟
- [ ] 关键路径冒烟通过：HomeTab / SettingsTab / CodesTab / LearningTab
- [ ] 深色模式下重点页面可读可操作
- [ ] 空态/错误态页面正常展示（非白屏或崩溃）

### 回归对比
- [ ] 与改动前的 guard 输出对比，无新增违规
- [ ] 页面跳转/返回流程无异常（Navigation 栈正确）

## 失败时

### 新模式归档
- [ ] 将新发现的编译错误模式补充到 `../topics/arkts-error-prevention.md`
- [ ] 将修复方案补充到 `../arkts-modernization-guard/references/error-to-fix-map.md`

### 复盘记录
- [ ] 记录失败原因、根因分析、修复方案
- [ ] 若为高频模式（≥2 次出现），提议加入 guard 自动扫描规则

---

## See Also

- [../topics/arkts-error-prevention.md](../topics/arkts-error-prevention.md) — ArkTS 历史报错防回归档案
- [../topics/arkts.md](../topics/arkts.md) — ArkTS 深入主题
- [../arkts-modernization-guard/SKILL.md](../arkts-modernization-guard/SKILL.md) — 编译现代化守卫
