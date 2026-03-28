# HarmonyOS 应用 UX 体验标准

## Scope
- 华为 HarmonyOS 应用 UX 体验标准中的**必须条款**
- 聚焦开发阶段可落地的硬性要求，不重复设计理念类软文
- 覆盖通用应用和元服务的核心审核卡点

## Official Entrypoints
- UX 体验标准概述: https://developer.huawei.com/consumer/cn/doc/design-guides/ux-guidelines-overview-0000001760867048
- 通用应用 UX 体验标准: https://developer.huawei.com/consumer/cn/doc/design-guides/ux-guidelines-general-0000001760708152
- 元服务 UX 体验标准: https://developer.huawei.com/consumer/cn/doc/design-guides/ux-standard-overview-0000002019655177
- 电脑应用 UX 体验标准: https://developer.huawei.com/consumer/cn/doc/design-guides/ux-guidelines-2in1-0000001777895636
- 设计理念: https://developer.huawei.com/consumer/cn/doc/design-guides/design-concepts-0000001795698445/

## 设计资源下载
- 设计资源中心（字体/图标/组件库/模板）: https://developer.huawei.com/consumer/cn/design/resource/
- HarmonyOS Sans 字体: https://developer.huawei.com/consumer/cn/design/resource/#/font
- HarmonyOS 主题图标库: https://developer.huawei.com/consumer/cn/design/harmonyos-icon/
- HarmonyOS Symbol 图标库: https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/
- 设计规范与指南总览: https://developer.huawei.com/consumer/cn/design
- JS Design HarmonyOS 组件库: https://js.design/community?category=detail&type=resource&id=60ba25d2fbc9478b602b237f
- 支持格式：Sketch (.sketch)、Figma (.fig)、Adobe XD

## 必须条款速查（按审核维度）

### 1. 基础体验
- 所有界面必须可响应系统返回操作
- 除一级界面外，全屏界面必须提供返回/关闭/取消按钮
- 应用启动后应在合理时间内可交互，不可长时间白屏

### 2. 界面布局
- 支持在各种屏幕尺寸上良好显示，元素不得错位、截断、变形、模糊
- 重要信息和操作按钮必须适配摄像头挖孔区，不被遮挡
- 支持横竖屏、分屏等多种显示状态下界面正常适配
- 元素对齐、层级关系清晰，留白合理

### 3. 人机交互
- 应用自定义手势不得与系统手势冲突（边缘返回等）
- 长按手势时长 500ms（允许 400-650ms），双击间隔 70-400ms
- **点击热区 ≥ 40vp × 40vp**（推荐 48vp × 48vp）
- 穿戴设备热区同理；电脑触控交互 ≥ 7mm

### 4. 文字与字号
- 手机/折叠屏/平板：正文字号 ≥ 12vp（必须 ≥ 8vp）
- 电脑：≥ 10vp
- 穿戴：≥ 10vp
- 不得出现文字截断、重叠、超出容器不可见

### 5. 视觉与色彩
- 正文与背景对比度 ≥ 4.5:1
- 图标/标题与背景对比度 ≥ 3:1
- 应用图标满足分层、尺寸与清晰度规范
- 界面图标满足最小尺寸要求

### 6. 动效与转场
- 页面转场动效不可缺失
- 全屏转场动画满足时长要求
- **可滑动组件必须有边界回弹动效**（`.edgeEffect(EdgeEffect.Spring)`）
- 离手后滑动需有减速过渡动效
- 操作滑动动效与系统保持一致

### 7. 深色模式
- **必须支持深色模式**
- 深色模式下色彩对比度仍需满足要求
- 图片、图标在深色模式下清晰可辨
- 不得出现深色模式下文字不可见、背景刺眼等问题

### 8. 系统特性适配
- 适配底部导航条（Home Bar）
- 适配状态栏
- 支持分屏、多窗口、悬浮窗
- 导航手势不被应用拦截

### 9. 多端适配
- 手机、平板、折叠屏至少支持基础适配
- 横竖屏切换后界面正常重排
- 大屏场景下内容合理分栏，不拉伸变形

### 10. 元服务附加要求
- 图标与应用图标有区分
- 启动无自定义动画、无开屏广告、无扑脸弹窗
- 用户可随时退出
- 胶囊、导航、沉浸式布局满足鸿蒙场景化需求

## ArkUI 落地对照表

