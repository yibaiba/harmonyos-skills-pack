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
| `10605099`：spread 触发全量重渲染 | `{ ...state }` / `[...arr]` 创建新引用 | 改用 `slice()` / `concat()` / 显式字段复制 |
| WARN：`Function may throw exceptions` | 可抛异常函数缺 try-catch | 包裹 try-catch 或 async/await + catch |

## P2 — 计划修复

| 错误码/现象 | 根因 | 修复动作 |
|-------------|------|----------|
| `10903329`：`Unknown resource name` | 动态 `$r()`，或 sys.symbol 名不存在 | 使用静态字面量；DevEco 搜索确认资源名存在 |
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

---

## See Also

- [../snippets/replacement-patterns.md](../snippets/replacement-patterns.md) — 替换代码模板
- [../../topics/arkts-error-prevention.md](../../topics/arkts-error-prevention.md) — 历史报错防回归档案
