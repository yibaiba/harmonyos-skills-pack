# Day 1 通用工程骨架清单

> 复制此文件，填入实际项目信息，逐项打勾完成 Day 1。

## 项目信息填写

```
App 名称：_______________
包名（bundleName）：com._____.___________
最低 API 版本：12（纯血鸿蒙）
App 类型：[ ] 工具  [ ] 社区/内容  [ ] 电商/交易  [ ] 其他: ____
```

---

## Step 1 — DevEco Studio 新建工程

- [ ] 模板选 `Empty Ability`，语言选 `ArkTS`
- [ ] 包名填入上方项目信息（一旦上架不可更改）
- [ ] targetSDKVersion 选最新稳定版

---

## Step 2 — 配置 AppScope/app.json5

```json5
{
  "app": {
    "bundleName": "com.xxx.appname",   // ← 填入实际包名
    "versionCode": 1,
    "versionName": "1.0.0",
    "minAPIVersion": 12,
    "targetAPIVersion": 13             // ← 按 DevEco 最新版调整
  }
}
```

- [ ] bundleName 已填入
- [ ] versionCode / versionName 符合规划

---

## Step 3 — 配置 module.json5（多端支持）

关键字段确认：
- [ ] `deviceTypes` 已包含 `["phone","tablet","2in1"]`
- [ ] `mainElement` 已指向 `EntryAbility`
- [ ] `pages` 已指向 `$profile:main_pages`
- [ ] 权限已按需添加（至少 `INTERNET`）

```json5
// 权限示例（按需选填）
"requestPermissions": [
  { "name": "ohos.permission.INTERNET" },
  // { "name": "ohos.permission.CAMERA" },               // 相机
  // { "name": "ohos.permission.READ_MEDIA" },           // 读媒体
  // { "name": "ohos.permission.WRITE_MEDIA" },          // 写媒体
  // { "name": "ohos.permission.LOCATION" }              // 定位
]
```

---

## Step 4 — Color Token（深色双主题）

- [ ] 在 `AppScope/resources/base/element/color.json` 写入亮色 Token（参见 modules/dark-multi.md）
- [ ] 在 `AppScope/resources/dark/element/color.json` 写入深色 Token
- [ ] 在 DevEco 切换深色，预览背景色变化

---

## Step 5 — 目录结构

按 `scaffold/project-structure.md` 创建以下空文件（建立目录占位）：

- [ ] `ets/entryability/EntryAbility.ets`（已有，添加初始化逻辑）
- [ ] `ets/pages/Index.ets`（Token 检测页）
- [ ] `ets/viewmodel/` 目录
- [ ] `ets/repository/` 目录
- [ ] `ets/model/` 目录
- [ ] `ets/components/common/` 目录
- [ ] `ets/components/business/` 目录
- [ ] `ets/service/` 目录
- [ ] `ets/utils/` 目录
- [ ] `ets/state/` 目录

---

## Step 6 — 基础工具类

从 `snippets/common-patterns.md` 复制并创建：

- [ ] `ets/utils/StorageUtil.ets`（Preferences 封装）
- [ ] `ets/utils/HttpUtil.ets`（网络封装，填入实际 BASE_URL）
- [ ] `ets/utils/BreakpointUtil.ets`（多端断点）
- [ ] `ets/utils/LogUtil.ets`（可选，hilog 封装）

---

## Step 7 — 全局状态初始化

从 `snippets/state-management.md` 复制：

- [ ] `ets/state/UserState.ets`（AppStorage 用户状态）
- [ ] `ets/state/AppConfig.ets`（主题切换，可选）
- [ ] 在 `EntryAbility.onCreate` 中调用 `StorageUtil.init()`、`bp.start()`、恢复用户状态

---

## Step 8 — 路由表注册

在 `resources/base/profile/main_pages.json` 中预注册所有页面：

```json
{
  "src": [
    "pages/Index",
    "pages/LoginPage",
    "pages/MainPage",
    "pages/HomePage",
    "pages/DetailPage",
    "pages/FormPage"
  ]
}
```

- [ ] 路由表已注册所有计划页面

---

## Step 9 — 验证 Day 1

- [ ] `DevEco Build > Run` 在手机模拟器启动无报错
- [ ] 切换深色模式，背景色变化（color token 生效）
- [ ] 在平板模拟器：`bp.current` 为 `tablet`
- [ ] `StorageUtil.put / get` 读写一次确认正常
- [ ] 控制台无 `ERROR` 级别日志

---

## 完成 Day 1 后

下一步 → `pipeline/execution-order.md` Day 2（登录模块）
选择你的 App 类型 → `pipeline/app-type-checklist.md`
