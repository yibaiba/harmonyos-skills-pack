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

- ArkTS 入门：[官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-get-started)
- ArkTS 总览：[官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-overview)
- ArkTS API 参考入口：[官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ability-arkts)
- 应用开发导读：[官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-dev-guide)
- 快速入门总览：[官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/start-overview)
- Samples：[官方示例](https://developer.huawei.com/consumer/cn/samples/)
- Codelabs：[官方练习](https://developer.huawei.com/consumer/cn/codelabsPortal/serviceTypes/43)

## Learning Path（建议顺序）

1. 先读 ArkTS 入门与总览，明确与通用 TypeScript 的差异
1. 结合应用开发导读完成最小可运行页面
1. 对照 ArkTS API 参考补齐类型、并发、模块拆分实践
1. 通过 samples/codelabs 验证真实场景写法

## 深入规则入口

- 工程硬规范：topics/arkts-engineering-rules.md
- 提交前静态检查清单：checklists/arkts-static-checklist.md

## 编译现代化入口

- 当出现 ArkTS 编译错误（如 `10605xxx` / `10505001` / `10903xxx`）或 deprecated 告警时，优先使用：
- `../../arkts-modernization-guard/SKILL.md`
- 典型场景：`animateTo`/`replaceUrl`/`getContext`/`AlertDialog.show`、动态 `$r(...)`、spread 刷新、符号资源名兼容问题
- 配套资产：
- `../../arkts-modernization-guard/scripts/scan-arkts-modernization.sh`
- `../../arkts-modernization-guard/references/error-to-fix-map.md`
- `../../arkts-modernization-guard/snippets/replacement-patterns.md`

## 历史错误防回归入口（CodeWrench）

- 当出现“曾修复后再次复发”的问题时，优先查看：
- `./arkts-error-prevention.md`
- 快速检查用：
- `../checklists/arkts-regression-prevention.md`
- 当前已收录场景：
- `@Prop` 函数回调导致运行时崩溃
- `void & Promise<Preferences>` 类型交叉
- `@Entry build` 根节点约束/DSL 解析错位

## 默认执行门禁（写代码时）

只要改动 `entry/src/main/ets/**`，就按以下顺序执行：
第 1 步未通过时，禁止继续写代码。

1. 写前先跑 guard 扫描：

```bash
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

1. 改完后再跑 guard + CompileArkTS：

```bash
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
hvigor :entry:default@CompileArkTS
```

1. 如含 UI 交互改动，补最小运行时冒烟：

- SafetyBanner 点击
- SettingNavigate 点击
- Preferences 读写路径（Codes/Learning/Settings）

## 工程实践清单

1. 类型约束

    - 关键业务模型禁止使用宽泛 any，优先显式类型与联合类型

1. 模块结构

    - 按业务域拆分模块，避免按页面随意堆叠公共逻辑

1. 并发与异步

    - 统一异步错误处理策略，避免无捕获 Promise 链路

1. 可维护性

    - 公共工具函数与业务逻辑解耦，减少跨模块循环依赖

1. 可测试性

    - 核心计算逻辑可独立测试，避免全部绑定 UI 生命周期

## 审核相关建议（ArkTS 侧）

1. 功能点丰富度

    - 用 ArkTS 代码结构明确体现至少 3 条完整业务链路

1. 异常兜底

    - 弱网、拒权、空态需有明确处理与用户反馈

1. 多端一致性支撑

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
