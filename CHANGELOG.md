# Changelog

All notable changes to this skills pack are documented in this file.

## [Unreleased]

## [0.1.4] - 2026-03-28

### Added

- 新增 `topics/acl-permissions.md` — ACL 受限权限申请完整指南
  - system_basic 级权限完整列表与分类（媒体/通讯/系统/网络）
  - ACL 申请流程（AGC → Profile → module.json5 → 动态请求）
  - 替代方案决策树（Picker / 安全控件优先标记 ✅ / ⚠️）
  - module.json5 配置示例与 ArkTS 动态权限请求代码
  - 审核避坑清单（10 条）
  - Agent 行为规范：先询问 → 推荐替代 → 确认后再用 ACL

### Changed

- SKILL.md 路由表新增 ACL 权限条目与映射
- media-device.md / testing-release.md 新增交叉引用

## [0.1.3] - 2026-03-28

### Added

- 新增 `arkts-modernization-guard` 子 skill（ArkTS 编译现代化守卫）
  - SKILL.md：9 条扫描规则（P0/P1/P2 分级）
  - scripts/scan-arkts-modernization.sh：自动扫描 .ets/.ts 文件
  - references/error-to-fix-map.md：15+ 错误码→修复映射
  - snippets/replacement-patterns.md：9 个代码替换模板
- CLI 新增 `--version` / `-v` 参数
- package.json 补充 `homepage` + `bugs` 字段

### Fixed

- 修复 17 处对 `arkts-modernization-guard` 的死链引用
- .gitignore 清理无关条目

### Changed

- `arkts-modernization-guard` 从顶层移入 `harmonyos-ark/` 子目录
- 验证脚本检查数 31 → 36 → 31（随结构调整）

## [0.1.2] - 2026-03-28

### Added

- npx 一键安装 CLI (`npx harmonyos-skills-pack`)
- `--mirror` / `--cn` 国内镜像加速参数
- GitHub Actions 自动发布工作流 (`.github/workflows/publish.yml`)
- Agent 摘要 (HTML comment) 覆盖所有 >500 行文件 (31/31)
- See Also 交叉引用覆盖所有关键文件 (70/70)
- SKILL.md 路由表重组为 8 个语义分组
- 12 个中等文件 + 13 个 500-1000 行文件的 Agent 摘要
- 6 个新 starter-kit 模块 (data-persistence, notification-handling, websocket-realtime, media-camera, payment-billing, background-tasks)
- 3 个质量模板 (CI/CD, 后端质量, 质量指标追踪)
- ArkTS 工程硬规范文档：
  - skills/harmonyos-ark/topics/arkts-engineering-rules.md
- ArkTS 提交前静态检查清单：
  - skills/harmonyos-ark/checklists/arkts-static-checklist.md
- ArkTS 静态检查命令模板：
  - skills/harmonyos-ark/checklists/arkts-static-check-commands.md

### Changed

- README 添加 npx 安装说明和 badge
- starter-kit 模块列表更新至 15 个
- .gitignore 允许 .github/workflows/ 被跟踪
- harmonyos-ark 主路由新增 ArkTS 工程规范路由与执行资产索引。
- harmonyos-ark 模块 README 增补 ArkTS 静态检查命令入口与维护约定。
- 根 README 明确 ArkTS 工程规范与静态检查能力定位。

### Fixed

- 移除 AGENTS.md/CLAUDE.md 自动复制（不应复制到用户项目）

## [0.1.0] - 2026-03-26

### Added

- Initial release of reusable skills pack with two skills:
  - harmonyos-ark
  - universal-product-quality
- Standard skill directories with full content:
  - .claude/skills/harmonyos-ark
  - .claude/skills/universal-product-quality
  - .github/skills/harmonyos-ark
  - .github/skills/universal-product-quality
- Installer and uninstaller scripts:
  - scripts/install-skills.sh
  - scripts/uninstall-skills.sh
- Sync script to keep standard directories aligned with canonical source:
  - scripts/sync-skills.sh
- Machine-readable metadata:
  - llms.txt
  - SKILLS_MANIFEST.json
- Root publishing documentation:
  - README.md
  - AGENTS.md
  - CLAUDE.md
- Starter-kit standalone/offline path:
  - skills/harmonyos-ark/starter-kit/modules/offline-no-login.md
- Starter-kit optional auth-upgrade path:
  - skills/harmonyos-ark/starter-kit/modules/optional-login-upgrade.md

### Changed

- Updated harmonyos-ark route docs for starter-kit asset completeness and numbering consistency.
- Clarified source-of-truth and install flow for clone-based distribution.
- Updated starter-kit routing table and prompts to include offline/no-login and guest-to-auth upgrade paths.
- Updated Day 2 execution guidance to support both account-login and standalone offline branches.
- Updated app-type checklist (Type A tools) to explicitly recommend offline-no-login module.

[0.1.2]: RELEASE_NOTES_0.1.0.md
[0.1.0]: RELEASE_NOTES_0.1.0.md
