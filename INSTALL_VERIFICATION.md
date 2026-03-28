# 安装验证清单

完成安装后，按照下列步骤验证技能包是否正确配置。

## 🚀 快速安装（推荐）

```bash
# 一键安装到当前项目
npx harmonyos-skills-pack

# 国内用户加速
npx harmonyos-skills-pack --mirror

# 验证安装
test -d .claude/skills/harmonyos-ark && echo "✓ Claude skills 已安装"
test -d .github/skills/harmonyos-ark && echo "✓ Copilot skills 已安装"
test -d .codex/skills/harmonyos-ark && echo "✓ Codex skills 已安装"
```

## 📋 目录清单

### Claude 安装路径验证

```bash
# 验证 Claude 技能目录存在
test -d ~/.claude/skills/harmonyos-ark && echo "✓ harmonyos-ark 已安装" || echo "✗ harmonyos-ark 缺失"
test -d ~/.claude/skills/universal-product-quality && echo "✓ universal-product-quality 已安装" || echo "✗ universal-product-quality 缺失"

# 查看完整目录结构
ls -la ~/.claude/skills/
```

### GitHub Copilot 安装路径验证（工作区内）

```bash
# 在工作区根目录执行
test -d .github/skills/harmonyos-ark && echo "✓ harmonyos-ark 已安装" || echo "✗ harmonyos-ark 缺失"
test -d .github/skills/universal-product-quality && echo "✓ universal-product-quality 已安装" || echo "✗ universal-product-quality 缺失"

# 查看完整目录结构
ls -la .github/skills/
```

---

## 🔍 文件完整性检查

### 核心入口文件

```bash
# Claude 技能入口
test -f ~/.claude/skills/harmonyos-ark/SKILL.md && echo "✓ SKILL.md 存在" || echo "✗ SKILL.md 缺失"
test -f ~/.claude/skills/universal-product-quality/SKILL.md && echo "✓ SKILL.md 存在" || echo "✗ SKILL.md 缺失"

# GitHub 技能入口
test -f .github/skills/harmonyos-ark/SKILL.md && echo "✓ SKILL.md 存在" || echo "✗ SKILL.md 缺失"
```

### 主题文件夹

harmonyos-ark 应包含以下主题目录：

```bash
ls -1 ~/.claude/skills/harmonyos-ark/topics/
# 应输出：
# arkts.md
# arkui.md
# media-device.md
# network-data.md
# routing-lifecycle.md
# state-management.md
# stage-ability.md
# testing-release.md
# incentive-review-2025.md (可选，鸿蒙审核风险指南)
```

### 快速启动包

```bash
test -d ~/.claude/skills/harmonyos-ark/starter-kit && echo "✓ starter-kit 已安装" || echo "✗ starter-kit 缺失"
ls -1 ~/.claude/skills/harmonyos-ark/starter-kit/
# 应包含：SKILL.md, scaffold/, modules/, pipeline/, snippets/
```

---

## 🧪 功能验证

### Step 1: 验证 Claude 可以发现技能

在 Claude 中提出如下问题：

```
我需要学习一下鸿蒙 Ark 应用的路由机制，从入门到进阶。
```

**预期结果：Claude 会识别这是一个 HarmonyOS 相关问题，并参考 harmonyos-ark 技能中的 routing-lifecycle.md**

### Step 2: 验证快速启动包是否可访问

在 Claude 中提出：

```
我想按照最佳实践快速搭建一个完整的鸿蒙 Ark 项目骨架，包括状态管理、路由、网络数据接入。
```

**预期结果：Claude 参考 starter-kit/SKILL.md 和对应的模块指南**

### Step 3: 验证 GitHub Copilot 集成（如已安装）

在工作区内打开一个 .ts 或 .ets 文件，试图：
- 编写一个 Page 组件
- 使用 @ohos.router 进行导航

**预期结果：Copilot 能够识别 HarmonyOS 上下文并提供相关建议**

### Step 4: 验证 Copilot 可访问技能清单

在 VS Code 中使用命令面板：
```
@harmonyos-ark 
```

**预期结果：能在建议中看到相关技能**

---

## ⚙️ 同步验证

### 验证安装脚本功能

测试安装脚本的 --help 输出：

```bash
bash scripts/install-skills.sh --help
# 应输出使用说明和支持的选项
```

### 验证同步脚本功能

更新后可使用同步脚本保持技能最新：

