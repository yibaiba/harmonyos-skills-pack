---
name: harmonyos-ark-docs-router
description: 纯血鸿蒙 Ark 应用开发文档路由技能。将问题映射到主题子文档，并按官方来源优先级给出检索路径。
---

# HarmonyOS Ark Docs Router

## When to Use
- 需要快速定位 ArkTS、ArkUI、Stage/Ability 等官方文档时
- 需要从问题直接路由到对应主题资料时
- 需要明确 HarmonyOS 与 OpenHarmony 文档使用边界时
- 项目还未开始，想快速找到语言规范并按顺序学习时

## Scope
- 覆盖 Ark 应用开发主链路：语言、UI、应用模型、路由、状态、网络、媒体、测试与发布
- 覆盖创作激励与审核避坑：按 2025 年规则设计应用，降低卡审风险
- 默认不覆盖内核、驱动、系统裁剪、板级 bring-up

## Source Priority
1. 华为开发者联盟 HarmonyOS 文档（主来源）
2. OpenHarmony 官方文档（概念补充）
3. 官方 samples/codelabs（实践补充）
4. 其他社区内容（仅在用户明确要求时）

## Topic Routing Table
- ArkTS、类型系统、装饰器、并发 -> topics/arkts.md
- ArkTS 官方开发指南（27 篇离线参考） -> topics/arkts-guide-specs.md（索引）
  - ArkTS 语言基础（简介/入门/TS迁移/编程规范） -> topics/arkts-lang-basics.md
  - ArkTS 基础类库（Buffer/XML/JSON） -> topics/arkts-stdlib.md
  - ArkTS 并发编程（Promise/TaskPool/Worker） -> topics/arkts-concurrency.md
  - ArkTS 跨语言交互（Node-API） -> topics/arkts-cross-lang.md
  - ArkTS 运行时（模块化/FAQ） -> topics/arkts-runtime.md
  - ArkTS 编译工具链（ArkGuard/字节码） -> topics/arkts-toolchain.md
- ArkTS 编译报错、deprecated 清理、符号资源兼容 -> ../arkts-modernization-guard/SKILL.md
- ArkTS 历史报错复盘、运行时崩溃防回归 -> topics/arkts-error-prevention.md
- ArkUI、声明式 UI、组件、布局、状态装饰器 -> topics/arkui.md
- ArkUI 官方开发指南（37 篇离线参考） -> topics/arkui-guide-specs.md（索引）
  - ArkUI 核心（简介/语法/状态管理/渲染控制/术语） -> topics/arkui-core.md
  - ArkUI 组件（导航路由/布局/列表/文本/弹窗等） -> topics/arkui-components.md
  - ArkUI 交互与动画 -> topics/arkui-interaction.md
  - ArkUI 高级（自定义/国际化/无障碍/主题/性能） -> topics/arkui-advanced.md
  - UI Design Kit（HDS 设计套件） -> topics/ui-design-kit.md
- Stage、UIAbility、应用模型 -> topics/stage-ability.md
- 路由、页面切换、生命周期 -> topics/routing-lifecycle.md
- 全局状态、数据绑定、状态共享 -> topics/state-management.md
- 网络请求、持久化、数据库 -> topics/network-data.md
- 相机、文件、媒体播放、权限 -> topics/media-device.md
- 测试、签名、打包、上架发布 -> topics/testing-release.md
- 创作激励、审核、上架卡审、合规材料 -> topics/incentive-review-2025.md
- UX 体验标准、交互热区、动效、深色模式、多端适配 -> topics/ux-standards.md
- 控件设计规范（41 个组件离线参考） -> topics/component-design-specs.md（索引）
  - 导航类（底部页签/子页签/标题栏/导航点） -> topics/component-navigation.md
  - 展示类（文本/进度条/Toast/气泡等 15 个） -> topics/component-display.md
  - 操作类（按钮/菜单/工具栏等 8 个） -> topics/component-action.md
  - 输入类（文本框/搜索框/数字加减/图案锁） -> topics/component-input.md
  - 选择类（勾选/开关/滑动条/选择器等 7 个） -> topics/component-selection.md
  - 容器类（列表/弹出框/半模态面板） -> topics/component-container.md

## 默认硬门禁（ArkTS 编码任务）
当任务涉及 `entry/src/main/ets/**` 的代码编写或修改时，默认必须执行以下流程：
未满足第 1 步时，不允许开始代码编辑。

