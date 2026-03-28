# HarmonyOS 6.0.2 ArkUI API 变更

> ArkUI 组件/属性/事件 API 新增、变更、废弃清单
> 版本：6.0.2 (API 22)
> 注意：6.0.0 变更见 harmonyos-6-api-arkui-v600.md

## ⚡ 快速导航（按模块分类）

> 本文件含 3348 行 API 变更明细。按以下分类快速定位：

### 高频变更模块（按变更条目数排序）

| 模块 | 变更数 | 关键变化 |
|------|--------|---------|
| **UIContext** (框架) | 44 | 上下文管理、节点操作、动画控制 |
| **common** (通用属性) | 26 | 组件通用属性/事件变更 |
| **window** (窗口) | 23 | 窗口管理、画中画 |
| **ui_picker** (选择器) | 23 | 新增选择器组件 |
| **particle** (粒子动画) | 17 | 粒子效果 API |
| **enums** (枚举) | 16 | 新增/变更枚举值 |
| **styled_string** (富文本) | 16 | 属性字符串 |
| **stepper** (步骤导航) | 21 | StepperItem 废弃/变更 |
| **BuilderNode** (节点) | 12 | 自定义节点 |
| **display** (显示) | 9 | 显示信息 |
| **list** (列表) | 8 | 列表组件 |
| **text** (文本) | 16 | Text/TextArea/TextInput |

### 搜索建议
- 找特定组件：在文件内搜索 `component/组件名.d.ts`（如 `component/list.d.ts`）
- 找新增 API：搜索 `新增`
- 找废弃 API：搜索 `废弃`

---

## 6.0.2 (API 22) ArkUI 变更

操作	旧版本	新版本	d.ts文件
API废弃版本变更	

类名：global；

API声明：export declare class StepperItemModifier

差异内容：NA

	

类名：global；

API声明：export declare class StepperItemModifier

差异内容：22

	api/arkui/StepperItemModifier.d.ts
API废弃版本变更	

类名：StepperItemModifier；

API声明：applyNormalAttribute?(instance: StepperItemAttribute): void;

差异内容：NA

	

类名：StepperItemModifier；

API声明：applyNormalAttribute?(instance: StepperItemAttribute): void;

差异内容：22

	api/arkui/StepperItemModifier.d.ts
API废弃版本变更	

类名：global；

API声明：export declare class StepperModifier

差异内容：NA

	

类名：global；

API声明：export declare class StepperModifier

差异内容：22

	api/arkui/StepperModifier.d.ts
API废弃版本变更	

类名：StepperModifier；

API声明：applyNormalAttribute?(instance: StepperAttribute): void;

差异内容：NA

	

类名：StepperModifier；

API声明：applyNormalAttribute?(instance: StepperAttribute): void;

差异内容：22

	api/arkui/StepperModifier.d.ts
API废弃版本变更	

类名：global；

API声明：declare enum ItemState

差异内容：NA

	

类名：global；

API声明：declare enum ItemState

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：ItemState；

API声明：Normal

差异内容：NA

	

类名：ItemState；

API声明：Normal

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：ItemState；

API声明：Disabled

差异内容：NA

	

类名：ItemState；

API声明：Disabled

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：ItemState；

API声明：Waiting

差异内容：NA

	

类名：ItemState；

API声明：Waiting

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：ItemState；

API声明：Skip

差异内容：NA

	

类名：ItemState；

API声明：Skip

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：global；

API声明：interface StepperItemInterface

差异内容：NA

	

类名：global；

API声明：interface StepperItemInterface

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：global；

API声明：declare class StepperItemAttribute

差异内容：NA

	

类名：global；

API声明：declare class StepperItemAttribute

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：StepperItemAttribute；

API声明：prevLabel(value: string): StepperItemAttribute;

差异内容：NA

	

类名：StepperItemAttribute；

API声明：prevLabel(value: string): StepperItemAttribute;

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：StepperItemAttribute；

API声明：nextLabel(value: string): StepperItemAttribute;

差异内容：NA

	

类名：StepperItemAttribute；

API声明：nextLabel(value: string): StepperItemAttribute;

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：StepperItemAttribute；

