# HarmonyOS 6.0.0 ArkUI API 变更

> ArkUI 组件/属性/事件 API 新增、变更、废弃清单
> 版本：6.0.0 (API 20)
> 📎 6.0.2 变更见 [harmonyos-6-api-arkui.md](harmonyos-6-api-arkui.md)

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

	

类名：TextAreaAttribute；

API声明：fontWeight(value: number | FontWeight | ResourceStr): TextAreaAttribute;

差异内容：value: number | FontWeight | ResourceStr

	

component/text_area.d.ts




函数变更

	

类名：TextClockAttribute；

API声明：format(value: string): TextClockAttribute;

差异内容：value: string

	

类名：TextClockAttribute；

API声明：format(value: ResourceStr): TextClockAttribute;

差异内容：value: ResourceStr

	

component/text_clock.d.ts




函数变更

	

类名：TextInputAttribute；

API声明：fontWeight(value: number | FontWeight | string): TextInputAttribute;

差异内容：value: number | FontWeight | string

	

类名：TextInputAttribute；

API声明：fontWeight(value: number | FontWeight | ResourceStr): TextInputAttribute;

差异内容：value: number | FontWeight | ResourceStr

	

component/text_input.d.ts




函数变更

	

类名：TextTimerAttribute；

API声明：fontWeight(value: number | FontWeight | string): TextTimerAttribute;

差异内容：value: number | FontWeight | string

	

类名：TextTimerAttribute；

API声明：fontWeight(value: number | FontWeight | ResourceStr): TextTimerAttribute;

差异内容：value: number | FontWeight | ResourceStr

	

component/text_timer.d.ts




函数变更

	

类名：VideoAttribute；

API声明：onError(event: () => void): VideoAttribute;

差异内容：event: () => void

	

类名：VideoAttribute；

API声明：onError(event: VoidCallback | import('../api/@ohos.base').ErrorCallback): VideoAttribute;

差异内容：event: VoidCallback | import('../api/@ohos.base').ErrorCallback

	

component/video.d.ts




函数变更

	

类名：RichEditorController；

API声明：addTextSpan(value: string, options?: RichEditorTextSpanOptions): number;

差异内容：value: string, options?: RichEditorTextSpanOptions

	

类名：RichEditorController；

API声明：addTextSpan(content: ResourceStr, options?: RichEditorTextSpanOptions): number;

差异内容：content: ResourceStr, options?: RichEditorTextSpanOptions

	

component/rich_editor.d.ts




属性变更

	

类名：ProgressButton；

API声明：@Prop

content: string;

差异内容：string

	

类名：ProgressButton；

API声明：@Prop

content: ResourceStr;

差异内容：ResourceStr

	

api/@ohos.arkui.advanced.ProgressButton.d.ets




属性变更

	

类名：SelectOptions；

API声明：value?: string;

差异内容：string

	

类名：SelectOptions；

API声明：value?: ResourceStr;

差异内容：ResourceStr

	

api/@ohos.arkui.advanced.SubHeader.d.ets




属性变更

	

类名：SubHeaderV2SelectOptions；

API声明：selectedContent?: string;

差异内容：string

	

类名：SubHeaderV2SelectOptions；

API声明：selectedContent?: ResourceStr;

差异内容：ResourceStr

	

api/@ohos.arkui.advanced.SubHeaderV2.d.ets




属性变更

	

类名：SubHeaderV2Select；

API声明：@Trace

selectedContent?: string;

差异内容：string

	

类名：SubHeaderV2Select；

API声明：@Trace

selectedContent?: ResourceStr;

差异内容：ResourceStr

	

api/@ohos.arkui.advanced.SubHeaderV2.d.ets




属性变更

	

类名：SwipeRefresher；

API声明：@Prop

content?: string;

差异内容：string

	

类名：SwipeRefresher；

API声明：@Prop

content?: ResourceStr;

差异内容：ResourceStr

	

api/@ohos.arkui.advanced.SwipeRefresher.d.ets


  	  	  	  


属性变更

	

类名：BadgeStyle；

API声明：fontSize?: number | string;

差异内容：number,string

	

类名：BadgeStyle；

API声明：fontSize?: number | ResourceStr;

差异内容：number,ResourceStr

	

component/badge.d.ts




属性变更

	

类名：BadgeStyle；

API声明：badgeSize?: number | string;

差异内容：number,string

	

类名：BadgeStyle；

API声明：badgeSize?: number | ResourceStr;

