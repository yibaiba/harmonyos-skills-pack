# ArkUI 主题

## Scope
- 声明式 UI、组件系统、布局与交互状态管理
- 深色模式主题体系与多端（PC/手机/平板）布局适配
- ArkUI 工程实践、性能优化、常见编译与运行时陷阱

## Key Concepts
- 声明式渲染：`build()` 内只写 DSL，不放命令式逻辑
- 组件生命周期：`aboutToAppear` → `build` → `aboutToDisappear`
- 布局系统：`Column` / `Row` / `Flex` / `Grid` / `List` / `Stack`
- 状态装饰器：`@State` / `@Prop` / `@Link` / `@Provide` / `@Consume` / `@Observed` / `@ObjectLink`
- 主题样式：系统资源 token（`$r('sys.color.xxx')`）、自定义主题
- 动画与过渡：属性动画 `animateTo`、转场动画 `transition`、共享元素转场
- 深浅色主题切换：`sysres` token 自动适配 + `AppStorage` 手动控制
- 响应式断点设计：`BreakpointSystem` + `GridRow` / `GridCol`
- 多端交互一致性：触控 + 键鼠 + 手写笔统一手势处理

## Official Entrypoints
- ArkUI 开发指南: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkui-overview
- ArkUI 组件 API: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-components-summary
- 设计指南（多设备）: https://developer.huawei.com/consumer/cn/doc/design-guides/phone-0000001776694632
- UX 体验标准: https://developer.huawei.com/consumer/cn/doc/design-guides/ux-guidelines-general-0000001760708152
- Samples: https://developer.huawei.com/consumer/cn/samples/

## 工程硬规范

### 1. 组件拆分原则

- **单一职责**：一个自定义组件只负责一个 UI 区域，超过 80 行 `build()` 必须拆子组件
- **数据向下、事件向上**：父组件通过 `@Prop` / `@Link` 传数据，子组件通过回调通知父组件
- **禁止在 `build()` 内写业务逻辑**：条件判断、数据转换、网络请求全部抽到私有方法或 ViewModel
- **命名约定**：页面 `*Page`，可复用组件 `*Component`、`*Card`、`*Item`，弹窗 `*Dialog`

### 2. 状态管理规范

**装饰器选择矩阵：**

| 场景 | 装饰器 | 说明 |
|------|--------|------|
| 组件内部私有状态 | `@State` | 仅当前组件使用 |
| 父→子单向传递 | `@Prop` | 子组件接收副本，修改不影响父 |
| 父↔子双向绑定 | `@Link` | 子组件修改直接同步父组件 |
| 跨层级共享 | `@Provide` / `@Consume` | 祖先提供，后代消费 |
| 观察嵌套对象 | `@Observed` + `@ObjectLink` | 深层属性变化触发刷新 |
| 全局持久化 | `AppStorage` / `LocalStorage` | 应用级 / 页面级共享 |

**禁止模式：**
- 禁止 `@Prop` 传递函数回调（ArkTS 编译器不支持 `@Prop` 函数类型）
- 禁止 `@State` 管理大型数组后用 spread 触发刷新（`this.list = [...this.list]` 全量重渲染）
- 禁止在 `@Link` 变量上做本地缓存（引用语义，缓存会失效）

### 3. 布局选型指南

| 布局组件 | 适用场景 | 性能特征 |
|---------|---------|---------|
| `Column` / `Row` | 简单线性排列 | 最轻量 |
| `Flex` | 需要换行、对齐 | 比 Column/Row 略重 |
| `Stack` | 层叠覆盖（浮动按钮、蒙层） | 轻量 |
| `Grid` | 固定网格（照片墙、设置页） | 中等 |
| `List` | 长列表（含懒加载） | LazyForEach 高性能 |
| `WaterFlow` | 瀑布流 | LazyForEach 高性能 |
| `GridRow` / `GridCol` | 响应式多端布局 | 断点驱动 |

**关键规则：**
- 长列表必须用 `List` + `LazyForEach`，禁止 `ForEach` 渲染 50+ 项
- `LazyForEach` 的 `keyGenerator` 必须返回稳定唯一值，禁止用 index
- 嵌套布局深度 ≤ 5 层，超过需抽取子组件或使用 `@Builder`

