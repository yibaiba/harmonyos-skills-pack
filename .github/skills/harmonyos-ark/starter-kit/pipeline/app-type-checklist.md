# App 类型定制任务清单

> 三种最常见 App 类型的任务清单差异对照。选择匹配的类型，在 `pipeline/task-breakdown.md` 基础上补充专项任务。

---

## 类型 A：工具类 App（离线为主 / 无社交）

**典型场景：** 计算器、笔记、文件管理、健康记录、定时器

### 补充模块清单
- [ ] 本地数据库（RelationalStore 或 Preferences）替代网络 Repository
- [ ] 数据导入/导出（分享文件、DocumentViewPicker）
- [ ] 无登录模式（跳过 auth-login 模块，或改为可选账号）
- [ ] 本地通知（推送定时提醒）
- [ ] 桌面卡片（FormExtensionAbility，可选）

### 核心页面骨架
```
Index（直接进主功能，无登录）
MainPage（TabBar）
  ├── 功能主页（工具核心操作）
  ├── 历史记录（List 模板）
  └── 设置（主题 / 导出 / 关于）
```

### 审核重点（低风险，但需注意）
- 权限最小化：仅申请功能必需权限，不要捆绑申请
- 若有定位权限，需说明使用原因
- 离线功能为主：不需要账号相关合规材料

### 推荐模块组合
```
scaffold/project-structure.md       （基础骨架）
scaffold/layer-architecture.md      （分层）
modules/offline-no-login.md         （单机离线免登录入口）
modules/tabbar-navigation.md        （底部导航）
snippets/state-management.md        （AppStorage 暗色主题 / 数据本地管理）
modules/dark-multi.md               （深色 + 多端）
pipeline/task-breakdown.md          Phase 0 + Phase 2（列表）+ Phase 5（多端）
```

---

## 类型 B：社区 / 内容类 App（UGC / 图文浏览）

**典型场景：** 图文社区、信息流、内容创作平台、问答、直播

### 补充模块清单
- [ ] 登录（auth-login 模块）
- [ ] 内容列表 + 详情（list-page + detail-page 模块）
- [ ] 发布内容（form-submit + 图片上传）
- [ ] 用户主页（头像 / 关注 / 作品列表）
- [ ] 消息中心（未读角标 + 通知列表）
- [ ] 评论 / 点赞（子列表 + 状态切换）
- [ ] 第三方分享（systemShare）

### 核心页面骨架
```
Index（Token 检测）→ LoginPage
MainPage（TabBar）
  ├── 首页（推荐流，List 模板）
  ├── 发现（分类列表 / 搜索）
  ├── 发布（form-submit + 图片上传）
  ├── 消息（未读通知）
  └── 我的（Profile + 我的发布）
DetailPage（图文详情 + 评论）
```

### 审核重点（中风险）
- 必须有内容合规审核机制（UGC 内容平台要求）
- 用户生成内容需说明举报 / 投诉方式
- 涉及分享需在隐私政策中声明
- 图片上传需声明存储权限
- 参见 topics/incentive-review-2025.md → 中风险专项

### 推荐模块组合
```
scaffold/project-structure.md
scaffold/layer-architecture.md
modules/auth-login.md
modules/list-page.md
modules/detail-page.md
modules/form-submit.md
modules/tabbar-navigation.md
modules/dark-multi.md
snippets/state-management.md         （AppStorage 未读数、用户信息）
pipeline/execution-order.md          完整 Day 1-10
pipeline/task-breakdown.md           所有 Phase
```

---

## 类型 C：电商 / 交易类 App（支付 / 订单）

**典型场景：** 购物、二手交易、外卖、商城、订阅服务

### 补充模块清单
- [ ] 登录（必须符合账号合规，auth-login 模块）
- [ ] 商品列表 + 详情（list-page + detail-page 模块）
- [ ] 购物车（本地状态 + 数量 / 规格选择）
- [ ] 订单确认页（表单变体）
- [ ] 支付集成（华为支付 / IAP Kit）
- [ ] 订单列表 + 状态追踪
- [ ] 地址管理

### 核心页面骨架
```
Index（Token 检测）→ LoginPage
MainPage（TabBar）
  ├── 首页（推荐商品列表）
  ├── 分类（类目导航 + 商品列表）
  ├── 购物车（本地数据 + LazyForEach）
  └── 我的（订单 / 地址 / 设置）
GoodsDetailPage（商品详情 + 加入购物车）
OrderConfirmPage（表单模板变体）
PayPage（调起 IAP Kit）
```

### 审核重点（高风险）
- 支付功能必须接入华为 IAP 或符合鸿蒙支付合规
- 不得绕过系统支付通道在 App 内自行收款
- 必须有用户协议 + 隐私政策 + 退款政策页面
- 支付相关权限（网络 / 生物识别）均需声明
- 参见 topics/incentive-review-2025.md → **高风险专项**，务必逐项确认

### 推荐模块组合
```
scaffold/project-structure.md
scaffold/layer-architecture.md
modules/auth-login.md               （高风险：账号合规必查）
modules/list-page.md
modules/detail-page.md
modules/form-submit.md              （订单确认变体）
modules/tabbar-navigation.md
modules/dark-multi.md
snippets/state-management.md         （AppStorage 购物车数量、登录状态）
pipeline/execution-order.md          完整 Day 1-10（支付在 Day 7-8 加入）
pipeline/task-breakdown.md           所有 Phase + 额外高风险支付验收项
checklists/pre-submission-2025.md → B3（增值服务）专项
topics/incentive-review-2025.md  → 高风险分支
```

---

## 快速判断：我是哪种类型？

```
有支付 / 购买功能？        → 类型 C（电商）
有用户发布内容（UGC）？    → 类型 B（社区）
主要离线 / 本地操作？      → 类型 A（工具）
以上都有？                 → 以主功能为准，补充混合专项
```
