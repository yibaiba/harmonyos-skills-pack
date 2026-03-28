# 语言规范学习地图（空项目可直接用）

## 学习目标
- 快速建立 HarmonyOS Ark 应用开发的语言与框架认知
- 用最短路径从"会查文档"到"能写基础应用"
- 建立系统化知识框架，避免碎片化学习

## Phase 1: ArkTS 语言基础（Day 1-3）

### 1.1 ArkTS 入门与类型系统
- 入口: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-get-started
- 离线参考: topics/arkts-lang-basics.md
- 目标: 理解 ArkTS 与标准 TypeScript 的关键差异
- 重点关注:
  - 禁止 any、unknown 类型
  - 强制类型注解（函数参数、返回值）
  - 装饰器语法（@Entry、@Component、@State）
  - 模块导入方式

### 1.2 编程规范与工程约束
- 离线参考: topics/arkts.md 工程硬规范章节
- 目标: 了解编译器红线（哪些写法会直接报错）
- 重点关注:
  - 命名规范（文件、类、变量）
  - 类型使用禁令
  - build() 约束
  - 资源引用规范

### 1.3 并发与异步
- 离线参考: topics/arkts-concurrency.md
- 目标: 理解 Promise、async/await、TaskPool、Worker
- 重点关注:
  - async 函数必须标注返回类型
  - .then() 闭包内的类型收窄陷阱
  - TaskPool vs Worker 的选型场景

## Phase 2: ArkUI 声明式 UI（Day 4-7）

### 2.1 组件基础
- 入口: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkui-overview
- 离线参考: topics/arkui-core.md
- 目标: 理解声明式 UI 范式与组件生命周期
- 重点关注:
  - @Component 结构体 + build() 方法
  - 组件生命周期（aboutToAppear / build / aboutToDisappear）
  - @Builder 与 @Styles 复用机制

### 2.2 状态管理
- 离线参考: topics/state-management.md
- 目标: 掌握 V1/V2 状态管理装饰器选型
- 重点关注:
  - @State / @Prop / @Link / @Provide / @Consume 选择矩阵
  - AppStorage 全局状态
  - 禁止模式（@Prop 传函数、spread 刷新）

### 2.3 布局与列表
- 离线参考: topics/arkui.md 布局选型指南章节
- 目标: 掌握布局组件选型和列表性能优化
- 重点关注:
  - Column/Row/Flex/Grid/List/Stack 选型
  - LazyForEach + keyGenerator 正确用法
  - 响应式断点布局（GridRow/GridCol）

## Phase 3: 应用模型与导航（Day 8-10）

### 3.1 Stage 模型与 UIAbility
- 入口: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/abilitykit-overview
- 离线参考: topics/stage-ability.md
- 目标: 理解应用结构、生命周期与页面组织
- 重点关注:
  - UIAbility 生命周期（Create / Foreground / Background / Destroy）
  - WindowStage 与页面加载
  - Context 获取与使用

### 3.2 页面路由
- 离线参考: topics/routing-lifecycle.md
- 目标: 掌握 Navigation 组件导航（推荐方案）
- 重点关注:
  - Navigation + NavPathStack 模式
  - 路由传参与返回值
  - 页面转场动画
  - 禁止使用 @ohos.router（已废弃，迁移到 Navigation）

### 3.3 网络与数据持久化
- 离线参考: topics/network-data.md
- 目标: 掌握 HTTP 请求、本地存储
- 重点关注:
  - HTTP 数据请求基本用法
  - 用户首选项（轻量 KV 存储）
  - 关系型数据库（RDB）基本操作

## Phase 4: 工程化与发布（Day 11-14）

### 4.1 测试与调试
- 离线参考: topics/testing-release.md
- 目标: 了解编译、签名、调试、测试流程

### 4.2 深色模式与多端适配
- 离线参考: topics/arkui.md 深色模式规范 / 多端适配规范章节
- 目标: 掌握系统 token 适配 + 断点布局

### 4.3 提审准备
- 离线参考: checklists/pre-submission-2025.md
- 离线参考: topics/incentive-review-2025.md
- 目标: 了解提审材料、审核规则、常见卡审点

## 每天 30 分钟学习法
1. 10 分钟读官方概念（或离线参考对应章节）
2. 10 分钟抄写最小示例并运行
3. 10 分钟改动示例验证理解

## 学习完成标志
1. 能解释 ArkTS 与通用 TypeScript 的关键差异（至少 5 点）
2. 能写出有状态页面并完成 Navigation 页面跳转
3. 能用 LazyForEach 渲染 100+ 项列表无卡顿
4. 能定位并阅读目标 API 的官方参考页
5. 能独立完成一个完整功能链路（从入口到结果反馈）

## 进阶方向（按需深入）
- 组件设计规范: topics/component-design-specs.md（索引 41 个组件）
- ArkTS 跨语言交互: topics/arkts-cross-lang.md（Node-API）
- HarmonyOS 6.0 新特性: topics/harmonyos-6-overview.md
- 创作激励与审核避坑: topics/incentive-review-2025.md
- 极速实现包（10 天交付模板）: starter-kit/SKILL.md