### 4. 资源引用规范

- 颜色：必须使用系统 token `$r('sys.color.ohos_id_color_text_primary')` 或自定义资源
- 字体大小：必须使用 `$r('sys.float.ohos_id_text_size_body1')` 等 token
- 禁止硬编码颜色值（`#FFFFFF`、`Color.Red`），否则深色模式失效
- 图标：优先使用 `SymbolGlyph($r('sys.symbol.xxx'))` 系统图标
- 资源引用必须静态：`$r('app.string.title')` ✓，`$r(dynamicKey)` ✗
- 未确认存在的 `sys.symbol.*` 名称需先查证，避免 `Unknown resource name` 编译错误

### 5. 深色模式规范

- 必须使用系统颜色 token，不得硬编码前景/背景色
- 图片资源准备 light/dark 双套，或使用 `ColorFilter` 适配
- 阴影、分割线使用透明度而非固定灰度值
- 重点验证页面：首页、详情页、表单提交页、设置页、弹窗
- 对比度要求：文本/背景 ≥ 4.5:1（WCAG AA），大文本 ≥ 3:1

### 6. 多端适配规范

**断点定义（dp）：**
- 小屏（手机）：宽 < 600
- 中屏（折叠屏/平板竖屏）：600 ≤ 宽 < 840
- 大屏（平板横屏/PC）：宽 ≥ 840

**实现方式：**
```typescript
GridRow({ breakpoints: { value: ['600vp', '840vp'] } }) {
  GridCol({ span: { sm: 12, md: 6, lg: 4 } }) {
    // 手机占满，平板半屏，PC 三分之一
  }
}
```

**必须规则：**
- 核心功能路径三端均可完成，不因设备变化缺失功能
- 大屏增加信息密度（双栏、侧边导航），不做简单拉伸
- 热区最小 48vp × 48vp（手指触控），键鼠操作支持 hover 态

### 7. 性能优化要点

- `build()` 内禁止耗时操作（网络、文件读写、复杂计算）
- 列表项复用：`List` 设置 `.cachedCount(5)` 预加载
- 图片加载：大图使用 `Image().objectFit(ImageFit.Cover).syncLoad(false)`
- 条件渲染优先 `if/else` 而非 `Visibility.Hidden`（后者仍占布局）
- 避免频繁触发全量 `@State` 数组刷新，改用 `@Observed` 对象数组 + `@ObjectLink`

### 8. 滚动与列表规范

- 列表必须设置 `.edgeEffect(EdgeEffect.Spring)` 弹性回弹（审核必查）
- 下拉刷新用 `Refresh` 组件包裹 `List`
- 上拉加载更多：监听 `onReachEnd` 事件
- 空态页面：数据为空时展示 `Empty State` 组件，不留空白
- 骨架屏：首次加载时展示占位骨架，禁止白屏等待

## 审核相关建议

1. **页面完整度**：每个 Tab 都必须有实际内容，禁止"敬请期待"占位
2. **交互反馈**：所有可点击元素必须有 `stateStyles` 或按压态反馈
3. **加载状态**：网络请求场景必须展示 loading → 成功/失败/空态 完整状态链
4. **滚动回弹**：所有可滚动区域必须 `.edgeEffect(EdgeEffect.Spring)`
5. **权限说明**：使用敏感权限前必须弹窗说明用途
6. **无障碍**：关键操作元素需设置 `.accessibilityText()` 或 `.accessibilityDescription()`

## Quick Q&A
- ArkUI 常见布局策略应该怎么选 → 参考 §3 布局选型指南
- @State/@Prop/@Link 的使用边界 → 参考 §2 状态管理规范
- 复杂页面如何拆分组件 → 参考 §1 组件拆分原则
- 深色模式设计 → 参考 §5 深色模式规范
- 多端适配 → 参考 §6 多端适配规范

## Boundaries
- 不覆盖 Web 前端框架的通用 UI 库选型
- 不覆盖 OpenGL/3D 引擎渲染细节
- 状态管理深度用法参见 topics/state-management.md
- 组件设计规范参见 topics/component-design-specs.md（索引）
