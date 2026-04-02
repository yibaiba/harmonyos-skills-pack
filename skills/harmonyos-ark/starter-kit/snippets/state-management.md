# 全局状态管理模板

> 覆盖：AppStorage（跨 Ability 全局） / LocalStorage（单 HAP 内） / @ObservedV2 响应式类

## 状态管理三层选择

```
┌──────────────────────────────────────────────────────────┐
│  AppStorage — 全局，跨页面、跨 Ability，内存级持久          │
│  适合：登录状态、当前用户信息、主题色、未读消息数           │
├──────────────────────────────────────────────────────────┤
│  LocalStorage — HAP 内，页面间共享，可传给子组件           │
│  适合：单个流程的共享状态（如多步骤表单）                   │
├──────────────────────────────────────────────────────────┤
│  @ObservedV2 ViewModel — 单页内，跟随页面生命周期          │
│  适合：页面私有的加载状态、表单字段、列表数据               │
└──────────────────────────────────────────────────────────┘
```

> ⚠️ `@StorageLink` / `@LocalStorageLink` 只绑定基础字段、数组或可序列化快照；不要直接绑定 `@ObservedV2` ViewModel，否则会触发 `10905348`。

---

## 一、AppStorage 全局用户状态

### 初始化（在 EntryAbility.onCreate 中）

```typescript
// entryability/EntryAbility.ets
import { AppStorage } from '@kit.ArkUI'
import { StorageUtil } from '../utils/StorageUtil'
import { UserState } from '../state/UserState'

export default class EntryAbility extends UIAbility {
  async onCreate(want, launchParam) {
    await StorageUtil.init(this.context)

    // 从 Preferences 恢复登录状态到 AppStorage
    const token = await StorageUtil.get<string>('user_token')
    const nickname = await StorageUtil.get<string>('user_nickname')
    AppStorage.setOrCreate<string | null>('userToken', token)
    AppStorage.setOrCreate<string | null>('userNickname', nickname)
    AppStorage.setOrCreate<number>('unreadCount', 0)
    AppStorage.setOrCreate<number>('forceLogout', 0)  // 401 信号
  }
}
```

### 集中管理：UserState 工具类

```typescript
// state/UserState.ets
import { AppStorage } from '@kit.ArkUI'
import { StorageUtil } from '../utils/StorageUtil'
import { UserModel } from '../model/UserModel'

export class UserState {
  /** 读取当前 token */
  static getToken(): string | null {
    return AppStorage.get<string>('userToken') ?? null
  }

  /** 登录后保存用户信息 */
  static async setUser(user: UserModel): Promise<void> {
    AppStorage.setOrCreate('userToken', user.token)
    AppStorage.setOrCreate('userNickname', user.nickname)
    AppStorage.setOrCreate('userAvatarUrl', user.avatarUrl)
    await StorageUtil.put('user_token', user.token)
    await StorageUtil.put('user_nickname', user.nickname)
  }

  /** 退出清空 */
  static async clear(): Promise<void> {
    AppStorage.setOrCreate<string | null>('userToken', null)
    AppStorage.setOrCreate<string | null>('userNickname', null)
    AppStorage.setOrCreate<string | null>('userAvatarUrl', null)
    await StorageUtil.remove('user_token')
    await StorageUtil.remove('user_nickname')
  }

  /** 触发全局强制退出信号 */
  static triggerForceLogout(): void {
    AppStorage.setOrCreate('forceLogout', Date.now())
  }

  /** 更新未读消息数 */
  static setUnreadCount(count: number): void {
    AppStorage.setOrCreate('unreadCount', count)
  }
}
```

### 页面中消费 AppStorage

