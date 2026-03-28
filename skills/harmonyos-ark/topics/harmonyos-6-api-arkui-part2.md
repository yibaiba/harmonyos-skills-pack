# HarmonyOS 6.0.2 ArkUI API 变更（续）

> 本文件从 harmonyos-6-api-arkui.md 拆分而来
> 内容：6.0.2 (API 22) ArkUI 后半部分变更

<!-- Agent 摘要：本文件 1595 行，为 6.0.2 ArkUI 后半部分 API 变更明细。
     前半部分 → harmonyos-6-api-arkui.md。
     不需要通读全文，按组件名或 d.ts 文件名搜索定位。 -->

	component/enums.d.ts
新增API	NA	

类名：global；

API声明：declare enum ResponseRegionSupportedTool

差异内容：declare enum ResponseRegionSupportedTool

	component/enums.d.ts
新增API	NA	

类名：ResponseRegionSupportedTool；

API声明：ALL = 0

差异内容：ALL = 0

	component/enums.d.ts
新增API	NA	

类名：ResponseRegionSupportedTool；

API声明：FINGER = 1

差异内容：FINGER = 1

	component/enums.d.ts
新增API	NA	

类名：ResponseRegionSupportedTool；

API声明：PEN = 2

差异内容：PEN = 2

	component/enums.d.ts
新增API	NA	

类名：ResponseRegionSupportedTool；

API声明：MOUSE = 3

差异内容：MOUSE = 3

	component/enums.d.ts
新增API	NA	

类名：global；

API声明：declare interface ImageAlt

差异内容：declare interface ImageAlt

	component/image.d.ts
新增API	NA	

类名：ImageAlt；

API声明：placeholder?: ResourceStr | PixelMap;

差异内容：placeholder?: ResourceStr | PixelMap;

	component/image.d.ts
新增API	NA	

类名：ImageAlt；

API声明：error?: ResourceStr | PixelMap;

差异内容：error?: ResourceStr | PixelMap;

	component/image.d.ts
新增API	NA	

类名：global；

API声明：declare enum ScrollSnapAnimationSpeed

差异内容：declare enum ScrollSnapAnimationSpeed

	component/list.d.ts
新增API	NA	

类名：ScrollSnapAnimationSpeed；

API声明：NORMAL = 0

差异内容：NORMAL = 0

	component/list.d.ts
新增API	NA	

类名：ScrollSnapAnimationSpeed；

API声明：SLOW = 1

差异内容：SLOW = 1

	component/list.d.ts
新增API	NA	

类名：ListAttribute；

API声明：scrollSnapAnimationSpeed(speed: ScrollSnapAnimationSpeed): ListAttribute;

差异内容：scrollSnapAnimationSpeed(speed: ScrollSnapAnimationSpeed): ListAttribute;

	component/list.d.ts
新增API	NA	

类名：Scroller；

API声明：contentSize(): SizeResult;

差异内容：contentSize(): SizeResult;

	component/scroll.d.ts
新增API	NA	

类名：SearchAttribute；

API声明：enableSelectedDataDetector(enable: boolean | undefined): SearchAttribute;

差异内容：enableSelectedDataDetector(enable: boolean | undefined): SearchAttribute;

	component/search.d.ts
新增API	NA	

类名：global；

API声明：declare type DrawableDescriptor = import('../api/@ohos.arkui.drawableDescriptor').DrawableDescriptor;

差异内容：declare type DrawableDescriptor = import('../api/@ohos.arkui.drawableDescriptor').DrawableDescriptor;

	component/tab_content.d.ts
新增API	NA	

类名：global；

API声明：declare interface DrawableTabBarIndicator

差异内容：declare interface DrawableTabBarIndicator

	component/tab_content.d.ts
新增API	NA	

类名：DrawableTabBarIndicator；

API声明：drawable?: DrawableDescriptor;

差异内容：drawable?: DrawableDescriptor;

	component/tab_content.d.ts
新增API	NA	

类名：DrawableTabBarIndicator；

API声明：width?: Length;

差异内容：width?: Length;

	component/tab_content.d.ts
新增API	NA	

类名：DrawableTabBarIndicator；

API声明：height?: Length;

