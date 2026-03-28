# HarmonyOS ArkTS Hooks 模板

本目录提供 Claude Code / GitHub Copilot / Codex CLI 三平台的 hooks 配置模板，实现 AI Agent 编辑代码后的**自动守护**。

## 包含内容

| 文件 | 用途 |
|------|------|
| `post-edit-arkts-scan.sh` | 编辑 .ets/.ts 后自动扫描（macOS/Linux） |
| `post-edit-arkts-scan.ps1` | 编辑 .ets/.ts 后自动扫描（Windows） |
| `post-edit-acl-check.sh` | 编辑 module.json5 后检查 ACL 权限（macOS/Linux） |
| `post-edit-acl-check.ps1` | 编辑 module.json5 后检查 ACL 权限（Windows） |
| `claude-settings.json` | Claude Code hooks 配置示例 |
| `copilot-hooks.json` | GitHub Copilot hooks 配置示例 |

## 安装方式

### Claude Code

将 `claude-settings.json` 中的 `hooks` 段合并到项目的 `.claude/settings.json`：

```bash
# 或直接复制（如果还没有 settings.json）
cp hooks/claude-settings.json .claude/settings.json
```

### GitHub Copilot

将 `copilot-hooks.json` 复制到项目的 `.github/hooks/` 目录：

```bash
mkdir -p .github/hooks
cp hooks/copilot-hooks.json .github/hooks/arkts-guard.json
```

> **注意**：Copilot hooks 使用 camelCase 事件名（`postToolUse`），且脚本通过 `bash`/`powershell` 分开指定，无需 `matcher` 字段——过滤逻辑在脚本内部完成。

### Codex CLI

在 `~/.codex/config.toml`（全局）或 `.codex/config.toml`（项目级）中添加：

```toml
[hooks]
post_run = [
  ".codex/skills/harmonyos-ark/hooks/post-edit-arkts-scan.sh",
  ".codex/skills/harmonyos-ark/hooks/post-edit-acl-check.sh"
]
```

> Codex `post_run` 在每次 agent 执行后触发（非逐 tool），脚本内部根据文件扩展名自行过滤。

## 三平台 JSON 格式差异

| 差异点 | Claude Code | GitHub Copilot | Codex CLI |
|--------|-------------|----------------|-----------|
| 配置文件 | `.claude/settings.json` | `.github/hooks/*.json` | `config.toml` |
| 事件名 | `PostToolUse` | `postToolUse` | `post_run` |
| 脚本键 | `command` | `bash` + `powershell` | 字符串/数组 |
| 过滤方式 | `matcher` 字段 | 脚本内 `toolName` 过滤 | 脚本内自行过滤 |
| stdin 路径字段 | `tool_input.path` | `toolArgs` (JSON 字符串) | 无/简单 |

本目录的脚本已兼容所有三种 stdin JSON 格式。

## 工作原理

```
Agent 编辑 .ets 文件
    ↓
PostToolUse hook 触发
    ↓
post-edit-arkts-scan.sh 执行
    ↓
├─ 0 违规 → 静默通过
├─ P2 告警 → 输出 WARNING（不阻断）
└─ P0/P1 违规 → 输出 FAILED（Agent 会看到并修复）
```
