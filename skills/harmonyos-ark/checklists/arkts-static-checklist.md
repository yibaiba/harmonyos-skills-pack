# ArkTS 提交前静态检查清单

## 使用方式
- 适用于功能开发、Bug 修复、重构后的提交前自检
- 建议在 Code Review 前先执行一次，优先修复 High 问题
- 若项目暂未接入自动化检查，可用本文作为人工检查模板

## Severity 定义
- High：会导致架构失控、运行期风险或审核风险显著上升，必须修复
- Medium：会降低可维护性或放大后续改动成本，建议本次修复
- Low：暂不阻塞提交，但应列入后续清理

## 1. 命名规范检查
- [ ] High：页面、组件、ViewModel、Repository、Service 文件是否使用明确后缀
- [ ] Medium：是否存在 `common`、`util`、`temp`、`newPage2` 之类弱语义命名
- [ ] Medium：布尔字段是否以 `is`、`has`、`can` 等判断语义命名
- [ ] Low：事件处理函数是否以动作语义命名，如 `handleSubmit`、`loadProfile`

## 2. 类型使用检查
- [ ] High：业务代码中是否仍存在宽泛 `any`
- [ ] High：是否存在 `as unknown as` 这类双重断言
- [ ] High：接口响应是否直接以 `Object`、`object`、裸 Map 承载
- [ ] Medium：可空值、枚举值、联合类型是否被显式建模
- [ ] Medium：边界层断言是否被限制在 adapter / mapper 内部

## 3. 装饰器边界检查
- [ ] High：非 UI 层是否出现 `@Component`、`@State`、`@Prop` 等装饰器
- [ ] High：是否把 `@Provide` / `@Consume` 用于核心业务数据同步
- [ ] Medium：是否在默认单向数据场景误用 `@Link`
- [ ] Medium：是否将过大的对象树交给 `@Observed` / `@ObjectLink`

## 4. 异步与错误处理检查
- [ ] High：用户触发的异步流程是否都有失败状态和兜底反馈
- [ ] High：是否存在空 `catch`、吞错后继续成功分支、未捕获 Promise
- [ ] High：Repository 是否统一收敛底层异常，UI 是否避免直接解析原始异常
- [ ] Medium：是否存在页面销毁后继续回写状态的风险
- [ ] Medium：错误对象是否至少区分权限、网络、存储、参数、未知异常

## 5. 文件组织和依赖方向检查
- [ ] High：是否存在 `repositories/services -> pages/components` 的反向依赖
- [ ] High：是否存在跨业务域双向依赖或循环依赖
- [ ] Medium：页面文件是否承担了复杂转换、存储、网络细节
- [ ] Medium：公共工具是否夹带业务状态或页面上下文
- [ ] Low：相近职责是否仍混在超大文件中

## 6. 复杂度与可维护性检查
- [ ] High：单函数是否超过 50 行且未拆分
- [ ] Medium：单文件是否超过 300 行且职责混杂
- [ ] Medium：嵌套层级是否超过 3 层
- [ ] Medium：是否存在重复分支逻辑和魔法数字
- [ ] Low：是否缺少关键的空态、弱网、拒权场景注释或测试点说明

## 7. 建议输出格式
执行检查时建议输出为：

1. 风险等级（High / Medium / Low）
2. 违反项位置
3. 违反原因
4. 最小修复建议

## Quick Prompt
- 帮我按 ArkTS 提交前静态检查清单审查这个目录，按 High / Medium / Low 输出问题
- 帮我只检查 ArkTS 的命名、类型禁令、装饰器边界和依赖方向