差异内容：height?: Length;

	component/tab_content.d.ts
新增API	NA	

类名：DrawableTabBarIndicator；

API声明：borderRadius?: Length;

差异内容：borderRadius?: Length;

	component/tab_content.d.ts
新增API	NA	

类名：DrawableTabBarIndicator；

API声明：marginTop?: Length;

差异内容：marginTop?: Length;

	component/tab_content.d.ts
新增API	NA	

类名：TextAreaAttribute；

API声明：scrollBarColor(thumbColor: ColorMetrics | undefined): TextAreaAttribute;

差异内容：scrollBarColor(thumbColor: ColorMetrics | undefined): TextAreaAttribute;

	component/text_area.d.ts
新增API	NA	

类名：TextAreaAttribute；

API声明：enableSelectedDataDetector(enable: boolean | undefined): TextAreaAttribute;

差异内容：enableSelectedDataDetector(enable: boolean | undefined): TextAreaAttribute;

	component/text_area.d.ts
新增API	NA	

类名：TextAreaAttribute；

API声明：onWillAttachIME(callback: Callback<IMEClient> | undefined): TextAreaAttribute;

差异内容：onWillAttachIME(callback: Callback<IMEClient> | undefined): TextAreaAttribute;

	component/text_area.d.ts
新增API	NA	

类名：TextInputAttribute；

API声明：enableSelectedDataDetector(enable: boolean | undefined): TextInputAttribute;

差异内容：enableSelectedDataDetector(enable: boolean | undefined): TextInputAttribute;

	component/text_input.d.ts
新增API	NA	

类名：TabContentInfo；

API声明：lastIndex?: number;

差异内容：lastIndex?: number;

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：uiObserver；

API声明：export class WindowSizeLayoutBreakpointInfo

差异内容：export class WindowSizeLayoutBreakpointInfo

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：WindowSizeLayoutBreakpointInfo；

API声明：readonly widthBreakpoint: WidthBreakpoint;

差异内容：readonly widthBreakpoint: WidthBreakpoint;

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：WindowSizeLayoutBreakpointInfo；

API声明：readonly heightBreakpoint: HeightBreakpoint;

差异内容：readonly heightBreakpoint: HeightBreakpoint;

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：uiObserver；

API声明：export interface TextChangeEventInfo

差异内容：export interface TextChangeEventInfo

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：TextChangeEventInfo；

API声明：id: string;

差异内容：id: string;

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：TextChangeEventInfo；

API声明：uniqueId: number;

差异内容：uniqueId: number;

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：TextChangeEventInfo；

API声明：content: string;

差异内容：content: string;

	api/@ohos.arkui.observer.d.ts
新增API	NA	

类名：UIUtils；

API声明：static applySync<T>(task: TaskCallback): T;

差异内容：static applySync<T>(task: TaskCallback): T;

	api/@ohos.arkui.StateManagement.d.ts
新增API	NA	

类名：UIUtils；

API声明：static flushUpdates(): void;

差异内容：static flushUpdates(): void;

	api/@ohos.arkui.StateManagement.d.ts
新增API	NA	

类名：UIUtils；

API声明：static flushUIUpdates(): void;

差异内容：static flushUIUpdates(): void;

	api/@ohos.arkui.StateManagement.d.ts
新增API	NA	

类名：global；

API声明：declare type TaskCallback = () => T;

差异内容：declare type TaskCallback = () => T;

	api/@ohos.arkui.StateManagement.d.ts
新增API	NA	

类名：display；

API声明：function getBrightnessInfo(displayId: number): BrightnessInfo;

差异内容：function getBrightnessInfo(displayId: number): BrightnessInfo;

	api/@ohos.display.d.ts
新增API	NA	

类名：display；

API声明：type BrightnessCallback<T1, T2> = (data1: T1, data2: T2) => void;

差异内容：type BrightnessCallback<T1, T2> = (data1: T1, data2: T2) => void;

	api/@ohos.display.d.ts
新增API	NA	

类名：display；

API声明：function on(type: 'brightnessInfoChange', callback: BrightnessCallback<number, BrightnessInfo>): void;

差异内容：function on(type: 'brightnessInfoChange', callback: BrightnessCallback<number, BrightnessInfo>): void;

	api/@ohos.display.d.ts