1. 写前预检（必跑）
```bash
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

2. 写中约束（必遵守）
- 禁止 `@Prop` 函数回调
- 禁止直 `await preferences.getPreferences(...)`
- 禁止 spread 刷新与动态 `$r(...)`
- 禁止引入已标记 deprecated API

3. 写后验收（必跑）
```bash
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
hvigor :entry:default@CompileArkTS
```

4. 运行时冒烟（必做）
- HomeTab / SettingsTab / CodesTab / LearningTab 的关键路径至少各验证一次

未满足上述门禁时，不得声称“已完成/可交付”。

## Review Risk Routing
- 高风险（High）
	- 关键词：支付、账号登录、用户数据、隐私、权限、未成年人、医疗健康、金融交易、内容审核
	- 处理：优先路由 topics/incentive-review-2025.md，再补充业务主题文档
- 中风险（Medium）
	- 关键词：媒体上传、分享、推送、定位、后台任务、第三方 SDK 接入
	- 处理：业务主题 + 审核主题双路由，补充材料准备清单
- 低风险（Low）
	- 关键词：纯工具、离线功能、本地计算、UI 优化、性能调优
	- 处理：优先业务主题，最后附审核主题最低必查项

## Answer Pattern
1. 先给 1-2 句直接结论
2. 明确问题所属主题
3. 先给风险等级（High/Medium/Low）
4. 引导到对应主题子文档的官方入口
5. 给下一步动作建议（先看什么，再做什么）
6. 必要时声明边界与版本差异风险

## Boundaries
- 不将 OpenHarmony 的社区实现细节误写成 HarmonyOS 商业 SDK 专属能力
- 无法确认版本时默认按最新稳定版本回答，并提示用户校验 API 版本
- 涉及账号资质、上架策略时优先引导到 AppGallery Connect 官方页面
- 涉及激励政策时需提醒“规则会更新”，优先给官方活动页和审核规范页

## Quick Prompts
- 帮我定位 ArkTS 入门和类型系统官方文档
- ArkUI 状态管理常见方案和官方入口有哪些
- Stage 模型下页面跳转和生命周期怎么查
- 纯血鸿蒙网络请求和本地存储该看哪些文档
- 发布到 AppGallery Connect 需要先看哪些流程
- 2025 创作激励规则下，如何设计应用才能避免卡审

## Learning Fast Path
- 语言规范学习地图: learning/language-spec-learning-map.md
- ArkTS 深入主题: topics/arkts.md
- ArkUI 深入主题: topics/arkui.md
- 建议顺序: ArkTS -> ArkUI -> Stage/Ability -> 路由生命周期 -> 状态管理

## Execution Assets
- 提审前清单（按应用类型）: checklists/pre-submission-2025.md
- 激励与审核主题: topics/incentive-review-2025.md
- 通用设计建议（功能丰富度 + 深色 + 多端）: checklists/universal-product-design-suggestions.md
- UX 体验标准（必须条款 + ArkUI 落地对照）: topics/ux-standards.md
- ArkTS 开发索引主题: topics/arkts.md
- ArkTS 历史报错防回归档案: topics/arkts-error-prevention.md
- ArkTS 防回归快速清单: checklists/arkts-regression-prevention.md
- ArkTS 编译现代化守卫: ../arkts-modernization-guard/SKILL.md

## 🚀 极速实现包（Starter Kit）
- 主入口 + 资产路由: starter-kit/SKILL.md
- 项目目录骨架 + 配置: starter-kit/scaffold/project-structure.md
- 四层分层架构 + 规范: starter-kit/scaffold/layer-architecture.md
- 登录模块模板: starter-kit/modules/auth-login.md
- 列表页模板（刷新/加载更多）: starter-kit/modules/list-page.md
- 详情页模板（路由传参/骨架屏）: starter-kit/modules/detail-page.md
- 表单提交模板（校验/图片上传）: starter-kit/modules/form-submit.md
- 底部导航模板（TabBar/侧边栏）: starter-kit/modules/tabbar-navigation.md
- 深色模式 + 多端断点适配: starter-kit/modules/dark-multi.md
- Day 1 骨架清单: starter-kit/pipeline/day1-scaffold-checklist.md
- Day-by-Day 执行顺序（10 天交付）: starter-kit/pipeline/execution-order.md
- 阶段任务拆分 + 验收清单: starter-kit/pipeline/task-breakdown.md
- App 类型定制清单: starter-kit/pipeline/app-type-checklist.md
- ArkTS/ArkUI 常用代码片段: starter-kit/snippets/common-patterns.md
- 全局状态管理模板: starter-kit/snippets/state-management.md
