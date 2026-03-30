# 深色模式 + 多端响应式适配

> 覆盖：深色 Color Token / 媒体查询断点 / 折叠屏 / 自适应布局 / 验收清单

## 断点定义（与 DESIGN.md §1.2 保持一致）

| 设备     | 断点      | module.json5 deviceType |
|---------|-----------|------------------------|
| 手机     | < 600vp   | phone                  |
| 平板     | 600-840vp | tablet                 |
| PC/折叠  | ≥ 840vp   | 2in1                   |

## 第一步：Color Token 双主题配置

### AppScope/resources/base/element/color.json（亮色）
```json
{
  "color": [
    { "name": "background",       "value": "#F5F5F5" },
    { "name": "card_background",  "value": "#FFFFFF" },
    { "name": "primary",          "value": "#007AFF" },
    { "name": "text_primary",     "value": "#191919" },
    { "name": "text_secondary",   "value": "#999999" },
    { "name": "error",            "value": "#FF3B30" },
    { "name": "disabled",         "value": "#CCCCCC" },
    { "name": "divider",          "value": "#E5E5E5" },
    { "name": "skeleton",         "value": "#EBEBEB" }
  ]
}
```

### AppScope/resources/dark/element/color.json（深色覆盖）
```json
{
  "color": [
    { "name": "background",       "value": "#1C1C1E" },
    { "name": "card_background",  "value": "#2C2C2E" },
    { "name": "primary",          "value": "#0A84FF" },
    { "name": "text_primary",     "value": "#EBEBF5" },
    { "name": "text_secondary",   "value": "#8E8E93" },
    { "name": "error",            "value": "#FF453A" },
    { "name": "disabled",         "value": "#48484A" },
    { "name": "divider",          "value": "#38383A" },
    { "name": "skeleton",         "value": "#3A3A3C" }
  ]
}
```

> **规则：** 所有颜色使用 `$r('app.color.xxx')` 引用，**禁止硬编码 hex 值**。系统会根据当前主题自动选择对应 color.json。

## 第二步：响应式断点工具

```typescript
// utils/BreakpointUtil.ets
import { mediaquery } from '@kit.ArkUI'

export type Breakpoint = 'phone' | 'tablet' | 'pc'

@ObservedV2
export class BreakpointSystem {
  @Trace current: Breakpoint = 'phone'

  private phoneListener = mediaquery.matchMediaSync('(max-width: 599vp)')
  private tabletListener = mediaquery.matchMediaSync('(min-width: 600vp) and (max-width: 839vp)')
  private pcListener = mediaquery.matchMediaSync('(min-width: 840vp)')

  start(): void {
    this.phoneListener.on('change',  (e) => { if (e.matches) this.current = 'phone' })
    this.tabletListener.on('change', (e) => { if (e.matches) this.current = 'tablet' })
    this.pcListener.on('change',     (e) => { if (e.matches) this.current = 'pc' })
  }

  stop(): void {
    this.phoneListener.off('change')
    this.tabletListener.off('change')
    this.pcListener.off('change')
  }
}

// 全局单例，在 EntryAbility.onCreate 中调用 bp.start()
export const bp = new BreakpointSystem()
```

## 第三步：在 EntryAbility 启动断点监听

```typescript
// entryability/EntryAbility.ets — 追加
import { bp } from '../utils/BreakpointUtil'

export default class EntryAbility extends UIAbility {
  onCreate(...) {
    bp.start()
  }
  onDestroy() {
    bp.stop()
  }
}
```

## 第四步：页面中使用断点（响应式布局示例）

```typescript
// pages/HomePage.ets — 多端响应式列表
import { bp } from '../utils/BreakpointUtil'

@Entry
@Component
struct HomePage {
  // ...

  /** 根据断点计算每行列数 */
  get columns(): number {
    if (bp.current === 'pc') return 3
    if (bp.current === 'tablet') return 2
    return 1
  }

  /** 根据断点决定侧边栏显示 */
  get showSidebar(): boolean {
    return bp.current !== 'phone'
  }

  build() {
    if (this.showSidebar) {
      // 平板/PC：左侧边栏 + 右内容区
      Row() {
        this.buildSidebar()
        Divider().vertical(true).height('100%')
        this.buildMainContent()
      }.width('100%').height('100%')
    } else {
      // 手机：全屏内容
      this.buildMainContent()
    }
  }

  @Builder buildSidebar() {
    Column() {
      Text('分类').fontSize(16).fontWeight(FontWeight.Bold).padding(16)
      // ... 分类导航
    }
    .width(bp.current === 'pc' ? 240 : 180)
    .height('100%')
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder buildMainContent() {
    // WaterFlow 自适应列数
    WaterFlow() {
      // ...
    }
    .columnsTemplate(this.columns === 3 ? '1fr 1fr 1fr'
      : this.columns === 2 ? '1fr 1fr' : '1fr')
    .layoutWeight(1)
  }
}
```

## 第五步：深色模式动态切换（可选，用户手动切换）

```typescript
// 在设置页中允许用户手动覆盖系统主题
import { window } from '@kit.ArkUI'

async function setDarkMode(isDark: boolean): Promise<void> {
  const win = await window.getLastWindow(getContext(this))
  await win.setWindowColorMode(isDark
    ? window.ColorMode.COLOR_MODE_DARK
    : window.ColorMode.COLOR_MODE_LIGHT)
}
```

## 折叠屏适配要点

```typescript
// 监听折叠状态变化
import { display } from '@kit.ArkUI'

display.on('foldStatusChange', (foldStatus: display.FoldStatus) => {
  if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
    // 展开态：按 PC 断点处理，增加侧边布局
  } else {
    // 折叠态：按手机断点处理
  }
})
```

## 验收清单（快速自检）

```
深色模式
  [ ] 所有颜色均使用 $r('app.color.xxx')，无硬编码 hex
  [ ] dark/element/color.json 已覆盖所有 token
  [ ] 图片/图标在深色下仍清晰可见（使用带透明通道的 PNG 或矢量图）
  [ ] Toast / Dialog / BottomSheet 背景也参与深色切换

多端布局
  [ ] module.json5 deviceTypes 包含 phone、tablet、2in1
  [ ] BreakpointSystem 在 EntryAbility 已 start()
  [ ] 手机（< 600vp）：单列、全屏内容区
  [ ] 平板（600-840vp）：双列或左侧导航
  [ ] PC（≥ 840vp）：三列或完整侧栏
  [ ] 关键页面在模拟器三种尺寸下截图无布局溢出
  [ ] 文字大小 / 间距使用 vp 单位，不使用 px

折叠屏
  [ ] 已监听 foldStatusChange，展开/折叠时更新布局
  [ ] 悬停态（HALF_FOLDED）有合理处理（上下分屏或忽略）
```

## 官方参考
- 深色模式: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-dynamic-color
- 媒体查询: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-mediaquery
- 自适应布局: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-layout-development-multi-device
- 折叠屏适配: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-foldable-screen-adaptation
- 多设备设计指南: https://developer.huawei.com/consumer/cn/doc/design-guides/phone-0000001776694632

---

## See Also

- [UX 体验标准（必须条款）](../../topics/ux-standards.md)
- [ArkUI 主题规范](../../topics/arkui.md)
- [多端深色模式检查清单](../../checklists/universal-product-design-suggestions.md)