新增API	NA	

类名：display；

API声明：function off(type: 'brightnessInfoChange', callback?: BrightnessCallback<number, BrightnessInfo>): void;

差异内容：function off(type: 'brightnessInfoChange', callback?: BrightnessCallback<number, BrightnessInfo>): void;

	api/@ohos.display.d.ts
新增API	NA	

类名：VirtualScreenConfig；

API声明：supportsFocus?: boolean;

差异内容：supportsFocus?: boolean;

	api/@ohos.display.d.ts
新增API	NA	

类名：display；

API声明：interface BrightnessInfo

差异内容：interface BrightnessInfo

	api/@ohos.display.d.ts
新增API	NA	

类名：BrightnessInfo；

API声明：readonly sdrNits: number;

差异内容：readonly sdrNits: number;

	api/@ohos.display.d.ts
新增API	NA	

类名：BrightnessInfo；

API声明：readonly currentHeadroom: number;

差异内容：readonly currentHeadroom: number;

	api/@ohos.display.d.ts
新增API	NA	

类名：BrightnessInfo；

API声明：readonly maxHeadroom: number;

差异内容：readonly maxHeadroom: number;

	api/@ohos.display.d.ts
新增API	NA	

类名：PiPConfiguration；

API声明：handleId?: number;

差异内容：handleId?: number;

	api/@ohos.PiPWindow.d.ts
新增API	NA	

类名：PiPConfiguration；

API声明：cornerAdsorptionEnabled?: boolean;

差异内容：cornerAdsorptionEnabled?: boolean;

	api/@ohos.PiPWindow.d.ts
新增API	NA	

类名：PiPController；

API声明：on(type: 'activeStatusChange', callback: Callback<boolean>): void;

差异内容：on(type: 'activeStatusChange', callback: Callback<boolean>): void;

	api/@ohos.PiPWindow.d.ts
新增API	NA	

类名：PiPController；

API声明：off(type: 'activeStatusChange', callback?: Callback<boolean>): void;

差异内容：off(type: 'activeStatusChange', callback?: Callback<boolean>): void;

	api/@ohos.PiPWindow.d.ts
新增API	NA	

类名：global；

API声明：export class ReactiveBuilderNode

差异内容：export class ReactiveBuilderNode

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：build(builder: WrappedBuilder<Args>, config: BuildOptions, ...args: Args): void;

差异内容：build(builder: WrappedBuilder<Args>, config: BuildOptions, ...args: Args): void;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：getFrameNode(): FrameNode | null;

差异内容：getFrameNode(): FrameNode | null;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：postTouchEvent(event: TouchEvent): boolean;

差异内容：postTouchEvent(event: TouchEvent): boolean;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：dispose(): void;

差异内容：dispose(): void;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：reuse(param?: Object): void;

差异内容：reuse(param?: Object): void;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：recycle(): void;

差异内容：recycle(): void;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：updateConfiguration(): void;

差异内容：updateConfiguration(): void;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：flushState(): void;

差异内容：flushState(): void;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：postInputEvent(event: InputEventType): boolean;

差异内容：postInputEvent(event: InputEventType): boolean;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：inheritFreezeOptions(enabled: boolean): void;

差异内容：inheritFreezeOptions(enabled: boolean): void;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：ReactiveBuilderNode；

API声明：isDisposed(): boolean;

差异内容：isDisposed(): boolean;

	api/arkui/BuilderNode.d.ts
新增API	NA	

类名：global；

API声明：export class ReactiveComponentContent

差异内容：export class ReactiveComponentContent

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：ReactiveComponentContent；

API声明：reuse(param?: Object): void;

差异内容：reuse(param?: Object): void;

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：ReactiveComponentContent；

API声明：recycle(): void;

差异内容：recycle(): void;

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：ReactiveComponentContent；

API声明：dispose(): void;

差异内容：dispose(): void;

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：ReactiveComponentContent；

API声明：updateConfiguration(): void;

差异内容：updateConfiguration(): void;

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：ReactiveComponentContent；

API声明：flushState(): void;

差异内容：flushState(): void;

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：ReactiveComponentContent；

API声明：inheritFreezeOptions(enabled: boolean): void;

