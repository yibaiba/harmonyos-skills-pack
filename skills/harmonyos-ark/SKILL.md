---
name: harmonyos-ark-docs-router
description: 纯血鸿蒙 Ark 应用开发文档路由技能。将问题映射到主题子文档，并按官方来源优先级给出检索路径。
globs: ["**/*.ets", "**/*.ts", "**/module.json5", "**/oh-package.json5"]
---

<!-- 🚨 MANDATORY: 编写 .ets/.ts 代码时以下规则为硬约束 -->
<!-- 禁止: any/unknown类型 | var | 解构赋值 | 函数表达式 | obj["field"] | for...in | 嵌套函数 | Function.apply/call/bind | 交叉类型 | 构造函数中声明字段 | 声明合并 | #private | as const | delete属性 | import不在顶部 -->
<!-- 必须: API不确定时搜索官方文档确认 | 权限配置module.json5 | 资源用$r引用 | 深色+浅色双主题 | 动画禁止改width/height/padding/margin -->
<!-- 完整60+条: topics/arkts-coding-rules.md -->

# HarmonyOS Ark Docs Router

## When to Use
- 需要快速定位 ArkTS、ArkUI、Stage/Ability 等官方文档时
- 需要从问题直接路由到对应主题资料时
- 需要明确 HarmonyOS 与 OpenHarmony 文档使用边界时
- 项目还未开始，想快速找到语言规范并按顺序学习时

## Scope
- 覆盖 Ark 应用开发主链路：语言、UI、应用模型、路由、状态、网络、媒体、测试与发布
- 覆盖创作激励与审核避坑：按 2025 年规则设计应用，降低卡审风险
- 默认不覆盖内核、驱动、系统裁剪、板级 bring-up

## Source Priority
1. 华为开发者联盟 HarmonyOS 文档（主来源）
2. OpenHarmony 官方文档（概念补充）
3. 官方 samples/codelabs（实践补充）
4. 其他社区内容（仅在用户明确要求时）

## 版本假设
- 未指定版本时，默认按最新稳定版本（HarmonyOS NEXT 6.x / API 13+）回答
- 如需 HarmonyOS 5 / API 11-12 支持，请明确声明
- 代码示例中涉及版本差异时会标注最低 API Level

## 文档链接读取策略
当需要读取华为开发者文档链接时，按以下优先级尝试：

1. **优先 MCP `web_fetch`** — 速度快、token 省，适合静态或服务端渲染页面
2. **降级 `agent-browser`** — 华为开发者文档站 (`developer.huawei.com/consumer/cn/doc/`) 是 SPA，`web_fetch` 返回空壳时需用浏览器自动化
   - 必须使用 `--headed` 模式（普通 headless 会超时）
   - 内容选择器用 `.markdown-body`（排除侧边栏噪音）
   - 侧边栏懒加载：需逐个访问父级页面才能发现子页面链接

## 🚨 全局编码约束（每次编写 .ets/.ts 代码前必读）

> **以下规则为硬约束。编写任何 .ets/.ts 代码前必须遵守，违反将导致编译失败或运行时异常。**

### ArkTS 语法 Top 15 禁止项（编译级）

| ❌ 禁止 | ✅ 替代 |
|---------|--------|
| `any` / `unknown` 类型 | 显式指定具体类型 |
| `var` 关键字 | `let` |
| 解构赋值 `const {a, b} = obj` | 逐字段赋值 `let a = obj.a` |
| 函数表达式 `function() {}` | 箭头函数 `() => {}` |
| `obj["field"]` 索引访问 | `obj.field` 点访问 |
| `for...in` 遍历对象 | 普通 `for` 循环 |
| 嵌套函数 | lambda / 箭头函数 |
| `Function.apply/call/bind` | 直接调用 |
| 交叉类型 `A & B` | 使用继承 `extends` |
| 构造函数中声明字段 | 在类声明体内声明字段 |
| 声明合并（class/interface/enum） | 保持定义紧凑不拆分 |
| `#privateField` 私有标识符 | `private` 关键字 |
| `as const` 断言 | 显式类型标注 |
| `delete` 删除属性 | 可空类型赋值 `null` |
| `import` 不在文件顶部 | 所有 `import` 必须在其他语句之前 |

