# @ComponentV2 迁移指南 — V1 → V2 状态管理

<!-- Agent 摘要：~330 行。V1(@Component) → V2(@ComponentV2) 迁移决策矩阵、装饰器映射、
     代码示例、混用规则与当前限制。适用于 API 12+。
     基础状态管理 → state-management.md；高级用法 → state-management-advanced.md。 -->

## 目录

- [概述](#概述)
- [何时迁移](#何时迁移)
- [装饰器映射表](#装饰器映射表)
- [迁移代码示例](#迁移代码示例)
- [混用规则](#混用规则)
- [V2 当前限制](#v2-当前限制)
- [迁移检查清单](#迁移检查清单)
- [参考链接](#参考链接)

## Official Entrypoints

- 状态管理 V2 概述: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-statemanagement-overview-V5
- @ComponentV2: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-componentv2-V5
- V1→V2 迁移指导: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-v1-v2-migration-V5
- V1/V2 混用文档: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-v1-v2-coexistence-V5

---

## 概述

@ComponentV2 是 HarmonyOS NEXT（API 12+）引入的 V2 状态管理框架，提供：

- **深度观测**：@ObservedV2 + @Trace 实现属性级精确追踪，无需整对象刷新
- **显式数据流**：@Param + @Event 取代 @Link 隐式双向绑定，数据流向一目了然
- **计算属性**：@Computed 自动缓存派生值，多次引用只计算一次
- **更精确的监听**：@Monitor 提供 before/now 值对比，多次变化仅取最终值触发一次

**V1 (@Component) 并未废弃**，两者长期共存。核心原则：**同一功能模块内保持一致**——不要在同一个模块中混用 V1 和 V2 装饰器，除非有明确的技术理由。

---

## 何时迁移

| 场景 | 推荐 | 原因 |
|------|------|------|
| 新项目（API 12+） | ✅ V2 (@ComponentV2) | 观测更精确、数据流更显式 |
| 现有 V1 项目，运行正常 | ⏸ 保持 V1 | 强制迁移无收益，徒增风险 |
| 需要深层对象观测 | ✅ V2 | @ObservedV2 + @Trace 原生解决 |
| 需要 @Reusable 组件复用 | ❌ 留在 V1 | V2 暂不支持 @Reusable |
| 需要 withTheme 局部主题 | ❌ 留在 V1 | V2 暂不支持 withTheme |
| 需要高级组件（DownloadFileButton 等） | ❌ 留在 V1 | V2 暂不支持这些组件 |
| 复杂动画场景（animateTo） | ⚠️ V1 优先 | 部分 V2 + animateTo 组合效果异常 |

---

## 装饰器映射表

| V1 | V2 | 关键差异 |
|----|----|---------| 
| @Component | @ComponentV2 | V2 组件内只能用 V2 装饰器 |
| @State | @Local | @Local **不可**从外部初始化 |
| @State（外部初始化） | @Param @Once | 仅初始化时同步一次 |
| @Prop | @Param | @Param 是引用传递；@Prop 是深拷贝 |
| @Link | @Param + @Event | V2 用显式事件实现双向同步 |
| @ObjectLink | @Param | @Param 无 @Observed 类型限制 |
| @Provide | @Provider | 兼容，用法一致 |
| @Consume | @Consumer | 兼容，用法一致 |
| @Watch | @Monitor | 深度监听；一次事件多次变化仅取最终值 |
| @Observed | @ObservedV2 | @ObservedV2 需搭配 @Trace 标记字段 |
| @Track | @Trace | V2 精确字段级追踪 |
| （无） | @Computed | V2 新增，计算属性缓存 |
| `$$` | `!!` | 双向绑定语法糖 |
| LocalStorage | 全局 @ObservedV2 + @Trace | V2 无 LocalStorage 等价物，用全局可观测对象替代 |
| AppStorage | AppStorageV2 | 兼容 |
| PersistentStorage | PersistenceV2 | V2 持久化可独立使用，不依赖 AppStorageV2 |
| Environment | Ability 接口获取 | V2 解除与 AppStorage 的耦合 |
| @CustomDialog | openCustomDialog | V2 推荐命令式弹窗 |

---

## 迁移代码示例

### 4.1 基础组件状态：@State → @Local

```typescript
// ── V1 ──
@Component
struct CounterV1 {
  @State count: number = 0

  build() {
    Column() {
      Text(`Count: ${this.count}`)
      Button('+1').onClick(() => { this.count++ })
    }
  }
}

// ── V2 ──
@ComponentV2
struct CounterV2 {
  @Local count: number = 0

  build() {
    Column() {
      Text(`Count: ${this.count}`)
      Button('+1').onClick(() => { this.count++ })
    }
  }
}
```

> ⚠️ @Local 不可从父组件传入初始值。若需外部初始化一次，用 `@Param @Once`。

### 4.2 父→子单向传递：@Prop → @Param

```typescript
// ── V1 ──
@Component
struct ChildV1 {
  @Prop title: string = ''
  build() { Text(this.title) }
}

// ── V2 ──
@ComponentV2
struct ChildV2 {
  @Param title: string = ''
  build() { Text(this.title) }
}
```

> ⚠️ 关键差异：@Prop 是深拷贝，@Param 是引用。对复杂对象的修改会反映到源数据。

### 4.3 双向绑定：@Link → @Param + @Event

```typescript
// ── V1 ──
@Component
struct ToggleV1 {
  @Link isOn: boolean

  build() {
    Toggle({ type: ToggleType.Switch, isOn: this.isOn })
      .onChange((value: boolean) => { this.isOn = value })
  }
}
// 父组件使用: ToggleV1({ isOn: $isOn })

// ── V2 ──
@ComponentV2
struct ToggleV2 {
  @Param isOn: boolean = false
  @Event onToggle: (value: boolean) => void = (value: boolean) => {}

  build() {
    Toggle({ type: ToggleType.Switch, isOn: this.isOn })
      .onChange((value: boolean) => { this.onToggle(value) })
  }
}
// 父组件使用: ToggleV2({ isOn: this.isOn, onToggle: (v: boolean) => { this.isOn = v } })
```

> 💡 V2 的 @Param + @Event 让数据流向更明确，比 @Link 隐式双向绑定更可控。

### 4.4 跨层级共享：@Provide/@Consume → @Provider/@Consumer

```typescript
// ── V1 ──
@Component
struct ParentV1 {
  @Provide('theme') theme: string = 'light'
  build() { ChildV1() }
}
@Component
struct ChildV1 {
  @Consume('theme') theme: string
  build() { Text(this.theme) }
}

// ── V2 ──
@ComponentV2
struct ParentV2 {
  @Provider('theme') theme: string = 'light'
  build() { ChildV2() }
}
@ComponentV2
struct ChildV2 {
  @Consumer('theme') theme: string = 'light'
  build() { Text(this.theme) }
}
```

### 4.5 深度监听：@Watch → @Monitor

```typescript
// ── V1 ──
@Component
struct WatchDemoV1 {
  @State @Watch('onCountChange') count: number = 0

  onCountChange(): void {
    console.info(`count changed to ${this.count}`)
  }

  build() { Text(`${this.count}`) }
}

// ── V2 ──
@ComponentV2
struct MonitorDemoV2 {
  @Local count: number = 0

  @Monitor('count')
  onCountChange(mon: IMonitor): void {
    console.info(`count: ${mon.value()?.before} → ${mon.value()?.now}`)
  }

  build() { Text(`${this.count}`) }
}
```

> 💡 @Monitor 提供 before/now 值对比，且同一事件循环内多次变化只触发一次（取最终值）。

### 4.6 计算属性：（无 V1 对应）→ @Computed

```typescript
@ComponentV2
struct PriceSummary {
  @Local price: number = 100
  @Local quantity: number = 3

  @Computed
  get total(): number {
    return this.price * this.quantity
  }

  build() {
    Text(`Total: ¥${this.total}`)  // UI 多次引用只计算一次
  }
}
```

### 4.7 ViewModel 模式（V1/V2 通用）

```typescript
@ObservedV2
class UserViewModel {
  @Trace name: string = ''
  @Trace age: number = 0
  @Trace isLoading: boolean = false

  async loadUser(id: string): Promise<void> {
    this.isLoading = true
    // ... fetch logic
    this.isLoading = false
  }
}

// V1 使用
@Component
struct UserPageV1 {
  @State vm: UserViewModel = new UserViewModel()
  build() { Text(this.vm.name) }
}

// V2 使用
@ComponentV2
struct UserPageV2 {
  @Local vm: UserViewModel = new UserViewModel()
  build() { Text(this.vm.name) }
}
```

> 💡 @ObservedV2 + @Trace 的 ViewModel 可在 V1/V2 组件中通用，是渐进式迁移的最佳桥梁。

---

## 混用规则

### 硬性规则

1. ❌ @ComponentV2 内**不能**使用 V1 装饰器（@State、@Prop、@Link、@Provide、@Consume、@Watch）
2. ❌ @Component 内**不能**使用 V2 装饰器（@Local、@Param、@Event、@Once、@Monitor、@Provider、@Consumer、@Computed）
3. ✅ @ComponentV2 子组件可以放在 @Component 父组件内（反之亦然）
4. ✅ @ObservedV2 + @Trace 的 class 可在 V1 和 V2 组件中共用
5. ✅ 同一页面可以同时包含 @Component 和 @ComponentV2 组件

### 推荐策略

- **新模块 / 新页面**：统一用 V2
- **旧模块**：保持 V1，不强制迁移
- **共享数据层**：用 @ObservedV2 + @Trace（两边通用）
- ⚠️ V1 parent → V2 child 传数据时，V2 child 用 @Param 接收（不能用 @Link）
- ⚠️ V2 parent → V1 child 传数据时，V1 child 可正常使用 @Prop / @Link

---

## V2 当前限制

- ❌ 不支持 @Reusable（组件复用）
- ❌ 不支持 withTheme（局部主题风格）
- ❌ 不支持高级组件（DownloadFileButton、ProgressButton、SegmentButton）
- ⚠️ animateTo 在某些 V2 场景下效果异常，推荐用 `this.getUIContext()?.animateTo()` 替代
- ⚠️ @Local 不可外部初始化（与 @State 不同），需要外部值请用 @Param @Once

---

## 迁移检查清单

- [ ] 确认目标 API Level ≥ 12
- [ ] 确认不需要 @Reusable / withTheme / 高级组件
- [ ] 将 @Component → @ComponentV2
- [ ] 将 @State → @Local（内部状态）或 @Param @Once（需外部初始化一次）
- [ ] 将 @Prop → @Param
- [ ] 将 @Link → @Param + @Event
- [ ] 将 @Provide/@Consume → @Provider/@Consumer
- [ ] 将 @Watch → @Monitor（注意参数类型变为 IMonitor）
- [ ] 将 `$$` 双向绑定 → `!!`
- [ ] 将 @CustomDialog → openCustomDialog
- [ ] 验证 animateTo 效果正常
- [ ] 运行全量编译确认无类型错误

---

## 参考链接

| 主题 | 链接 |
|------|------|
| 状态管理 V2 概述 | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-statemanagement-overview-V5 |
| @ComponentV2 | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-componentv2-V5 |
| @Local | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-local-V5 |
| @Param | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-param-V5 |
| @Event | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-event-V5 |
| @Monitor | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-monitor-V5 |
| @Computed | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-computed-V5 |
| @Provider/@Consumer | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-provider-and-consumer-V5 |
| @ObservedV2/@Trace | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-new-observedv2-and-trace-V5 |
| V1→V2 迁移指导 | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-v1-v2-migration-V5 |
| V1/V2 混用文档 | https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-v1-v2-coexistence-V5 |