差异内容：inheritFreezeOptions(enabled: boolean): void;

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：ReactiveComponentContent；

API声明：isDisposed(): boolean;

差异内容：isDisposed(): boolean;

	api/arkui/ComponentContent.d.ts
新增API	NA	

类名：BadgeStyle；

API声明：outerBorderColor?: ResourceColor;

差异内容：outerBorderColor?: ResourceColor;

	component/badge.d.ts
新增API	NA	

类名：BadgeStyle；

API声明：outerBorderWidth?: LengthMetrics;

差异内容：outerBorderWidth?: LengthMetrics;

	component/badge.d.ts
新增API	NA	

类名：BadgeStyle；

API声明：enableAutoAvoidance?: boolean;

差异内容：enableAutoAvoidance?: boolean;

	component/badge.d.ts
新增API	NA	

类名：LongPressGestureHandlerOptions；

API声明：allowableMovement?: number;

差异内容：allowableMovement?: number;

	component/gesture.d.ts
新增API	NA	

类名：LongPressRecognizer；

API声明：getAllowableMovement(): number;

差异内容：getAllowableMovement(): number;

	component/gesture.d.ts
新增API	NA	

类名：ImageSpanAttribute；

API声明：supportSvg2(enable: Optional<boolean>): ImageSpanAttribute;

差异内容：supportSvg2(enable: Optional<boolean>): ImageSpanAttribute;

	component/image_span.d.ts
新增API	NA	

类名：global；

API声明：declare type InterceptionCallback = (from: NavPathInfo | NavBar, to: NavPathInfo | NavBar, pathStack: NavPathStack, operation: NavigationOperation, isAnimated: boolean) => void;

差异内容：declare type InterceptionCallback = (from: NavPathInfo | NavBar, to: NavPathInfo | NavBar, pathStack: NavPathStack, operation: NavigationOperation, isAnimated: boolean) => void;

	component/navigation.d.ts
新增API	NA	

类名：NavigationInterception；

API声明：interception?: InterceptionCallback;

差异内容：interception?: InterceptionCallback;

	component/navigation.d.ts
新增API	NA	

类名：NavDestinationContext；

API声明：mode?: NavDestinationMode;

差异内容：mode?: NavDestinationMode;

	component/nav_destination.d.ts
新增API	NA	

类名：global；

API声明：declare type Vector2T<T> = import('../api/arkui/Graphics').Vector2T<T>;

差异内容：declare type Vector2T<T> = import('../api/arkui/Graphics').Vector2T<T>;

	component/particle.d.ts
新增API	NA	

类名：ParticleAttribute；

API声明：rippleFields(fields: Array<RippleFieldOptions> | undefined): ParticleAttribute;

差异内容：rippleFields(fields: Array<RippleFieldOptions> | undefined): ParticleAttribute;

	component/particle.d.ts
新增API	NA	

类名：ParticleAttribute；

API声明：velocityFields(fields: Array<VelocityFieldOptions> | undefined): ParticleAttribute;

差异内容：velocityFields(fields: Array<VelocityFieldOptions> | undefined): ParticleAttribute;

	component/particle.d.ts
新增API	NA	

类名：global；

API声明：declare interface FieldRegion

差异内容：declare interface FieldRegion

	component/particle.d.ts
新增API	NA	

类名：FieldRegion；

API声明：shape?: DisturbanceFieldShape;

差异内容：shape?: DisturbanceFieldShape;

	component/particle.d.ts
新增API	NA	

类名：FieldRegion；

API声明：position?: PositionT<number>;

差异内容：position?: PositionT<number>;

	component/particle.d.ts
新增API	NA	

类名：FieldRegion；

API声明：size?: SizeT<number>;

差异内容：size?: SizeT<number>;

	component/particle.d.ts
新增API	NA	

类名：global；

API声明：declare interface RippleFieldOptions

差异内容：declare interface RippleFieldOptions

	component/particle.d.ts
新增API	NA	

类名：RippleFieldOptions；

API声明：amplitude?: number;

差异内容：amplitude?: number;

	component/particle.d.ts
新增API	NA	

类名：RippleFieldOptions；

API声明：wavelength?: number;

