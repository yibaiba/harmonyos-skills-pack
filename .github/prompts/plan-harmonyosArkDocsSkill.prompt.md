## Plan: 鸿蒙 Ark 文档技能化（方案 2：总 skill + 主题子文档）

目标是先建立 1 个“总 skill”作为统一入口，再用多份主题子文档承载细分知识。总 skill 只负责路由、边界与引用规则；具体内容全部下沉到主题子文档，降低维护成本并便于后续增量扩展。

**Architecture**
1. 总 skill：定义触发场景、回答边界、来源优先级、主题路由策略。
2. 主题子文档：每个主题独立维护“核心概念 + 官方入口 + 常见问法 + 不回答范围”。
3. 公共来源清单：维护稳定官方入口，不在主题文档中重复写来源规则。
4. 总 skill 只引用主题子文档和来源清单，不复制内容。

**Steps**
1. Phase 1 - 资料收敛：固定主来源为华为开发者联盟 HarmonyOS 文档中心，补充来源为 OpenHarmony 官方文档、官方 samples/codelabs、AppGallery Connect 发布文档。
2. Phase 1 - 主题建模：拆分 9 个主题：ArkTS、ArkUI、Stage/Ability、路由与生命周期、状态管理、网络与数据、媒体与设备能力、测试与发布、2025 创作激励与审核避坑。
3. Phase 1 - 来源优先级：定义统一规则：华为 HarmonyOS 文档优先，OpenHarmony 作为概念补充，社区资料默认不作为主依据。
4. Phase 2 - 总 skill 设计：在总 skill 中定义 Topic Routing 表，把用户问题映射到对应主题子文档。
5. Phase 2 - 主题模板设计：统一子文档模板，固定章节为 Scope、Key Concepts、Official Entrypoints、Quick Q&A、Boundaries。
6. Phase 3 - 目录规划：落地一个“总入口 + 主题子文档 + 来源清单”结构，确保可直接被后续实现使用。
7. Phase 3 - 质量校验：检查每个主题至少绑定 1 个稳定官方入口，且边界描述不与总 skill 冲突。
8. Phase 4 - 路由演练：用 8-10 个代表问题测试总 skill 是否能正确分流到目标主题子文档。

**Relevant files (proposed)**
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/SKILL.md — 总 skill，负责路由与统一规则
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/sources.md — 官方来源清单与优先级
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/arkts.md — ArkTS 主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/arkui.md — ArkUI 主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/stage-ability.md — Stage/Ability 主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/routing-lifecycle.md — 路由与生命周期主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/state-management.md — 状态管理主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/network-data.md — 网络与数据主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/media-device.md — 媒体与设备能力主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/testing-release.md — 测试与发布主题子文档
- /Users/yibai/Code/pythonProjects/hongmeng/skills/harmonyos-ark/topics/incentive-review-2025.md — 2025 创作激励与审核避坑主题子文档

**Verification**
1. 总 skill 是否只做路由，不承载重复主题细节。
2. 每个主题子文档是否都包含统一模板章节。
3. 每个主题是否至少有 1 个可长期稳定访问的官方入口。
4. 路由演练时，问题是否能落到唯一主题，不出现歧义分流。
5. 边界是否清晰：默认不覆盖内核、驱动、系统裁剪等底层方向。

**Decisions**
- 采用“总 skill + 主题子文档”，不做双入口并行，先保证一套结构跑通。
- 新增“2025 创作激励与审核避坑”主题，专门降低上架卡审风险。
- 主范围为纯血鸿蒙 Ark 应用开发链路。
- 维护策略为“先改子文档，再校验总 skill 路由表”。

**Further Considerations**
1. 后续若需要兼容多平台入口（Copilot/Agents），可在不改主题文档的前提下新增入口层。
2. 若需要版本化（如 HarmonyOS 5.x/6.x），建议在 sources.md 加版本分区而非复制一套 topics。

