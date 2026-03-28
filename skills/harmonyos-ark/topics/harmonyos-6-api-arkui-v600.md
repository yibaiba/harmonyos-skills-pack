# HarmonyOS 6.0.0 ArkUI API 变更

> ArkUI 组件/属性/事件 API 新增、变更、废弃清单
> 版本：6.0.0 (API 20)
> 📎 6.0.2 变更见 [harmonyos-6-api-arkui.md](harmonyos-6-api-arkui.md)

<!-- Agent 摘要：本文件 1270 行，为 6.0.0 ArkUI API 前半部分变更明细。
     后半部分 → harmonyos-6-api-arkui-v600-part2.md。
     6.0.2 版本变更 → harmonyos-6-api-arkui.md。
     按组件名或 d.ts 文件名搜索定位。 -->

## 6.0.0 (API 20) ArkUI 变更

操作

	

旧版本

	

新版本

	

d.ts文件




API废弃版本变更

	

类名：global；

API声明：export declare class NavigatorModifier

差异内容：NA

	

类名：global；

API声明：export declare class NavigatorModifier

差异内容：20

	

api/arkui/NavigatorModifier.d.ts




API废弃版本变更

	

类名：NavigatorModifier；

API声明：applyNormalAttribute?(instance: NavigatorAttribute): void;

差异内容：NA

	

类名：NavigatorModifier；

API声明：applyNormalAttribute?(instance: NavigatorAttribute): void;

差异内容：20

	

api/arkui/NavigatorModifier.d.ts




API废弃版本变更

	

类名：global；

API声明：export declare class NavRouterModifier

差异内容：NA

	

类名：global；

API声明：export declare class NavRouterModifier

差异内容：20

	

api/arkui/NavRouterModifier.d.ts




API废弃版本变更

	

类名：NavRouterModifier；

API声明：applyNormalAttribute?(instance: NavRouterAttribute): void;

差异内容：NA

	

类名：NavRouterModifier；

API声明：applyNormalAttribute?(instance: NavRouterAttribute): void;

差异内容：20

	

api/arkui/NavRouterModifier.d.ts




API废弃版本变更

	

类名：global；

API声明：export declare class PanelModifier

差异内容：NA

	

类名：global；

API声明：export declare class PanelModifier

差异内容：20

	

api/arkui/PanelModifier.d.ts




API废弃版本变更

	

类名：PanelModifier；

API声明：applyNormalAttribute?(instance: PanelAttribute): void;

差异内容：NA

	

类名：PanelModifier；

API声明：applyNormalAttribute?(instance: PanelAttribute): void;

差异内容：20

	

api/arkui/PanelModifier.d.ts




新增错误码

	

类名：ClickEvent；

API声明：preventDefault: () => void;

差异内容：NA

	

类名：ClickEvent；

API声明：preventDefault: () => void;

差异内容：100017

	

component/common.d.ts




新增错误码

	

类名：TouchEvent；

API声明：preventDefault: () => void;

差异内容：NA

	

类名：TouchEvent；

API声明：preventDefault: () => void;

差异内容：100017

	

component/common.d.ts




新增错误码

	

类名：PromptAction；

API声明：closeToast(toastId: number): void;

差异内容：NA

	

类名：PromptAction；

API声明：closeToast(toastId: number): void;

差异内容：103401

	

api/@ohos.arkui.UIContext.d.ts




新增错误码

	

类名：promptAction；

API声明：function closeToast(toastId: number): void;

差异内容：NA

	

类名：promptAction；

API声明：function closeToast(toastId: number): void;

差异内容：103401

	

api/@ohos.promptAction.d.ts




新增错误码

	

类名：Window；

API声明：setSubWindowModal(isModal: boolean): Promise<void>;

差异内容：NA

	

类名：Window；

API声明：setSubWindowModal(isModal: boolean): Promise<void>;

差异内容：1300003

	

api/@ohos.window.d.ts




新增错误码

	

类名：Window；

API声明：setSubWindowModal(isModal: boolean, modalityType: ModalityType): Promise<void>;

差异内容：NA

	

类名：Window；

API声明：setSubWindowModal(isModal: boolean, modalityType: ModalityType): Promise<void>;

差异内容：1300003

	

api/@ohos.window.d.ts




新增错误码

	

类名：WindowStage；

API声明：setWindowModal(isModal: boolean): Promise<void>;

差异内容：NA

	

类名：WindowStage；

API声明：setWindowModal(isModal: boolean): Promise<void>;

差异内容：1300005

	

api/@ohos.window.d.ts




新增错误码

	

类名：WindowStage；

API声明：isWindowRectAutoSave(): Promise<boolean>;

差异内容：NA

	

类名：WindowStage；

API声明：isWindowRectAutoSave(): Promise<boolean>;

差异内容：1300003

	

api/@ohos.window.d.ts




新增错误码

	

类名：CanvasRenderingContext2D；

API声明：startImageAnalyzer(config: ImageAnalyzerConfig): Promise<void>;

差异内容：NA

	