差异内容：wavelength?: number;

	component/particle.d.ts
新增API	NA	

类名：RippleFieldOptions；

API声明：waveSpeed?: number;

差异内容：waveSpeed?: number;

	component/particle.d.ts
新增API	NA	

类名：RippleFieldOptions；

API声明：attenuation?: number;

差异内容：attenuation?: number;

	component/particle.d.ts
新增API	NA	

类名：RippleFieldOptions；

API声明：center?: PositionT<number>;

差异内容：center?: PositionT<number>;

	component/particle.d.ts
新增API	NA	

类名：RippleFieldOptions；

API声明：region?: FieldRegion;

差异内容：region?: FieldRegion;

	component/particle.d.ts
新增API	NA	

类名：global；

API声明：declare interface VelocityFieldOptions

差异内容：declare interface VelocityFieldOptions

	component/particle.d.ts
新增API	NA	

类名：VelocityFieldOptions；

API声明：velocity?: Vector2T<number>;

差异内容：velocity?: Vector2T<number>;

	component/particle.d.ts
新增API	NA	

类名：VelocityFieldOptions；

API声明：region?: FieldRegion;

差异内容：region?: FieldRegion;

	component/particle.d.ts
新增API	NA	

类名：RichEditorAttribute；

API声明：enableSelectedDataDetector(enable: boolean | undefined): RichEditorAttribute;

差异内容：enableSelectedDataDetector(enable: boolean | undefined): RichEditorAttribute;

	component/rich_editor.d.ts
新增API	NA	

类名：RichEditorAttribute；

API声明：onWillAttachIME(callback: Callback<IMEClient> | undefined): RichEditorAttribute;

差异内容：onWillAttachIME(callback: Callback<IMEClient> | undefined): RichEditorAttribute;

	component/rich_editor.d.ts
新增API	NA	

类名：SecurityComponentMethod；

API声明：focusBox(style: FocusBoxStyle): T;

差异内容：focusBox(style: FocusBoxStyle): T;

	component/security_component.d.ts
新增API	NA	

类名：ParagraphStyle；

API声明：readonly leadingMarginSpan?: LeadingMarginSpan;

差异内容：readonly leadingMarginSpan?: LeadingMarginSpan;

	component/styled_string.d.ts
新增API	NA	

类名：ParagraphStyleInterface；

API声明：leadingMarginSpan?: LeadingMarginSpan;

差异内容：leadingMarginSpan?: LeadingMarginSpan;

	component/styled_string.d.ts
新增API	NA	

类名：ImageAttachment；

API声明：readonly supportSvg2?: boolean;

差异内容：readonly supportSvg2?: boolean;

	component/styled_string.d.ts
新增API	NA	

类名：ResourceImageAttachmentOptions；

API声明：supportSvg2?: boolean;

差异内容：supportSvg2?: boolean;

	component/styled_string.d.ts
新增API	NA	

类名：global；

API声明：declare interface LeadingMarginSpanDrawInfo

差异内容：declare interface LeadingMarginSpanDrawInfo

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：x: number;

差异内容：x: number;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：top: number;

差异内容：top: number;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：bottom: number;

差异内容：bottom: number;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：baseline: number;

差异内容：baseline: number;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：direction: TextDirection;

差异内容：direction: TextDirection;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：start: number;

差异内容：start: number;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：end: number;

差异内容：end: number;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpanDrawInfo；

API声明：first: boolean;

差异内容：first: boolean;

	component/styled_string.d.ts
新增API	NA	

类名：global；

API声明：declare abstract class LeadingMarginSpan

差异内容：declare abstract class LeadingMarginSpan

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpan；

API声明：abstract onDraw(context: DrawContext, drawInfo: LeadingMarginSpanDrawInfo): void;

差异内容：abstract onDraw(context: DrawContext, drawInfo: LeadingMarginSpanDrawInfo): void;

	component/styled_string.d.ts
新增API	NA	

类名：LeadingMarginSpan；

API声明：abstract getLeadingMargin(): LengthMetrics;

差异内容：abstract getLeadingMargin(): LengthMetrics;

	component/styled_string.d.ts
新增API	NA	

类名：TextAttribute；