| UX 必须条款 | ArkUI 实现方式 |
|-------------|---------------|
| 点击热区 ≥ 40vp | 交互组件设置 `.width(48)` `.height(48)` 或 `.hitTestArea()` |
| 滑动回弹动效 | `List/Scroll/Grid/WaterFlow` 设置 `.edgeEffect(EdgeEffect.Spring)` |
| 深色模式支持 | 使用系统资源颜色（`$r('sys.color.xxx')`）；`@StorageProp('colorMode')` 监听切换 |
| 转场动效 | 使用 `pageTransition` 或 `sharedTransition`；不要留空白跳转 |
| 系统返回响应 | 页面实现 `onBackPress()` 或使用 `Navigation` 组件自动处理 |
| 状态栏适配 | `.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])` |
| 挖孔区适配 | 关键内容避开 `avoidArea` 区域 |
| 文字最小字号 | 正文字号设置 ≥ 12（fp 或 vp），不小于 8 |
| 对比度 ≥ 4.5:1 | 避免浅灰色文字 + 白色背景组合；可用 DevEco Preview 检查 |

## HarmonyOS Symbol 图标使用规范

**官方指南**: https://developer.huawei.com/consumer/cn/doc/design-guides/system-icons-0000001929854962

### 组件选择
- `SymbolGlyph`：独立图标，支持事件交互
- `SymbolSpan`：文本流内插入图标，不支持交互事件

### 命名与引用
- 统一前缀 `sys.symbol.`，如 `$r('sys.symbol.ohos_wifi')`
- **使用前必须在官方图标库确认名称存在**（避免 `Unknown resource name` 编译错误）
- 图标库查询: https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/

### 关键属性
| 属性 | 说明 |
|------|------|
| `fontSize` | 图标大小（fp），仅影响图标尺寸 |
| `fontWeight` | 线条粗细（100-900 或 Normal/Bold/Lighter） |
| `fontColor` | 单色或多色数组，配合 renderingStrategy |
| `renderingStrategy` | `SINGLE`（单色）/ `MULTIPLE_COLOR`（多色≤3）/ `MULTIPLE_OPACITY`（分层透明） |
| `effectStrategy` | 动效：Appear/Disappear/Bounce/Scale/Replace/Pulse/Hierarchical |

### 代码示例
```typescript
// 单色图标
SymbolGlyph($r('sys.symbol.ohos_folder_badge_plus'))
  .fontSize(48)
  .fontColor([Color.Black])

// 多色 + 动效
SymbolGlyph($r('sys.symbol.ohos_wifi'))
  .fontSize(24)
  .fontWeight(FontWeight.Bold)
  .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
  .fontColor([Color.Black, Color.Green, Color.White])
  .effectStrategy(SymbolEffectStrategy.SCALE)
```

### 注意事项
- `SymbolGlyph` 参数类型为 `Resource`，不是 `string`
- 并非所有图标都支持 fontWeight 调节
- 自定义图标放 `resources/base/media/`，与系统资源分离管理

## 组件设计规范索引

**控件概览**: https://developer.huawei.com/consumer/cn/doc/design-guides/general_overview-0000001929599380

> 以下链接来自官方设计指南侧边栏「控件」节点，每个链接均为独立组件的设计规范页面。

### 导航类
| 组件 | 官方链接 |
|------|---------|
| 底部页签 | https://developer.huawei.com/consumer/cn/doc/design-guides/bottomtab-0000001956787789 |
| 子页签 | https://developer.huawei.com/consumer/cn/doc/design-guides/chipsgroup-0000001929788350 |
| 标题栏 | https://developer.huawei.com/consumer/cn/doc/design-guides/titlebar-0000001929628982 |
| 导航点 | https://developer.huawei.com/consumer/cn/doc/design-guides/swiper-0000001957947629 |

### 展示类
| 组件 | 官方链接 |
|------|---------|
| 文本 | https://developer.huawei.com/consumer/cn/doc/design-guides/text-0000001956975261 |
| 分隔器 | https://developer.huawei.com/consumer/cn/doc/design-guides/divider-0000001956815469 |
| 子标题 | https://developer.huawei.com/consumer/cn/doc/design-guides/subheader-0000001929816012 |
| 进度条 | https://developer.huawei.com/consumer/cn/doc/design-guides/progress-0000001929656644 |
| 索引条 | https://developer.huawei.com/consumer/cn/doc/design-guides/alphabetindexer-0000001956975265 |
| 滚动条 | https://developer.huawei.com/consumer/cn/doc/design-guides/scrollbar-0000001956815473 |
| 新事件标记 | https://developer.huawei.com/consumer/cn/doc/design-guides/badge-0000001929816016 |
| 即时反馈 | https://developer.huawei.com/consumer/cn/doc/design-guides/toast-0000001929656648 |
| 即时操作 | https://developer.huawei.com/consumer/cn/doc/design-guides/component_snackbar-0000002340726169 |
| 气泡提示 | https://developer.huawei.com/consumer/cn/doc/design-guides/popup-0000001956975269 |
| 数据可视化 | https://developer.huawei.com/consumer/cn/doc/design-guides/datapanel-0000001956815481 |
| 二维码 | https://developer.huawei.com/consumer/cn/doc/design-guides/qrcode-0000001929816020 |
| 文本时钟 | https://developer.huawei.com/consumer/cn/doc/design-guides/textclock-0000001929656652 |
| 图片 | https://developer.huawei.com/consumer/cn/doc/design-guides/image-0000001956975273 |
| 空白 | https://developer.huawei.com/consumer/cn/doc/design-guides/blank-0000001956815485 |

