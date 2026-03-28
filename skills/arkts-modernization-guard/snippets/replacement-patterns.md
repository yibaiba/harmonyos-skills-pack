# ArkTS 现代化替换模板

<!-- Agent 摘要：常见 ArkTS 坏模式→好模式的代码替换片段。Agent 可直接复制应用。搜索: replacement pattern deprecated fix template。 -->

## AMG-001: @Prop 函数回调 → 普通成员

```diff
// ❌ 错误
@Component
struct Child {
-  @Prop onTap: () => void
+  onTap: () => void = () => {}
   build() {
     Button('Click').onClick(() => this.onTap())
   }
}
```

## AMG-002: build() 内非 DSL 代码 → 抽到私有方法

```diff
@Entry
@Component
struct Page {
+  private getData(): string {
+    return 'computed value'
+  }
+
   build() {
-    let data = 'computed value'  // ❌ build 内禁止赋值
     Column() {
-      Text(data)
+      Text(this.getData())
     }
   }
}
```

## AMG-003: FontWeight.Black → FontWeight.Bolder

```diff
Text('Title')
-  .fontWeight(FontWeight.Black)
+  .fontWeight(FontWeight.Bolder)
```

## AMG-004: LengthMetrics 类型别名 → 数值或对象

```diff
// ❌ LengthMetrics 不可作为值调用
-padding(LengthMetrics.vp(16))

// ✅ 直接传数值（默认 vp）
+padding(16)

// ✅ 或显式对象
+padding({ value: 16, unit: LengthUnit.VP })
```

## AMG-005: spread 刷新 → 显式方法

```diff
// ❌ 触发全量重渲染
-this.list = [...this.list]

// ✅ 数组
+this.list = this.list.slice()

// ❌ 对象展开
-this.config = { ...this.config, key: value }

// ✅ 显式字段复制
+this.config.key = value
+// 如需触发 @Observed 刷新，使用 @Track 标记字段
```

## AMG-006: 缺 try-catch → 包裹异常处理

```diff
// ❌ 编译器 WARN: Function may throw exceptions
-const store = await preferences.getPreferences(context, 'settings')
-const value = await store.get('key', 'default')

// ✅ try-catch 包裹
+try {
+  const store = await preferences.getPreferences(context, 'settings')
+  const value = await store.get('key', 'default')
+} catch (err) {
+  hilog.error(0x0000, 'Prefs', 'Failed: %{public}s', JSON.stringify(err))
+}
```

## AMG-007: 动态 $r() → 静态字面量

```diff
// ❌ 变量拼接
-let iconName = 'ic_' + type
-Image($r('app.media.' + iconName))

// ✅ 静态字面量 + 条件分支
+Image(type === 'home'
+  ? $r('app.media.ic_home')
+  : $r('app.media.ic_default'))
```

## AMG-008: deprecated API 替换

### router.pushUrl → Navigation

```diff
// ❌ deprecated
-import router from '@ohos.router'
-router.pushUrl({ url: 'pages/Detail', params: { id: 123 } })

// ✅ Navigation + NavPathStack
+@Entry
+@Component
+struct Index {
+  navStack: NavPathStack = new NavPathStack()
+  build() {
+    Navigation(this.navStack) { /* ... */ }
+      .navDestination(this.PageMap)
+  }
+  @Builder PageMap(name: string) {
+    if (name === 'Detail') { DetailPage() }
+  }
+}
+// 跳转
+this.navStack.pushPathByName('Detail', { id: 123 })
```

### animateTo → UIContext.animateTo

```diff
// ❌ deprecated
-animateTo({ duration: 300, curve: Curve.EaseOut }, () => {
-  this.opacity = 1.0
-})

// ✅ UIContext 版本
+this.getUIContext().animateTo(
+  { duration: 300, curve: Curve.EaseOut },
+  () => { this.opacity = 1.0 }
+)
```

### promptAction → UIContext 版本

```diff
// ❌ deprecated
-import promptAction from '@ohos.promptAction'
-promptAction.showToast({ message: '已保存' })

// ✅ UIContext 版本
+this.getUIContext().getPromptAction().showToast({ message: '已保存' })
```

## AMG-009: 未验证 sys.symbol → 已确认可用名

```diff
// ❌ 可能不存在
-SymbolGlyph($r('sys.symbol.trophy'))
-SymbolGlyph($r('sys.symbol.doc_on_doc'))

// ✅ 使用已验证可用的符号名（DevEco 搜索确认）
+SymbolGlyph($r('sys.symbol.star_fill'))
+SymbolGlyph($r('sys.symbol.doc_text'))
```

> 使用前请在 DevEco Studio 的符号资源面板中搜索确认名称存在。

---

## See Also

- [../references/error-to-fix-map.md](../references/error-to-fix-map.md) — 错误码速查
- [../../harmonyos-ark/topics/arkts-error-prevention.md](../../harmonyos-ark/topics/arkts-error-prevention.md) — 历史报错档案
