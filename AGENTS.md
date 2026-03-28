# AGENTS

本文件为 Codex/通用 Coding Agent 的仓库入口说明。

## Skill Discovery Order
1. 先读标准技能入口（便于自动发现）
2. 在标准目录内完成路由与执行，不依赖额外目录跳转

## Standard Skill Entrypoints
- 鸿蒙 Ark: .github/skills/harmonyos-ark/SKILL.md
- ArkTS 现代化守卫: .github/skills/harmonyos-ark/arkts-modernization-guard/SKILL.md
- 通用质量: .github/skills/universal-product-quality/SKILL.md
- Claude 兼容入口: .claude/skills/harmonyos-ark/SKILL.md
- Claude 兼容入口: .claude/skills/harmonyos-ark/arkts-modernization-guard/SKILL.md
- Claude 兼容入口: .claude/skills/universal-product-quality/SKILL.md

## Canonical Content Sources
- Claude 鸿蒙主路由: .claude/skills/harmonyos-ark/SKILL.md
- Claude 鸿蒙极速实现包: .claude/skills/harmonyos-ark/starter-kit/SKILL.md
- Claude 鸿蒙来源清单: .claude/skills/harmonyos-ark/sources.md
- Claude ArkTS 守卫: .claude/skills/harmonyos-ark/arkts-modernization-guard/SKILL.md
- Claude 通用质量主路由: .claude/skills/universal-product-quality/SKILL.md
- Copilot 鸿蒙主路由: .github/skills/harmonyos-ark/SKILL.md
- Copilot ArkTS 守卫: .github/skills/harmonyos-ark/arkts-modernization-guard/SKILL.md
- Copilot 通用质量主路由: .github/skills/universal-product-quality/SKILL.md

## Task Routing
- 文档学习/官方链接定位: .claude/skills/harmonyos-ark/SKILL.md
- 项目快速落地(骨架/模块/执行顺序): .claude/skills/harmonyos-ark/starter-kit/SKILL.md
- ArkTS 编译错误/deprecated 扫描: .claude/skills/harmonyos-ark/arkts-modernization-guard/SKILL.md
- 发布前质量检查: .claude/skills/universal-product-quality/SKILL.md
- 鸿蒙审核风险问题: .claude/skills/harmonyos-ark/topics/incentive-review-2025.md

## Maintenance Rule
- 标准目录中的技能内容即执行内容。
- 若更新技能，请先运行 scripts/sync-skills.sh 再提交。
