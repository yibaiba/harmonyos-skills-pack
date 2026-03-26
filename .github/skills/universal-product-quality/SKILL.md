---
name: universal-product-quality-gate
description: 通用产品质量与提审技能，适用于任意项目。聚焦功能丰富度、深色模式、多端适配与发布前风险控制。
---

# Universal Product Quality Skill

## When to Use
- 新项目立项时定义功能与体验基线
- 版本发布前做统一质量体检
- 团队评审时快速识别高风险缺陷

## Scope
- 适用于 App、Web、桌面应用、小程序等项目形态
- 不依赖具体技术栈
- 重点覆盖：功能丰富度、深色模式、多端适配、发布前风险

## Core Rules
1. 功能点丰富度
- 至少 3 条完整业务链路，且每条都可独立走通。
2. 深色模式
- 关键页面在深色/浅色主题下都具备可读性与可操作性。
3. 多端适配
- 至少覆盖手机、平板、桌面（或等价分辨率层级）的核心流程。
4. 风险分级
- 对需求按 High/Medium/Low 风险分级并执行对应验证深度。

## Risk Routing
- High: 支付、账号体系、敏感数据、未成年人、医疗金融、合规敏感场景
- Medium: 定位、推送、媒体上传、第三方 SDK、复杂权限
- Low: 离线工具、静态内容、本地处理为主功能

## Auto Classification Rule
- 若风险分级存在争议，按 rules/risk-auto-classification.md 执行自动判定

## Execution Assets
- checklists/pre-release-universal.md
- checklists/multi-platform-dark-mode.md
- topics/feature-richness.md
- templates/project-onboarding-template.md
- templates/team-review-scorecard.md
- rules/risk-auto-classification.md

## Answer Pattern
1. 先给结论
2. 标注风险等级
3. 给执行清单
4. 给最小可落地动作

## Boundaries
- 不替代法律审查与监管合规结论
- 不替代业务方最终上线决策
