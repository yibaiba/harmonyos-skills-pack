# 任务拆分与阶段验收清单

> 每个阶段完成后，逐项打勾自测，全部通过才进入下一阶段。

## Phase 0 — 工程骨架（Day 1-3）

### 任务清单
- [ ] 新建工程，包名已定 `com.xxx.appname`
- [ ] 目录结构已按 `scaffold/project-structure.md` 创建
- [ ] `app.json5` 版本、包名、minAPIVersion 已填写
- [ ] `module.json5` deviceTypes 包含 phone / tablet / 2in1
- [ ] Color token（亮色 + 深色）已配置完毕
- [ ] `StorageUtil.ets` 已创建，Preferences 可读写
- [ ] `HttpUtil.ets` 已创建，含 token 注入 + 超时 + 统一错误
- [ ] `BreakpointSystem` 已在 EntryAbility 启动
- [ ] `INTERNET` 权限已声明

### 阶段验收
- [ ] 模拟器启动无报错
- [ ] 手动切换深色：背景色正确变化
- [ ] 手机模拟器 `bp.current === 'phone'`，平板返回 `tablet`
- [ ] 网络工具类可正常发起一个 GET 请求

---

## Phase 1 — 账号与登录（Day 2）

### 任务清单
- [ ] `UserModel.ets` 已定义（id / nickname / token 等字段）
- [ ] `UserRepository.ets` 实现：login / sendVerifyCode / logout
- [ ] `LoginViewModel.ets` 实现：手机号校验 / 倒计时 / 错误捕获
- [ ] `pages/Index.ets` 自动 Token 检测路由
- [ ] `pages/LoginPage.ets` 完整 UI

### 阶段验收
- [ ] 未登录 → 自动跳转 LoginPage
- [ ] 手机号格式错误 → 实时提示
- [ ] 获取验证码 → 60s 倒计时
- [ ] 登录成功 → 跳转 HomePage
- [ ] 已登录重启 → 直接进 HomePage
- [ ] 退出登录 → 清除 token，跳 LoginPage

---

## Phase 2 — 内容列表（Day 4）

### 任务清单
- [ ] `ContentModel.ets` 已定义（id / title / coverUrl / summary）
- [ ] `ContentRepository.ets` 实现：分页列表接口
- [ ] `HomeViewModel.ets` 实现：load / refresh / loadMore
- [ ] `ContentCard.ets` 组件
- [ ] `EmptyView.ets` / `ErrorView.ets` 组件
- [ ] `pages/HomePage.ets` 含 Refresh + List + Footer

### 阶段验收
- [ ] 首次加载 → Loading 中间状态
- [ ] 数据到达 → 列表正确渲染
- [ ] 下拉刷新 → 数据重置正确
- [ ] 上拉到底 → 继续加载更多
- [ ] 无更多数据 → "已经到底了"
- [ ] 网络失败 → ErrorView + 重试可用
- [ ] 空列表 → EmptyView

---

## Phase 3 — 详情页（Day 5）

### 任务清单
- [ ] `DetailViewModel.ets` 实现：init / load / share
- [ ] `pages/DetailPage.ets` 含骨架屏 + 导航栏 + Scroll 内容
- [ ] ContentCard onClick 连接路由跳转（传 id）

### 阶段验收
- [ ] 点击卡片 → 正确进入详情（id 正确）
- [ ] 标题先用占位标题，加载后更新
- [ ] 骨架屏在加载期间显示
- [ ] 返回按钮正常返回
- [ ] 加载失败显示错误 + 重试

---

## Phase 4 — 表单发布（Day 6）

### 任务清单
- [ ] `FormViewModel.ets` 实现：validateTitle / validateContent / submit
- [ ] `FormRepository.ets` 实现：图片上传 + 表单提交
- [ ] `pages/FormPage.ets` 含字段校验 + 图片选择 + 提交按钮

### 阶段验收
- [ ] 标题为空 → 实时红色错误提示
- [ ] 内容 < 10 字 → 实时错误提示
- [ ] 提交按钮无效时无法点击
- [ ] 选择图片 ≤ 9 张，超出后加号消失
- [ ] 图片上传 → 提交 → 成功 Toast → 返回
- [ ] 提交失败 → 显示错误信息 → 可重试

---

## Phase 5 — 深色与多端（Day 7）

### 任务清单
- [ ] 所有颜色均通过 `$r('app.color.xxx')` 引用
- [ ] dark/element/color.json 覆盖了所有 token
- [ ] BreakpointSystem 运作正常
- [ ] 列表页多端列数（手机1 / 平板2 / PC3）
- [ ] 平板 / PC 有侧边导航

### 阶段验收
- [ ] 手机模拟器：单列，无溢出
- [ ] 平板模拟器：双列 / 侧边栏
- [ ] PC 模拟器：三列 / 完整侧栏
- [ ] 深色模式：全页面背景/文字/卡片均正确
- [ ] 图片/图标在深色下可见

---

## Phase 6 — 测试与优化（Day 8-9）

### 任务清单
- [ ] 核心链路手动走一遍（登录→列表→详情→发布）
- [ ] 断网测试：所有网络操作触发 Toast，无 crash
- [ ] 空状态测试：空列表 / 空表单 / 无图片
- [ ] ForeEach key 均为稳定 id
- [ ] 大列表（>50 项）使用 LazyForEach

### 阶段验收
- [ ] 无未捕获异常（hilog 无 ERROR）
- [ ] 冷启动到列表显示 < 2s
- [ ] 快速滚动 60fps（Profiler 验证）

---

## Phase 7 — 提审（Day 10）

### 任务清单
- [ ] pre-submission-2025.md A 节全部通过
- [ ] pre-submission-2025.md 对应类型专项通过
- [ ] AGC 应用记录已创建
- [ ] 发布签名 `.p12` 已生成
- [ ] Release 包在真机安装正常
- [ ] 应用截图（手机 + 平板）已准备
- [ ] 隐私声明 URL 已配置

### 阶段验收
- [ ] pre-submission-2025.md D 节十分钟快检全通过
- [ ] AGC 提交无红标必填项
- [ ] 真机安装无签名错误
- [ ] 已点击"提交审核"

---

## 常见阻塞处理

| 阻塞场景                    | 处理方式                                               |
|--------------------------|-------------------------------------------------------|
| 模拟器无网络                | 检查 `module.json5` 是否声明 `INTERNET` 权限          |
| token 持久化失效            | 检查 StorageUtil.init() 是否在 onCreate 中被调用      |
| 深色颜色不变                | 检查是否有硬编码颜色未替换为 `$r(...)` 引用            |
| 断点不响应                  | 检查 BreakpointSystem.start() 是否被调用              |
| AGC 提交按钮灰              | 检查必填项：截图 / 隐私政策链接 / 应用类目             |
| 审核被拒（权限相关）         | 参见 topics/incentive-review-2025.md 权限使用说明要求 |
