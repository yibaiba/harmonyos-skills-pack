# ArkTS 历史错误防回归档案（CodeWrench）

## Scope
- 记录本仓已真实出现过的 ArkTS 编译错误、运行时崩溃与高频告警
- 给出“错误现象 -> 根因模式 -> 固化修复动作 -> 防回归门禁”
- 作为 `topics/arkts.md` 的故障复盘补充，不替代官方 API 文档

## 历史错误档案（按优先级）

| 等级 | 现象/错误码 | 根因模式 | 固化修复动作 |
| --- | --- | --- | --- |
| P0 | 运行时崩溃：`Illegal variable value error with decorated variable @Prop 'onTap'` | `@Prop` 修饰函数回调（如 `@Prop onTap: () => void`） | 函数回调改为普通成员（不加 `@Prop`），调用方继续传函数 |
| P0 | `10605999`：`void & Promise<Preferences>`、`Property 'get/put/flush' does not exist` | 直接 `await preferences.getPreferences(...)` + `hostContext` 可空 | 统一封装 `getPrefsStore()`：先判空 `hostContext`，再 `.then(...)` 获取 `Preferences`，并在调用前判空 |
| P0 | `10905210`：`@Entry` 组件 `build` 仅允许一个容器根节点 | DSL 解析错位或 `build` 结构被局部声明干扰 | `build()` 内只保留 UI DSL；辅助变量/逻辑抽到私有方法 |
| P1 | `10505001`：属性冲突/类型不匹配（如 `size`、`onClick`、`ResourceStr -> Resource`） | 组件字段与链式 API 冲突，或资源参数类型不匹配 | `size -> ringSize`、`onClick -> onTap`，`SymbolGlyph` 参数使用 `Resource` |
| P1 | `10605034` | 泛型推断受限（`Array.from({length...})`） | 改显式 `number[]` 构造，再 `ForEach` |
| P1 | `10605038` / `10605040` | 未命名对象类型或对象字面量直接作为类型 | 抽离 `interface/type`，避免内联对象类型声明 |
| P1 | `10605099` | spread 刷新状态（`{ ...state }`、`[...arr]`） | 改显式字段复制或 `slice()/concat()` |
| P2 | `10905332` / `10903329` | 动态 `$r(...)`、不兼容 `sys.symbol.*` 名称 | 静态资源字面量；不兼容符号改为已验证可用名 |
| P2 | deprecated 告警漂移：`animateTo`、`replaceUrl`、`getContext`、`AlertDialog.show`、`pushUrl`、`showDialog`、`showToast` | SDK 升级导致旧 API 逐步废弃 | 每次升级后先跑 guard 扫描，再按当前 SDK 推荐 API 迁移 |

## 固化防回归流程（必做）

1. 改动前扫描：
```bash
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

2. 改动后扫描（必须 `passed`）：
```bash
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh
```

3. 编译验收（DevEco Studio 或 CLI）：
```bash
hvigor :entry:default@CompileArkTS
```

4. 最小运行时回归（至少）：
- 进入首页，确认 `SafetyBanner` 可渲染且点击不崩溃
- 进入设置页，确认 `SettingNavigate` 点击不崩溃
- 走一遍 `CodesTab/LearningTab/SettingsTab` 的 Preferences 读写路径

## 快速诊断矩阵

- 日志含 `Illegal variable value ... @Prop ... function`
- 先查：是否把函数回调写成 `@Prop`
- 处理：去掉 `@Prop`，保留默认空函数

- 日志含 `void & Promise<Preferences>`
- 先查：是否 `await preferences.getPreferences(...)`
- 处理：替换为 `getPrefsStore()` 封装模式

- 日志含 `In an '@Entry' decorated component, the 'build' method can have only one root node`
- 先查：`build()` 内是否混入局部变量声明/非 DSL 语句
- 处理：抽出辅助方法，保持单容器根节点

## 关联资产
- 守卫入口：`../../arkts-modernization-guard/SKILL.md`
- 错误映射：`../../arkts-modernization-guard/references/error-to-fix-map.md`
- 扫描脚本：`../../arkts-modernization-guard/scripts/scan-arkts-modernization.sh`
- 替换模板：`../../arkts-modernization-guard/snippets/replacement-patterns.md`
