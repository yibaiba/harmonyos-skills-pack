# HarmonyOS Ark Docs Skill

## 模块目标

提供一个可复用的“纯血鸿蒙 Ark 文档路由技能”，通过总入口将问题分发到 9 个主题子文档，统一官方来源优先级并减少重复维护。
新增“2025 创作激励与审核避坑”主题，用于按规则设计应用，降低卡审风险。

## 标准入口位置

- Claude 标准 skills 入口: `.claude/skills/harmonyos-ark/SKILL.md`
- GitHub/Copilot 标准 skills 入口: `.github/skills/harmonyos-ark/SKILL.md`
- 当前目录 `skills/harmonyos-ark/` 是内容源目录，负责维护实际主题文档、模板与清单

## 目录结构

- SKILL.md: 总 skill 入口，负责路由与回答模式
- DESIGN.md: 设计决策、验收标准与基线
- sources.md: 官方来源清单与优先级规则
- topics/: 主题子文档
- learning/language-spec-learning-map.md: 语言规范学习地图（空项目快速上手）
- starter-kit/: 鸿蒙项目极速实现包（脚手架、模块模板、执行流水线）
- checklists/pre-submission-2025.md: 按应用类型的提审前检查清单
- checklists/arkts-static-checklist.md: ArkTS 提交前静态检查清单
- checklists/arkts-static-check-commands.md: ArkTS 静态检查命令模板
- checklists/universal-product-design-suggestions.md: 通用设计建议（功能丰富度 + 深色 + 多端）
- topics/arkts-engineering-rules.md: ArkTS 工程硬规范（命名、类型、装饰器、异步、依赖）

## 使用方式

1. 先阅读 SKILL.md 的路由规则
2. 根据问题关键词进入对应 topics 文档
3. 按 sources.md 的优先级引用官方入口
4. 提审前按 checklists/pre-submission-2025.md 执行快检
5. 提交前按 checklists/arkts-static-checklist.md 做静态自检
6. 需要自动化扫描时按 checklists/arkts-static-check-commands.md 执行命令模板

## 维护约定

1. 新增主题时，先新增 topics 子文档，再更新 SKILL.md 的路由表
2. 修改来源规则时，仅更新 sources.md
3. 回答边界变更需同步 SKILL.md 与相关主题文档
4. 激励政策口径变更时，优先更新 incentive-review-2025.md 与 sources.md
5. ArkTS 工程规则变更时，需同步 arkts.md、arkts-engineering-rules.md 与 arkts-static-checklist.md
6. 静态扫描策略变更时，需同步 arkts-static-check-commands.md 与 arkts-static-checklist.md