类名：CanvasRenderingContext2D；

API声明：startImageAnalyzer(config: ImageAnalyzerConfig): Promise<void>;

差异内容：110003

	

component/canvas.d.ts




新增错误码

	

类名：StyledString；

API声明：static fromHtml(html: string): Promise<StyledString>;

差异内容：NA

	

类名：StyledString；

API声明：static fromHtml(html: string): Promise<StyledString>;

差异内容：170001

	

component/styled_string.d.ts




删除错误码

	

类名：Window；

API声明：destroyWindow(callback: AsyncCallback<void>): void;

差异内容：1300003

	

类名：Window；

API声明：destroyWindow(callback: AsyncCallback<void>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：destroyWindow(): Promise<void>;

差异内容：1300003

	

类名：Window；

API声明：destroyWindow(): Promise<void>;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：loadContent(path: string, storage: LocalStorage, callback: AsyncCallback<void>): void;

差异内容：1300003

	

类名：Window；

API声明：loadContent(path: string, storage: LocalStorage, callback: AsyncCallback<void>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：loadContent(path: string, storage: LocalStorage): Promise<void>;

差异内容：1300003

	

类名：Window；

API声明：loadContent(path: string, storage: LocalStorage): Promise<void>;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：setUIContent(path: string, callback: AsyncCallback<void>): void;

差异内容：1300003

	

类名：Window；

API声明：setUIContent(path: string, callback: AsyncCallback<void>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：setUIContent(path: string): Promise<void>;

差异内容：1300003

	

类名：Window；

API声明：setUIContent(path: string): Promise<void>;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：maximize(presentation?: MaximizePresentation): Promise<void>;

差异内容：1300005

	

类名：Window；

API声明：maximize(presentation?: MaximizePresentation): Promise<void>;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：setWindowDecorVisible(isVisible: boolean): void;

差异内容：1300004

	

类名：Window；

API声明：setWindowDecorVisible(isVisible: boolean): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：Window；

API声明：setTitleAndDockHoverShown(isTitleHoverShown?: boolean, isDockHoverShown?: boolean): Promise<void>;

差异内容：401

	

类名：Window；

API声明：setTitleAndDockHoverShown(isTitleHoverShown?: boolean, isDockHoverShown?: boolean): Promise<void>;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：createSubWindow(name: string): Promise<Window>;

差异内容：1300005

	

类名：WindowStage；

API声明：createSubWindow(name: string): Promise<Window>;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：createSubWindow(name: string, callback: AsyncCallback<Window>): void;

差异内容：1300005

	

类名：WindowStage；

API声明：createSubWindow(name: string, callback: AsyncCallback<Window>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：loadContent(path: string, storage: LocalStorage, callback: AsyncCallback<void>): void;

差异内容：1300005

	

类名：WindowStage；

API声明：loadContent(path: string, storage: LocalStorage, callback: AsyncCallback<void>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：loadContent(path: string, storage?: LocalStorage): Promise<void>;

差异内容：1300005

	

类名：WindowStage；

API声明：loadContent(path: string, storage?: LocalStorage): Promise<void>;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：loadContent(path: string, callback: AsyncCallback<void>): void;

差异内容：1300005

	

类名：WindowStage；

API声明：loadContent(path: string, callback: AsyncCallback<void>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：loadContentByName(name: string, storage: LocalStorage, callback: AsyncCallback<void>): void;

差异内容：1300003

	

类名：WindowStage；

API声明：loadContentByName(name: string, storage: LocalStorage, callback: AsyncCallback<void>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：loadContentByName(name: string, callback: AsyncCallback<void>): void;

差异内容：1300003

	

类名：WindowStage；

API声明：loadContentByName(name: string, callback: AsyncCallback<void>): void;

差异内容：NA

	

api/@ohos.window.d.ts




删除错误码

	

类名：WindowStage；

API声明：loadContentByName(name: string, storage?: LocalStorage): Promise<void>;

差异内容：1300003

	

类名：WindowStage；

API声明：loadContentByName(name: string, storage?: LocalStorage): Promise<void>;

差异内容：NA

	

api/@ohos.window.d.ts




错误码变更

	

类名：WindowStage；

API声明：getSubWindow(): Promise<Array<Window>>;

差异内容：1300005

	

类名：WindowStage；

API声明：getSubWindow(): Promise<Array<Window>>;

差异内容：1300002

	

api/@ohos.window.d.ts




错误码变更

	

类名：WindowStage；

API声明：getSubWindow(callback: AsyncCallback<Array<Window>>): void;

差异内容：1300005

	

类名：WindowStage；

API声明：getSubWindow(callback: AsyncCallback<Array<Window>>): void;

差异内容：1300002

	

api/@ohos.window.d.ts




函数变更

	

类名：PathAttribute；

API声明：commands(value: string): PathAttribute;

差异内容：value: string

	

类名：PathAttribute；

API声明：commands(value: ResourceStr): PathAttribute;

差异内容：value: ResourceStr

	

component/path.d.ts




函数变更

	

类名：RectAttribute；

API声明：radiusWidth(value: number | string): RectAttribute;

差异内容：value: number | string

	

类名：RectAttribute；

API声明：radiusWidth(value: Length): RectAttribute;

差异内容：value: Length

	

component/rect.d.ts




函数变更

	

类名：RectAttribute；

API声明：radiusHeight(value: number | string): RectAttribute;

差异内容：value: number | string

	

类名：RectAttribute；

API声明：radiusHeight(value: Length): RectAttribute;

差异内容：value: Length

	

component/rect.d.ts




函数变更

	

类名：RectAttribute；

API声明：radius(value: number | string | Array<any>): RectAttribute;

差异内容：value: number | string | Array<any>

	

类名：RectAttribute；

API声明：radius(value: Length | Array<any>): RectAttribute;

差异内容：value: Length | Array<any>

	

component/rect.d.ts




函数变更

	

类名：SearchAttribute；

API声明：searchButton(value: string, option?: SearchButtonOptions): SearchAttribute;

差异内容：value: string

	

类名：SearchAttribute；

API声明：searchButton(value: ResourceStr, option?: SearchButtonOptions): SearchAttribute;

差异内容：value: ResourceStr

	

component/search.d.ts




函数变更

	

类名：ShapeAttribute；

API声明：strokeDashOffset(value: number | string): ShapeAttribute;

差异内容：value: number | string

	

类名：ShapeAttribute；

API声明：strokeDashOffset(value: Length): ShapeAttribute;

差异内容：value: Length

	

component/shape.d.ts




函数变更

	

类名：ShapeAttribute；

API声明：strokeMiterLimit(value: number | string): ShapeAttribute;

差异内容：value: number | string

	

类名：ShapeAttribute；

API声明：strokeMiterLimit(value: Length): ShapeAttribute;

差异内容：value: Length

	

component/shape.d.ts




函数变更

	

类名：ShapeAttribute；

API声明：strokeWidth(value: number | string): ShapeAttribute;

差异内容：value: number | string

	

类名：ShapeAttribute；

API声明：strokeWidth(value: Length): ShapeAttribute;

差异内容：value: Length

	

component/shape.d.ts




函数变更

	

类名：SpanAttribute；

API声明：fontWeight(value: number | FontWeight | string): SpanAttribute;

差异内容：value: number | FontWeight | string

	

类名：SpanAttribute；

API声明：fontWeight(value: number | FontWeight | ResourceStr): SpanAttribute;

差异内容：value: number | FontWeight | ResourceStr

	

component/span.d.ts




函数变更

	

类名：SpanAttribute；

API声明：letterSpacing(value: number | string): SpanAttribute;

差异内容：value: number | string

	

类名：SpanAttribute；

API声明：letterSpacing(value: number | ResourceStr): SpanAttribute;

差异内容：value: number | ResourceStr

	

component/span.d.ts




函数变更

	

类名：TextAttribute；

API声明：fontWeight(value: number | FontWeight | string): TextAttribute;

差异内容：value: number | FontWeight | string

	

类名：TextAttribute；

API声明：fontWeight(value: number | FontWeight | ResourceStr): TextAttribute;

差异内容：value: number | FontWeight | ResourceStr

	

component/text.d.ts




函数变更

	

类名：TextAttribute；

API声明：fontWeight(weight: number | FontWeight | string, options?: FontSettingOptions): TextAttribute;

差异内容：weight: number | FontWeight | string

	

类名：TextAttribute；

API声明：fontWeight(weight: number | FontWeight | ResourceStr, options?: FontSettingOptions): TextAttribute;

差异内容：weight: number | FontWeight | ResourceStr

	

component/text.d.ts




函数变更

	

类名：TextAttribute；

API声明：letterSpacing(value: number | string): TextAttribute;

差异内容：value: number | string

	

类名：TextAttribute；

API声明：letterSpacing(value: number | ResourceStr): TextAttribute;

差异内容：value: number | ResourceStr

	

component/text.d.ts




函数变更

	

类名：TextAttribute；

API声明：baselineOffset(value: number | string): TextAttribute;

差异内容：value: number | string

	

类名：TextAttribute；

API声明：baselineOffset(value: number | ResourceStr): TextAttribute;

差异内容：value: number | ResourceStr

	

component/text.d.ts




函数变更

	

类名：TextAreaAttribute；

API声明：fontWeight(value: number | FontWeight | string): TextAreaAttribute;

差异内容：value: number | FontWeight | string


---

> 📎 后续变更见 [harmonyos-6-api-arkui-v600-part2.md](./harmonyos-6-api-arkui-v600-part2.md)

## See Also

- [harmonyos-6-api-arkui-v600-part2.md](./harmonyos-6-api-arkui-v600-part2.md) — 6.0.0 ArkUI 变更（续）
- [harmonyos-6-api-arkui.md](./harmonyos-6-api-arkui.md) — 6.0.2 ArkUI 变更
- [harmonyos-6-overview.md](./harmonyos-6-overview.md) — 6.0 新特性总览
