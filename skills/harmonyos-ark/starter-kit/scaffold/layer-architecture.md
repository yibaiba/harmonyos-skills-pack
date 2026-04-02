# 四层分层架构

> MVVM + Repository 分层，适合鸿蒙 Ark 应用中等以上复杂度项目。

## 架构图

```
┌─────────────────────────────────────────────┐
│              UI Layer (Pages + Components)   │
│  @Entry / @Component  纯声明式 UI，无业务逻辑  │
└──────────────────┬──────────────────────────┘
                   │ @State / @Watch / 调用
┌──────────────────▼──────────────────────────┐
│              ViewModel Layer                 │
│  持有 @ObservedV2 数据，处理 UI 事件，编排流程 │
└──────────────────┬──────────────────────────┘
                   │ 调用 fetch / save
┌──────────────────▼──────────────────────────┐
│              Repository Layer                │
│  数据来源聚合：网络 + 本地缓存 + 权限判断      │
└──────────────────┬──────────────────────────┘
                   │ 定义 interface
┌──────────────────▼──────────────────────────┐
│              Model Layer                     │
│  纯数据结构：interface / class，无副作用       │
└─────────────────────────────────────────────┘
```

## 各层职责与代码规范

### Model 层
- 仅定义 interface / class，**不含任何 UI 或网络逻辑**
- 字段命名使用 camelCase，与后端 snake_case 在 Repository 层转换

```typescript
// model/UserModel.ets
export interface UserModel {
  id: string
  nickname: string
  avatarUrl: string
  token: string
}

export interface ContentModel {
  contentId: string
  title: string
  coverUrl: string
  description: string
  createTime: number
}
```

### Repository 层
- 统一网络请求 + 本地缓存逻辑
- 对 ViewModel 暴露 `async` 方法，返回 Model 对象或抛出业务异常
- 使用 `HttpUtil` 封装 `@ohos.net.http`

```typescript
// repository/UserRepository.ets
import { HttpUtil } from '../utils/HttpUtil'
import { StorageUtil } from '../utils/StorageUtil'
import { UserModel } from '../model/UserModel'

export class UserRepository {
  private static readonly TOKEN_KEY = 'user_token'

  async login(phone: string, code: string): Promise<UserModel> {
    const resp = await HttpUtil.post<UserModel>('/api/login', { phone, code })
    await StorageUtil.put(UserRepository.TOKEN_KEY, resp.token)
    return resp
  }

  async getToken(): Promise<string | null> {
    return StorageUtil.get<string>(UserRepository.TOKEN_KEY)
  }

  async logout(): Promise<void> {
    await StorageUtil.remove(UserRepository.TOKEN_KEY)
  }
}
```

### ViewModel 层
- 使用 `@ObservedV2` + `@Trace` 维护响应式状态
- 对 UI 暴露 `loadXxx()` / `submitXxx()` 等方法
- **捕获异常，不允许异常穿透到 UI 层**

```typescript
// viewmodel/LoginViewModel.ets
import { UserRepository } from '../repository/UserRepository'
import { UserModel } from '../model/UserModel'

@ObservedV2
export class LoginViewModel {
  @Trace phone: string = ''
  @Trace code: string = ''
  @Trace isLoading: boolean = false
  @Trace errorMsg: string = ''
  @Trace currentUser: UserModel | null = null

  private repo = new UserRepository()

  async login(): Promise<boolean> {
    if (!this.phone || !this.code) {
      this.errorMsg = '手机号和验证码不能为空'
      return false
    }
    this.isLoading = true
    this.errorMsg = ''
    try {
      this.currentUser = await this.repo.login(this.phone, this.code)
      return true
    } catch (e) {
      this.errorMsg = e?.message ?? '登录失败，请重试'
      return false
    } finally {
      this.isLoading = false
    }
  }
}
```

### UI 层（Page / Component）
- 只持有 ViewModel 实例和 UI 纯状态（如输入框 focus）
- 事件处理直接调用 ViewModel 方法，不写业务逻辑
- 跨页共享时，用 `@LocalStorageLink` / `@StorageLink` 仅同步基础字段或可序列化快照，不直接共享 `@ObservedV2` ViewModel

```typescript
// pages/LoginPage.ets
import { LoginViewModel } from '../viewmodel/LoginViewModel'

@Entry
@Component
struct LoginPage {
  private vm: LoginViewModel = new LoginViewModel()

  build() {
    Column() {
      TextInput({ placeholder: '手机号', text: this.vm.phone })
        .onChange(v => { this.vm.phone = v })

      TextInput({ placeholder: '验证码', text: this.vm.code })
        .onChange(v => { this.vm.code = v })

      if (this.vm.errorMsg) {
        Text(this.vm.errorMsg).fontColor(Color.Red)
      }

      Button(this.vm.isLoading ? '登录中...' : '登录')
        .enabled(!this.vm.isLoading)
        .onClick(async () => {
          const ok = await this.vm.login()
          if (ok) {
            this.navStack.replacePath({ name: 'HomePage' })
          }
        })
    }
    .padding(24)
  }
}
```

> ⚠️ `@StorageLink` / `@LocalStorageLink` 只适合同步 `token`、`id`、主题、草稿字段等快照，不要直接存 `@ObservedV2` ViewModel，否则会触发 `10905348`。

## 禁止事项（Hard Rules）

| 禁止                           | 说明                                |
|-------------------------------|-------------------------------------|
| UI 层直接 `http.request()`      | 所有网络必须经 Repository            |
| ViewModel 调用 `navStack.pushPath` | 导航必须由 UI 层决定                  |
| Model 层包含 `@State` 装饰器    | Model 是纯数据结构                    |
| Repository 引用 UI 组件         | 依赖方向只能向下，不能逆向              |

## 官方参考
- @ObservedV2 / @Trace: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-new-observedv2-and-trace
- 状态管理最佳实践: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-state-management-best-practices
