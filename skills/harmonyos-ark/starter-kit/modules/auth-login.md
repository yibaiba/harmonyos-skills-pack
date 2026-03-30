# 登录 / 账号认证模块

> ⚠️ **Router 废弃提醒**: 本模板使用 `router` API，新项目推荐使用 `Navigation` 组件替代（见 `snippets/common-patterns.md` 模式三十四）。

> 覆盖：手机号+验证码登录 / Token 持久化 / 自动跳转 / 退出登录

## EntryAbility — 启动时 Token 检测

```typescript
// entryability/EntryAbility.ets
import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { window } from '@kit.ArkUI'
import { StorageUtil } from '../utils/StorageUtil'

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, 'EntryAbility', 'onCreate')
    await StorageUtil.init(this.context)  // 初始化 Preferences
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'EntryAbility', 'loadContent 失败: %{public}s', JSON.stringify(err))
      }
    })
  }
}
```

## Index.ets — 启动页（自动路由）

```typescript
// pages/Index.ets
import { router } from '@kit.ArkUI'
import { StorageUtil } from '../utils/StorageUtil'

const TOKEN_KEY = 'user_token'

@Entry
@Component
struct Index {
  async aboutToAppear(): Promise<void> {
    const token = await StorageUtil.get<string>(TOKEN_KEY)
    if (token) {
      router.replaceUrl({ url: 'pages/HomePage' })
    } else {
      router.replaceUrl({ url: 'pages/LoginPage' })
    }
  }

  build() {
    Column() {
      LoadingProgress().width(48).height(48)
      Text('加载中...').margin({ top: 12 })
    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

## LoginPage.ets — 登录页

```typescript
// pages/LoginPage.ets
import { router } from '@kit.ArkUI'
import { LoginViewModel } from '../viewmodel/LoginViewModel'

@Entry
@Component
struct LoginPage {
  @State private vm: LoginViewModel = new LoginViewModel()

  build() {
    Column({ space: 16 }) {
      // ── 品牌 logo ──────────────────────────────────
      Image($r('app.media.logo'))
        .width(80).height(80)
        .margin({ top: 60, bottom: 24 })

      // ── 手机号输入 ─────────────────────────────────
      TextInput({ placeholder: '请输入手机号', text: this.vm.phone })
        .type(InputType.PhoneNumber)
        .maxLength(11)
        .onChange(v => { this.vm.phone = v })
        .width('100%')

      // ── 验证码输入 + 发送按钮 ──────────────────────
      Row({ space: 8 }) {
        TextInput({ placeholder: '验证码', text: this.vm.code })
          .type(InputType.Number)
          .maxLength(6)
          .onChange(v => { this.vm.code = v })
          .layoutWeight(1)

        Button(this.vm.countdown > 0 ? `${this.vm.countdown}s` : '获取验证码')
          .enabled(!this.vm.sending && this.vm.countdown === 0)
          .onClick(() => this.vm.sendCode())
          .width(110)
      }.width('100%')

      // ── 错误提示 ───────────────────────────────────
      if (this.vm.errorMsg) {
        Text(this.vm.errorMsg)
          .fontColor($r('app.color.error'))
          .fontSize(13)
          .width('100%')
      }

      // ── 登录按钮 ───────────────────────────────────
      Button('登录')
        .width('100%')
        .enabled(!this.vm.isLoading)
        .onClick(async () => {
          const ok = await this.vm.login()
          if (ok) {
            router.replaceUrl({ url: 'pages/HomePage' })
          }
        })

      if (this.vm.isLoading) {
        LoadingProgress().width(32).height(32)
      }
    }
    .padding({ left: 24, right: 24 })
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}
```

## LoginViewModel.ets

```typescript
// viewmodel/LoginViewModel.ets
import { UserRepository } from '../repository/UserRepository'

const COUNTDOWN_SECONDS = 60

@ObservedV2
export class LoginViewModel {
  @Trace phone: string = ''
  @Trace code: string = ''
  @Trace isLoading: boolean = false
  @Trace sending: boolean = false
  @Trace countdown: number = 0
  @Trace errorMsg: string = ''

  private repo = new UserRepository()
  private timer: number = -1

  async sendCode(): Promise<void> {
    if (!/^1[3-9]\d{9}$/.test(this.phone)) {
      this.errorMsg = '请输入正确的手机号'
      return
    }
    this.sending = true
    try {
      await this.repo.sendVerifyCode(this.phone)
      this.startCountdown()
    } catch (e) {
      this.errorMsg = e?.message ?? '验证码发送失败'
    } finally {
      this.sending = false
    }
  }

  async login(): Promise<boolean> {
    this.errorMsg = ''
    if (this.phone.length !== 11 || this.code.length < 4) {
      this.errorMsg = '手机号或验证码格式错误'
      return false
    }
    this.isLoading = true
    try {
      await this.repo.login(this.phone, this.code)
      return true
    } catch (e) {
      this.errorMsg = e?.message ?? '登录失败，请重试'
      return false
    } finally {
      this.isLoading = false
    }
  }

  private startCountdown(): void {
    this.countdown = COUNTDOWN_SECONDS
    this.timer = setInterval(() => {
      this.countdown -= 1
      if (this.countdown <= 0) {
        clearInterval(this.timer)
      }
    }, 1000)
  }
}
```

## StorageUtil.ets — Preferences 封装

```typescript
// utils/StorageUtil.ets
import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'

const STORE_NAME = 'app_prefs'
let store: preferences.Preferences | null = null

export class StorageUtil {
  static async init(context: common.UIAbilityContext): Promise<void> {
    store = await preferences.getPreferences(context, STORE_NAME)
  }

  static async put<T>(key: string, value: T): Promise<void> {
    await store?.put(key, value as preferences.ValueType)
    await store?.flush()
  }

  static async get<T>(key: string): Promise<T | null> {
    const v = await store?.get(key, null)
    return v as T | null
  }

  static async remove(key: string): Promise<void> {
    await store?.delete(key)
    await store?.flush()
  }
}
```

## 退出登录（在 HomePage / 我的页中调用）

```typescript
// 在任意页面退出登录
import { StorageUtil } from '../utils/StorageUtil'
import { router } from '@kit.ArkUI'

async function logout(): Promise<void> {
  await StorageUtil.remove('user_token')
  router.clear()
  router.replaceUrl({ url: 'pages/LoginPage' })
}
```

## 审核注意事项
- 必须在 `module.json5` 的 `requestPermissions` 声明所用权限
- 账号登录功能需在 AppGallery Connect 开启「账号服务」
- 涉及收集手机号需在隐私声明中说明；参见 topics/incentive-review-2025.md

## 官方参考
- Preferences: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/preferences-guidelines
- UIAbility 生命周期: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/uiability-lifecycle

---

## See Also

- [../../topics/stage-ability.md](../../topics/stage-ability.md) — Stage 模型与 UIAbility
- [../../topics/routing-lifecycle.md](../../topics/routing-lifecycle.md) — 路由与生命周期
- [./data-persistence.md](./data-persistence.md) — 数据持久化
