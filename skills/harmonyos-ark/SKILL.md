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
- ArkUI、声明式 UI、组件、布局、状态装饰器 -> topics/arkui.md
- Stage、UIAbility、应用模型 -> topics/stage-ability.md
- 路由、页面切换、生命周期 -> topics/routing-lifecycle.md
- 全局状态、数据绑定、状态共享 -> topics/state-management.md
- 网络请求、持久化、数据库 -> topics/network-data.md
- 相机、文件、媒体播放、权限 -> topics/media-device.md
- 测试、签名、打包、上架发布 -> topics/testing-release.md
- 创作激励、审核、上架卡审、合规材料 -> topics/incentive-review-2025.md

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
- ArkTS 开发索引主题: topics/arkts.md

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
