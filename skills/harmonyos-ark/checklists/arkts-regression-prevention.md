# ArkTS 防回归快速清单（CodeWrench）

## 改动前
- [ ] 运行 guard 扫描并保存输出
- [ ] 确认是否涉及以下高风险模式：
- [ ] `@Prop` 函数回调
- [ ] `await preferences.getPreferences(...)` 直 await
- [ ] spread 刷新
- [ ] 动态 `$r(...)`
- [ ] deprecated API 调用

## 改动中
- [ ] `build()` 内仅保留 DSL，辅助逻辑抽私有方法
- [ ] 组件字段避免与链式 API 冲突（`size/onClick`）
- [ ] 资源参数使用静态 `Resource`/`$r('xxx.yyy.zzz')`
- [ ] `hostContext`、`Preferences` 调用均做空值保护

## 改动后
- [ ] guard 扫描输出 `passed`
- [ ] `CompileArkTS` 已执行并记录结果
- [ ] 关键运行时路径冒烟通过（HomeTab/SettingsTab/CodesTab/LearningTab）

## 失败时
- [ ] 将新模式补充到：
- [ ] `../topics/arkts-error-prevention.md`
- [ ] `../../arkts-modernization-guard/references/error-to-fix-map.md`