API声明：minLineHeight(value: LengthMetrics | undefined): TextAttribute;

差异内容：minLineHeight(value: LengthMetrics | undefined): TextAttribute;

	component/text.d.ts
新增API	NA	

类名：TextAttribute；

API声明：maxLineHeight(value: LengthMetrics | undefined): TextAttribute;

差异内容：maxLineHeight(value: LengthMetrics | undefined): TextAttribute;

	component/text.d.ts
新增API	NA	

类名：TextAttribute；

API声明：lineHeightMultiple(value: number | undefined): TextAttribute;

差异内容：lineHeightMultiple(value: number | undefined): TextAttribute;

	component/text.d.ts
新增API	NA	

类名：TextAttribute；

API声明：minLines(minLines: Optional<number>): TextAttribute;

差异内容：minLines(minLines: Optional<number>): TextAttribute;

	component/text.d.ts
新增API	NA	

类名：TextAttribute；

API声明：enableSelectedDataDetector(enable: boolean | undefined): TextAttribute;

差异内容：enableSelectedDataDetector(enable: boolean | undefined): TextAttribute;

	component/text.d.ts
新增API	NA	

类名：global；

API声明：declare type InputMethodExtraConfig = import('../api/@ohos.inputMethod.ExtraConfig').InputMethodExtraConfig;

差异内容：declare type InputMethodExtraConfig = import('../api/@ohos.inputMethod.ExtraConfig').InputMethodExtraConfig;

	component/text_common.d.ts
新增API	NA	

类名：global；

API声明：declare enum TextDirection

差异内容：declare enum TextDirection

	component/text_common.d.ts
新增API	NA	

类名：TextDirection；

API声明：LTR = 0

差异内容：LTR = 0

	component/text_common.d.ts
新增API	NA	

类名：TextDirection；

API声明：RTL = 1

差异内容：RTL = 1

	component/text_common.d.ts
新增API	NA	

类名：IMEClient；

API声明：setExtraConfig(config: InputMethodExtraConfig): void;

差异内容：setExtraConfig(config: InputMethodExtraConfig): void;

	component/text_common.d.ts
新增API	NA	

类名：global；

API声明：declare interface CacheCountInfo

差异内容：declare interface CacheCountInfo

	component/units.d.ts
新增API	NA	

类名：CacheCountInfo；

API声明：minCount: number;

差异内容：minCount: number;

	component/units.d.ts
新增API	NA	

类名：CacheCountInfo；

API声明：maxCount: number;

差异内容：maxCount: number;

	component/units.d.ts
新增API	NA	

类名：global；

API声明：declare type ResponsiveFillType = PresetFillType;

差异内容：declare type ResponsiveFillType = PresetFillType;

	component/units.d.ts
新增API	NA	

类名：global；

API声明：declare interface ItemFillPolicy

差异内容：declare interface ItemFillPolicy

	component/units.d.ts
新增API	NA	

类名：ItemFillPolicy；

API声明：fillType?: ResponsiveFillType;

差异内容：fillType?: ResponsiveFillType;

	component/units.d.ts
新增API	NA	

类名：PlaybackSpeed；

API声明：SPEED_FORWARD_0_50_X = 5

差异内容：SPEED_FORWARD_0_50_X = 5

	component/video.d.ts
新增API	NA	

类名：PlaybackSpeed；

API声明：SPEED_FORWARD_1_50_X = 6

差异内容：SPEED_FORWARD_1_50_X = 6

	component/video.d.ts
新增API	NA	

类名：PlaybackSpeed；

API声明：SPEED_FORWARD_3_00_X = 7

差异内容：SPEED_FORWARD_3_00_X = 7

	component/video.d.ts
新增API	NA	

类名：PlaybackSpeed；

API声明：SPEED_FORWARD_0_25_X = 8

差异内容：SPEED_FORWARD_0_25_X = 8

	component/video.d.ts
新增API	NA	

类名：PlaybackSpeed；

API声明：SPEED_FORWARD_0_125_X = 9

差异内容：SPEED_FORWARD_0_125_X = 9

	component/video.d.ts
新增API	NA	

类名：global；

API声明：declare interface SurfaceConfig

差异内容：declare interface SurfaceConfig

	component/xcomponent.d.ts
