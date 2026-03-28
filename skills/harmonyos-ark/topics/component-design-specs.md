# HarmonyOS 控件设计规范索引

> ⚠️ **这是索引文件，非完整内容。** 请根据需要加载下方对应的分类文件。

> 来源：华为 HarmonyOS 设计指南官方文档
> 提取时间：2026-03-28

本目录下按分类拆分了 41 个控件的离线设计规范，供 AI Agent 按需加载。

## 快速选择指南

| 我想要… | 加载文件 |
|---------|---------|
| 用户怎么在应用内移动（Tab/标题栏/返回） | component-navigation.md |
| 展示文本、数字、进度、提示 | component-display.md |
| 按钮、菜单、操作反馈 | component-action.md |
| 用户输入文本、搜索 | component-input.md |
| 勾选、开关、滑动条、日期选择 | component-selection.md |
| 弹窗、列表、半模态面板 | component-container.md |

## 分类文件

| 分类 | 文件 | 组件数 |
|------|------|--------|
| 导航类 | [component-navigation.md](component-navigation.md) | 4（底部页签、子页签、标题栏、导航点） |
| 展示类 | [component-display.md](component-display.md) | 15（文本、进度条、Toast、气泡等） |
| 操作类 | [component-action.md](component-action.md) | 8（按钮、菜单、工具栏等） |
| 输入类 | [component-input.md](component-input.md) | 4（文本框、搜索框、数字加减、图案锁） |
| 选择类 | [component-selection.md](component-selection.md) | 7（勾选、开关、滑动条、选择器等） |
| 容器类 | [component-container.md](component-container.md) | 3（列表、弹出框、半模态面板） |

## 使用方式

- 根据用户问题涉及的组件类型，加载对应分类文件
- 每个文件包含：组件规则、视觉规则、布局规则、开发文档引用
- 无需一次性加载全部，按需查阅即可节省上下文

---

## See Also

- [ArkUI 组件参考](arkui-components.md)
- [UX 体验标准](ux-standards.md)
- [UI Design Kit](ui-design-kit.md)
