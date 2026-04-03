# Changelog

All notable changes to this skills pack are documented in this file.

## [Unreleased]

## [0.1.11] - 2026-04-03

### Added

- **ArkUI 图标规范**（全局硬约束）
  - ❌ 禁止在 UI 中直接使用 Emoji 表情符号（渲染依赖设备字体，跨设备不一致）
  - ✅ 改用 `SymbolGlyph($r('sys.symbol.xxx'))` HarmonyOS 原生矢量图标
  - `SymbolGlyph` 随深色模式自动适配（`fontColor` / `renderingStrategy`）
  - `sys.symbol.*` 资源名禁止猜测，必须在 DevEco Studio SDK 资源面板验证

### Changed

- **`arkts-coding-rules.md`** — 新增「4 ArkUI 图标规范」章节，快速检查清单增加 Emoji 检查项，原章节编号顺延
- **`SKILL.md`** — 「ArkUI 动画规范」后新增「ArkUI 图标规范」子节
- **`AGENTS.md`** — 全局约束摘要追加图标规范条目

## [0.1.10] - 2026-04-02

### Added

- **ArkTS 现代化守卫新增 3 条规则**
  - `AMG-012`: `arkts-limited-throw`（`throw` 非 `Error`）
  - `AMG-013`: `@StorageLink` / `@LocalStorageLink` 绑定 `@ObservedV2` class
  - `AMG-014`: `ohos_ic_public_*` 系统图标资源名校验提醒
- **4 类 ShieldBox 实战报错防回归条目**
  - `10605087`：`arkts-limited-throw`
  - `10505001`：DSL 链式属性断裂 / `Cannot find name 'width'`
  - `10905348`：StorageLink 绑定 `@ObservedV2`
  - `10903329`：`ohos_ic_public_*` 资源名缺失
- **3 个新代码替换模板**（`throw` 归一化、Storage 快照拆分、系统图标回退）

### Changed

- **状态管理文档纠偏** — 明确 `@StorageLink` / `@LocalStorageLink` 只绑定快照字段，不直接绑定 `@ObservedV2` ViewModel
- **Starter Kit 架构说明修正** — 移除“跨页共享 ViewModel”误导表述，统一为“跨页同步快照字段 + 页面级 ViewModel”
- **README 发布信息同步** — 版本号、守卫规则数、映射表规模、替换模板数更新为当前发布状态

## [0.1.9] - 2025-07-22

### Added

- **QUICK_START.md** — 30 秒 Agent 快速上手指南（约束→资源→模板三步走）
- **@ComponentV2 迁移指南** (`topics/componentv2-migration.md`, 338 行)
  - V1→V2 决策矩阵（7 场景）、22 项装饰器映射、7 组 Before/After 代码示例
  - 混用规则（5 条硬约束）、V2 限制清单、12 步迁移检查表
- **4 个 ArkTS 编译错误防回归模式**
  - `10605038` Record 对象字面量 → 声明 interface
  - `10905209` @Builder 内 let 声明 → private helper 方法
  - `10905209` @Builder ForEach 内联 UI → 独立 @Builder
  - build() 括号缺失连锁报错 → 优先检查大括号匹配
- **SKILL.md @Builder 编码规范段** — 6 条硬约束
- **Skill 选择决策树** (ASCII) — 6 条路径快速路由
- **error-to-fix-map 内嵌修复代码片段** — Router→Navigation 示例

### Changed

- **Router→Navigation 全量迁移** — 7 个 starter-kit 模块 + common-patterns.md，30+ 处 router 调用替换为 NavPathStack
- **废弃 API 全面清理** — getContext→getContext(this)、animateTo→UIContext.animateTo()、@system.prompt→@kit.ArkUI
- **SKILL.md 版本兼容表前置** — 从底部移至顶部（版本假设段后）
- **关键词速查表增强** — 补充行号/章节提示（登录/Navigation/ComponentV2）
- **3 个模块 Copy-Paste Ready 标记** — auth-login / list-page / detail-page
- **孤儿模块接入** — offline-no-login / optional-login-upgrade 加入路由表
- **审计修复** — 11 条路径纠正、async/await 转换、版本假设段、质量验收工作流

## [0.1.8] - 2026-03-29

### Added

- **ArkTS 全局编码约束** (`topics/arkts-coding-rules.md`)
  - 60+ 条 ArkTS 语法禁止项（7 组表格：类型/变量/函数/类/模块/运算符/枚举）
  - HarmonyOS API 使用规范（10 条）
  - ArkUI 动画规范（4 条，禁止布局属性动画）
  - 快速检查清单（10 项）

### Changed

- **SKILL.md 全局约束内联** — Top 15 禁止项 + API 规范 + 动画规范直接嵌入 SKILL.md，Agent 无需额外文件读取
- **SKILL.md frontmatter 新增 `globs`** — 匹配 .ets/.ts/module.json5 文件，提升 Agent 自动激活率
- **四层约束注入** — AGENTS.md / CLAUDE.md / copilot-instructions.md / SKILL.md 多平台同步，确保 Copilot、Claude、Codex 三平台 Agent 自动遵守编码约束

## [0.1.7] - 2026-03-28

### Added

- **UX 设计验收指南** (`topics/ux-design-specs.md`)
  - 8 大验收维度：视觉风格 / 布局 / 动效 / 系统特性 / 多设备适配 / 人机交互
  - 50+ 检查项，P0/P1/P2 严重度分级
  - 快速决策树（4 项 P0 必查优先）
  - 20 个华为官方来源 URL + ArkUI 代码提示
  - 覆盖：色彩、字体、图标、基础布局、响应式架构、转场/手势/离手减速动效、导航条、状态栏、深色模式、启动页、折叠屏、2in1/平板、横竖屏、多窗口/画中画、光标/焦点/键盘交互
- SKILL.md 新增 UX 设计验收路由

## [0.1.6] - 2026-03-28

### Added

- Agent Hooks 模板（三平台 × 双系统）
  - `post-edit-arkts-scan.sh/ps1`: 编辑 .ets/.ts 后自动触发 11 条 AMG 规则扫描
  - `post-edit-acl-check.sh/ps1`: 编辑 module.json5 后检查 19 条 ACL 受限权限
  - `claude-settings.json`: Claude Code PostToolUse 配置模板
  - `copilot-hooks.json`: GitHub Copilot PostToolUse 配置模板（官方 v1 格式）
  - `hooks/README.md`: 三平台安装指南 + JSON 格式差异对照表
  - SKILL.md 路由表新增 hooks 入口

### Fixed

- Copilot hooks 配置修正为官方格式（version:1, camelCase, bash/powershell 分离键）
- 4 个 hook 脚本新增 Copilot toolArgs JSON 字符串路径提取（兼容三平台）
- PowerShell Split-Path 空路径错误修复
- 代码审查修复：validate-skills.sh check() $? 捕获时序 bug
- 安装脚本 --all 标志逻辑修复（保留用户指定路径）
- CLI execSync → execFileSync 安全加固（防 shell 注入）

## [0.1.5] - 2026-03-28

### Added

- 现代化守卫新增 AMG-010/AMG-011 检测规则
  - AMG-010: `arkts-no-destruct-decls`（10605074）解构声明检测
  - AMG-011: `arkts-no-any-unknown`（10605008）any/unknown 类型检测
  - 扫描脚本新增 3 条检测规则
  - 2 个新代码替换模板（replacement-patterns.md）
  - 错误映射表与防回归档案同步更新

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