新增API	NA	

类名：SurfaceConfig；

API声明：isOpaque?: boolean;

差异内容：isOpaque?: boolean;

	component/xcomponent.d.ts
新增API	NA	

类名：XComponentController；

API声明：setXComponentSurfaceConfig(config: SurfaceConfig): void;

差异内容：setXComponentSurfaceConfig(config: SurfaceConfig): void;

	component/xcomponent.d.ts
新增kit	

类名：global；

API声明：

差异内容：NA

	

类名：global；

API声明：api\arkui\PickerModifier.d.ts

差异内容：ArkUI

	api/arkui/PickerModifier.d.ts
新增kit	

类名：global；

API声明：

差异内容：NA

	

类名：global；

API声明：component\picker.d.ts

差异内容：ArkUI

	component/picker.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：CommonMethod；

API声明：borderRadius(value: Length | BorderRadiuses | LocalizedBorderRadiuses): T;

差异内容：borderRadius(value: Length | BorderRadiuses | LocalizedBorderRadiuses): T;

	

类名：CommonMethod；

API声明：borderRadius(value: Length | BorderRadiuses | LocalizedBorderRadiuses, type?: RenderStrategy): T;

差异内容：borderRadius(value: Length | BorderRadiuses | LocalizedBorderRadiuses, type?: RenderStrategy): T;

	component/common.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：ScrollableCommonMethod；

API声明：scrollBarColor(color: Color | number | string): T;

差异内容：scrollBarColor(color: Color | number | string): T;

	

类名：ScrollableCommonMethod；

API声明：scrollBarColor(color: Color | number | string | Resource): T;

差异内容：scrollBarColor(color: Color | number | string | Resource): T;

	component/common.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：GridAttribute；

API声明：columnsTemplate(value: string): GridAttribute;

差异内容：columnsTemplate(value: string): GridAttribute;

	

类名：GridAttribute；

API声明：columnsTemplate(value: string | ItemFillPolicy): GridAttribute;

差异内容：columnsTemplate(value: string | ItemFillPolicy): GridAttribute;

	component/grid.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：GridAttribute；

API声明：scrollBarColor(value: Color | number | string): GridAttribute;

差异内容：scrollBarColor(value: Color | number | string): GridAttribute;

	

类名：GridAttribute；

API声明：scrollBarColor(color: Color | number | string | Resource): GridAttribute;

差异内容：scrollBarColor(color: Color | number | string | Resource): GridAttribute;

	component/grid.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：ListAttribute；

API声明：lanes(value: number | LengthConstrain, gutter?: Dimension): ListAttribute;

差异内容：lanes(value: number | LengthConstrain, gutter?: Dimension): ListAttribute;

	

类名：ListAttribute；

API声明：lanes(value: number | LengthConstrain | ItemFillPolicy, gutter?: Dimension): ListAttribute;

差异内容：lanes(value: number | LengthConstrain | ItemFillPolicy, gutter?: Dimension): ListAttribute;

	component/list.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：ListAttribute；

API声明：contentStartOffset(value: number): ListAttribute;

差异内容：contentStartOffset(value: number): ListAttribute;

	

类名：ListAttribute；

API声明：contentStartOffset(offset: number | Resource): ListAttribute;

差异内容：contentStartOffset(offset: number | Resource): ListAttribute;

	component/list.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：ListAttribute；

API声明：contentEndOffset(value: number): ListAttribute;

差异内容：contentEndOffset(value: number): ListAttribute;

	

类名：ListAttribute；

API声明：contentEndOffset(offset: number | Resource): ListAttribute;

差异内容：contentEndOffset(offset: number | Resource): ListAttribute;

	component/list.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：ListAttribute；

API声明：cachedCount(count: number, show: boolean): ListAttribute;

差异内容：cachedCount(count: number, show: boolean): ListAttribute;

	

类名：ListAttribute；

API声明：cachedCount(count: number | CacheCountInfo, show: boolean): ListAttribute;

差异内容：cachedCount(count: number | CacheCountInfo, show: boolean): ListAttribute;

	component/list.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：ScrollAttribute；

API声明：scrollBarColor(color: Color | number | string): ScrollAttribute;

