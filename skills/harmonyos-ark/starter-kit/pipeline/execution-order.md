# 执行顺序 — 项目 Day-by-Day 推进计划

> 适用于单人 / 小团队从零开始交付一个中等复杂度鸿蒙应用（约 5-8 个核心页面）。

## 总体里程碑

```
Week 1  Day 1-3   工程骨架 + 登录
Week 1  Day 4-5   核心列表 + 详情
Week 2  Day 6-7   表单 / 发布 + 深色多端
Week 2  Day 8-9   测试 + 性能优化
Week 2  Day 10    提审准备 + 上架
```

---

## Day 1 — 工程初始化

**目标：** 跑通 Hello World + 配置骨架

**步骤：**
1. DevEco Studio 新建 Empty Ability 工程，包名 `com.xxx.appname`
2. 按 `scaffold/project-structure.md` 创建目录结构
3. 配置 `AppScope/app.json5`（包名、版本、minAPIVersion: 12）
4. 配置 `module.json5` deviceTypes: `["phone","tablet","2in1"]`
5. 创建 `resources/base/element/color.json` + `dark/element/color.json`（见 `modules/dark-multi.md`）
6. 创建 `utils/StorageUtil.ets`、`utils/HttpUtil.ets`（见 `snippets/common-patterns.md`）
7. 在 EntryAbility 初始化 StorageUtil + BreakpointSystem

**验收：**
- [ ] 模拟器启动不报错
- [ ] 切换深色模式，背景色变化（color token 生效）
- [ ] `bp.current` 在平板模拟器返回 `tablet`

---

## Day 2 — 登录模块

**目标：** 完整登录流程跑通

> 单机离线场景可选分支：使用 `modules/offline-no-login.md`，跳过登录拦截，直接进入主功能页。

**步骤：**
1. 二选一：
	- 在线账号版：复制 `modules/auth-login.md` 模板，填入真实 API 地址
	- 单机离线版：复制 `modules/offline-no-login.md` 模板，配置首次引导 + 直接进 HomePage
2. 创建 `model/UserModel.ets`
3. 创建 `repository/UserRepository.ets`（login / sendVerifyCode / logout）
4. 创建 `viewmodel/LoginViewModel.ets`
5. 创建 `pages/Index.ets`（Token 检测 → 自动跳转）
6. 创建 `pages/LoginPage.ets`

**验收：**
- [ ] 在线账号版：未登录时自动到 LoginPage
- [ ] 在线账号版：登录成功后跳转到 HomePage（先用空页面占位）
- [ ] 在线账号版：已登录时重启 App 直接到 HomePage
- [ ] 在线账号版：退出登录清除 token，跳回 LoginPage
- [ ] 单机离线版：首次启动进入 GuidePage，完成后进入 HomePage
- [ ] 单机离线版：重启 App 直接进入 HomePage

---

## Day 3 — 分层架构 + 网络层

**目标：** HttpUtil 封装完成，通用错误处理可用

**步骤：**
1. 完善 `utils/HttpUtil.ets`（含 token 注入 / 超时 / 统一错误转换）
2. 实现 BaseRepository 基类（可选）
3. 补全 `AppConstants.ets`（BASE_URL、超时时间等常量）
4. 补全权限声明（网络权限 `ohos.permission.INTERNET`）

**验收：**
- [ ] 网络请求携带 Authorization header
- [ ] 401 响应自动清除 token 并跳登录页
- [ ] 无网络时给出 Toast 提示，不 crash

---

## Day 4 — 列表页

**目标：** 首页列表完整可用

**步骤：**
1. 复制 `modules/list-page.md` 模板
2. 创建 `model/ContentModel.ets`
3. 创建 `repository/ContentRepository.ets`
4. 创建 `viewmodel/HomeViewModel.ets`
5. 创建 `components/business/ContentCard.ets`
6. 创建 `components/common/EmptyView.ets`、`ErrorView.ets`
7. 完成 `pages/HomePage.ets`（含下拉刷新 + 上拉加载）

