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
- High: 支付金融、账号身份/实名、敏感人群（未成年人/医疗/教育收费）、敏感数据（通讯录/精确位置/生物特征）、大规模 UGC/内容审核
- Medium: 设备能力（定位/推送/相机/蓝牙）、后台任务/定时同步、第三方 SDK、跨端同步、媒体上传处理
- Low: 离线工具、静态展示、本地计算为主（无支付/无账号/无敏感数据）

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

## 平台特定扩展

- **HarmonyOS / Ark 应用**：见 `skills/harmonyos-ark/SKILL.md`
  - 额外检查项：系统权限声明、ArkTS 编译合规、提审材料格式、鸿蒙特有 API 用法
  - 推荐组合：先用本技能做通用质量把关 → 再用 harmonyos-ark 做平台专项把关

## Boundaries
- 不替代法律审查与监管合规结论
- 不替代业务方最终上线决策
