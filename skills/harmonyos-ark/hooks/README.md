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

### Codex CLI

在 `~/.codex/config.toml` 中添加：

```toml
[hooks]
post_run = [".codex/skills/harmonyos-ark/hooks/post-edit-arkts-scan.sh"]
```

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