### HarmonyOS API 规范（运行级）

| 规则 | 说明 |
|------|------|
| 禁止猜测 API | 不确定的 API 必须搜索华为官方文档确认 |
| import 声明 | 使用 API 前确认是否需要 `import` |
| 权限配置 | 调用前确认 `module.json5` 权限配置 |
| 资源引用 | UI 常量用 `$r` 引用，不直接用字面值 |
| 深色主题 | 新增颜色资源默认支持深色/浅色双主题 |
| 组件装饰器 | `@Component` vs `@ComponentV2` 与工程保持一致 |

### ArkUI 动画规范

- ✅ 优先 `@State` 驱动动画 + 声明式 UI
- ✅ 复杂子组件设置 `renderGroup(true)`
- ❌ **禁止在动画中频繁改变 `width`/`height`/`padding`/`margin`**（严重影响性能）

> 📄 完整 60+ 条约束详见 → [topics/arkts-coding-rules.md](topics/arkts-coding-rules.md)

---

## 🧭 Skill 选择指南

> Agent 首先判断任务类型，选择正确的 Skill 入口：

| 任务类型 | 使用 Skill | 说明 |
|----------|-----------|------|
| 鸿蒙开发知识查询 | **本文件** (harmonyos-ark) | 文档路由 + 编码约束 |
| 从零开始新项目 | **starter-kit/SKILL.md** | 骨架 + 模板 + 10 天执行计划 |
| 编译报错 / deprecated 清理 | **arkts-modernization-guard/SKILL.md** | 自动扫描 + 修复建议 |
| 通用产品质量验收（非鸿蒙特定） | **universal-product-quality/SKILL.md** | 功能丰富度 / 深色 / 多端 / 发布前 |
| 鸿蒙 + 通用质量双验收 | 先 universal → 再 harmonyos-ark | 组合使用，universal 做通用把关 |

## 🔍 关键词速查表

> Agent 直接用关键词匹配目标文件，无需遍历路由树。

| 关键词 | → 文件 | 补充 |
|--------|--------|------|
| 下拉刷新、列表、加载更多 | starter-kit/modules/list-page.md | 代码: starter-kit/snippets/common-patterns.md §二十四 |
| 登录、注册、Token | starter-kit/modules/auth-login.md | API: topics/network-data.md |
| 表单、校验、上传 | starter-kit/modules/form-submit.md | 代码: starter-kit/snippets/common-patterns.md §十一 |
| 权限、相机、文件、媒体 | topics/media-device.md | 模板: starter-kit/modules/media-camera.md |
| 安全控件、剪贴板、SaveButton | topics/security-components.md | 权限: topics/acl-permissions.md |
| 深色模式、主题切换 | starter-kit/modules/dark-multi.md | 检查: topics/ux-standards.md |
| Navigation、路由、传参 | topics/routing-lifecycle.md | 模板: starter-kit/modules/tabbar-navigation.md |
| 状态管理、@State、@Provide | topics/state-management.md | 高级: topics/state-management-advanced.md |
| 网络请求、HTTP、下载 | topics/network-data.md | 代码: starter-kit/snippets/common-patterns.md §一 |
| WebSocket、实时、重连 | starter-kit/modules/websocket-realtime.md | 代码: starter-kit/snippets/common-patterns.md §三十三 |
| 数据库、持久化、Preferences | starter-kit/modules/data-persistence.md | 代码: starter-kit/snippets/common-patterns.md §二十六 |
| 通知、推送、角标 | topics/notification-kit.md | 模板: starter-kit/modules/notification-handling.md |
| 后台任务、Worker | topics/background-tasks-kit.md | 模板: starter-kit/modules/background-tasks.md |
| 支付、IAP、计费 | starter-kit/modules/payment-billing.md | 审核: topics/incentive-review-2025.md |
| WebView、H5、Bridge | topics/arkweb.md | 混合/同层渲染 |
| 图片、PixelMap、编解码 | topics/image-kit.md | 缓存: topics/network-data.md |
| 卡片、Form Kit | topics/form-kit.md | 扫码: topics/scan-kit.md |
| 指纹、人脸、认证 | topics/user-auth-kit.md | 代码: starter-kit/snippets/common-patterns.md §三十二 |
| 发布、签名、上架 | topics/testing-release.md | 清单: checklists/pre-submission-2025.md |
| 审核、激励、合规 | topics/incentive-review-2025.md | 设计: topics/universal-product-design-suggestions.md |
| ACL、受限权限 | topics/acl-permissions.md | 审核: topics/incentive-review-2025.md |
| 编译报错、崩溃 | topics/arkts-error-prevention.md | 守卫: arkts-modernization-guard/ |
| 6.0 新特性、API 变更 | topics/harmonyos-6-overview.md | API: topics/harmonyos-6-api-*.md |
| ArkTS 语法、类型、装饰器 | topics/arkts.md | 深入: topics/arkts-lang-basics.md |
| ArkUI 组件、布局 | topics/arkui.md | 组件: topics/arkui-components.md |
| UX 设计、验收 | topics/ux-design-specs.md | 标准: topics/ux-standards.md |
| any 类型、var、解构 | topics/arkts-coding-rules.md | 60+ 条编码约束 |

