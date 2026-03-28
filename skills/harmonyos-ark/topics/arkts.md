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

## 工程硬规范

### 1. 命名规范

**文件命名：**
- 页面 `*Page.ets`、组件 `*Component.ets`、ViewModel `*ViewModel.ets`
- Repository `*Repository.ets`、Service `*Service.ets`
- 数据模型用语义实体名（`ToolRecord.ets`），工具用能力语义（`DateFormatter.ets`）
- 禁止 `index2.ets`、`tmp.ets`、`util.ets`、`common.ets` 等弱语义命名

**标识符命名：**
- 类/结构体/枚举：PascalCase；方法/变量/参数：camelCase；常量：`MAX_RETRY_COUNT`
- 布尔变量必须表达判断语义：`isLoading`、`hasPermission`、`canSubmit`
- 事件方法动词开头：`loadRecords`、`submitForm`、`handleRetryTap`

### 2. 类型使用禁令

**禁止：**
- 业务模型、Repository 返回值、页面状态中使用宽泛 `any`
- `as unknown as TargetType` 双重断言
- 外部响应直接声明为 `Object`/`object` 或裸 Map
- 用类型断言掩盖空值或错误分支

**推荐：**
- 显式接口、联合类型、字面量类型
- 远端响应先定义 Raw 类型，再转换为 Domain 类型
- 空值用 `null`/`undefined` 联合显式表达
- 平台 API 边界层可做受控断言，不扩散到业务层

### 3. 装饰器使用边界

- `@Entry` 仅用于入口页面；`@Component` 仅用于 UI 组件
- `@State` 限当前组件私有状态；`@Prop` 限单向传值，子组件不得反向修改
- `@Link` 默认禁用，除非能说明双向同步收益
- `@Provide`/`@Consume` 仅跨层级轻量 UI 状态，禁止承载核心业务
- ViewModel/Repository/Service/Model/Utils 层禁止出现任何 UI 装饰器

### 4. 异步与错误处理

- 异步默认 `async/await`，禁止同一链路混用 `.then().catch()`
- 每个异步入口必须有可见状态（加载/成功/失败/空态）
- 页面销毁后不得回写失效状态
- Repository 收敛底层异常为统一错误类型；ViewModel 映射为页面状态；UI 禁止直接解析原始异常
- 禁止空 `catch`、吞错走成功分支、未捕获 Promise
- 错误对象至少含 `code`/`message`/`recoverable`，至少区分权限/网络/存储/参数/未知

### 5. 文件组织与依赖方向

```
pages/ → components/, viewmodels/
viewmodels/ → repositories/, services/, models/
repositories/ → services/, models/, utils/
services/ → models/, utils/
components/ → models/（仅展示型）
```

- 禁止反向依赖（repositories/services → pages/components）
- 禁止跨业务域双向依赖
- 单文件 ≤ 300 行，单函数 ≤ 50 行，嵌套 ≤ 3 层，位置参数 ≤ 3

### 6. 提交前静态检查

**高风险快速扫描（每次提交前执行）：**
```bash
rg -n "\bany\b|as unknown as|@Provide|@Consume|\.then\(|catch\s*\(\s*\)\s*=>\s*\{\s*\}" src
```

**分项扫描命令：**
```bash
# 弱语义文件名
find entry/src -name "*.ets" | rg -i "index\d|tmp|util\.ets|common\.ets"
# 类型禁令
rg -n "\bany\b|as unknown as|\bObject\b" --glob '*.ets' entry/src
# 装饰器越界（非 UI 目录出现 UI 装饰器）
rg -n "@Component|@State|@Prop|@Link" entry/src/main/ets/{viewmodels,repositories,services,models,utils}
# 异步风险
rg -n "\.then\(|catch\s*\(\s*\)\s*=>" --glob '*.ets' entry/src
# 超长文件
find entry/src -name "*.ets" -exec awk 'END{if(NR>300)print FILENAME": "NR" lines"}' {} \;
```

**检查清单（High 必修 / Medium 建议 / Low 后续清理）：**

| 等级 | 检查项 |
|------|--------|
| High | 业务代码中是否存在宽泛 `any`、双重断言 |
| High | 非 UI 层是否出现 `@Component`/`@State`/`@Prop` |
| High | 是否存在空 `catch`、未捕获 Promise、UI 无失败兜底 |
| High | 是否存在反向依赖或循环依赖 |
| High | 单函数 > 50 行未拆分 |
| Medium | `@Link`/`@Provide`/`@Consume` 是否有滥用 |
| Medium | 文件 > 300 行且职责混杂 |
| Medium | 嵌套 > 3 层、魔法数字 |
| Low | 弱语义命名、缺少空态/弱网注释 |

## 编译现代化入口
- 当出现 ArkTS 编译错误（如 `10605xxx` / `10505001` / `10903xxx`）或 deprecated 告警时，优先使用：
- `../arkts-modernization-guard/SKILL.md`
- 典型场景：`animateTo`/`replaceUrl`/`getContext`/`AlertDialog.show`、动态 `$r(...)`、spread 刷新、符号资源名兼容问题
- 配套资产：
- `../arkts-modernization-guard/scripts/scan-arkts-modernization.sh`
- `../arkts-modernization-guard/references/error-to-fix-map.md`
- `../arkts-modernization-guard/snippets/replacement-patterns.md`

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
bash .codex/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

2. 改完后再跑 guard + CompileArkTS：
```bash
bash .codex/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
hvigor :entry:default@CompileArkTS
```

3. 如含 UI 交互改动，补最小运行时冒烟：
- SafetyBanner 点击
- SettingNavigate 点击
- Preferences 读写路径（Codes/Learning/Settings）

## 审核相关建议（ArkTS 侧）
1. 功能点丰富度
- 用 ArkTS 代码结构明确体现至少 3 条完整业务链路
2. 异常兜底
- 弱网、拒权、空态需有明确处理与用户反馈
3. 多端一致性支撑
- 避免把端差异写死在业务逻辑层，优先通过配置化适配
4. 滑动边界回弹动效
- 所有可滑动组件（`List`、`Scroll`、`Grid`、`WaterFlow` 等）必须设置 `.edgeEffect(EdgeEffect.Spring)`
- 自检提示：「页面的可滑动控件上滑到顶部或下滑到底部时缺少回弹动效」
- 左右滑动场景（如横向 `Scroll`、`Swiper` 边界）同理，需有边界反馈
- 不加此属性会导致自检/审核直接不通过

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
- 可滑动组件未设置 `edgeEffect(EdgeEffect.Spring)`，导致自检报"缺少回弹动效"

## Boundaries
- 不覆盖 C/C++ NDK 级别开发
- 不覆盖内核线程调度与系统底层机制

## Quick Prompts
- 给我一份 ArkTS 从 0 到可提审版本的开发任务顺序
- ArkTS 项目如何设计类型与模块才能支撑 PC/手机/平板三端
- 结合 2025 审核重点，ArkTS 层面需要先补哪些异常处理


---

## See Also

- [ArkTS 历史错误防回归档案](arkts-error-prevention.md)
- [ArkTS 跨语言交互](arkts-cross-lang.md)
- [状态管理](state-management.md)