差异内容：scrollBarColor(color: Color | number | string): ScrollAttribute;

	

类名：ScrollAttribute；

API声明：scrollBarColor(color: Color | number | string | Resource): ScrollAttribute;

差异内容：scrollBarColor(color: Color | number | string | Resource): ScrollAttribute;

	component/scroll.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：SwiperAttribute；

API声明：displayCount(value: number | string | SwiperAutoFill, swipeByGroup?: boolean): SwiperAttribute;

差异内容：displayCount(value: number | string | SwiperAutoFill, swipeByGroup?: boolean): SwiperAttribute;

	

类名：SwiperAttribute；

API声明：displayCount(value: number | string | SwiperAutoFill | ItemFillPolicy, swipeByGroup?: boolean): SwiperAttribute;

差异内容：displayCount(value: number | string | SwiperAutoFill | ItemFillPolicy, swipeByGroup?: boolean): SwiperAttribute;

	component/swiper.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：SubTabBarStyle；

API声明：indicator(value: IndicatorStyle): SubTabBarStyle;

差异内容：indicator(value: IndicatorStyle): SubTabBarStyle;

	

类名：SubTabBarStyle；

API声明：indicator(value: IndicatorStyle | DrawableTabBarIndicator): SubTabBarStyle;

差异内容：indicator(value: IndicatorStyle | DrawableTabBarIndicator): SubTabBarStyle;

	component/tab_content.d.ts
类新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：WaterFlowAttribute；

API声明：columnsTemplate(value: string): WaterFlowAttribute;

差异内容：columnsTemplate(value: string): WaterFlowAttribute;

	

类名：WaterFlowAttribute；

API声明：columnsTemplate(value: string | ItemFillPolicy): WaterFlowAttribute;

差异内容：columnsTemplate(value: string | ItemFillPolicy): WaterFlowAttribute;

	component/water_flow.d.ts
类新增同名方法且参数类型与已有的参数类型范围不是包含关系	

类名：ImageAttribute；

API声明：alt(value: string | Resource | PixelMap): ImageAttribute;

差异内容：alt(value: string | Resource | PixelMap): ImageAttribute;

	

类名：ImageAttribute；

API声明：alt(src: ResourceStr | PixelMap | ImageAlt): ImageAttribute;

差异内容：alt(src: ResourceStr | PixelMap | ImageAlt): ImageAttribute;

	component/image.d.ts
接口新增同名方法且参数类型与已有的参数类型范围是包含关系	

类名：Window；

API声明：maximize(presentation?: MaximizePresentation): Promise<void>;

差异内容：maximize(presentation?: MaximizePresentation): Promise<void>;

	

类名：Window；

API声明：maximize(presentation?: MaximizePresentation, acrossDisplay?: boolean): Promise<void>;

差异内容：maximize(presentation?: MaximizePresentation, acrossDisplay?: boolean): Promise<void>;

	api/@ohos.window.d.ts
新增导出符号	

类名：global；

API声明：export const enum ResolveStrategy

差异内容：NA

	

类名：global；

API声明：

差异内容：export const enum ResolveStrategy

	api/@ohos.arkui.UIContext.d.ts
arkts演进版本整改兼容变化	

类名：global；

API声明：export declare class FocusController

差异内容：NA

	

类名：global；

API声明：export class FocusController

差异内容：NA

	api/@ohos.arkui.UIContext.d.ts
arkts演进版本整改兼容变化	

类名：global；

API声明：export declare class ComponentSnapshot

差异内容：NA

	

类名：global；

API声明：export class ComponentSnapshot

差异内容：NA

	api/@ohos.arkui.UIContext.d.ts


---

> 📎 6.0.0 (API 20) ArkUI 变更见 [harmonyos-6-api-arkui-v600.md](harmonyos-6-api-arkui-v600.md)


---


## See Also

- [harmonyos-6-api-arkui.md](./harmonyos-6-api-arkui.md) — 6.0.2 ArkUI 变更（前半）
- [harmonyos-6-api-arkui-v600.md](./harmonyos-6-api-arkui-v600.md) — 6.0.0 ArkUI 变更
- [harmonyos-6-overview.md](./harmonyos-6-overview.md) — 6.0 新特性总览
