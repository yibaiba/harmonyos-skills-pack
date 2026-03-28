---
description: ArkTS 编译现代化守卫 — 自动扫描已知坏模式（@Prop 回调、deprecated API、FontWeight.Black 等），在编译前拦截问题
---

# ArkTS 编译现代化守卫

<!-- Agent 摘要：~120 行。ArkTS 现代化扫描入口，提供自动检测 @Prop 回调、deprecated API、FontWeight.Black 等已知坏模式的脚本与修复映射。搜索: arkts guard scan modernization deprecated。 -->

## 目的

自动扫描 ArkTS 项目源码，检测已知编译错误模式与 deprecated API 使用，在编译前拦截问题。

## 快速使用

```bash
# 扫描当前项目
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh

# 指定扫描目录
bash .codex/skills/arkts-modernization-guard/scripts/scan-arkts-modernization.sh entry/src/main/ets
```

## 扫描规则

| 规则 ID | 等级 | 检测模式 | 说明 |
|---------|------|----------|------|
| AMG-001 | P0 | `@Prop` 修饰函数回调 | ArkTS 不支持 `@Prop` 传递函数类型 |
| AMG-002 | P0 | `build()` 内含赋值/await/console | build 仅允许 UI DSL |
| AMG-003 | P1 | `FontWeight.Black` | ArkTS 枚举无 Black，用 Bolder |
| AMG-004 | P1 | `LengthMetrics.vp/fp/px(...)` | LengthMetrics 是类型别名，不可调用 |
| AMG-005 | P1 | spread 刷新 `[...arr]` / `{...obj}` 在状态赋值中 | 触发全量重渲染，用 slice/concat |
| AMG-006 | P1 | 可抛异常函数缺 try-catch | WARN: Function may throw exceptions |
| AMG-007 | P2 | 动态 `$r(variable)` | 编译器要求静态字面量 |
| AMG-008 | P2 | deprecated API 调用 | animateTo/replaceUrl/pushUrl/showDialog 等 |
| AMG-009 | P2 | 未验证的 sys.symbol.* 资源名 | Unknown resource name 风险 |

## 推荐工作流

```
改动前扫描 → 保存基线
    ↓
编码改动
    ↓
改动后扫描 → 对比基线
    ↓
0 新增违规 → 提交
    ↓（有新违规）
查 error-to-fix-map.md → 修复 → 重新扫描
```

## 相关资产

| 文件 | 用途 |
|------|------|
| [scripts/scan-arkts-modernization.sh](scripts/scan-arkts-modernization.sh) | 自动扫描脚本 |
| [references/error-to-fix-map.md](references/error-to-fix-map.md) | 错误码→修复方案映射 |
| [snippets/replacement-patterns.md](snippets/replacement-patterns.md) | 代码替换模板 |

## 输出格式

```
[AMG-003] P1  src/main/ets/pages/Home.ets:42  FontWeight.Black → 使用 FontWeight.Bolder
[AMG-008] P2  src/main/ets/utils/nav.ets:18   deprecated: replaceUrl → 使用 replaceNamedRoute

扫描完成：3 个文件，2 个违规（0 P0, 1 P1, 1 P2）
结果: FAILED（存在 P0/P1 违规时为 FAILED）
```

## 退出码

| 码 | 含义 |
|----|------|
| 0  | passed — 无 P0/P1 违规 |
| 1  | failed — 存在 P0 或 P1 违规 |
| 2  | warning — 仅 P2 违规 |

---

## See Also

- [../harmonyos-ark/topics/arkts-error-prevention.md](../harmonyos-ark/topics/arkts-error-prevention.md) — 历史报错防回归档案
- [../harmonyos-ark/checklists/arkts-regression-prevention.md](../harmonyos-ark/checklists/arkts-regression-prevention.md) — 防回归清单
- [../harmonyos-ark/topics/arkts.md](../harmonyos-ark/topics/arkts.md) — ArkTS 深入主题
