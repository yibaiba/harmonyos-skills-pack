# HarmonyOS 6.0.0 ArkUI API 变更（续）

> 本文件从 harmonyos-6-api-arkui-v600.md 拆分而来
> 内容：6.0.0 (API 20) ArkUI 后半部分变更

<!-- Agent 摘要：本文件 1266 行，为 6.0.0 ArkUI 后半部分 API 变更明细。
     前半部分 → harmonyos-6-api-arkui-v600.md。
     按组件名或 d.ts 文件名搜索定位。 -->

	

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

- [harmonyos-6-api-arkui-v600.md](./harmonyos-6-api-arkui-v600.md) — 6.0.0 ArkUI 变更（前半）
- [harmonyos-6-api-arkui.md](./harmonyos-6-api-arkui.md) — 6.0.2 ArkUI 变更
- [harmonyos-6-overview.md](./harmonyos-6-overview.md) — 6.0 新特性总览
