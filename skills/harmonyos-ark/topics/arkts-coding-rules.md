<!-- Agent Summary: 🚨 全局硬约束——每次编写 .ets/.ts 代码前必读。违反语法约束将导致编译失败。 -->

# ArkTS/ETS 全局编码约束

> **⚠️ 本文件为强制规则，非建议。** 每次生成 `.ets` / `.ts` 代码前必须遵守。
> 违反语法约束将直接导致 **编译失败**；违反 API 规范将导致 **运行时异常**。

---

## 1 ArkTS/ETS 语法约束（违反将无法编译）

### 1.1 类型系统约束

| # | ❌ 禁止 | ✅ 替代方案 |
|---|---------|------------|
| T1 | `any` / `unknown` 类型 | 显式指定具体类型 |
| T2 | 索引访问类型 `T[K]` | 直接使用类型名称 |
| T3 | `as const` 断言 | 使用字面量的显式类型标注 |
| T4 | 条件类型别名、`infer` 关键字 | 显式引入带约束的新类型 |
| T5 | 交叉类型 `A & B` | 使用继承 |
| T6 | 映射类型 | 使用常规类和语言惯用法 |
| T7 | `is` 类型守卫运算符 | 使用 `instanceof`；访问字段前用 `as` 转换 |
| T8 | `typeof` 用于类型标注 | `typeof` 仅可在表达式上下文中使用 |
| T9 | `this` 用于类型标注 | 使用显式类型 |
| T10 | 结构化类型（structural typing） | 使用继承、接口或类型别名 |
| T11 | TS 扩展实用类型（`Partial` `Required` `Readonly` `Record` 除外） | `Record<K, V>` 的 `rec[index]` 类型为 `V \| undefined` |
| T12 | 省略返回类型且 `return` 调用另一函数 | 显式指定函数返回类型 |
| T13 | 仅基于返回类型推断泛型参数 | 显式传入泛型类型参数 |

### 1.2 变量与对象约束

| # | ❌ 禁止 | ✅ 替代方案 |
|---|---------|------------|
| V1 | `var` 关键字 | 使用 `let` |
| V2 | 确定性赋值断言 `let v!: T` | 带初始化值的声明 |
| V3 | 解构赋值 / 解构变量声明 | 逐字段赋值 |
| V4 | 解构参数声明 | 将参数直接传递给函数 |
| V5 | 对象字面量直接作为类型声明 | 显式声明 `class` / `interface` |
| V6 | 类字面量 | 引入命名类类型 |
| V7 | 动态字段声明 / `obj["field"]` | 使用 `obj.field` |
| V8 | 索引签名 `[key: string]: T` | 使用数组 |
| V9 | `delete` 删除属性 | 可空类型赋值 `null` |
| V10 | 运行时修改对象布局 | 对象布局编译时确定，运行时不可更改 |
| V11 | `in` 运算符 | 使用 `instanceof` |
| V12 | 对象字面量初始化 `any` / `Object` / 带方法的类 / 带参数构造函数的类 / `readonly` 字段的类 | 须让编译器可推断对应 class/interface |
| V13 | 数组字面量包含无法推断类型的元素 | 所有元素须有可推断类型 |

### 1.3 函数约束

| # | ❌ 禁止 | ✅ 替代方案 |
|---|---------|------------|
| F1 | 函数表达式 `function() {}` | 箭头函数 `() => {}` |
| F2 | 嵌套函数 | lambda / 箭头函数 |
| F3 | 独立函数 / 静态方法中使用 `this` | `this` 仅限实例方法 |
| F4 | `Function.apply` / `.call` / `.bind` | 直接调用 |
| F5 | 在函数上声明属性 | 使用类封装 |
| F6 | 构造函数类型 | 使用 lambda |
| F7 | 生成器函数 `function*` | 使用 `async` / `await` |
| F8 | `new.target` | 不支持 |
| F9 | `throw` string / number / object / 任意值 | 仅允许 `throw new Error(...)` 或抛出 `Error` 子类实例 |

### 1.4 类与接口约束

| # | ❌ 禁止 | ✅ 替代方案 |
|---|---------|------------|
| C1 | 在构造函数中声明类字段 | 在类声明体内声明 |
| C2 | 声明合并（class / interface / enum） | 保持定义紧凑，不拆分 |
| C3 | 接口中的构造函数签名 | 使用普通方法 |
| C4 | 对象类型中的调用签名 / 构造函数签名 | 使用 `class` |
| C5 | 接口包含不可区分签名的方法 | 重构方法名或返回类型 |
| C6 | 重新分配对象方法 | 使用包装函数或继承 |
| C7 | 多个静态代码块 | 合并为一个 `static {}` |
| C8 | `#privateField` 私有标识符 | 使用 `private` 关键字 |
| C9 | 原型赋值 `Cls.prototype.x = ...` | 使用类和接口静态组合 |
| C10 | 将类用作对象（赋值给变量等） | 不支持 |

### 1.5 模块与导入约束

| # | ❌ 禁止 | ✅ 替代方案 |
|---|---------|------------|
| M1 | 环境模块声明 `declare module` | 从原始模块导入 |
| M2 | `export = ...` 语法 | 使用普通 `export` / `import` |
| M3 | `require()` 导入 | 使用 `import` |
| M4 | 导入断言 `import ... assert {}` | 使用普通 `import` |
| M5 | 模块名称中的通配符 | 不支持 |
| M6 | UMD 模块 | 不支持 |
| M7 | `import` 不在文件顶部 | **所有 `import` 必须在其他语句之前** |
| M8 | TypeScript 代码导入 ArkTS 代码 | 仅支持 ArkTS → TS，不支持反向 |
| M9 | 全局作用域 / `globalThis` | 使用显式模块 `import` / `export` |