API声明：status(value?: ItemState): StepperItemAttribute;

差异内容：NA

	

类名：StepperItemAttribute；

API声明：status(value?: ItemState): StepperItemAttribute;

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：global；

API声明：declare const StepperItemInstance: StepperItemAttribute;

差异内容：NA

	

类名：global；

API声明：declare const StepperItemInstance: StepperItemAttribute;

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：global；

API声明：declare const StepperItem: StepperItemInterface;

差异内容：NA

	

类名：global；

API声明：declare const StepperItem: StepperItemInterface;

差异内容：22

	component/stepper_item.d.ts
API废弃版本变更	

类名：global；

API声明：interface StepperInterface

差异内容：NA

	

类名：global；

API声明：interface StepperInterface

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：global；

API声明：declare class StepperAttribute

差异内容：NA

	

类名：global；

API声明：declare class StepperAttribute

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：StepperAttribute；

API声明：onFinish(callback: () => void): StepperAttribute;

差异内容：NA

	

类名：StepperAttribute；

API声明：onFinish(callback: () => void): StepperAttribute;

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：StepperAttribute；

API声明：onSkip(callback: () => void): StepperAttribute;

差异内容：NA

	

类名：StepperAttribute；

API声明：onSkip(callback: () => void): StepperAttribute;

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：StepperAttribute；

API声明：onChange(callback: (prevIndex: number, index: number) => void): StepperAttribute;

差异内容：NA

	

类名：StepperAttribute；

API声明：onChange(callback: (prevIndex: number, index: number) => void): StepperAttribute;

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：StepperAttribute；

API声明：onNext(callback: (index: number, pendingIndex: number) => void): StepperAttribute;

差异内容：NA

	

类名：StepperAttribute；

API声明：onNext(callback: (index: number, pendingIndex: number) => void): StepperAttribute;

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：StepperAttribute；

API声明：onPrevious(callback: (index: number, pendingIndex: number) => void): StepperAttribute;

差异内容：NA

	

类名：StepperAttribute；

API声明：onPrevious(callback: (index: number, pendingIndex: number) => void): StepperAttribute;

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：global；

API声明：declare const Stepper: StepperInterface;

差异内容：NA

	

类名：global；

API声明：declare const Stepper: StepperInterface;

差异内容：22

	component/stepper.d.ts
API废弃版本变更	

类名：global；

API声明：declare const StepperInstance: StepperAttribute;

差异内容：NA

	

类名：global；

API声明：declare const StepperInstance: StepperAttribute;

差异内容：22

	component/stepper.d.ts
新增错误码	

类名：FrameNode；

API声明：appendChild(node: FrameNode): void;

差异内容：NA

	

类名：FrameNode；

API声明：appendChild(node: FrameNode): void;

差异内容：100025

	api/arkui/FrameNode.d.ts
新增错误码	

类名：FrameNode；

API声明：insertChildAfter(child: FrameNode, sibling: FrameNode | null): void;

差异内容：NA

	

类名：FrameNode；

API声明：insertChildAfter(child: FrameNode, sibling: FrameNode | null): void;

差异内容：100025

	api/arkui/FrameNode.d.ts
新增错误码	

类名：FrameNode；

API声明：moveTo(targetParent: FrameNode, index?: number): void;

差异内容：NA

	

类名：FrameNode；

API声明：moveTo(targetParent: FrameNode, index?: number): void;

差异内容：100027

	api/arkui/FrameNode.d.ts
新增错误码	

类名：NodeContent；

API声明：addFrameNode(node: FrameNode): void;

差异内容：NA

	

类名：NodeContent；

API声明：addFrameNode(node: FrameNode): void;

差异内容：100025

	api/arkui/NodeContent.d.ts
新增错误码	

类名：RenderNode；

API声明：appendChild(node: RenderNode): void;

差异内容：NA

	

类名：RenderNode；

API声明：appendChild(node: RenderNode): void;

差异内容：100025

	api/arkui/RenderNode.d.ts
新增错误码	

类名：RenderNode；

API声明：insertChildAfter(child: RenderNode, sibling: RenderNode | null): void;

差异内容：NA

	

类名：RenderNode；

