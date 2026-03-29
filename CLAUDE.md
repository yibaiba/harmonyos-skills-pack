# CLAUDE

本文件为 Claude 在本仓库的标准技能入口说明。

## Start Here
- .claude/skills/harmonyos-ark/SKILL.md
- .claude/skills/harmonyos-ark/arkts-modernization-guard/SKILL.md
- .claude/skills/universal-product-quality/SKILL.md

## Canonical Sources
- .claude/skills/harmonyos-ark/SKILL.md
- .claude/skills/harmonyos-ark/starter-kit/SKILL.md
- .claude/skills/harmonyos-ark/arkts-modernization-guard/SKILL.md
- .claude/skills/universal-product-quality/SKILL.md

## Usage Rule
- 入口文件用于发现技能。
- 标准目录中的技能文件就是执行来源。
- 若目录存在差异，先执行 scripts/sync-skills.sh 对齐后再运行。

## Recommended Prompt Prefix
在开始任务前可先执行以下约束：

"先读取 .claude/skills 的对应 SKILL.md，并在 .claude/skills 目录内按路由执行任务。"

## 🚨 ArkTS 全局编码约束
编写 .ets/.ts 代码时，SKILL.md 中「🚨 全局编码约束」区块为硬约束。
完整规则: .claude/skills/harmonyos-ark/topics/arkts-coding-rules.md