```bash
bash scripts/sync-skills.sh
# 应输出同步状态信息，确认 .claude/skills 和 .github/skills 已更新
```

---

## 🔧 故障排查

### 问题 1: "技能目录未找到"

**症状**：Claude/Copilot 无法识别 harmonyos-ark 技能

**检查步骤**：
```bash
# 1. 验证目录是否存在且有读权限
ls -la ~/.claude/skills/harmonyos-ark/
ls -la .github/skills/harmonyos-ark/

# 2. 检查 SKILL.md 文件是否存在
file ~/.claude/skills/harmonyos-ark/SKILL.md

# 3. 查看 SKILL.md frontmatter
head -20 ~/.claude/skills/harmonyos-ark/SKILL.md
# 应包含 name: 和 description: 字段
```

**解决方案**：
- 重新运行 `bash scripts/install-skills.sh --claude`
- 或手动复制：`cp -r skills/harmonyos-ark ~/.claude/skills/`

### 问题 2: "平台间技能不同步"

**症状**：.claude/skills 和 .github/skills 版本不一致

**检查步骤**：
```bash
# 比较文件计数
find ~/.claude/skills -type f | wc -l
find .github/skills -type f | wc -l
# 两个数字应该相同

# 比较目录结构
diff <(find ~/.claude/skills -type d | sort) <(find .github/skills -type d | sort)
```

**解决方案**：
```bash
# 运行同步脚本
bash scripts/sync-skills.sh

# 或手动同步
rm -rf ~/.claude/skills .github/skills
bash scripts/install-skills.sh --claude
bash scripts/install-skills.sh --copilot
```

### 问题 3: "权限被拒绝"

**症状**：安装脚本无法写入 ~/.claude/skills

**解决方案**：
```bash
# 检查 .claude 目录权限
ls -la ~/.claude/

# 如果目录不存在，创建它
mkdir -p ~/.claude
chmod 755 ~/.claude

# 重新运行安装脚本
bash scripts/install-skills.sh --claude
```

### 问题 4: "SKILL.md Frontmatter 格式错误"

**症状**：Claude 无法正确解析技能元数据

**检查步骤**：
```bash
# 验证 SKILL.md 开头是否包含 ---
head -5 ~/.claude/skills/harmonyos-ark/SKILL.md
# 第一行应该是 ---

# 验证必需字段存在
grep -E "^(name|description):" ~/.claude/skills/harmonyos-ark/SKILL.md
```

---

## 📊 完整验证清单

使用下面的检查表确保所有步骤都已完成：

- [ ] ✓ Claude 技能目录存在 (`~/.claude/skills/harmonyos-ark`)
- [ ] ✓ GitHub 技能目录存在 (`.github/skills/harmonyos-ark`)
- [ ] ✓ 核心 SKILL.md 文件存在并可读
- [ ] ✓ 9 个主题 markdown 文件都存在
- [ ] ✓ starter-kit 子目录完整
- [ ] ✓ 两个平台的目录结构完全相同
- [ ] ✓ Claude 可识别 HarmonyOS 相关问题
- [ ] ✓ 快速启动功能可访问（可选）
- [ ] ✓ 同步脚本功能正常
- [ ] ✓ 版本号与 VERSION 文件一致

---

## 📞 需要帮助？

如果验证过程中遇到问题：

1. **查看日志**：检查安装脚本的完整输出
   ```bash
   bash scripts/install-skills.sh --claude 2>&1 | tee install.log
   ```

2. **运行诊断脚本**：
   ```bash
   bash scripts/validate-skills.sh
   ```

3. **手动验证 Frontmatter**：
   ```bash
   python3 << 'EOF'
   import yaml
   import sys
   
   with open(sys.argv[1], 'r') as f:
       content = f.read()
       if content.startswith('---'):
           parts = content.split('---', 2)
           if len(parts) >= 3:
               meta = yaml.safe_load(parts[1])
               print("✓ FrontMatter 有效:")
               print(f"  name: {meta.get('name', '(缺失)')}")
               print(f"  description: {meta.get('description', '(缺失)')}")
           else:
               print("✗ FrontMatter 格式不完整")
       else:
           print("✗ 文件不以 --- 开头")
   EOF
   ~/.claude/skills/harmonyos-ark/SKILL.md
   ```

---

**最后更新**：2026-03-28  
**技能版本**：0.1.2  
**适用平台**：Claude, GitHub Copilot, Codex
