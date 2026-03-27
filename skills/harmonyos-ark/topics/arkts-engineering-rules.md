# ArkTS 工程硬规范

## 适用范围

- 适用于使用 ArkTS + ArkUI 开发的 HarmonyOS 应用工程
- 适用于页面、ViewModel、Repository、Service、Model、Utils 等业务代码
- 本文关注工程约束，不重复解释基础语法

## 1. 命名规范

### 文件命名

- 页面文件使用 `Page` 后缀，例如 `HomePage.ets`
- 组件文件使用 `Component` 后缀，例如 `FilterPanelComponent.ets`
- ViewModel 文件使用 `ViewModel` 后缀，例如 `HomeViewModel.ets`
- 仓储文件使用 `Repository` 后缀，例如 `ProfileRepository.ets`
- 服务文件使用 `Service` 后缀，例如 `SyncService.ets`
- 数据模型文件使用语义化实体名，例如 `ToolRecord.ets`、`UserPreference.ets`
- 工具文件使用能力语义命名，例如 `DateFormatter.ets`、`PermissionGuard.ets`
- 禁止使用 `index2.ets`、`tmp.ets`、`util.ets`、`common.ets` 这类弱语义命名

### 类型与接口命名

- 类、结构体、枚举使用 PascalCase
- 方法、变量、参数使用 camelCase
- 常量使用全大写蛇形命名，例如 `MAX_RETRY_COUNT`
- 布尔变量必须表达判断语义，例如 `isLoading`、`hasPermission`、`canSubmit`
- 枚举成员使用可读业务名，禁止仅用数字语义占位
- 类型别名与接口名必须体现业务意图，禁止 `DataType`、`TempModel` 之类空泛命名

### 事件与状态命名

- 用户动作方法使用动词开头，例如 `loadRecords`、`submitForm`、`syncDraft`
- 页面状态字段用“数据 + 状态”表达，例如 `recordList`、`loadStatus`、`submitError`
- 回调函数命名必须可读，例如 `handleRetryTap`、`onPermissionDenied`

## 2. 类型使用禁令

### 明确禁止

- 禁止在业务模型、Repository 返回值、页面状态中使用宽泛 `any`
- 禁止使用双重断言绕过类型系统，例如 `foo as unknown as TargetType`
- 禁止把外部接口响应直接声明为 `Object`、`object` 或未约束 Map
- 禁止通过字符串键随意读写动态对象，除非有明确索引签名或字典类型
- 禁止为了消除报错而用类型断言掩盖空值、联合类型或错误分支

### 允许的例外

- 与平台 API、三方 SDK 边界交互时，可在边界层做一次受控断言
- 例外断言必须落在适配层或转换函数中，不能扩散到页面和核心业务逻辑

### 推荐做法

- 优先使用显式接口、类型别名、联合类型、字面量类型
- 对远端响应先定义 Raw 类型，再转换为内部 Domain 类型
- 空值场景使用 `null` / `undefined` 联合类型显式表达
- 错误状态使用可区分结构，而不是返回魔法字符串

## 3. 装饰器使用边界

### 页面与组件层

- `@Entry` 仅用于应用入口页面，禁止在普通复用组件上使用
- `@Component` 仅用于 UI 组件，禁止在工具类、Repository、Service 中使用
- `@State` 仅用于当前组件内部私有 UI 状态
- `@Prop` 仅用于父子单向传值，子组件不得反向修改传入值
- `@Link` 仅用于明确需要双向同步的场景，默认禁用，除非能说明双向数据流收益
- `@Provide` / `@Consume` 仅用于跨层级共享轻量 UI 状态，禁止承载核心业务流程或复杂数据写入
- `@Observed` / `@ObjectLink` 仅用于需要对象级联刷新的场景，禁止把整个大对象树直接挂入页面

### 分层边界

- ViewModel、Repository、Service、Model、Utils 层禁止出现任何 UI 装饰器
- 装饰器不得作为跨模块通信手段，跨模块通信应使用显式接口、参数或状态容器
- 一个页面内若同时出现 `@State`、`@Link`、`@Provide`、`@Consume`，必须重新审视状态边界，避免隐式数据流失控

## 4. 异步与错误处理约束

### 异步调用规则

- 异步业务默认使用 `async/await`，禁止在同一链路混用层层 `.then().catch()`
- 每个用户触发的异步入口必须有可见状态，例如加载中、成功、失败、空态
- 页面销毁后不得继续回写已失效状态；需要取消或忽略过期请求结果
- 禁止无返回值的悬空 Promise；不关心结果时也必须显式记录为 fire-and-forget 场景

### 错误处理规则

- Repository 层负责把平台异常、网络异常、解析异常收敛为统一错误类型
- ViewModel 层负责把错误类型映射为页面可消费的状态或提示文案
- UI 层禁止直接解析底层异常对象并拼接提示文案
- 禁止空 `catch`、禁止只打印日志不更新状态、禁止吞错后继续走成功分支
- 所有失败场景至少覆盖一种兜底：重试、降级、空态说明、权限引导、离线提示

### 最低错误模型要求

- 错误对象至少包含 `code`、`message`、`recoverable`
- 对用户可见的错误文案与内部调试信息分离
- 对权限、网络、存储、参数、未知异常至少做分类处理

## 5. 文件组织和依赖方向约束

### 推荐目录职责

- `pages/`：页面容器，负责路由、页面组合、生命周期接入
- `components/`：复用 UI 组件，只承载展示与轻交互
- `viewmodels/`：页面状态聚合、事件响应、调用编排
- `repositories/`：数据来源聚合，屏蔽网络、存储、缓存细节
- `services/`：跨页面业务服务、平台能力封装、同步任务
- `models/`：领域模型、DTO、错误模型、枚举
- `utils/`：纯函数或无业务状态通用工具

### 依赖方向

- 允许：`pages -> components/viewmodels`
- 允许：`viewmodels -> repositories/services/models`
- 允许：`repositories -> services/models/utils`
- 允许：`services -> models/utils`
- 允许：`components -> models`（仅展示型数据）
- 禁止：`repositories -> pages/components`
- 禁止：`services -> pages/components`
- 禁止：`models -> viewmodels/pages/components`
- 禁止：跨业务域双向依赖
- 禁止：通过深层相对路径跨目录偷用内部实现

### 拆分规则

- 单文件超过 300 行优先拆分职责
- 单函数超过 50 行必须抽取辅助函数
- 嵌套判断超过 3 层必须用守卫语句或状态对象压平
- 页面文件不承载复杂数据转换；数据转换放在 ViewModel 或 mapper 中

## 6. 提交前静态检查项

提交前至少完成以下检查：

1. 命名检查

- 文件名、类型名、状态字段名是否符合语义与后缀约定

1. 类型检查

- 是否仍存在宽泛 `any`、双重断言、无约束动态对象

1. 装饰器边界检查

- 非 UI 层是否错误使用装饰器
- 是否存在滥用 `@Link`、`@Provide`、`@Consume`

1. 异步链路检查

- 是否存在未捕获 Promise、空 `catch`、UI 无失败兜底

1. 分层依赖检查

- 是否存在 `pages/components` 反向被 Repository、Service 依赖
- 是否存在跨业务域循环依赖

1. 复杂度检查

- 是否存在超长函数、超长文件、重复分支、魔法数字

## 自检提示

- 帮我按 ArkTS 工程硬规范审查这个模块，重点看命名、类型、装饰器和异步错误处理
- 帮我做一次 ArkTS 提交前静态检查，输出违反项与修复建议