```typescript
// 在任意 @Component 中读取全局状态
@Entry
@Component
struct ProfilePage {
  @StorageLink('userNickname') nickname: string | null = null
  @StorageLink('userAvatarUrl') avatarUrl: string | null = null
  @StorageLink('unreadCount') unreadCount: number = 0

  build() {
    Column() {
      Image(this.avatarUrl ?? $r('app.media.ic_default_avatar'))
        .width(64).height(64).borderRadius(32)

      Text(this.nickname ?? '未登录')
        .fontSize(18).fontWeight(FontWeight.Medium)

      if (this.unreadCount > 0) {
        Badge({ count: this.unreadCount, style: {} }) {
          Image($r('app.media.ic_message')).width(28).height(28)
        }
      }
    }
  }
}
```

---

## 二、LocalStorage 流程内共享状态（多步表单）

```typescript
// 场景：发布流程分 3 步（填信息 → 选分类 → 预览提交），共享同一份草稿

// state/draftStorage.ets — 定义并导出 LocalStorage 实例
export const draftStorage = new LocalStorage({
  title: '',
  content: '',
  categoryId: '',
  imageUris: [] as string[]
})

// pages/PublishStep1.ets
import { draftStorage } from '../state/draftStorage'

@Entry(draftStorage)
@Component
struct PublishStep1 {
  @LocalStorageLink('title') title: string = ''
  @LocalStorageLink('imageUris') imageUris: string[] = []

  build() {
    TextInput({ text: this.title, placeholder: '请输入标题' })
      .onChange(v => { this.title = v })
  }
}

// pages/PublishStep2.ets — 同一 draftStorage，读上步填写的 title
@Entry(draftStorage)
@Component
struct PublishStep2 {
  @LocalStorageLink('title') title: string = ''
  @LocalStorageLink('categoryId') categoryId: string = ''
  // ...
}
```

---

## 三、@ObservedV2 页面级 ViewModel（最常用）

> 已在 `scaffold/layer-architecture.md` 中详细说明，这里补充嵌套对象响应式的正确写法。

```typescript
// 嵌套对象必须加 @ObservedV2，否则内部字段变化不触发 UI 刷新
@ObservedV2
class Address {
  @Trace city: string = ''
  @Trace street: string = ''
}

@ObservedV2
class UserFormViewModel {
  @Trace name: string = ''
  @Trace address: Address = new Address()  // 嵌套 @ObservedV2 对象

  updateCity(city: string): void {
    this.address.city = city  // 触发 UI 刷新 ✅
  }
}
```

---

## 四、全局配置（主题 / 语言）

```typescript
// state/AppConfig.ets
import { AppStorage } from '@kit.ArkUI'
import { window } from '@kit.ArkUI'

export type Theme = 'light' | 'dark' | 'system'

export class AppConfig {
  static getTheme(): Theme {
    return AppStorage.get<Theme>('theme') ?? 'system'
  }

  static async setTheme(theme: Theme): Promise<void> {
    AppStorage.setOrCreate('theme', theme)
    const win = await window.getLastWindow(getContext(this))
    if (theme === 'dark') {
      await win.setWindowColorMode(window.ColorMode.COLOR_MODE_DARK)
    } else if (theme === 'light') {
      await win.setWindowColorMode(window.ColorMode.COLOR_MODE_LIGHT)
    } else {
      await win.setWindowColorMode(window.ColorMode.COLOR_MODE_NOT_DEFINED)  // 跟随系统
    }
  }
}

// 在设置页使用
AppConfig.setTheme('dark')
```

---

## 状态层选择速查

| 场景                        | 推荐方案                         |
|---------------------------|----------------------------------|
| 登录态 / 用户信息           | `AppStorage` + `UserState`       |
| 401 强制退出信号            | `AppStorage.forceLogout`         |
| 未读数 / 全局角标           | `AppStorage.unreadCount`         |
| 多步骤流程草稿              | `LocalStorage` + `@Entry(store)` |
| 单页加载 / 表单 / 列表      | `@ObservedV2` ViewModel          |
| 嵌套对象响应式              | 嵌套 `@ObservedV2` + `@Trace`    |
| 深色模式主题                | `AppStorage.theme` + `AppConfig` |

## 官方参考
- AppStorage: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-appstorage
- LocalStorage: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-localstorage
- @ObservedV2 / @Trace: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-new-observedv2-and-trace