---

## Topic Routing Table

> 按分类快速定位。每组第一行是入口文件，子行是细分方向。

### 🔤 ArkTS 语言
- **🚨 全局编码约束**（语法禁止项 + API 规范 + 动画规范） -> topics/arkts-coding-rules.md
- ArkTS、类型系统、装饰器、并发 -> topics/arkts.md
- ArkTS 官方开发指南（27 篇离线参考） -> topics/arkts-guide-specs.md（索引）
  - 语言基础（简介/入门/TS迁移/编程规范） -> topics/arkts-lang-basics.md
  - 基础类库（Buffer/XML/JSON） -> topics/arkts-stdlib.md
  - 并发编程（Promise/TaskPool/Worker） -> topics/arkts-concurrency.md
  - 跨语言交互（Node-API） -> topics/arkts-cross-lang.md
  - 运行时（模块化/FAQ） -> topics/arkts-runtime.md
  - 编译工具链（ArkGuard/字节码） -> topics/arkts-toolchain.md
- 编译报错、deprecated 清理、符号资源兼容 -> arkts-modernization-guard/SKILL.md
- 历史报错复盘、运行时崩溃防回归 -> topics/arkts-error-prevention.md
- **Agent Hooks**（PostToolUse 自动扫描/权限检查） -> hooks/README.md

### 🖼️ ArkUI 框架
- ArkUI、声明式 UI、组件、布局、状态装饰器 -> topics/arkui.md
- ArkUI 官方开发指南（37 篇离线参考） -> topics/arkui-guide-specs.md（索引）
  - 核心（简介/语法/状态管理/渲染控制/术语） -> topics/arkui-core.md
  - 组件（导航路由/布局/列表/文本/弹窗等） -> topics/arkui-components.md
  - 交互（键鼠/手势） -> topics/arkui-interaction.md
  - 拖拽/焦点/动画 -> topics/arkui-interaction-animation.md
  - 高级（自定义/国际化/无障碍/主题/性能） -> topics/arkui-advanced.md
  - UI Design Kit（HDS 设计套件） -> topics/ui-design-kit.md

### 📱 应用模型 / 路由 / 状态
- Stage、UIAbility、应用模型 -> topics/stage-ability.md
- 路由、页面切换、生命周期 -> topics/routing-lifecycle.md
- Router API、Router→Navigation 迁移 -> topics/routing-lifecycle-router.md
- 全局状态、数据绑定、状态共享 -> topics/state-management.md
- 状态管理高级用法、反模式、性能优化 -> topics/state-management-advanced.md

### 🔗 网络 / 存储 / 设备
- 网络请求、持久化、数据库 -> topics/network-data.md
- HTTP/WebSocket/Socket、图片加载缓存 -> topics/network-data-network.md
- 相机、文件、媒体播放、权限 -> topics/media-device.md

