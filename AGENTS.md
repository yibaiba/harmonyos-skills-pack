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

## 🚨 ArkTS 全局编码约束（编写 .ets/.ts 代码前必读）
- **编写任何 .ets/.ts 代码时，SKILL.md 中的「🚨 全局编码约束」区块为硬约束。**
- 完整规则文件: .claude/skills/harmonyos-ark/topics/arkts-coding-rules.md
- 核心禁止项: `any`/`unknown`、`var`、解构赋值、函数表达式、`obj["field"]`、`for...in`、嵌套函数、`Function.apply/call/bind`、交叉类型、构造函数中声明字段、声明合并、`#private`、`as const`、`delete`属性、`import`不在顶部
- API 规范: 不确定的 API 禁止猜测，搜索华为官方文档确认；权限配置 module.json5；资源用 `$r` 引用
- 动画规范: 禁止在动画中频繁改变 width/height/padding/margin
- 图标规范: 禁止在 UI 中直接使用 Emoji 表情，改用 `SymbolGlyph($r('sys.symbol.xxx'))` 矢量图标

## Maintenance Rule
- 标准目录中的技能内容即执行内容。
- 若更新技能，请先运行 scripts/sync-skills.sh 再提交。