### 1.6 运算符与语法约束

| # | ❌ 禁止 | ✅ 替代方案 |
|---|---------|------------|
| O1 | 逗号运算符（`for` 循环外） | 仅在 `for` 循环中使用 |
| O2 | 一元 `+` `-` `~` 作用于非数字类型 | 仅作用于数字，不支持字符串隐式转换 |
| O3 | `with` 语句 | 不支持 |
| O4 | JSX 表达式 | 不支持 |
| O5 | `Symbol()` API（`Symbol.iterator` 除外） | 不支持 |
| O6 | 命名空间中的语句 | 使用函数 |
| O7 | 命名空间用作对象 | 使用类或模块 |
| O8 | `catch` 变量类型标注 | 省略类型标注 |
| O9 | 展开运算符用于非数组场景 | 仅支持数组展开到 rest 参数或数组字面量 |

### 1.7 枚举约束

| # | ❌ 禁止 | ✅ 替代方案 |
|---|---------|------------|
| E1 | 枚举声明合并 | 不支持 |
| E2 | 运行时表达式初始化枚举成员 | 所有显式初始化器须为同类型常量 |

---

## 2 HarmonyOS API 使用规范

| 规则 | 说明 |
|------|------|
| 优先官方 API | 优先使用 HarmonyOS 官方 API、UI 组件、动画、代码模板 |
| API 确认 | 调用前确认入参、返回值、API Level 和设备支持 |
| 禁止猜测 API | 不确定的语法和 API 不要猜测，搜索华为开发者官方文档确认 |
| import 声明 | 使用 API 前确认是否需要添加 `import` |
| 权限配置 | 调用 API 前确认是否需要权限，在 `module.json5` 中配置 |
| 依赖管理 | 使用依赖库前确认存在和版本，在 `oh-package.json5` 中配置 |
| 组件装饰器 | `@Component` 和 `@ComponentV2` 注意兼容性，与已有工程保持一致 |
| 状态存储边界 | `@StorageLink` / `@LocalStorageLink` 仅绑定基础字段、数组或可序列化快照，禁止直接绑定 `@ObservedV2` class |
| 资源引用 | UI 常量定义 `resources` 资源值，使用 `$r` 引用，不直接用字面值 |
| 系统资源校验 | `sys.symbol.*` / `sys.media.ohos_ic_public_*` 使用前在当前 SDK 资源面板验证，不要凭名称猜测 |
| 国际化 | 新增字符串时在所有语言下添加值，避免遗漏 |
| 深色主题 | 新增颜色资源确认是否需要深色主题支持，新工程默认支持 |

---

## 3 ArkUI 动画规范

| 规则 | 说明 |
|------|------|
| 优先原生动画 | 优先使用 HarmonyOS 原生动画 API 和高级模板 |
| 状态驱动 | 优先使用声明式 UI + `@State` 驱动动画 |
| renderGroup | 复杂子组件动画设置 `renderGroup(true)` 减少渲染批次 |
| ❌ 禁止布局属性动画 | 不可在动画中频繁改变 `width` / `height` / `padding` / `margin`，严重影响性能 |

---

## 4 ArkUI 图标规范

| 规则 | 说明 |
|------|------|
| ❌ 禁止使用 Emoji 表情 | 不得在 UI 中直接嵌入 Emoji 字符（如 ⭐、❤️、📱），渲染结果因设备字体而异，跨设备不一致 |
| ✅ 使用 SymbolGlyph | 改用 HarmonyOS 原生矢量图标：`SymbolGlyph($r('sys.symbol.xxx')).fontSize(24).fontColor([Color.Black])` |
| 深色自动适配 | `SymbolGlyph` 支持 `fontColor`、`renderingStrategy`，随深色模式自动适配，无需手动切换 |
| 图标名称校验 | `sys.symbol.*` 资源名必须在 DevEco Studio SDK 资源面板验证，**禁止凭名称猜测** |

---

## 5 快速检查清单

编码前逐项确认：

```
□ 是否使用了 any/unknown？        → 替换为具体类型
□ 是否有解构赋值？                → 改为逐字段赋值
□ 是否有 var？                    → 改为 let
□ 是否有函数表达式？              → 改为箭头函数
□ 是否有 obj["field"]？           → 改为 obj.field
□ 是否有 for...in？               → 改为普通 for 循环
□ 是否有 throw 任意值？            → 改为 throw new Error(...)
□ import 是否在文件顶部？         → 移到最顶部
□ 是否把 @ObservedV2 class 绑到 StorageLink？ → 改为存快照字段 + 页面级 ViewModel
□ API 是否已确认官方文档？        → 搜索确认
□ 是否需要权限？                  → 检查 module.json5
□ 系统图标资源名是否已验证？       → 先查当前 SDK / DevEco 资源面板
□ UI 中是否直接使用了 Emoji？        → 改用 SymbolGlyph($r('sys.symbol.xxx'))
□ 动画是否改变了布局属性？        → 改用 transform/opacity
```

---

## See Also

- [arkts-error-prevention.md](./arkts-error-prevention.md) — 历史报错复盘
- [arkts.md](./arkts.md) — ArkTS 语言概览
- [arkui.md](./arkui.md) — ArkUI 框架概览
- [arkts-modernization-guard](../arkts-modernization-guard/SKILL.md) — 编译现代化守卫