### 🧩 Kit 能力
- 通知、推送、角标、渠道管理 -> topics/notification-kit.md
- 后台任务、短时/长时/延迟任务 -> topics/background-tasks-kit.md
- 定位、地理编码、地理围栏 -> topics/location-kit.md
- 无障碍、屏幕朗读适配 -> topics/accessibility.md
- 图片解码、编码、变换、EXIF -> topics/image-kit.md
- WebView、H5 混合开发、JS Bridge -> topics/arkweb.md
- 桌面卡片、服务卡片、Form Kit -> topics/form-kit.md
- 扫码、二维码生成、码图识别 -> topics/scan-kit.md
- 指纹/人脸/口令认证 -> topics/user-auth-kit.md

### 📦 测试 / 发布 / 合规
- 测试、签名、打包、上架发布 -> topics/testing-release.md
- 应用内更新、QuickFix 热修复 -> topics/testing-release.md § "应用更新"
- 创作激励、审核、上架卡审、合规材料 -> topics/incentive-review-2025.md
- **ACL 受限权限申请**、system_basic 权限审批 -> topics/acl-permissions.md
- **安全控件**（PasteButton 读剪贴板 / SaveButton 写媒体库，点击即许可） -> topics/security-components.md

### 🎨 设计规范
- UX 体验标准、交互热区、动效、深色模式、多端适配 -> topics/ux-standards.md
- **UX 设计验收指南**（色彩/布局/动效/系统特性/多设备/人机交互 8 维度验收清单） -> topics/ux-design-specs.md
- 控件设计规范（41 个组件离线参考） -> topics/component-design-specs.md（索引）
  - 导航类（底部页签/子页签/标题栏/导航点） -> topics/component-navigation.md
  - 展示类（文本/进度条/Toast/气泡等 15 个） -> topics/component-display.md
  - 操作类（按钮/菜单/工具栏等 8 个） -> topics/component-action.md
  - 输入类（文本框/搜索框/数字加减/图案锁） -> topics/component-input.md
  - 选择类（勾选/开关/滑动条/选择器等 7 个） -> topics/component-selection.md
  - 容器类（列表/弹出框/半模态面板） -> topics/component-container.md

### 📋 HarmonyOS 6.0 版本变更（API changelog，按需查阅）
> 仅在需要确认 6.0 API breaking change 或新增 API 时读取。优先读 overview 获取摘要。
- 6.0 新特性、版本概览、升级适配 -> topics/harmonyos-6-overview.md
- 6.0 API 变更 — Ability Kit 6.0.0 -> topics/harmonyos-6-api-core.md
- 6.0 API 变更 — Ability Kit 6.0.2 -> topics/harmonyos-6-api-core-602.md
- 6.0 API 变更 — ArkTS/ArkData -> topics/harmonyos-6-api-core-arkts.md
- 6.0 ArkUI API 变更 — 6.0.2 前半 -> topics/harmonyos-6-api-arkui.md
- 6.0 ArkUI API 变更 — 6.0.2 后半 -> topics/harmonyos-6-api-arkui-part2.md
- 6.0 ArkUI API 变更 — 6.0.0 前半 -> topics/harmonyos-6-api-arkui-v600.md
- 6.0 ArkUI API 变更 — 6.0.0 后半 -> topics/harmonyos-6-api-arkui-v600-part2.md
- 6.0 服务类 Kit API 变更（Network/Camera/Media 等） -> topics/harmonyos-6-api-services.md

## 默认硬门禁（ArkTS 编码任务）
当任务涉及 `entry/src/main/ets/**` 的代码编写或修改时，默认必须执行以下流程：
未满足第 1 步时，不允许开始代码编辑。