API声明：insertChildAfter(child: RenderNode, sibling: RenderNode | null): void;

差异内容：100025

	api/arkui/RenderNode.d.ts
删除错误码	

类名：screenshot；

API声明：function capture(options?: CaptureOption): Promise<image.PixelMap>;

差异内容：401

	

类名：screenshot；

API声明：function capture(options?: CaptureOption): Promise<image.PixelMap>;

差异内容：NA

	api/@ohos.screenshot.d.ts
权限变更	

类名：screenshot；

API声明：function capture(options?: CaptureOption): Promise<image.PixelMap>;

差异内容：ohos.permission.CUSTOM_SCREEN_CAPTURE

	

类名：screenshot；

API声明：function capture(options?: CaptureOption): Promise<image.PixelMap>;

差异内容：ohos.permission.CUSTOM_SCREEN_CAPTURE or ohos.permission.CUSTOM_SCREEN_RECORDING

	api/@ohos.screenshot.d.ts
函数变更	

类名：FrameNode；

API声明：addComponentContent<T>(content: ComponentContent<T>): void;

差异内容：content: ComponentContent<T>

	

类名：FrameNode；

API声明：addComponentContent<T>(content: ComponentContent<T> | ReactiveComponentContent<T>): void;

差异内容：content: ComponentContent<T> | ReactiveComponentContent<T>

	api/arkui/FrameNode.d.ts
函数变更	

类名：SearchAttribute；

API声明：customKeyboard(value: CustomBuilder, options?: KeyboardOptions): SearchAttribute;

差异内容：value: CustomBuilder

	

类名：SearchAttribute；

API声明：customKeyboard(value: CustomBuilder | ComponentContent | undefined, options?: KeyboardOptions): SearchAttribute;

差异内容：value: CustomBuilder | ComponentContent | undefined

	component/search.d.ts
函数变更	

类名：TextAreaAttribute；

API声明：customKeyboard(value: CustomBuilder, options?: KeyboardOptions): TextAreaAttribute;

差异内容：value: CustomBuilder

	

类名：TextAreaAttribute；

API声明：customKeyboard(value: CustomBuilder | ComponentContent | undefined, options?: KeyboardOptions): TextAreaAttribute;

差异内容：value: CustomBuilder | ComponentContent | undefined

	component/text_area.d.ts
函数变更	

类名：TextInputAttribute；

API声明：customKeyboard(value: CustomBuilder, options?: KeyboardOptions): TextInputAttribute;

差异内容：value: CustomBuilder

	

类名：TextInputAttribute；

API声明：customKeyboard(value: CustomBuilder | ComponentContent | undefined, options?: KeyboardOptions): TextInputAttribute;

差异内容：value: CustomBuilder | ComponentContent | undefined

	component/text_input.d.ts
新增API	NA	

类名：global；

API声明：export declare class UIPickerComponentModifier

差异内容：export declare class UIPickerComponentModifier

	api/arkui/UIPickerComponentModifier.d.ts
新增API	NA	

类名：UIPickerComponentModifier；

API声明：applyNormalAttribute?(instance: UIPickerComponentAttribute): void;

差异内容：applyNormalAttribute?(instance: UIPickerComponentAttribute): void;

	api/arkui/UIPickerComponentModifier.d.ts
新增API	NA	

类名：global；

API声明：declare interface UIPickerComponentOptions

差异内容：declare interface UIPickerComponentOptions

	component/ui_picker_component.d.ts
新增API	NA	

类名：UIPickerComponentOptions；

API声明：selectedIndex?: number;

差异内容：selectedIndex?: number;

	component/ui_picker_component.d.ts
新增API	NA	

类名：global；

API声明：interface UIPickerComponentInterface

差异内容：interface UIPickerComponentInterface

	component/ui_picker_component.d.ts
新增API	NA	

类名：global；

API声明：declare type OnUIPickerComponentCallback = (selectedIndex: number) => void;

差异内容：declare type OnUIPickerComponentCallback = (selectedIndex: number) => void;

	component/ui_picker_component.d.ts
新增API	NA	

类名：global；

API声明：declare enum PickerIndicatorType

差异内容：declare enum PickerIndicatorType

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorType；

API声明：BACKGROUND = 0

