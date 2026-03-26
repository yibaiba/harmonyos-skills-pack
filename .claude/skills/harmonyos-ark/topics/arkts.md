# ArkTS 主题

## Scope
- ArkTS 语法、类型系统、装饰器、并发与工程实践
- ArkTS 在 HarmonyOS 应用中的工程化落地、调试与发布前质量自检

## Key Concepts
- TypeScript 子集
- 类型推断
- 装饰器
- 异步与并发
- 模块化
- 错误处理
- 严格类型约束
- 资源与状态建模
- 可测试性与可维护性

## Official Entrypoints
- ArkTS 入门: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-get-started
- ArkTS 总览: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-overview
- ArkTS API 参考入口: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ability-arkts
- 应用开发导读: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-dev-guide
- 快速入门总览: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/start-overview
- Samples: https://developer.huawei.com/consumer/cn/samples/
- Codelabs: https://developer.huawei.com/consumer/cn/codelabsPortal/serviceTypes/43

## Learning Path（建议顺序）
1. 先读 ArkTS 入门与总览，明确与通用 TypeScript 的差异
2. 结合应用开发导读完成最小可运行页面
3. 对照 ArkTS API 参考补齐类型、并发、模块拆分实践
4. 通过 samples/codelabs 验证真实场景写法

## 工程实践清单
1. 类型约束
- 关键业务模型禁止使用宽泛 any，优先显式类型与联合类型
2. 模块结构
- 按业务域拆分模块，避免按页面随意堆叠公共逻辑
3. 并发与异步
- 统一异步错误处理策略，避免无捕获 Promise 链路
4. 可维护性
- 公共工具函数与业务逻辑解耦，减少跨模块循环依赖
5. 可测试性
- 核心计算逻辑可独立测试，避免全部绑定 UI 生命周期

## 审核相关建议（ArkTS 侧）
1. 功能点丰富度
- 用 ArkTS 代码结构明确体现至少 3 条完整业务链路
2. 异常兜底
- 弱网、拒权、空态需有明确处理与用户反馈
3. 多端一致性支撑
- 避免把端差异写死在业务逻辑层，优先通过配置化适配

## Quick Q&A
- ArkTS 和 TypeScript 有哪些关键差异
- 如何在 ArkTS 中组织模块与类型
- ArkTS 并发编程推荐路径是什么
- ArkTS 项目如何设计目录结构才能支撑后续多端适配
- ArkTS 如何避免“能跑但难过审”的代码组织问题

## Common Pitfalls
- 直接套用 Web TypeScript 生态导致 API 误用
- 忽略平台能力边界，跨端假设过多
- 装饰器使用场景不清晰导致可维护性下降
- 类型约束过弱，导致运行期问题在审核阶段暴露
- 只做 happy path，缺少异常流程与状态反馈

## Boundaries
- 不覆盖 C/C++ NDK 级别开发
- 不覆盖内核线程调度与系统底层机制

## Quick Prompts
- 给我一份 ArkTS 从 0 到可提审版本的开发任务顺序
- ArkTS 项目如何设计类型与模块才能支撑 PC/手机/平板三端
- 结合 2025 审核重点，ArkTS 层面需要先补哪些异常处理
