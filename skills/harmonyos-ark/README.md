# HarmonyOS Ark Docs Skill

## 模块目标
提供一个可复用的“纯血鸿蒙 Ark 文档路由技能”，通过总入口将问题分发到 9 个主题子文档，统一官方来源优先级并减少重复维护。
新增“2025 创作激励与审核避坑”主题，用于按规则设计应用，降低卡审风险。

## 标准入口位置
- Claude 标准 skills 入口: `.claude/skills/harmonyos-ark/SKILL.md`
- GitHub/Copilot 标准 skills 入口: `.github/skills/harmonyos-ark/SKILL.md`
- 当前目录 `skills/harmonyos-ark/` 是内容源目录，负责维护实际主题文档、模板与清单

## 目录结构

### 入口与元数据
- SKILL.md: 总 skill 入口，负责路由与回答模式
- DESIGN.md: 设计决策、验收标准与基线
- sources.md: 官方来源清单与优先级规则

### 主题文档 (topics/)

#### ArkTS 核心
- topics/arkts.md: ArkTS 深入主题（类型系统/装饰器/工程硬规范/审核建议）
- topics/arkts-error-prevention.md: ArkTS 历史报错防回归档案（P0-P2 分级）

#### ArkTS 官方开发指南（27 篇离线参考）
- topics/arkts-guide-specs.md: 索引文件
- topics/arkts-lang-basics.md: 语言基础（简介/入门/TS迁移/编程规范）
- topics/arkts-stdlib.md: 基础类库（Buffer/XML/JSON）
- topics/arkts-concurrency.md: 并发编程（Promise/TaskPool/Worker/线程通信）
- topics/arkts-cross-lang.md: 跨语言交互（Node-API）
- topics/arkts-runtime.md: 运行时（模块化/FAQ）
- topics/arkts-toolchain.md: 编译工具链（ArkGuard/字节码）

#### ArkUI 核心
- topics/arkui.md: ArkUI 深入主题（声明式 UI/组件/布局/状态装饰器）

#### ArkUI 官方开发指南（37 篇离线参考）
- topics/arkui-guide-specs.md: 索引文件
- topics/arkui-core.md: 核心（简介/语法/状态管理/渲染控制/术语）
- topics/arkui-components.md: 组件（导航路由/布局/列表/文本/弹窗）
- topics/arkui-interaction.md: 交互与动画
- topics/arkui-advanced.md: 高级（自定义/国际化/无障碍/主题/性能）
- topics/ui-design-kit.md: UI Design Kit（HDS 组件套件/图标/导航/视效/多窗，13 篇）

#### 控件设计规范（41 个组件离线参考）
- topics/component-design-specs.md: 索引文件
- topics/component-navigation.md: 导航类（4 个）
- topics/component-display.md: 展示类（15 个）
- topics/component-action.md: 操作类（8 个）
- topics/component-input.md: 输入类（4 个）
- topics/component-selection.md: 选择类（7 个）
- topics/component-container.md: 容器类（3 个）

#### 应用模型与系统能力
- topics/stage-ability.md: Stage 模型、UIAbility 生命周期
- topics/routing-lifecycle.md: 页面路由、页面切换、生命周期
- topics/state-management.md: 全局状态、数据绑定、状态共享
- topics/network-data.md: 网络请求、持久化、数据库
- topics/media-device.md: 相机、文件、媒体播放、权限
- topics/notification-kit.md: 通知服务（授权/角标/渠道/文本通知/进度条/行为意图）
- topics/background-tasks-kit.md: 后台任务（短时/长时/延迟任务 WorkScheduler）
- topics/location-kit.md: 位置服务（定位/地理编码/地理围栏）
- topics/accessibility.md: 无障碍服务（屏幕朗读适配）
- topics/testing-release.md: 测试、签名、打包、上架发布

#### HarmonyOS 6.0 版本（API 20-22）
- topics/harmonyos-6-overview.md: 6.0.0/6.0.1/6.0.2 版本概览与新增特性
- topics/harmonyos-6-api-core.md: 核心框架 API 变更（Ability Kit/ArkTS/ArkData）
- topics/harmonyos-6-api-arkui.md: ArkUI API 变更（6.0.2, API 22）
- topics/harmonyos-6-api-arkui-v600.md: ArkUI API 变更（6.0.0, API 20）
- topics/harmonyos-6-api-services.md: 服务类 Kit API 变更（Network/Camera/Media/Image/Test/UI Design）

#### UX 与审核
- topics/ux-standards.md: UX 体验标准（必须条款 + ArkUI 落地对照 + Symbol 图标）
- topics/incentive-review-2025.md: 创作激励、审核规则、上架卡审、合规材料

### 学习地图
- learning/language-spec-learning-map.md: 语言规范学习地图（空项目快速上手）

### 检查清单 (checklists/)
- checklists/pre-submission-2025.md: 按应用类型的提审前检查清单
- checklists/arkts-regression-prevention.md: ArkTS 防回归快速清单
- checklists/universal-product-design-suggestions.md: 通用设计建议（功能丰富度 + 深色 + 多端）

### 极速实现包 (starter-kit/)
- starter-kit/SKILL.md: 主入口 + 资产路由
- starter-kit/scaffold/: 项目骨架（目录结构 + 四层架构）
- starter-kit/modules/: 模块模板（登录/列表/详情/表单/TabBar/深色适配等）
- starter-kit/pipeline/: 执行流水线（Day1 清单/10 天排期/任务拆分/App 类型清单）
- starter-kit/snippets/: 代码片段（常用模式 + 状态管理）

## 使用方式
1. 先阅读 SKILL.md 的路由规则
2. 根据问题关键词进入对应 topics 文档
3. 按 sources.md 的优先级引用官方入口
4. 提审前按 checklists/pre-submission-2025.md 执行快检
5. ArkTS 工程规范与静态检查命令已融合到 topics/arkts.md「工程硬规范」章节

## 维护约定
1. 新增主题时，先新增 topics 子文档，再更新 SKILL.md 的路由表
2. 修改来源规则时，仅更新 sources.md
3. 回答边界变更需同步 SKILL.md 与相关主题文档
4. 激励政策口径变更时，优先更新 incentive-review-2025.md 与 sources.md
5. ArkTS 工程规则、静态检查变更时，更新 topics/arkts.md 的「工程硬规范」章节