**验收：**
- [ ] 首次进入显示 LoadingProgress
- [ ] 数据加载成功显示列表
- [ ] 下拉刷新正常（Refresh 组件动画）
- [ ] 滚到底部加载更多，所有数据加载完显示"已经到底了"
- [ ] 网络失败显示 ErrorView + 重试按钮

---

## Day 5 — 详情页

**目标：** 详情页完整可用，路由传参正确

**步骤：**
1. 复制 `modules/detail-page.md` 模板
2. 创建 `viewmodel/DetailViewModel.ets`
3. 完成 `pages/DetailPage.ets`（含骨架屏）
4. 在 ContentCard onClick 中加 navStack.pushPath 跳转

**验收：**
- [ ] 点击列表卡片正确跳到对应详情
- [ ] 详情页标题先显示列表传来的标题，加载完后更新
- [ ] 返回按钮正常
- [ ] 骨架屏在加载期间显示

---

## Day 6 — 表单 / 发布页

**目标：** 表单提交含图片上传

**步骤：**
1. 复制 `modules/form-submit.md` 模板
2. 创建 `viewmodel/FormViewModel.ets`
3. 创建 `repository/FormRepository.ets`（含图片上传）
4. 完成 `pages/FormPage.ets`
5. 在 HomePage 或底部 TabBar 加入入口

**验收：**
- [ ] 所有字段实时校验（标题/内容）
- [ ] 提交按钮在表单无效时禁用
- [ ] 图片选择最多 9 张，已上传的可删除
- [ ] 提交成功显示 Toast，返回上一页
- [ ] 提交失败显示错误信息，可重试

---

## Day 7 — 深色模式 + 多端布局

**目标：** 三个尺寸（手机/平板/PC）均可用，深色模式正常

**步骤：**
1. 按 `modules/dark-multi.md` 验收清单逐项检查
2. 调整列表页为多列（平板 2 列 / PC 3 列）
3. 平板/PC 增加侧边导航
4. 确认所有页面无硬编码颜色
5. 在模拟器切换明暗模式，截图记录

**验收：**
- [ ] 手机：单列，无横向溢出
- [ ] 平板：双列，侧边导航可用
- [ ] PC：三列，侧边栏展开
- [ ] 深色模式下界面清晰，无白底图片撞白
- [ ] 折叠屏展开后布局自动切换

---

## Day 8 — 测试

**步骤：**
1. 核心链路 UI 测试（登录 → 列表 → 详情 → 发布）
2. 网络异常测试（断网 / 超时 / 401）
3. 边界数据测试（空列表 / 超长文本 / 图片加载失败）
4. 深色模式在真机测试
5. 运行 DevEco Studio Lint，修复 warning

**验收：**
- [ ] 所有核心流程在手机模拟器完整执行一遍
- [ ] 断网 → 恢复网络，刷新正常
- [ ] 无未处理的异常（hilog 无 ERROR 级别）

---

## Day 9 — 性能优化

**步骤：**
1. 列表 ForEach key 均为稳定 id（非 index）
2. 图片组件 `.cachedCount`、`.syncLoad(false)` 检查
3. 大列表使用 LazyForEach + DataSource（如超过 50 项）
4. 启动耗时：EntryAbility.onCreate 不做耗时同步操作
5. Profiler 抓一次首页加载帧率，确保 60fps

**验收：**
- [ ] 快速滚动列表无卡顿
- [ ] 冷启动到首页内容显示 < 1.5s

---

## Day 10 — 提审准备

**步骤：**
1. 执行 `checklists/pre-submission-2025.md` A 节 + 对应类型专项
2. AGC 创建应用记录，填写基础信息
3. 生成发布签名（DevEco Studio → Build → Generate Key）
4. 打 Release 包，在真机安装验证
5. 准备应用截图（手机 + 平板各至少 2 张）
6. 上传至 AGC，填写版本说明、隐私声明链接

**验收：**
- [ ] pre-submission-2025.md D 节十分钟快检全部通过
- [ ] AGC 提交按钮可点击（无必填项红标）
- [ ] 真机安装正常，无签名错误