1. 写前预检（必跑）
```bash
# 以下路径按实际安装位置选择一个可用的即可
bash skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh  # 仓库源目录
# 或 bash .codex/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
# 或 bash .claude/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

2. 写中约束（必遵守）
- 禁止 `@Prop` 函数回调
- 禁止直 `await preferences.getPreferences(...)`
- 禁止 spread 刷新与动态 `$r(...)`
- 禁止引入已标记 deprecated API

3. 写后验收（必跑）
```bash
bash skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh  # 同上，选可用路径
hvigor :entry:default@CompileArkTS
```

4. 运行时冒烟（必做）
- HomeTab / SettingsTab / CodesTab / LearningTab 的关键路径至少各验证一次

未满足上述门禁时，不得声称“已完成/可交付”。

## Review Risk Routing
- 高风险（High）
	- 关键词：支付、账号登录、用户数据、隐私、权限、未成年人、医疗健康、金融交易、内容审核
	- 处理：优先路由 topics/incentive-review-2025.md，再补充业务主题文档
- 中风险（Medium）
	- 关键词：媒体上传、分享、推送、定位、后台任务、第三方 SDK 接入
	- 处理：业务主题 + 审核主题双路由，补充材料准备清单
- 低风险（Low）
	- 关键词：纯工具、离线功能、本地计算、UI 优化、性能调优
	- 处理：优先业务主题，最后附审核主题最低必查项

## Answer Pattern
1. 先给 1-2 句直接结论
2. 明确问题所属主题
3. 先给风险等级（High/Medium/Low）
4. 引导到对应主题子文档的官方入口
5. 给下一步动作建议（先看什么，再做什么）
6. 必要时声明边界与版本差异风险

## Boundaries
- 不将 OpenHarmony 的社区实现细节误写成 HarmonyOS 商业 SDK 专属能力
- 无法确认版本时默认按最新稳定版本回答，并提示用户校验 API 版本
- 涉及账号资质、上架策略时优先引导到 AppGallery Connect 官方页面
- 涉及激励政策时需提醒“规则会更新”，优先给官方活动页和审核规范页

## 质量验收工作流（组合使用两个 Skill）

> 发布前建议按以下顺序执行双 Skill 验收：

1. **通用质量把关** → `universal-product-quality/SKILL.md`
   - 功能丰富度、深色模式、多端适配、发布前风险
   - 适用任意项目，不依赖鸿蒙特定知识
2. **鸿蒙平台专项** → 本 Skill (`harmonyos-ark`)
   - ArkTS 编译合规、系统权限、提审材料、API 兼容
   - 使用 `checklists/pre-submission-2025.md` 按应用类型逐项验收
3. **合并结论** → 两份清单的 🔴 Blocker 项全部通过方可发布

## Quick Prompts
- 帮我定位 ArkTS 入门和类型系统官方文档
- ArkUI 状态管理常见方案和官方入口有哪些
- Stage 模型下页面跳转和生命周期怎么查
- 纯血鸿蒙网络请求和本地存储该看哪些文档
- 发布到 AppGallery Connect 需要先看哪些流程
- 2025 创作激励规则下，如何设计应用才能避免卡审

### Prompt → Topic 快速映射

| 常见问题关键词 | 主题文件 | 补充 |
|---------------|---------|------|
| ArkTS 入门、类型、装饰器 | topics/arkts.md | 深入: arkts-lang-basics.md |
| 状态管理、@State、@Provide | topics/state-management.md | 代码: snippets/state-management.md |
| 路由、页面跳转、Navigation | topics/routing-lifecycle.md | 模板: modules/tabbar-navigation.md |
| 网络请求、持久化、数据库 | topics/network-data.md | 代码: snippets/common-patterns.md § HttpUtil |
| 发布、签名、上架 | topics/testing-release.md | 清单: checklists/pre-submission-2025.md |
| ACL、受限权限、权限审批 | topics/acl-permissions.md | 审核: topics/incentive-review-2025.md |
| 安全控件、PasteButton、SaveButton | topics/security-components.md | 权限: topics/acl-permissions.md |
| 激励、审核、合规 | topics/incentive-review-2025.md | 设计建议: checklists/universal-product-design-suggestions.md |
| 编译报错、崩溃 | topics/arkts-error-prevention.md | 守卫: arkts-modernization-guard/SKILL.md |
| 6.0 新特性、API 变更 | topics/harmonyos-6-overview.md | API: harmonyos-6-api-*.md |
| 图片处理、PixelMap、编解码 | topics/image-kit.md | 缓存: network-data.md § 图片加载 |
| WebView、H5、JS Bridge | topics/arkweb.md | 混合开发/同层渲染 |
| 桌面卡片、服务卡片 | topics/form-kit.md | Stage 模型卡片 |
| 扫码、二维码、条形码 | topics/scan-kit.md | 图像识码/码图生成 |
| 指纹、人脸、生物认证 | topics/user-auth-kit.md | 支付认证/凭据感知 |

## API 版本兼容说明

| 文档来源 | 对应版本 | 说明 |
|----------|---------|------|
| topics/ 大部分文件 | HarmonyOS 5.0 (API 12) | V5 官方文档离线版，当前最完整 |
| harmonyos-6-*.md | HarmonyOS 6.0 (API 20-22) | 仅含 API 变更/新增，非完整指南 |
| starter-kit/ 代码模板 | API 12+ 兼容 | 默认目标 API 12，标注了 V2 替代方案 |

> 若目标平台为 6.0+，先查 `harmonyos-6-overview.md` 确认是否有 breaking change，再参考主题文件。

## Learning Fast Path
- 语言规范学习地图: learning/language-spec-learning-map.md
- ArkTS 深入主题: topics/arkts.md
- ArkUI 深入主题: topics/arkui.md
- 建议顺序: ArkTS -> ArkUI -> Stage/Ability -> 路由生命周期 -> 状态管理

## Execution Assets
- 提审前清单（按应用类型）: checklists/pre-submission-2025.md
- 激励与审核主题: topics/incentive-review-2025.md
- 通用设计建议（功能丰富度 + 深色 + 多端）: checklists/universal-product-design-suggestions.md
- UX 体验标准（必须条款 + ArkUI 落地对照）: topics/ux-standards.md
- ArkTS 开发索引主题: topics/arkts.md
- 🚨 **全局编码约束（必读）**: topics/arkts-coding-rules.md
- ArkTS 历史报错防回归档案: topics/arkts-error-prevention.md
- ArkTS 防回归快速清单: checklists/arkts-regression-prevention.md
- ArkTS 编译现代化守卫: arkts-modernization-guard/SKILL.md

## 🚀 极速实现包（Starter Kit）
> ℹ️ 下方 `starter-kit/SKILL.md` 是**独立的子路由表**，覆盖项目初始化、目录骨架、Day-by-Day 执行顺序。与本文件是父子关系，不会重复路由。
- 主入口 + 资产路由: starter-kit/SKILL.md
- 项目目录骨架 + 配置: starter-kit/scaffold/project-structure.md
- 四层分层架构 + 规范: starter-kit/scaffold/layer-architecture.md
- 登录模块模板: starter-kit/modules/auth-login.md
- 列表页模板（刷新/加载更多）: starter-kit/modules/list-page.md
- 详情页模板（路由传参/骨架屏）: starter-kit/modules/detail-page.md
- 表单提交模板（校验/图片上传）: starter-kit/modules/form-submit.md
- 底部导航模板（TabBar/侧边栏）: starter-kit/modules/tabbar-navigation.md
- 侧边栏抽屉导航模板: starter-kit/modules/drawer-navigation.md
- 深色模式 + 多端断点适配: starter-kit/modules/dark-multi.md
- 数据持久化（Preferences/RDB/KV Store）: starter-kit/modules/data-persistence.md
- 通知处理（权限/文本/进度/交互）: starter-kit/modules/notification-handling.md
- 实时通信（WebSocket/重连/心跳）: starter-kit/modules/websocket-realtime.md
- 相机与媒体（拍照/选图/压缩）: starter-kit/modules/media-camera.md
- 应用内支付（IAP Kit 框架）: starter-kit/modules/payment-billing.md
- Day 1 骨架清单: starter-kit/pipeline/day1-scaffold-checklist.md
- Day-by-Day 执行顺序（10 天交付）: starter-kit/pipeline/execution-order.md
- 阶段任务拆分 + 验收清单: starter-kit/pipeline/task-breakdown.md
- App 类型定制清单: starter-kit/pipeline/app-type-checklist.md
- ArkTS/ArkUI 常用代码片段: starter-kit/snippets/common-patterns.md
- 全局状态管理模板: starter-kit/snippets/state-management.md
