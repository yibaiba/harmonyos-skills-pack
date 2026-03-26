# 项目目录结构模板

> 适用于手机 + 平板 + PC 多端、功能模块超过 3 个的标准鸿蒙 Ark 应用。

## 标准目录骨架

```
MyApp/
├── AppScope/                        # 全局资源与应用配置
│   ├── app.json5                    # bundle 名称、版本、权限声明
│   └── resources/
│       ├── base/
│       │   ├── element/
│       │   │   ├── string.json      # 全局字符串
│       │   │   └── color.json       # 全局 color token（含深色对）
│       │   └── media/               # 全局图标、启动图
│       └── dark/                    # 暗色模式覆盖资源
│           └── element/
│               └── color.json       # 深色 color token
│
├── entry/                           # 主 HAP（手机端默认入口）
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── entryability/
│   │   │   │   └── EntryAbility.ets # UIAbility 入口（见 modules/auth-login.md）
│   │   │   ├── pages/               # 路由页面（@Entry 组件）
│   │   │   │   ├── Index.ets        # 首页/启动页
│   │   │   │   ├── LoginPage.ets
│   │   │   │   ├── HomePage.ets
│   │   │   │   └── DetailPage.ets
│   │   │   ├── viewmodel/           # ViewModel 层
│   │   │   │   ├── LoginViewModel.ets
│   │   │   │   └── HomeViewModel.ets
│   │   │   ├── repository/          # Repository 层（数据拉取与缓存）
│   │   │   │   ├── UserRepository.ets
│   │   │   │   └── ContentRepository.ets
│   │   │   ├── model/               # 数据模型（interface / class）
│   │   │   │   ├── UserModel.ets
│   │   │   │   └── ContentModel.ets
│   │   │   ├── components/          # 可复用 UI 组件
│   │   │   │   ├── common/
│   │   │   │   │   ├── LoadingView.ets
│   │   │   │   │   ├── EmptyView.ets
│   │   │   │   │   └── ErrorView.ets
│   │   │   │   └── business/
│   │   │   │       ├── ContentCard.ets
│   │   │   │       └── UserAvatar.ets
│   │   │   ├── service/             # 业务服务（纯 TS 逻辑，无 UI）
│   │   │   │   └── AuthService.ets
│   │   │   └── utils/               # 工具函数
│   │   │       ├── HttpUtil.ets     # 封装 @ohos.net.http
│   │   │       ├── StorageUtil.ets  # 封装 Preferences/RelationalStore
│   │   │       └── LogUtil.ets
│   │   ├── resources/
│   │   │   ├── base/element/
│   │   │   │   └── string.json      # 当前 HAP 模块字符串
│   │   │   └── rawfile/             # 原始资源（JSON 配置等）
│   │   └── module.json5             # 模块声明（页面路由表、权限）
│   └── oh-package.json5             # 模块依赖声明
│
├── features/                        # 可选：多 HAR 功能分包（按需使用）
│   ├── feature_user/                # 用户中心功能包
│   └── feature_content/             # 内容功能包
│
├── common/                          # 可选：跨 HAP/HAR 共享基础库
│   └── utils/
│
├── oh-package.json5                 # 根依赖（ohpm 包）
├── build-profile.json5              # 构建配置（签名、环境）
└── hvigor/                          # 构建工具配置
```

## 关键配置文件说明

### AppScope/app.json5 最小必填项
```json5
{
  "app": {
    "bundleName": "com.example.myapp",    // 必须全局唯一
    "versionCode": 1,
    "versionName": "1.0.0",
    "minAPIVersion": 12,                  // 纯血鸿蒙最低 API 12
    "targetAPIVersion": 13
  }
}
```

### entry/src/main/module.json5 最小必填项
```json5
{
  "module": {
    "name": "entry",
    "type": "entry",
    "mainElement": "EntryAbility",
    "deviceTypes": ["phone", "tablet", "2in1"],  // 多端支持必填
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ets",
        "description": "$string:EntryAbility_desc",
        "icon": "$media:icon",
        "label": "$string:EntryAbility_label",
        "startWindowIcon": "$media:startIcon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": ["entity.system.home"],
            "actions": ["action.system.home"]
          }
        ]
      }
    ],
    "pages": "$profile:main_pages"   // 路由表文件
  }
}
```

### resources/base/profile/main_pages.json 路由表
```json
{
  "src": [
    "pages/Index",
    "pages/LoginPage",
    "pages/HomePage",
    "pages/DetailPage"
  ]
}
```

## 命名约定

| 层级         | 命名规范              | 示例                     |
|------------|-----------------------|--------------------------|
| 页面         | `XxxPage.ets`          | `LoginPage.ets`          |
| ViewModel   | `XxxViewModel.ets`     | `LoginViewModel.ets`     |
| Repository  | `XxxRepository.ets`    | `UserRepository.ets`     |
| 数据模型     | `XxxModel.ets`         | `UserModel.ets`          |
| 可复用组件   | `XxxView.ets / XxxCard.ets` | `ContentCard.ets`   |
| 工具类       | `XxxUtil.ets`          | `HttpUtil.ets`           |
| 常量         | `XxxConstants.ets`     | `AppConstants.ets`       |

## 官方参考
- 工程结构: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-hvigor-structure
- module.json5: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/module-configuration-file
- 多 HAP 分包: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/multi-hap-principles
