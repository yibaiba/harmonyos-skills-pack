# ArkTS 静态检查命令模板

## 目标

- 为“命名规范、类型禁令、装饰器边界、异步错误处理、依赖方向”提供可执行检查入口
- 在未接入完整 lint 体系时，先用轻量命令快速发现高风险问题

## 使用建议

1. 先跑“高风险快速扫描”
1. 再跑“分项扫描”并按 High / Medium / Low 归档
1. 最后结合 `checklists/arkts-static-checklist.md` 完成人工复核

## 高风险快速扫描（建议每次提交前执行）

```bash
rg -n "\bany\b|as unknown as|@Provide|@Consume|\.then\(|catch\s*\(\s*\)\s*=>\s*\{\s*\}" src
```

说明：

- `any`、`as unknown as`：类型禁令高风险
- `@Provide`、`@Consume`：装饰器边界滥用风险
- `.then(`：异步链路风格不统一风险
- 空 `catch`：吞错风险

## 分项扫描命令

### 1) 命名规范（弱语义文件名）

```bash
rg --files src | rg -n "(common|util|utils|temp|tmp|new|demo|test2|index2)\.ets$"
```

### 2) 类型禁令（宽泛 any / 双重断言）

```bash
rg -n "\bany\b|as unknown as|\bObject\b|\bobject\b" src
```

### 3) 装饰器边界（非 UI 层禁止 UI 装饰器）

```bash
rg -n "@(Component|State|Prop|Link|Provide|Consume|Observed|ObjectLink|Entry)" src/viewmodels src/repositories src/services src/models src/utils
```

### 4) 异步与错误处理（空 catch / 混用 then）

```bash
rg -n "catch\s*\(\s*\)\s*=>\s*\{\s*\}|\.then\(" src
```

### 5) 依赖方向（禁止下层依赖 UI 层）

```bash
rg -n "from ['\"][.]{1,2}/(pages|components)|from ['\"].*(/pages/|/components/)" src/repositories src/services
```

## 可选自动化增强

### A. ESLint 规则方向（ArkTS 项目可按实际能力映射）

- 开启 `no-explicit-any`
- 开启 `@typescript-eslint/no-unsafe-assignment`
- 开启 `@typescript-eslint/no-unsafe-member-access`
- 开启 `@typescript-eslint/no-floating-promises`
- 开启 `no-restricted-imports`（限制 `repositories/services` 引入 `pages/components`）

### B. 依赖图检查（可选）

```bash
npx madge src --circular
```

用途：检测循环依赖，辅助识别跨域双向依赖问题。

## 输出模板（建议）

```text
[High] src/repositories/ProfileRepository.ets:18
- 规则: 类型禁令
- 问题: 使用 any 承载接口响应
- 建议: 定义 RawProfileResponse 并在 mapper 中转换为 Profile

[Medium] src/viewmodels/HomeViewModel.ets:76
- 规则: 异步约束
- 问题: Promise then/catch 链与 async/await 混用
- 建议: 改为统一 async/await，并补失败态更新
```

## Quick Prompt

- 帮我按 arkts-static-check-commands 扫描 src 目录，只输出 High 问题
- 帮我执行命名、类型禁令、装饰器边界、依赖方向扫描并汇总结果