差异内容：BACKGROUND = 0

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorType；

API声明：DIVIDER = 1

差异内容：DIVIDER = 1

	component/ui_picker_component.d.ts
新增API	NA	

类名：global；

API声明：declare interface PickerIndicatorStyle

差异内容：declare interface PickerIndicatorStyle

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorStyle；

API声明：type: PickerIndicatorType;

差异内容：type: PickerIndicatorType;

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorStyle；

API声明：strokeWidth?: LengthMetrics;

差异内容：strokeWidth?: LengthMetrics;

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorStyle；

API声明：dividerColor?: ResourceColor;

差异内容：dividerColor?: ResourceColor;

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorStyle；

API声明：startMargin?: LengthMetrics;

差异内容：startMargin?: LengthMetrics;

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorStyle；

API声明：endMargin?: LengthMetrics;

差异内容：endMargin?: LengthMetrics;

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorStyle；

API声明：backgroundColor?: ResourceColor;

差异内容：backgroundColor?: ResourceColor;

	component/ui_picker_component.d.ts
新增API	NA	

类名：PickerIndicatorStyle；

API声明：borderRadius?: LengthMetrics | BorderRadiuses | LocalizedBorderRadiuses;

差异内容：borderRadius?: LengthMetrics | BorderRadiuses | LocalizedBorderRadiuses;

	component/ui_picker_component.d.ts
新增API	NA	

类名：global；

API声明：declare class UIPickerComponentAttribute

差异内容：declare class UIPickerComponentAttribute

	component/ui_picker_component.d.ts
新增API	NA	

类名：UIPickerComponentAttribute；

API声明：onChange(callback: Optional<OnUIPickerComponentCallback>): UIPickerComponentAttribute;

差异内容：onChange(callback: Optional<OnUIPickerComponentCallback>): UIPickerComponentAttribute;

	component/ui_picker_component.d.ts
新增API	NA	

类名：UIPickerComponentAttribute；

API声明：onScrollStop(callback: Optional<OnUIPickerComponentCallback>): UIPickerComponentAttribute;

差异内容：onScrollStop(callback: Optional<OnUIPickerComponentCallback>): UIPickerComponentAttribute;

	component/ui_picker_component.d.ts
新增API	NA	

类名：UIPickerComponentAttribute；

API声明：canLoop(isLoop: Optional<boolean>): UIPickerComponentAttribute;

差异内容：canLoop(isLoop: Optional<boolean>): UIPickerComponentAttribute;

	component/ui_picker_component.d.ts
新增API	NA	

类名：UIPickerComponentAttribute；

API声明：enableHapticFeedback(enable: Optional<boolean>): UIPickerComponentAttribute;

差异内容：enableHapticFeedback(enable: Optional<boolean>): UIPickerComponentAttribute;

	component/ui_picker_component.d.ts
新增API	NA	

类名：UIPickerComponentAttribute；

API声明：selectionIndicator(style: Optional<PickerIndicatorStyle>): UIPickerComponentAttribute;

差异内容：selectionIndicator(style: Optional<PickerIndicatorStyle>): UIPickerComponentAttribute;

	component/ui_picker_component.d.ts
新增API	NA	

类名：global；

API声明：declare const UIPickerComponent: UIPickerComponentInterface;

差异内容：declare const UIPickerComponent: UIPickerComponentInterface;

	component/ui_picker_component.d.ts
新增API	NA	

类名：global；

API声明：declare const UIPickerComponentInstance: UIPickerComponentAttribute;

差异内容：declare const UIPickerComponentInstance: UIPickerComponentAttribute;

	component/ui_picker_component.d.ts
新增API	NA	

类名：UIObserver；

API声明：on(type: 'tabChange', config: observer.ObserverOptions, callback: Callback<observer.TabContentInfo>): void;