差异内容：number,ResourceStr

	

component/badge.d.ts




属性变更

	

类名：BadgeStyle；

API声明：fontWeight?: number | FontWeight | string;

差异内容：number,FontWeight,string

	

类名：BadgeStyle；

API声明：fontWeight?: number | FontWeight | ResourceStr;

差异内容：number,FontWeight,ResourceStr

	

component/badge.d.ts




属性变更

	

类名：BadgeParamWithString；

API声明：value: string;

差异内容：string

	

类名：BadgeParamWithString；

API声明：value: ResourceStr;

差异内容：ResourceStr

	

component/badge.d.ts




属性变更

	

类名：CircleOptions；

API声明：width?: string | number;

差异内容：string,number

	

类名：CircleOptions；

API声明：width?: Length;

差异内容：Length

	

component/circle.d.ts




属性变更

	

类名：CircleOptions；

API声明：height?: string | number;

差异内容：string,number

	

类名：CircleOptions；

API声明：height?: Length;

差异内容：Length

	

component/circle.d.ts




属性变更

	

类名：EllipseOptions；

API声明：width?: string | number;

差异内容：string,number

	

类名：EllipseOptions；

API声明：width?: Length;

差异内容：Length

	

component/ellipse.d.ts




属性变更

	

类名：EllipseOptions；

API声明：height?: string | number;

差异内容：string,number

	

类名：EllipseOptions；

API声明：height?: Length;

差异内容：Length

	

component/ellipse.d.ts




属性变更

	

类名：LineOptions；

API声明：width?: string | number;

差异内容：string,number

	

类名：LineOptions；

API声明：width?: Length;

差异内容：Length

	

component/line.d.ts




属性变更

	

类名：LineOptions；

API声明：height?: string | number;

差异内容：string,number

	

类名：LineOptions；

API声明：height?: Length;

差异内容：Length

	

component/line.d.ts




属性变更

	

类名：PathOptions；

API声明：width?: number | string;

差异内容：number,string

	

类名：PathOptions；

API声明：width?: Length;

差异内容：Length

	

component/path.d.ts




属性变更

	

类名：PathOptions；

API声明：height?: number | string;

差异内容：number,string

	

类名：PathOptions；

API声明：height?: Length;

差异内容：Length

	

component/path.d.ts




属性变更

	

类名：PathOptions；

API声明：commands?: string;

差异内容：string

	

类名：PathOptions；

API声明：commands?: ResourceStr;

差异内容：ResourceStr

	

component/path.d.ts




属性变更

	

类名：PolygonOptions；

API声明：width?: string | number;

差异内容：string,number

	

类名：PolygonOptions；

API声明：width?: Length;

差异内容：Length

	

component/polygon.d.ts




属性变更

	

类名：PolygonOptions；

API声明：height?: string | number;

差异内容：string,number

	

类名：PolygonOptions；

API声明：height?: Length;

差异内容：Length

	

component/polygon.d.ts




属性变更

	

类名：PolylineOptions；

API声明：width?: string | number;

差异内容：string,number

	

类名：PolylineOptions；

API声明：width?: Length;

差异内容：Length

	

component/polyline.d.ts




属性变更

	

类名：PolylineOptions；

API声明：height?: string | number;

差异内容：string,number

	

类名：PolylineOptions；

API声明：height?: Length;

差异内容：Length

	

component/polyline.d.ts




属性变更

	

类名：CapsuleStyleOptions；

API声明：content?: string;

差异内容：string

	

类名：CapsuleStyleOptions；

API声明：content?: ResourceStr;

差异内容：ResourceStr

	

component/progress.d.ts




属性变更

	

类名：StarStyleOptions；

API声明：backgroundUri: string;

差异内容：string

	

类名：StarStyleOptions；

API声明：backgroundUri: ResourceStr;

差异内容：ResourceStr

	

component/rating.d.ts




属性变更

	

类名：StarStyleOptions；

API声明：foregroundUri: string;

差异内容：string

	

类名：StarStyleOptions；

API声明：foregroundUri: ResourceStr;

差异内容：ResourceStr

	

component/rating.d.ts




属性变更

	

类名：StarStyleOptions；

API声明：secondaryUri?: string;

差异内容：string

	

类名：StarStyleOptions；

API声明：secondaryUri?: ResourceStr;

差异内容：ResourceStr

	

component/rating.d.ts




属性变更

	

类名：RectOptions；

API声明：width?: number | string;

差异内容：number,string

	

