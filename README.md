# HarmonyOS Skills Pack

Current Version: 0.1.0

这是一个面向 Claude、GitHub Copilot、Codex 等 Coding Agent 的可安装 Skills 项目。

它的目标不是提供某个具体业务应用，而是沉淀一套可复用的鸿蒙 Ark 开发知识、提审避坑经验和通用产品质量检查能力，让 Agent 在做 HarmonyOS 项目时能直接调用这些结构化资产。

## 项目定位

这个仓库解决的是两个问题：

1. HarmonyOS Ark 项目从 0 到 1 落地时，如何快速得到可执行的目录结构、模块模板、执行顺序和提审清单。
2. 在正式发布前，如何统一检查功能丰富度、深色模式、多端适配、风险等级和审核材料完整性。

换句话说，这个仓库是一个“可发布的 Skills 发行包”，不是单一 Demo，也不是某个 App 的源码仓库。

## 包含内容

当前版本包含两个核心技能：

### 1. harmonyos-ark

面向纯血鸿蒙 Ark 应用开发，覆盖：

- ArkTS、ArkUI、Stage/Ability、路由生命周期
- 网络请求、本地存储、媒体与设备能力
- 测试、签名、打包、上架发布
- 2025 创作激励与审核避坑
- Starter Kit 极速实现包

其中 starter-kit 已包含：

- 登录模块模板
- 单机离线 / 免登录模块
- 游客升级登录同步模块
- 列表页、详情页、表单页、TabBar 模板
- 深色模式与多端适配模板
- Day-by-Day 执行顺序与提审前清单

### 2. universal-product-quality

面向项目无关的通用产品质量校验，覆盖：

- 功能丰富度基线
- 深色模式可用性
- 多端适配一致性
- 风险分级与发布前验证
- 一键可勾选的通用发布前检查表

## 适用对象

适合以下场景：

- 你想让 Agent 辅助开发 HarmonyOS Ark 项目
- 你需要一套可复用的鸿蒙开发知识路由
- 你要做 2025 鸿蒙激励相关项目，想降低卡审风险
- 你希望把“功能开发”和“发布前质量检查”一起标准化

## 项目特点

- 可安装：支持安装到 Claude 标准技能目录或 Copilot 工作区目录
- 可同步：维护目录与标准入口目录可一键同步
- 可发布：已提供 release 打包与校验脚本
- 可审查：带有提审前检查表、ArkTS 工程规范、静态检查清单和风险专项
- 可扩展：可以继续追加新的 skill、module、checklist 和模板

## 快速开始

### 1. 克隆仓库

```bash
git clone <your-repo-url> harmonyos-skills-pack
cd harmonyos-skills-pack
```

### 2. 安装到 Claude

```bash
./scripts/install-skills.sh --claude
```

安装目标目录：

- ~/.claude/skills/harmonyos-ark
- ~/.claude/skills/universal-product-quality

### 3. 安装到 Copilot 工作区

```bash
./scripts/install-skills.sh --copilot-workspace /path/to/your/workspace
```

安装目标目录：

- /path/to/your/workspace/.github/skills/harmonyos-ark
- /path/to/your/workspace/.github/skills/universal-product-quality

### 4. 强制覆盖安装

```bash
./scripts/install-skills.sh --claude --force
./scripts/install-skills.sh --copilot-workspace /path/to/your/workspace --force
```

### 5. 维护者同步标准目录

```bash
./scripts/sync-skills.sh
```

## 卸载

```bash
./scripts/uninstall-skills.sh --claude
./scripts/uninstall-skills.sh --copilot-workspace /path/to/your/workspace
```

## 项目结构说明

- .claude/skills/
  - Claude 标准技能入口目录
- .github/skills/
  - Copilot 标准技能入口目录
- skills/
  - 内容维护目录，作为 canonical source
- scripts/
  - 安装、卸载、同步、校验、发布脚本
- releases/
  - 生成的 zip 发布包与校验文件

## 发布与维护

常用命令：

```bash
./scripts/validate-skills.sh
./scripts/make-release.sh --force
./scripts/sync-skills.sh
```

机器可读索引：

- llms.txt
- SKILLS_MANIFEST.json

## 使用示例 Prompt

下面这些提问方式可以直接帮助 Agent 路由到合适的 skills：

### HarmonyOS Ark 开发

```text
帮我梳理一个纯血鸿蒙 Ark 项目的目录结构和分层架构
```

```text
给我一个带列表页、详情页、表单页的鸿蒙 starter-kit 落地方案
```

```text
我这个鸿蒙应用是单机离线工具类，不需要登录，帮我设计启动页和主页结构
```

```text
我现在先免登录，后面再加账号同步，帮我设计游客升级登录的数据迁移方案
```

### ArkTS / ArkUI 学习与路由

```text
帮我定位 ArkTS 入门、类型系统和装饰器的官方学习路径
```

```text
ArkUI 状态管理、页面路由和生命周期要分别看哪些主题文档
```

```text
帮我按 ArkTS 规范检查命名、类型使用、装饰器边界、异步错误处理和依赖方向
```

### 激励与提审

```text
我准备参加 2025 鸿蒙激励，帮我按工具类 App 做一份提审前检查表
```

```text
我的应用有账号登录和媒体上传，按审核风险应该怎么准备材料
```

```text
帮我检查这个项目是否满足华为鸿蒙激励 2025 的提审要求
```

### 通用产品质量检查

```text
帮我做一次发布前质量体检，重点看功能丰富度、深色模式和多端适配
```

```text
给我一份通用的一键发布前检查表，适用于 App 和 Web 项目
```

### 维护与发布 Skills 包

```text
帮我同步 skills 到 .claude 和 .github 标准目录
```

```text
帮我验证这个 skills 包是否还能正常发布
```

```text
帮我重新打一个最新 release 包并生成校验文件
```

## 说明

- 这是一个通用 Skills 包，不绑定某一个具体业务项目。
- 安装脚本复制的是完整技能目录，不是只有介绍文件。
- 若你只需要鸿蒙相关能力，可以单独使用 harmonyos-ark。
- 涉及 2025 激励规则和提审策略时，最终仍以华为官方当期页面和 AGC 审核要求为准。

## 交流

QQ 群: 1029748283