### 操作类
| 组件 | 官方链接 |
|------|---------|
| 按钮 | https://developer.huawei.com/consumer/cn/doc/design-guides/button-0000001929683228 |
| 下拉按钮 | https://developer.huawei.com/consumer/cn/doc/design-guides/select-0000001957001873 |
| 状态按钮 | https://developer.huawei.com/consumer/cn/doc/design-guides/togglebutton-0000001956842045 |
| 操作块 | https://developer.huawei.com/consumer/cn/doc/design-guides/chips-0000001929842624 |
| 工具栏 | https://developer.huawei.com/consumer/cn/doc/design-guides/toolbar-0000001929683232 |
| 核心操作栏 | https://developer.huawei.com/consumer/cn/doc/design-guides/component_actionbar-0000002306891560 |
| 菜单 | https://developer.huawei.com/consumer/cn/doc/design-guides/menu-0000001957001877 |
| 文本选择菜单 | https://developer.huawei.com/consumer/cn/doc/design-guides/textselection-0000001956842049 |

### 输入类
| 组件 | 官方链接 |
|------|---------|
| 文本框 | https://developer.huawei.com/consumer/cn/doc/design-guides/textinput-0000001957012557 |
| 搜索框 | https://developer.huawei.com/consumer/cn/doc/design-guides/search-0000001956852741 |
| 数字加减 | https://developer.huawei.com/consumer/cn/doc/design-guides/counter-0000001929853284 |
| 图案锁 | https://developer.huawei.com/consumer/cn/doc/design-guides/patternlock-0000001929853902 |

### 选择类
| 组件 | 官方链接 |
|------|---------|
| 勾选 | https://developer.huawei.com/consumer/cn/doc/design-guides/checkbox-0000001957012561 |
| 开关 | https://developer.huawei.com/consumer/cn/doc/design-guides/toggleswitch-0000001956852745 |
| 单选框 | https://developer.huawei.com/consumer/cn/doc/design-guides/radio-0000001929853288 |
| 评分条 | https://developer.huawei.com/consumer/cn/doc/design-guides/rating-0000001929853906 |
| 滑动条 | https://developer.huawei.com/consumer/cn/doc/design-guides/slider-0000001957012565 |
| 选择器 | https://developer.huawei.com/consumer/cn/doc/design-guides/picker-0000001956852749 |
| 分段按钮 | https://developer.huawei.com/consumer/cn/doc/design-guides/segmentbutton-0000001929853292 |

### 容器类
| 组件 | 官方链接 |
|------|---------|
| 列表 | https://developer.huawei.com/consumer/cn/doc/design-guides/list-0000001929853910 |
| 弹出框 | https://developer.huawei.com/consumer/cn/doc/design-guides/dialog-0000001957012569 |
| 半模态面板 | https://developer.huawei.com/consumer/cn/doc/design-guides/bindsheet-0000001956852753 |

### 设计通用规则
- 栅格与间距：以 8dp 为基础单位（8/16/24）
- 组件状态：必须区分常规/按压/聚焦/禁用/错误状态
- 动效时长：操作反馈 200-300ms，采用贝塞尔曲线
- 响应式布局：手机单列、平板多列，组件条件渲染

## 自检提示

- 帮我按 HarmonyOS UX 体验标准检查这个页面的交互热区、对比度和动效
- 帮我确认这个应用是否满足深色模式和多端适配的必须条款
- 帮我列出当前页面中不符合 UX 体验标准的问题

## Common Pitfalls
- 可滑动组件未设置 `edgeEffect`，自检报"缺少回弹动效"
- 点击热区实际尺寸小于 40vp，但视觉上看起来足够大
- 深色模式下硬编码颜色导致文字不可见
- 转场动效缺失，页面跳转时生硬闪烁
- 自定义手势与系统边缘返回冲突，导致用户无法退出页面
- 小字号文本在大屏/平板上低于最低要求
- 元服务启动时有自定义开屏动画或弹窗

## Boundaries
- 不覆盖设计理念和美学建议（仅聚焦必须条款）
- 不覆盖具体设计稿评审流程
- 视觉风格指南以官方文档为准，本文仅提供开发侧快速对照


---

## See Also

- [HarmonyOS 控件设计规范索引](component-design-specs.md)
- [ArkUI 主题](arkui.md)
- [Accessibility Kit 无障碍服务](accessibility.md)