差异内容：on(type: 'tabChange', config: observer.ObserverOptions, callback: Callback<observer.TabContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：on(type: 'tabChange', callback: Callback<observer.TabContentInfo>): void;

差异内容：on(type: 'tabChange', callback: Callback<observer.TabContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：off(type: 'tabChange', config: observer.ObserverOptions, callback?: Callback<observer.TabContentInfo>): void;

差异内容：off(type: 'tabChange', config: observer.ObserverOptions, callback?: Callback<observer.TabContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：off(type: 'tabChange', callback?: Callback<observer.TabContentInfo>): void;

差异内容：off(type: 'tabChange', callback?: Callback<observer.TabContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：on(type: 'windowSizeLayoutBreakpointChange', callback: Callback<observer.WindowSizeLayoutBreakpointInfo>): void;

差异内容：on(type: 'windowSizeLayoutBreakpointChange', callback: Callback<observer.WindowSizeLayoutBreakpointInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：off(type: 'windowSizeLayoutBreakpointChange', callback?: Callback<observer.WindowSizeLayoutBreakpointInfo>): void;

差异内容：off(type: 'windowSizeLayoutBreakpointChange', callback?: Callback<observer.WindowSizeLayoutBreakpointInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：on(type: 'textChange', callback: Callback<observer.TextChangeEventInfo>): void;

差异内容：on(type: 'textChange', callback: Callback<observer.TextChangeEventInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：on(type: 'textChange', identity: observer.ObserverOptions, callback: Callback<observer.TextChangeEventInfo>): void;

差异内容：on(type: 'textChange', identity: observer.ObserverOptions, callback: Callback<observer.TextChangeEventInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：off(type: 'textChange', callback?: Callback<observer.TextChangeEventInfo>): void;

差异内容：off(type: 'textChange', callback?: Callback<observer.TextChangeEventInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：off(type: 'textChange', identity: observer.ObserverOptions, callback?: Callback<observer.TextChangeEventInfo>): void;

差异内容：off(type: 'textChange', identity: observer.ObserverOptions, callback?: Callback<observer.TextChangeEventInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：onSwiperContentUpdate(callback: Callback<SwiperContentInfo>): void;

差异内容：onSwiperContentUpdate(callback: Callback<SwiperContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：onSwiperContentUpdate(config: observer.ObserverOptions, callback: Callback<SwiperContentInfo>): void;

差异内容：onSwiperContentUpdate(config: observer.ObserverOptions, callback: Callback<SwiperContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：offSwiperContentUpdate(callback?: Callback<SwiperContentInfo>): void;

差异内容：offSwiperContentUpdate(callback?: Callback<SwiperContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIObserver；

API声明：offSwiperContentUpdate(config: observer.ObserverOptions, callback?: Callback<SwiperContentInfo>): void;

差异内容：offSwiperContentUpdate(config: observer.ObserverOptions, callback?: Callback<SwiperContentInfo>): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：global；

API声明：export interface SwiperContentInfo

差异内容：export interface SwiperContentInfo

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：SwiperContentInfo；

API声明：id: string;

差异内容：id: string;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：SwiperContentInfo；

API声明：uniqueId: number;

差异内容：uniqueId: number;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：SwiperContentInfo；

API声明：swiperItemInfos: Array<SwiperItemInfo>;

差异内容：swiperItemInfos: Array<SwiperItemInfo>;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：global；

API声明：export interface SwiperItemInfo

差异内容：export interface SwiperItemInfo

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：SwiperItemInfo；

API声明：uniqueId: number;

差异内容：uniqueId: number;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：SwiperItemInfo；

API声明：index: number;

差异内容：index: number;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：global；

API声明：export class Magnifier

差异内容：export class Magnifier

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：Magnifier；

API声明：bind(id: string): void;

差异内容：bind(id: string): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：Magnifier；

API声明：show(x: number, y: number): void;

差异内容：show(x: number, y: number): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：Magnifier；

API声明：unbind(): void;

差异内容：unbind(): void;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：global；

API声明：export const enum ResolveStrategy

差异内容：export const enum ResolveStrategy

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：ResolveStrategy；

API声明：CALLING_SCOPE = 0

差异内容：CALLING_SCOPE = 0

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：ResolveStrategy；

API声明：LAST_FOCUS = 1

差异内容：LAST_FOCUS = 1

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：ResolveStrategy；

API声明：MAX_INSTANCE_ID = 2

差异内容：MAX_INSTANCE_ID = 2

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：ResolveStrategy；

API声明：UNIQUE = 3

差异内容：UNIQUE = 3

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：ResolveStrategy；

API声明：LAST_FOREGROUND = 4

差异内容：LAST_FOREGROUND = 4

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：ResolveStrategy；

API声明：UNDEFINED = 5

差异内容：UNDEFINED = 5

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：global；

API声明：export class ResolvedUIContext

差异内容：export class ResolvedUIContext

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：ResolvedUIContext；

API声明：strategy: ResolveStrategy;

差异内容：strategy: ResolveStrategy;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIContext；

API声明：static getCallingScopeUIContext(): UIContext | undefined;

差异内容：static getCallingScopeUIContext(): UIContext | undefined;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIContext；

API声明：static getLastFocusedUIContext(): UIContext | undefined;

差异内容：static getLastFocusedUIContext(): UIContext | undefined;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIContext；

API声明：static getLastForegroundUIContext(): UIContext | undefined;

差异内容：static getLastForegroundUIContext(): UIContext | undefined;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIContext；

API声明：static getAllUIContexts(): UIContext[];

差异内容：static getAllUIContexts(): UIContext[];

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIContext；

API声明：static resolveUIContext(): ResolvedUIContext;

差异内容：static resolveUIContext(): ResolvedUIContext;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIContext；

API声明：getMagnifier(): Magnifier;

差异内容：getMagnifier(): Magnifier;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：UIContext；

API声明：getId(): number;

差异内容：getId(): number;

	api/@ohos.arkui.UIContext.d.ts
新增API	NA	

类名：window；

API声明：enum PixelUnit

差异内容：enum PixelUnit

	api/@ohos.window.d.ts
新增API	NA	

类名：PixelUnit；

API声明：PX = 0

差异内容：PX = 0

	api/@ohos.window.d.ts
新增API	NA	

类名：PixelUnit；

API声明：VP = 1

差异内容：VP = 1

	api/@ohos.window.d.ts
新增API	NA	

类名：window；

API声明：interface FrameMetrics

差异内容：interface FrameMetrics

	api/@ohos.window.d.ts
新增API	NA	

类名：FrameMetrics；

API声明：firstDrawFrame: boolean;

差异内容：firstDrawFrame: boolean;

	api/@ohos.window.d.ts
新增API	NA	

类名：FrameMetrics；

API声明：inputHandlingDuration: number;

差异内容：inputHandlingDuration: number;

	api/@ohos.window.d.ts
新增API	NA	

类名：FrameMetrics；

API声明：layoutMeasureDuration: number;

差异内容：layoutMeasureDuration: number;

	api/@ohos.window.d.ts
新增API	NA	

类名：FrameMetrics；

API声明：vsyncTimestamp: number;

差异内容：vsyncTimestamp: number;

	api/@ohos.window.d.ts
新增API	NA	

类名：WindowLimits；

API声明：pixelUnit?: PixelUnit;

差异内容：pixelUnit?: PixelUnit;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：getWindowAvoidAreaIgnoringVisibility(type: AvoidAreaType): AvoidArea;

差异内容：getWindowAvoidAreaIgnoringVisibility(type: AvoidAreaType): AvoidArea;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：on(type: 'occlusionStateChanged', callback: Callback<OcclusionState>): void;

差异内容：on(type: 'occlusionStateChanged', callback: Callback<OcclusionState>): void;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：off(type: 'occlusionStateChanged', callback?: Callback<OcclusionState>): void;

差异内容：off(type: 'occlusionStateChanged', callback?: Callback<OcclusionState>): void;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：on(type: 'frameMetricsMeasured', callback: Callback<FrameMetrics>): void;

差异内容：on(type: 'frameMetricsMeasured', callback: Callback<FrameMetrics>): void;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：off(type: 'frameMetricsMeasured', callback?: Callback<FrameMetrics>): void;

差异内容：off(type: 'frameMetricsMeasured', callback?: Callback<FrameMetrics>): void;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：getWindowLimitsVP(): WindowLimits;

差异内容：getWindowLimitsVP(): WindowLimits;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：isInFreeWindowMode(): boolean;

差异内容：isInFreeWindowMode(): boolean;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：on(type: 'freeWindowModeChange', callback: Callback<boolean>): void;

差异内容：on(type: 'freeWindowModeChange', callback: Callback<boolean>): void;

	api/@ohos.window.d.ts
新增API	NA	

类名：Window；

API声明：off(type: 'freeWindowModeChange', callback?: Callback<boolean>): void;

差异内容：off(type: 'freeWindowModeChange', callback?: Callback<boolean>): void;

	api/@ohos.window.d.ts
新增API	NA	

类名：window；

API声明：enum OcclusionState

差异内容：enum OcclusionState

	api/@ohos.window.d.ts
新增API	NA	

类名：OcclusionState；

API声明：NO_OCCLUSION = 0

差异内容：NO_OCCLUSION = 0

	api/@ohos.window.d.ts
新增API	NA	

类名：OcclusionState；

API声明：PARTIAL_OCCLUSION = 1

差异内容：PARTIAL_OCCLUSION = 1

	api/@ohos.window.d.ts
新增API	NA	

类名：OcclusionState；

API声明：FULL_OCCLUSION = 2

差异内容：FULL_OCCLUSION = 2

	api/@ohos.window.d.ts
新增API	NA	

类名：FrameNode；

API声明：convertPosition(position: Position, targetNode: FrameNode): Position;

差异内容：convertPosition(position: Position, targetNode: FrameNode): Position;

	api/arkui/FrameNode.d.ts
新增API	NA	

类名：FrameNode；

API声明：adoptChild(child: FrameNode): void;

差异内容：adoptChild(child: FrameNode): void;

	api/arkui/FrameNode.d.ts
新增API	NA	

类名：FrameNode；

API声明：removeAdoptedChild(child: FrameNode): void;

差异内容：removeAdoptedChild(child: FrameNode): void;

	api/arkui/FrameNode.d.ts
新增API	NA	

类名：InputCounterOptions；

API声明：counterTextColor?: ColorMetrics;

差异内容：counterTextColor?: ColorMetrics;

	component/common.d.ts
新增API	NA	

类名：InputCounterOptions；

API声明：counterTextOverflowColor?: ColorMetrics;

差异内容：counterTextOverflowColor?: ColorMetrics;

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare type EnvDecorator = (value: SystemProperties) => PropertyDecorator;

差异内容：declare type EnvDecorator = (value: SystemProperties) => PropertyDecorator;

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare const Env: EnvDecorator;

差异内容：declare const Env: EnvDecorator;

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare enum SystemProperties

差异内容：declare enum SystemProperties

	component/common.d.ts
新增API	NA	

类名：SystemProperties；

API声明：BREAK_POINT = 'system.arkui.breakpoint'

差异内容：BREAK_POINT = 'system.arkui.breakpoint'

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare interface ResponseRegion

差异内容：declare interface ResponseRegion

	component/common.d.ts
新增API	NA	

类名：ResponseRegion；

API声明：tool?: ResponseRegionSupportedTool;

差异内容：tool?: ResponseRegionSupportedTool;

	component/common.d.ts
新增API	NA	

类名：ResponseRegion；

API声明：x?: LengthMetrics;

差异内容：x?: LengthMetrics;

	component/common.d.ts
新增API	NA	

类名：ResponseRegion；

API声明：y?: LengthMetrics;

差异内容：y?: LengthMetrics;

	component/common.d.ts
新增API	NA	

类名：ResponseRegion；

API声明：width?: LengthMetrics | string;

差异内容：width?: LengthMetrics | string;

	component/common.d.ts
新增API	NA	

类名：ResponseRegion；

API声明：height?: LengthMetrics | string;

差异内容：height?: LengthMetrics | string;

	component/common.d.ts
新增API	NA	

类名：SourceType；

API声明：KEY = 4

差异内容：KEY = 4

	component/common.d.ts
新增API	NA	

类名：SourceType；

API声明：JOYSTICK = 5

差异内容：JOYSTICK = 5

	component/common.d.ts
新增API	NA	

类名：AxisEvent；

API声明：hasAxis(axisType: AxisType): boolean;

差异内容：hasAxis(axisType: AxisType): boolean;

	component/common.d.ts
新增API	NA	

类名：CommonMethod；

API声明：responseRegionList(regions: Array<ResponseRegion>): T;

差异内容：responseRegionList(regions: Array<ResponseRegion>): T;

	component/common.d.ts
新增API	NA	

类名：CommonMethod；

API声明：onVisibleAreaChange(ratios: Array<number>, event: VisibleAreaChangeCallback, measureFromViewport: boolean): T;

差异内容：onVisibleAreaChange(ratios: Array<number>, event: VisibleAreaChangeCallback, measureFromViewport: boolean): T;

	component/common.d.ts
新增API	NA	

类名：TextContentControllerBase；

API声明：setStyledPlaceholder(styledString: StyledString): void;

差异内容：setStyledPlaceholder(styledString: StyledString): void;

	component/common.d.ts
新增API	NA	

类名：ScrollableCommonMethod；

API声明：contentStartOffset(offset: number | Resource): T;

差异内容：contentStartOffset(offset: number | Resource): T;

	component/common.d.ts
新增API	NA	

类名：ScrollableCommonMethod；

API声明：contentEndOffset(offset: number | Resource): T;

差异内容：contentEndOffset(offset: number | Resource): T;

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare type BuilderCallback = (...args: Args) => void;

差异内容：declare type BuilderCallback = (...args: Args) => void;

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare function mutableBuilder<Args extends Object[]>(builder: BuilderCallback): MutableBuilder<Args>;

差异内容：declare function mutableBuilder<Args extends Object[]>(builder: BuilderCallback): MutableBuilder<Args>;

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare class MutableBuilder

差异内容：declare class MutableBuilder

	component/common.d.ts
新增API	NA	

类名：VisibleAreaEventOptions；

API声明：measureFromViewport?: boolean;

差异内容：measureFromViewport?: boolean;

	component/common.d.ts
新增API	NA	

类名：global；

API声明：declare enum RenderStrategy

差异内容：declare enum RenderStrategy

	component/enums.d.ts
新增API	NA	

类名：RenderStrategy；

API声明：FAST = 0

差异内容：FAST = 0

	component/enums.d.ts
新增API	NA	

类名：RenderStrategy；

API声明：OFFSCREEN = 1

差异内容：OFFSCREEN = 1

	component/enums.d.ts
新增API	NA	

类名：global；

API声明：declare enum PresetFillType

差异内容：declare enum PresetFillType

	component/enums.d.ts
新增API	NA	

类名：PresetFillType；

API声明：BREAKPOINT_DEFAULT = 0

差异内容：BREAKPOINT_DEFAULT = 0

	component/enums.d.ts
新增API	NA	

类名：PresetFillType；

API声明：BREAKPOINT_SM1MD2LG3 = 1

差异内容：BREAKPOINT_SM1MD2LG3 = 1

	component/enums.d.ts
新增API	NA	

类名：PresetFillType；

API声明：BREAKPOINT_SM2MD3LG5 = 2

差异内容：BREAKPOINT_SM2MD3LG5 = 2

	component/enums.d.ts
新增API	NA	

类名：global；

API声明：declare enum AxisType

差异内容：declare enum AxisType

	component/enums.d.ts
新增API	NA	

类名：AxisType；

API声明：VERTICAL_AXIS = 0

差异内容：VERTICAL_AXIS = 0

	component/enums.d.ts
新增API	NA	

类名：AxisType；

API声明：HORIZONTAL_AXIS = 1

差异内容：HORIZONTAL_AXIS = 1

	component/enums.d.ts
新增API	NA	

类名：AxisType；

API声明：PINCH_AXIS = 2

差异内容：PINCH_AXIS = 2


---

> 📎 后续变更见 [harmonyos-6-api-arkui-part2.md](./harmonyos-6-api-arkui-part2.md)

## See Also

- [harmonyos-6-api-arkui-part2.md](./harmonyos-6-api-arkui-part2.md) — 6.0.2 ArkUI 变更（续）
- [harmonyos-6-api-arkui-v600.md](./harmonyos-6-api-arkui-v600.md) — 6.0.0 ArkUI 变更
- [harmonyos-6-overview.md](./harmonyos-6-overview.md) — 6.0 新特性总览
