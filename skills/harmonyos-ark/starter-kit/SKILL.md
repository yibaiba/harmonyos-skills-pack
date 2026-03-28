---
name: harmonyos-ark-starter-kit
description: 鸿蒙极速实现包。给定任何项目需求，输出可直接落地的目录结构、分层架构、代码模板、执行顺序与验收清单。
---

# HarmonyOS Ark 极速实现包（Starter Kit）

## When to Use
- 新建鸿蒙项目，需要快速搭建工程骨架
- 实现特定功能模块（登录 / 列表 / 详情 / 表单提交）
- 需要适配深色模式 + PC / 手机 / 平板多端
- 需要一份"先做什么、后做什么"的执行顺序

## One-Shot Use（直接复制执行）

```
1. 读 scaffold/project-structure.md   → 创建项目目录骨架
2. 读 scaffold/layer-architecture.md  → 理解四层分层，套用命名规范
3. 按需选择 modules/ 下的功能模块      → 复制代码模板，填入业务逻辑
4. 读 modules/dark-multi.md           → 补齐深色模式与多端断点
5. 读 pipeline/execution-order.md     → 确认执行顺序，Day-by-Day 推进
6. 用 pipeline/task-breakdown.md      → 每个阶段自测验收
7. 用 snippets/common-patterns.md     → 随时查阅常用 ArkTS/ArkUI 代码片段
```

## Asset Routing Table

| 需求                   | 对应文件                                    |
|-----------------------|---------------------------------------------|
| 工程目录 / 分包         | scaffold/project-structure.md               |
| 架构分层 / 命名         | scaffold/layer-architecture.md              |
| Day 1 骨架清单          | pipeline/day1-scaffold-checklist.md         |
| 登录 / 账号认证         | modules/auth-login.md                       |
| 单机离线 / 免登录       | modules/offline-no-login.md                 |
| 免登录升级账号同步       | modules/optional-login-upgrade.md           |
| 列表页 / 瀑布流         | modules/list-page.md                        |
| 详情页 / 导航跳转       | modules/detail-page.md                      |
| 表单 / 提交流程         | modules/form-submit.md                      |
| TabBar 底部/侧边导航    | modules/tabbar-navigation.md                |
| 深色 + 多端适配         | modules/dark-multi.md                       |
| 数据持久化              | modules/data-persistence.md                 |
| 通知推送 / 角标         | modules/notification-handling.md            |
| WebSocket 实时通信       | modules/websocket-realtime.md               |
| 拍照 / 选图 / 压缩      | modules/media-camera.md                     |
| 应用内支付 (IAP)        | modules/payment-billing.md                  |
| 全局状态管理            | snippets/state-management.md                |
| 执行顺序 / 天计划       | pipeline/execution-order.md                 |
| 任务拆分 / 阶段验收     | pipeline/task-breakdown.md                  |
| App 类型定制清单        | pipeline/app-type-checklist.md              |
| ArkTS/ArkUI 代码片段   | snippets/common-patterns.md                 |

## Quick Prompts
- 帮我生成这个项目的目录结构和分层架构
- 给我一个带登录跳转的完整 UIAbility 入口模板
- 给我一个单机离线、无需登录的启动与路由模板
- 给我一个游客模式升级登录并迁移本地数据的方案
- 列表页 + 下拉刷新 + 上拉加载代码模板
- 表单提交 + 加载状态 + 错误提示模板
- 深色模式 + 手机/平板/PC 响应式布局适配清单
- 今天是 Day 1，告诉我要做什么