## 分节展示设计（V1）

### Section A - 总 skill 骨架（SKILL.md）
1. 目标：作为单一入口，将问题分发到对应主题子文档。
2. 输入：用户的自然语言问题（如“ArkUI 状态怎么更新”“Stage 模型页面跳转”）。
3. 输出：
	- 先给简短结论。
	- 再引用对应主题子文档里的官方入口与建议路径。
	- 最后说明边界（不覆盖内核/驱动类问题）。
4. 必备章节：
	- When to Use
	- Scope
	- Source Priority
	- Topic Routing Table
	- Answer Pattern
	- Boundaries

### Section B - 主题子文档统一模板（topics/*.md）
每个主题子文档使用同一模板，避免风格漂移：
1. Scope：本主题解决什么问题。
2. Key Concepts：5-8 个核心概念词。
3. Official Entrypoints：官方入口（栏目级链接优先）。
4. Quick Q&A：3-5 个典型问法和推荐检索路径。
5. Common Pitfalls：常见误区与纠正建议。
6. Boundaries：不在本主题覆盖范围内的内容。

### Section C - Topic Routing Table（总 skill 内）
| 用户问题关键词 | 路由主题 | 子文档 |
| --- | --- | --- |
| ArkTS、类型、装饰器、并发 | ArkTS | topics/arkts.md |
| 组件、布局、声明式 UI、@State | ArkUI | topics/arkui.md |
| Ability、UIAbility、Stage 模型 | Stage/Ability | topics/stage-ability.md |
| 页面跳转、路由、生命周期 | 路由与生命周期 | topics/routing-lifecycle.md |
| 单向数据流、状态共享、数据绑定 | 状态管理 | topics/state-management.md |
| HTTP、网络请求、本地存储、数据库 | 网络与数据 | topics/network-data.md |
| 相机、相册、文件、媒体播放 | 媒体与设备能力 | topics/media-device.md |
| 测试、签名、打包、发布上架 | 测试与发布 | topics/testing-release.md |
| 创作激励、审核、资质、卡审、合规 | 2025 创作激励与审核避坑 | topics/incentive-review-2025.md |

### Section D - Answer Pattern（回答模式）
1. 结论：1-2 句回答问题。
2. 路由：说明问题所属主题。
3. 官方路径：给出文档入口优先级（华为 > OpenHarmony 补充）。
4. 动作建议：给出下一步可执行动作（如先看哪个章节，再做哪个示例）。

### Section E - 边界约束
1. 默认不回答内核、驱动、系统裁剪、板级 bring-up。
2. 当问题跨多个主题时，以“主主题 + 次主题”方式回答，避免重复。
3. 无法确认版本时，默认按最新稳定 HarmonyOS 文档回答，并提示版本差异风险。

## 实现级任务清单（下一阶段）

1. 创建目录结构：
	- skills/harmonyos-ark/
	- skills/harmonyos-ark/topics/
2. 创建总 skill：
	- skills/harmonyos-ark/SKILL.md
	- 写入 When to Use、Scope、Source Priority、Topic Routing Table、Answer Pattern、Boundaries。
3. 创建来源清单：
	- skills/harmonyos-ark/sources.md
	- 写入主来源与补充来源、版本说明、引用优先级。
4. 创建 9 个主题子文档：
	- arkts.md
	- arkui.md
	- stage-ability.md
	- routing-lifecycle.md
	- state-management.md
	- network-data.md
	- media-device.md
	- testing-release.md
	- incentive-review-2025.md
5. 每个主题子文档按统一模板填充：
	- Scope
	- Key Concepts
	- Official Entrypoints
	- Quick Q&A
	- Common Pitfalls
	- Boundaries
6. 自检验收：
	- 每个主题至少 1 个稳定官方入口。
	- 总 skill 路由到 9 个主题无遗漏。
	- 抽样 8 个问题进行分流验证。
