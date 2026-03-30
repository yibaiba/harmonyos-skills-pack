# ⚡ Agent 快速上手（30 秒）

> 本文件帮助 AI Agent 在最短时间内定位所需资源。详细路由见 SKILL.md。

## 🚨 第一步：读约束（必须）

编写 `.ets` / `.ts` 代码前，以下规则为**硬约束**（违反即编译失败）：

- ❌ 禁止 `any` / `unknown` / `var` / 解构赋值 / `for...in` / 函数表达式
- ❌ 禁止 `obj["field"]` 索引访问 / `Function.apply/call/bind`
- ❌ 动画中禁止改 `width` / `height` / `padding` / `margin`
- ✅ 不确定的 API **必须搜索官方文档确认**
- 📄 完整 60+ 条 → `topics/arkts-coding-rules.md`

## 🧭 第二步：找资源

| 你要做什么 | 去哪里 |
|-----------|--------|
| 查 API / 学知识 | `SKILL.md` 关键词速查表（30 个关键词直达） |
| 新建项目 | `starter-kit/SKILL.md` |
| 编译报错 | `arkts-modernization-guard/SKILL.md` |
| @Component → @ComponentV2 | `topics/componentv2-migration.md` |
| 准备提审 | `checklists/pre-submission-2025.md` |
| 质量验收 | 先 `universal-product-quality/SKILL.md` → 再本 Skill |

## 🔑 第三步：常用模板

| 场景 | 模板文件 |
|------|---------|
| 登录页（手机号+验证码） | `starter-kit/modules/auth-login.md` |
| 列表页（刷新+加载更多） | `starter-kit/modules/list-page.md` |
| 详情页（路由传参） | `starter-kit/modules/detail-page.md` |
| 表单提交（校验+上传） | `starter-kit/modules/form-submit.md` |
| 底部 Tab 导航 | `starter-kit/modules/tabbar-navigation.md` |
| 深色模式+多端适配 | `starter-kit/modules/dark-multi.md` |
| 34 个代码片段集合 | `starter-kit/snippets/common-patterns.md` |

## ⚙️ 版本假设

- 默认 HarmonyOS NEXT 6.x / API 13+
- 路由使用 Navigation + NavPathStack（非 Router）
- 状态管理新项目推荐 @ComponentV2（V2）

> 📄 完整文档路由 → `SKILL.md`
