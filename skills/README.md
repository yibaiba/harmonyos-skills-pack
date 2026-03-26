# Skills Index

## Positioning
- 当前 `skills/` 目录是内容源（canonical content source），用于集中维护主题文档、模板与清单
- 标准技能入口已同步提供在 `.claude/skills/` 与 `.github/skills/`
- Agent 应优先从标准入口发现技能，再跳转回 `skills/` 下的内容源文件

## Install As A Pack (git clone)
- 这是可发布的通用 skills 包，可通过 `git clone` 后执行安装脚本安装
- 安装脚本: `scripts/install-skills.sh`
- 卸载脚本: `scripts/uninstall-skills.sh`

## Domain Skills
- harmonyos-ark: 鸿蒙 Ark 文档与审核规则技能

## Universal Skills
- universal-product-quality: 项目无关的发布前质量技能

## Standard Entry Points
- Claude: `.claude/skills/harmonyos-ark/SKILL.md`
- Claude: `.claude/skills/universal-product-quality/SKILL.md`
- GitHub/Copilot: `.github/skills/harmonyos-ark/SKILL.md`
- GitHub/Copilot: `.github/skills/universal-product-quality/SKILL.md`

## Recommended Default
如果你希望每个项目都能复用，优先使用 universal-product-quality。