类名：RectOptions；

API声明：width?: Length;

差异内容：Length

	

component/rect.d.ts




属性变更

	

类名：RectOptions；

API声明：height?: number | string;

差异内容：number,string

	

类名：RectOptions；

API声明：height?: Length;

差异内容：Length

	

component/rect.d.ts




属性变更

	

类名：RectOptions；

API声明：radius?: number | string | Array<any>;

差异内容：number,string,Array<any>

	

类名：RectOptions；

API声明：radius?: Length | Array<any>;

差异内容：Length,Array<any>

	

component/rect.d.ts




属性变更

	

类名：RoundedRectOptions；

API声明：width?: number | string;

差异内容：number,string

	

类名：RoundedRectOptions；

API声明：width?: Length;

差异内容：Length

	

component/rect.d.ts




属性变更

	

类名：RoundedRectOptions；

API声明：height?: number | string;

差异内容：number,string

	

类名：RoundedRectOptions；

API声明：height?: Length;

差异内容：Length

	

component/rect.d.ts




属性变更

	

类名：RoundedRectOptions；

API声明：radiusWidth?: number | string;

差异内容：number,string

	

类名：RoundedRectOptions；

API声明：radiusWidth?: Length;

差异内容：Length

	

component/rect.d.ts




属性变更

	

类名：RoundedRectOptions；

API声明：radiusHeight?: number | string;

差异内容：number,string

	

类名：RoundedRectOptions；

API声明：radiusHeight?: Length;

差异内容：Length

	

component/rect.d.ts




属性变更

	

类名：SearchOptions；

API声明：value?: string;

差异内容：string

	

类名：SearchOptions；

API声明：value?: ResourceStr;

差异内容：ResourceStr

	

component/search.d.ts




属性变更

	

类名：ViewportRect；

API声明：x?: number | string;

差异内容：number,string

	

类名：ViewportRect；

API声明：x?: Length;

差异内容：Length

	

component/shape.d.ts




属性变更

	

类名：ViewportRect；

API声明：y?: number | string;

差异内容：number,string

	

类名：ViewportRect；

API声明：y?: Length;

差异内容：Length

	

component/shape.d.ts




属性变更

	

类名：ViewportRect；

API声明：width?: number | string;

差异内容：number,string

	

类名：ViewportRect；

API声明：width?: Length;

差异内容：Length

	

component/shape.d.ts




属性变更

	

类名：ViewportRect；

API声明：height?: number | string;

差异内容：number,string

	

类名：ViewportRect；

API声明：height?: Length;

差异内容：Length

	

component/shape.d.ts




属性变更

	

类名：TextPickerOptions；

API声明：value?: string | string[];

差异内容：string,string[]

	

类名：TextPickerOptions；

API声明：value?: ResourceStr | ResourceStr[];

差异内容：ResourceStr,ResourceStr[]

	

component/text_picker.d.ts




新增API

	

NA

	

类名：global；

API声明：export declare class StepperModifier

差异内容：export declare class StepperModifier

	

api/arkui/StepperModifier.d.ts




新增API

	

NA

	

类名：StepperModifier；

API声明：applyNormalAttribute?(instance: StepperAttribute): void;

差异内容：applyNormalAttribute?(instance: StepperAttribute): void;

	

api/arkui/StepperModifier.d.ts




新增API

	

NA

	

类名：global；

API声明：declare enum ToolBarItemPlacement

差异内容：declare enum ToolBarItemPlacement

	

component/toolbar.d.ts




新增API

	

NA

	

类名：ToolBarItemPlacement；

API声明：TOP_BAR_LEADING = 0

差异内容：TOP_BAR_LEADING = 0

	

component/toolbar.d.ts




新增API

	

NA

	

类名：ToolBarItemPlacement；

API声明：TOP_BAR_TRAILING = 1

差异内容：TOP_BAR_TRAILING = 1

	

component/toolbar.d.ts




新增API

	

NA

	

类名：global；

API声明：interface ToolBarItemOptions

差异内容：interface ToolBarItemOptions

	

<!-- 原始内容共 9378 行，此处截断至 2500 行 -->
<!-- 完整版请访问: https://developer.huawei.com/consumer/cn/doc/harmonyos-releases/js-apidiff-arkui-6001 -->


---

## See Also

- [HarmonyOS 6.0.2 ArkUI API 变更](harmonyos-6-api-arkui.md)
- [HarmonyOS 6.0 版本概览与新特性](harmonyos-6-overview.md)
