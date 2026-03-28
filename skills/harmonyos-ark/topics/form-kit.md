# Form Kit 卡片开发服务（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V5/API 12）
> 覆盖：卡片架构、ArkTS 卡片运行机制、卡片创建与配置、生命周期、数据更新


## 目录

- [Form Kit 简介](#form-kit-简介)
- [卡片架构与运行机制](#卡片架构与运行机制)
- [创建 ArkTS 卡片](#创建-arkts-卡片)
- [配置卡片](#配置卡片)
- [卡片生命周期](#卡片生命周期)
- [卡片数据更新](#卡片数据更新)
- [常见陷阱与最佳实践](#常见陷阱与最佳实践)

---

## Form Kit 简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/formkit-overview-V5

Form Kit（卡片开发框架）提供在桌面、锁屏等系统入口嵌入显示应用信息的能力。

### 核心概念

| 角色 | 说明 |
|------|------|
| **卡片使用方** | 桌面等宿主应用，负责卡片的添加、删除、显示 |
| **卡片提供方** | 提供卡片的应用/元服务，实现卡片 UI、数据更新、点击交互 |
| **卡片管理服务** | 系统服务，作为提供方和使用方的桥梁 |

### 开发模式选择

| 维度 | JS 卡片 | ArkTS 卡片（推荐） |
|------|---------|-------------------|
| 开发范式 | 类 Web 范式 | 声明式范式 |
| 自定义动效 | ❌ | ✅ |
| 自定义绘制 | ❌ | ✅ |
| 逻辑代码执行 | ❌ | ✅ |
| 运行模型 | Stage + FA | Stage（推荐） |

> ⚠️ **推荐 ArkTS 卡片 + Stage 模型**，JS 卡片已不再推荐使用。

### 使用场景

- **信息呈现**：天气、步数、新闻摘要等定时更新
- **服务直达**：快捷操作按钮，一步跳转到应用功能页

### 约束限制

- 仅支持手机、平板设备
- 卡片只能在桌面、锁屏等系统应用上使用
- 卡片 UI 控件范围和动效能力有限制
- 系统对更新频次和后台运行有限制

---

## 卡片架构与运行机制

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-ui-widget-working-principles-V5

### ArkTS 卡片运行机制

ArkTS 卡片框架基于 Stage 模型的 FormExtensionAbility 实现。

**关键架构**：

```
┌─────────────────┐     ┌──────────────────┐     ┌───────────────┐
│  卡片使用方(桌面) │ ←→ │  卡片管理服务      │ ←→ │  卡片提供方(App) │
│                 │     │  FormManagerService│     │  FormExtension │
└─────────────────┘     └──────────────────┘     └───────────────┘
```

**运行特点**：
1. 卡片提供方的 FormExtensionAbility 运行在独立进程中
2. 卡片使用方通过 FormComponent 组件嵌入显示卡片
3. 卡片提供方和使用方通过卡片管理服务进行通信
4. 卡片页面采用 ArkTS + 声明式 UI 开发
5. 卡片页面的渲染在卡片使用方进程完成

### 卡片相关模块

| 模块 | 说明 |
|------|------|
| `FormExtensionAbility` | 卡片生命周期回调，提供方必须实现 |
| `formProvider` | 卡片提供方主动刷新/更新卡片数据 |
| `formInfo` | 卡片信息查询 |
| `formBindingData` | 构造卡片数据绑定对象 |

---

## 创建 ArkTS 卡片

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-ui-widget-creation-V5

### 使用 DevEco Studio 创建

1. 右键点击 entry 目录 → New → Service Widget
2. 选择模板（如 2x2 静态卡片）
3. 自动生成：
   - `src/main/ets/entryformability/EntryFormAbility.ets` — 生命周期
   - `src/main/ets/widget/pages/WidgetCard.ets` — 卡片页面
   - `src/main/resources/base/profile/form_config.json` — 卡片配置

### 手动创建 FormExtensionAbility

```typescript
import { formBindingData, FormExtensionAbility } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // 卡片被添加时触发
    let formData = { title: 'Hello Widget' };
    return formBindingData.createFormBindingData(formData);
  }

  onRemoveForm(formId: string) {
    // 卡片被移除时触发
  }

  onUpdateForm(formId: string) {
    // 定时/定点更新触发
  }
}
```

---

## 配置卡片

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-ui-widget-configuration-V5

### module.json5 配置

```json
{
  "extensionAbilities": [
    {
      "name": "EntryFormAbility",
      "srcEntry": "./ets/entryformability/EntryFormAbility.ets",
      "type": "form",
      "metadata": [
        {
          "name": "ohos.extension.form",
          "resource": "$profile:form_config"
        }
      ]
    }
  ]
}
```

### form_config.json 配置

```json
{
  "forms": [
    {
      "name": "widget",
      "description": "我的卡片",
      "src": "./ets/widget/pages/WidgetCard.ets",
      "uiSyntax": "arkts",
      "window": {
        "designWidth": 720,
        "autoDesignWidth": true
      },
      "colorMode": "auto",
      "isDynamic": true,
      "isDefault": true,
      "updateEnabled": true,
      "scheduledUpdateTime": "10:30",
      "updateDuration": 1,
      "defaultDimension": "2*2",
      "supportDimensions": ["2*2", "2*4", "4*4"]
    }
  ]
}
```

### 关键配置项

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string | 卡片名称，同一应用内唯一 |
| `src` | string | 卡片页面路径 |
| `isDynamic` | boolean | 是否为动态卡片（支持交互） |
| `updateEnabled` | boolean | 是否启用定时更新 |
| `updateDuration` | number | 更新间隔（小时），最小 1 |
| `scheduledUpdateTime` | string | 每日定点更新时间 HH:mm |
| `defaultDimension` | string | 默认尺寸 |
| `supportDimensions` | array | 支持的尺寸列表 |

> ⚠️ `updateDuration` 优先级高于 `scheduledUpdateTime`。设置 `updateDuration` 后 `scheduledUpdateTime` 不生效。

### 卡片尺寸规格

| 规格 | 列数 x 行数 | 典型用途 |
|------|------------|---------|
| 1*2 | 1列2行 | 极简信息 |
| 2*2 | 2列2行 | 小卡片（默认） |
| 2*4 | 2列4行 | 中卡片 |
| 4*4 | 4列4行 | 大卡片 |
| 6*4 | 6列4行 | 超大卡片（平板） |

---

## 卡片生命周期

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-ui-widget-lifecycle-V5

### FormExtensionAbility 生命周期回调

| 回调 | 触发时机 | 必须实现 |
|------|---------|---------|
| `onAddForm` | 卡片被添加到桌面 | ✅ |
| `onRemoveForm` | 卡片被从桌面移除 | 推荐 |
| `onUpdateForm` | 定时/定点更新触发 | 推荐 |
| `onFormEvent` | 卡片中的事件触发（message 事件） | 按需 |
| `onCastToNormalForm` | 临时卡片转为常态卡片 | 按需 |
| `onChangeFormVisibility` | 卡片可见性变化 | 按需 |
| `onConfigurationUpdate` | 系统配置变化（如语言、深色模式） | 按需 |
| `onShareForm` | 跨设备卡片共享 | 按需 |

### 完整生命周期示例

```typescript
import { formBindingData, formInfo, formProvider, FormExtensionAbility } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    let formId = want.parameters?.[formInfo.FormParam.IDENTITY_KEY] as string;
    console.info(`onAddForm, formId: ${formId}`);

    let formData: Record<string, string> = {
      title: '天气',
      detail: '晴 25°C',
    };
    return formBindingData.createFormBindingData(formData);
  }

  onUpdateForm(formId: string) {
    console.info(`onUpdateForm, formId: ${formId}`);
    // 获取最新数据并更新
    let formData: Record<string, string> = {
      title: '天气',
      detail: '多云 22°C',
    };
    let formInfo = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo);
  }

  onRemoveForm(formId: string) {
    console.info(`onRemoveForm, formId: ${formId}`);
    // 清理与该卡片关联的持久化数据
  }

  onFormEvent(formId: string, message: string) {
    console.info(`onFormEvent, formId: ${formId}, message: ${message}`);
    // 处理卡片内按钮点击等事件
  }
}
```

---

## 卡片数据更新

### 定时更新

在 `form_config.json` 中配置 `updateDuration` 或 `scheduledUpdateTime`。

### 主动更新（代理刷新）

```typescript
import { formProvider, formBindingData } from '@kit.FormKit';

// 在应用内任意位置主动更新卡片
let formData: Record<string, string> = { title: '最新数据' };
let formInfo = formBindingData.createFormBindingData(formData);
formProvider.updateForm(formId, formInfo);
```

### 卡片页面开发

```typescript
// WidgetCard.ets
let storage = new LocalStorage();

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('title') title: string = '默认标题';
  @LocalStorageProp('detail') detail: string = '默认内容';

  build() {
    Column() {
      Text(this.title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
      Text(this.detail)
        .fontSize(14)
        .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .onClick(() => {
      // 点击跳转应用
      postCardAction(this, {
        action: 'router',
        abilityName: 'EntryAbility',
        params: { targetPage: 'detail' }
      });
    })
  }
}
```

### 卡片事件交互

```typescript
// 在卡片页面发送 message 事件
postCardAction(this, {
  action: 'message',
  params: { msgType: 'refresh' }
});

// 在 FormExtensionAbility 中处理
onFormEvent(formId: string, message: string) {
  let params = JSON.parse(message);
  if (params.msgType === 'refresh') {
    // 刷新卡片数据
  }
}
```

---

## 常见陷阱与最佳实践

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 卡片不显示 | module.json5 配置错误 | 检查 extensionAbilities type 是否为 "form" |
| 卡片不更新 | updateEnabled 为 false | 确认 form_config.json 配置正确 |
| 点击无响应 | action 类型错误 | router 用于跳转，message 用于事件 |
| 卡片白屏 | 页面路径错误 | 检查 form_config.json 的 src 路径 |
| 数据不同步 | LocalStorage 未正确绑定 | 确保 @Entry(storage) 正确传入 |

### 设计建议

1. **信息精简**：卡片空间有限，展示最核心信息
2. **更新频率**：避免过于频繁更新，updateDuration 最小为 1 小时
3. **交互简单**：卡片交互应以跳转和简单操作为主
4. **适配多尺寸**：至少支持 2x2 和 2x4 两种尺寸
5. **深色模式**：设置 `colorMode: "auto"` 自动适配

---

## See Also

- [routing-lifecycle.md](./routing-lifecycle.md) — 应用生命周期与页面路由
- [arkts.md](./arkts.md) — ArkTS 语言工程硬规范
- [ux-standards.md](./ux-standards.md) — UX 设计规范
