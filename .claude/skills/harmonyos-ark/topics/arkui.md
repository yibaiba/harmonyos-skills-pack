# ArkUI 主题

## Scope
- 声明式 UI、组件系统、布局与交互状态管理
- 深色模式主题体系与多端（PC/手机/平板）布局适配

## Key Concepts
- 声明式渲染
- 组件生命周期
- 布局系统
- 状态装饰器
- 主题样式
- 动画与过渡
- 深浅色主题切换
- 响应式断点设计
- 多端交互一致性

## Official Entrypoints
- HarmonyOS ArkUI 开发指南
- ArkUI 组件与布局 API 文档
- ArkUI 官方示例工程
- HarmonyOS 设计指南（多设备设计）
- HarmonyOS 应用 UX 体验建议

## Quick Q&A
- ArkUI 常见布局策略应该怎么选
- @State、@Prop、@Link 的使用边界是什么
- 复杂页面如何拆分组件才能易维护
- 深色模式与系统主题跟随如何设计
- 同一页面如何同时适配手机、平板、PC

## Common Pitfalls
- 组件职责过大导致重渲染开销增加
- 状态来源分散，导致数据流难追踪
- 交互与样式耦合过深影响复用
- 只做手机布局，平板和 PC 出现留白或错位
- 深色模式下对比度不足，文本和操作控件难以识别

## Boundaries
- 不覆盖 Web 前端框架的通用 UI 库选型
- 不覆盖 OpenGL/3D 引擎渲染细节
