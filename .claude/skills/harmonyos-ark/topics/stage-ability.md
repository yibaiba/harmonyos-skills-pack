# Stage/Ability 主题

## Scope
- Stage 模型、UIAbility 生命周期、应用结构与模块边界

## Key Concepts
- Stage 模型
- UIAbility
- 应用入口
- 模块拆分
- 任务管理
- 跨 Ability 通信

## Official Entrypoints
- HarmonyOS Stage 模型开发指南
- UIAbility API 参考
- 应用模型最佳实践文档

## Quick Q&A
- Stage 模型和旧模型的核心差异是什么
- UIAbility 生命周期如何影响初始化与资源释放
- 多模块应用如何规划 Ability 边界

## Common Pitfalls
- 把页面路由逻辑混在 Ability 生命周期中
- Ability 边界不清导致跨模块耦合
- 初始化时机不当引发性能抖动

## Boundaries
- 不覆盖分布式系统底层调度机制
- 不覆盖系统服务开发与系统应用特权细节
