<!-- Agent Summary: PasteButton 读剪贴板 + SaveButton 写媒体库，点击即许可，无权限弹窗。约束与限制 + 完整代码示例。 -->
# 安全控件 Security Components（离线参考）

> 来源：华为 HarmonyOS 开发者文档
> 覆盖：安全控件概述、PasteButton 粘贴控件、SaveButton 保存控件、约束与限制

## 概述

安全控件是系统提供的 ArkUI 基础组件，包括 **PasteButton**（粘贴控件）和 **SaveButton**（保存控件）。
实现"点击即许可"的场景化授权，无需动态申请权限弹窗。

**核心优势**：
- 用户掌握授权时机，授权范围最小化
- 授权场景匹配用户真实意图
- 减少弹窗打扰，提升体验

**运作机制**：
应用集成安全控件 → ArkUI 框架生成控件 → 注册到安全控件管理服务 → 用户点击 → 临时授权 → 回调 `onClick` → 应用调用特权操作

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/security-component-overview

---

## PasteButton（粘贴控件）

- **功能**：静默读取剪贴板数据，无弹窗
- **授权周期**：持续到灭屏 / 切后台 / 退出
- **调用次数**：授权期间无限制
- **使用场景**：验证码粘贴、文本粘贴等

```typescript
import { pasteboard, BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct PasteExample {
  @State message: string = '';

  build() {
    Column({ space: 10 }) {
      TextInput({ placeholder: $r('app.string.input_verify_code'), text: this.message })
        .onChange((val: string) => {
          this.message = val;
        })
      PasteButton()
        .padding({ top: 12, bottom: 12, left: 24, right: 24 })
        .onClick((event: ClickEvent, result: PasteButtonOnClickResult) => {
          if (PasteButtonOnClickResult.SUCCESS === result) {
            pasteboard.getSystemPasteboard().getData((err: BusinessError, pasteData: pasteboard.PasteData) => {
              if (err) {
                console.error(`Failed to get paste data. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              this.message = pasteData.getPrimaryText();
            });
          }
        })
    }.width('100%')
  }
}
```

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/pastebutton
**API 参考**: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-security-components-pastebutton

---

## SaveButton（保存控件）

- **功能**：临时获取媒体库写入权限，无需权限弹窗
- **授权周期**：API 19 及之前为 10 秒；API 20 及之后为 1 分钟
- **调用次数**：每次点击仅获取一次授权
- **首次使用**：弹窗请求授权，允许后后续不再弹窗
- **限制**：仅支持主窗口和子窗口，不支持 UIExtension
- **自定义**：需申请 `ohos.permission.CUSTOMIZE_SAVE_BUTTON` 权限

```typescript
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

async function savePhotoToGallery(context: common.UIAbilityContext): Promise<void> {
  let helper = photoAccessHelper.getPhotoAccessHelper(context);
  try {
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
    let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    context.resourceManager.getMediaContent($r('app.media.test').id, 0)
      .then(async (value: Uint8Array) => {
        let media = value.buffer;
        await fileIo.write(file.fd, media);
        await fileIo.close(file.fd);
        promptAction.openToast({ message: $r('app.string.saved_in_photo') });
      });
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to save photo. Code is ${err.code}, message is ${err.message}`);
  }
}

@Entry
@Component
struct SaveExample {
  build() {
    Column({ space: 10 }) {
      Image($r('app.media.test'))
        .height(400)
        .width('100%')
      SaveButton()
        .padding({ top: 12, bottom: 12, left: 24, right: 24 })
        .onClick((event: ClickEvent, result: SaveButtonOnClickResult) => {
          if (result === SaveButtonOnClickResult.SUCCESS) {
            const context: common.UIAbilityContext =
              this.getUIContext().getHostContext() as common.UIAbilityContext;
            savePhotoToGallery(context);
          } else {
            promptAction.openToast({ message: $r('app.string.set_permission_failed') });
          }
        })
    }.width('100%')
  }
}
```

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/savebutton
**API 参考**: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-security-components-savebutton

---

## 约束与限制

以下情况会导致安全控件授权失败（所有安全控件通用）：

- 字体 / 图标尺寸过小
- 安全控件整体尺寸过大
- 字体 / 图标 / 背景颜色透明度过高
- 字体或图标与背景颜色过于相似
- 控件超出屏幕 / 窗口，显示不全
- 控件被其他组件或窗口遮挡
- 父组件有变形 / 模糊等导致显示不完整的属性

> **Debug tip**: 过滤关键字 `SecurityComponentCheckFail` 查看具体失败原因。

---

## Agent 决策表

| 场景 | 推荐方案 | 说明 |
|------|---------|------|
| 读剪贴板 | PasteButton | 无弹窗，即点即用 |
| 保存图片/视频到媒体库 | SaveButton | 首次弹窗，后续无弹窗 |
| 保存文件到用户指定目录 | Picker | SaveButton 仅支持媒体库 |
| 需要长期存储权限 | 动态权限申请 | 安全控件为临时授权 |

---

## See Also

- [ArkUI 组件开发](arkui-components.md)
- [权限管控](acl-permissions.md)
