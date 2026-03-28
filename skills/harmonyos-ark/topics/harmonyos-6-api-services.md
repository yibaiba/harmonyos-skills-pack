# HarmonyOS 6.0 服务类 Kit API 变更

> Network / Camera / Media / Image / Test / UI Design Kit 的 API 变更清单
> 版本：6.0.2 (API 22)

## Network Kit

操作	旧版本	新版本	d.ts文件
新增API	NA	

类名：connection；

API声明：function getIpNeighTable(): Promise<Array<NetIpMacInfo>>;

差异内容：function getIpNeighTable(): Promise<Array<NetIpMacInfo>>;

	api/@ohos.net.connection.d.ts
新增API	NA	

类名：connection；

API声明：export interface NetIpMacInfo

差异内容：export interface NetIpMacInfo

	api/@ohos.net.connection.d.ts
新增API	NA	

类名：NetIpMacInfo；

API声明：ipAddress: NetAddress;

差异内容：ipAddress: NetAddress;

	api/@ohos.net.connection.d.ts
新增API	NA	

类名：NetIpMacInfo；

API声明：macAddress: string;

差异内容：macAddress: string;

	api/@ohos.net.connection.d.ts
新增API	NA	

类名：NetIpMacInfo；

API声明：iface: string;

差异内容：iface: string;

	api/@ohos.net.connection.d.ts
新增API	NA	

类名：http；

API声明：export enum InterceptorType

差异内容：export enum InterceptorType

	api/@ohos.net.http.d.ts
新增API	NA	

类名：InterceptorType；

API声明：INITIAL_REQUEST = 'INITIAL_REQUEST'

差异内容：INITIAL_REQUEST = 'INITIAL_REQUEST'

	api/@ohos.net.http.d.ts
新增API	NA	

类名：InterceptorType；

API声明：REDIRECTION = 'REDIRECTION'

差异内容：REDIRECTION = 'REDIRECTION'

	api/@ohos.net.http.d.ts
新增API	NA	

类名：InterceptorType；

API声明：CACHE_CHECKED = 'READ_CACHE'

差异内容：CACHE_CHECKED = 'READ_CACHE'

	api/@ohos.net.http.d.ts
新增API	NA	

类名：InterceptorType；

API声明：NETWORK_CONNECT = 'CONNECT_NETWORK'

差异内容：NETWORK_CONNECT = 'CONNECT_NETWORK'

	api/@ohos.net.http.d.ts
新增API	NA	

类名：InterceptorType；

API声明：FINAL_RESPONSE = 'FINAL_RESPONSE'

差异内容：FINAL_RESPONSE = 'FINAL_RESPONSE'

	api/@ohos.net.http.d.ts
新增API	NA	

类名：http；

API声明：export interface HttpRequestContext

差异内容：export interface HttpRequestContext

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpRequestContext；

API声明：url: string;

差异内容：url: string;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpRequestContext；

API声明：header: Object;

差异内容：header: Object;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpRequestContext；

API声明：body: Object;

差异内容：body: Object;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：http；

API声明：export type ChainContinue = boolean;

差异内容：export type ChainContinue = boolean;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：http；

API声明：export interface HttpInterceptor

差异内容：export interface HttpInterceptor

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpInterceptor；

API声明：interceptorType: InterceptorType;

差异内容：interceptorType: InterceptorType;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpInterceptor；

API声明：interceptorHandle(reqContext: HttpRequestContext, rspContext: HttpResponse): Promise<ChainContinue>;

差异内容：interceptorHandle(reqContext: HttpRequestContext, rspContext: HttpResponse): Promise<ChainContinue>;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：http；

API声明：export class HttpInterceptorChain

差异内容：export class HttpInterceptorChain

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpInterceptorChain；

API声明：public getChain(): HttpInterceptor[];

差异内容：public getChain(): HttpInterceptor[];

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpInterceptorChain；

API声明：public addChain(chain: HttpInterceptor[]): boolean;

差异内容：public addChain(chain: HttpInterceptor[]): boolean;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：HttpInterceptorChain；

API声明：public apply(httpRequest: HttpRequest): boolean;

差异内容：public apply(httpRequest: HttpRequest): boolean;

	api/@ohos.net.http.d.ts
新增API	NA	

类名：policy；

API声明：function showAppNetPolicySettings(context: Context): Promise<void>;

差异内容：function showAppNetPolicySettings(context: Context): Promise<void>;

	api/@ohos.net.policy.d.ts
新增API	NA	

类名：TLSConnectOptions；

API声明：timeout?: number;

差异内容：timeout?: number;

	api/@ohos.net.socket.d.ts
新增API	NA	

类名：statistics；

API声明：export interface NetStatsInfo

差异内容：export interface NetStatsInfo

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetStatsInfo；

API声明：rxBytes: number;

差异内容：rxBytes: number;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetStatsInfo；

API声明：txBytes: number;

差异内容：txBytes: number;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetStatsInfo；

API声明：rxPackets: number;

差异内容：rxPackets: number;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetStatsInfo；

API声明：txPackets: number;

差异内容：txPackets: number;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：statistics；

API声明：export interface NetworkInfo

差异内容：export interface NetworkInfo

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetworkInfo；

API声明：type: NetBearType;

差异内容：type: NetBearType;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetworkInfo；

API声明：startTime: number;

差异内容：startTime: number;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetworkInfo；

API声明：endTime: number;

差异内容：endTime: number;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：NetworkInfo；

API声明：simId?: number;

差异内容：simId?: number;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：statistics；

API声明：function getSelfTrafficStats(networkInfo: NetworkInfo): Promise<NetStatsInfo>;

差异内容：function getSelfTrafficStats(networkInfo: NetworkInfo): Promise<NetStatsInfo>;

	api/@ohos.net.statistics.d.ts
新增API	NA	

类名：VpnConnection；

API声明：protectProcessNet(): Promise<void>;

差异内容：protectProcessNet(): Promise<void>;

	api/@ohos.net.vpnExtension.d.ts

## Camera Kit

操作	旧版本	新版本	d.ts文件
新增API	NA	

类名：CameraInput；

API声明：isPhysicalCameraOrientationVariable(): boolean;

差异内容：isPhysicalCameraOrientationVariable(): boolean;

	api/@ohos.multimedia.camera.d.ts
新增API	NA	

类名：CameraInput；

API声明：getPhysicalCameraOrientation(): number;

差异内容：getPhysicalCameraOrientation(): number;

	api/@ohos.multimedia.camera.d.ts
新增API	NA	

类名：CameraInput；

API声明：usePhysicalCameraOrientation(isUsed: boolean): void;

差异内容：usePhysicalCameraOrientation(isUsed: boolean): void;

	api/@ohos.multimedia.camera.d.ts
新增API	NA	

类名：VideoSession；

API声明：onIsoInfoChange(callback: Callback<IsoInfo>): void;

差异内容：onIsoInfoChange(callback: Callback<IsoInfo>): void;

	api/@ohos.multimedia.camera.d.ts
新增API	NA	

类名：VideoSession；

API声明：offIsoInfoChange(callback?: Callback<IsoInfo>): void;

差异内容：offIsoInfoChange(callback?: Callback<IsoInfo>): void;

	api/@ohos.multimedia.camera.d.ts
新增API	NA	

类名：camera；

API声明：interface IsoInfo

差异内容：interface IsoInfo

	api/@ohos.multimedia.camera.d.ts
新增API	NA	

类名：IsoInfo；

API声明：readonly iso?: number;

差异内容：readonly iso?: number;

	api/@ohos.multimedia.camera.d.ts

## Media Kit

操作	旧版本	新版本	d.ts文件
新增API	NA	

类名：media；

API声明：enum PickerMode

差异内容：enum PickerMode

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：PickerMode；

API声明：WINDOW_ONLY = 0

差异内容：WINDOW_ONLY = 0

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：PickerMode；

API声明：SCREEN_ONLY = 1

差异内容：SCREEN_ONLY = 1

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：PickerMode；

API声明：SCREEN_AND_WINDOW = 2

差异内容：SCREEN_AND_WINDOW = 2

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：media；

API声明：enum AacProfile

差异内容：enum AacProfile

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：AacProfile；

API声明：AAC_LC = 0

差异内容：AAC_LC = 0

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：AacProfile；

API声明：AAC_HE = 1

差异内容：AAC_HE = 1

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：AacProfile；

API声明：AAC_HE_V2 = 2

差异内容：AAC_HE_V2 = 2

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：AVRecorderProfile；

API声明：aacProfile?: AacProfile;

差异内容：aacProfile?: AacProfile;

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：AVScreenCaptureRecorder；

API声明：setPickerMode(pickerMode: PickerMode): Promise<void>;

差异内容：setPickerMode(pickerMode: PickerMode): Promise<void>;

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：AVScreenCaptureRecorder；

API声明：excludePickerWindows(excludedWindows: Array<number>): Promise<void>;

差异内容：excludePickerWindows(excludedWindows: Array<number>): Promise<void>;

	api/@ohos.multimedia.media.d.ts
新增API	NA	

类名：AVScreenCaptureRecorder；

API声明：presentPicker(): Promise<void>;

差异内容：presentPicker(): Promise<void>;

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：media；

API声明：function createAVTranscoder(): Promise<AVTranscoder>;

差异内容：NA

	

类名：media；

API声明：function createAVTranscoder(): Promise<AVTranscoder>;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：ContainerFormatType；

API声明：CFT_MPEG_4 = 'mp4'

差异内容：NA

	

类名：ContainerFormatType；

API声明：CFT_MPEG_4 = 'mp4'

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：CodecMimeType；

API声明：VIDEO_AVC = 'video/avc'

差异内容：NA

	

类名：CodecMimeType；

API声明：VIDEO_AVC = 'video/avc'

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：CodecMimeType；

API声明：VIDEO_HEVC = 'video/hevc'

差异内容：NA

	

类名：CodecMimeType；

API声明：VIDEO_HEVC = 'video/hevc'

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：media；

API声明：interface AVTranscoderConfig

差异内容：NA

	

类名：media；

API声明：interface AVTranscoderConfig

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：audioBitrate?: number;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：audioBitrate?: number;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：audioCodec?: CodecMimeType;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：audioCodec?: CodecMimeType;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：fileFormat: ContainerFormatType;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：fileFormat: ContainerFormatType;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：videoBitrate?: number;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：videoBitrate?: number;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：videoCodec?: CodecMimeType;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：videoCodec?: CodecMimeType;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：videoFrameWidth?: number;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：videoFrameWidth?: number;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：videoFrameHeight?: number;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：videoFrameHeight?: number;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoderConfig；

API声明：enableBFrame?: boolean;

差异内容：NA

	

类名：AVTranscoderConfig；

API声明：enableBFrame?: boolean;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：media；

API声明：interface AVTranscoder

差异内容：NA

	

类名：media；

API声明：interface AVTranscoder

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：fdSrc: AVFileDescriptor;

差异内容：NA

	

类名：AVTranscoder；

API声明：fdSrc: AVFileDescriptor;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：fdDst: number;

差异内容：NA

	

类名：AVTranscoder；

API声明：fdDst: number;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：prepare(config: AVTranscoderConfig): Promise<void>;

差异内容：NA

	

类名：AVTranscoder；

API声明：prepare(config: AVTranscoderConfig): Promise<void>;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：start(): Promise<void>;

差异内容：NA

	

类名：AVTranscoder；

API声明：start(): Promise<void>;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：pause(): Promise<void>;

差异内容：NA

	

类名：AVTranscoder；

API声明：pause(): Promise<void>;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：resume(): Promise<void>;

差异内容：NA

	

类名：AVTranscoder；

API声明：resume(): Promise<void>;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：cancel(): Promise<void>;

差异内容：NA

	

类名：AVTranscoder；

API声明：cancel(): Promise<void>;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：release(): Promise<void>;

差异内容：NA

	

类名：AVTranscoder；

API声明：release(): Promise<void>;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：on(type: 'complete', callback: Callback<void>): void;

差异内容：NA

	

类名：AVTranscoder；

API声明：on(type: 'complete', callback: Callback<void>): void;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：on(type: 'error', callback: ErrorCallback): void;

差异内容：NA

	

类名：AVTranscoder；

API声明：on(type: 'error', callback: ErrorCallback): void;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：on(type: 'progressUpdate', callback: Callback<number>): void;

差异内容：NA

	

类名：AVTranscoder；

API声明：on(type: 'progressUpdate', callback: Callback<number>): void;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：off(type: 'complete', callback?: Callback<void>): void;

差异内容：NA

	

类名：AVTranscoder；

API声明：off(type: 'complete', callback?: Callback<void>): void;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：off(type: 'error', callback?: ErrorCallback): void;

差异内容：NA

	

类名：AVTranscoder；

API声明：off(type: 'error', callback?: ErrorCallback): void;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts
API从不支持元服务到支持元服务	

类名：AVTranscoder；

API声明：off(type: 'progressUpdate', callback?: Callback<number>): void;

差异内容：NA

	

类名：AVTranscoder；

API声明：off(type: 'progressUpdate', callback?: Callback<number>): void;

差异内容：atomicservice

	api/@ohos.multimedia.media.d.ts

## Image Kit

操作	旧版本	新版本	d.ts文件
新增API	NA	

类名：PixelMap；

API声明：isReleased(): boolean;

差异内容：isReleased(): boolean;

	api/@ohos.multimedia.image.d.ts
新增API	NA	

类名：PixelMap；

API声明：getUniqueId(): number;

差异内容：getUniqueId(): number;

	api/@ohos.multimedia.image.d.ts
新增API	NA	

类名：PixelMap；

API声明：createCroppedAndScaledPixelMapSync(region: Region, x: number, y: number, level?: AntiAliasingLevel): PixelMap;

差异内容：createCroppedAndScaledPixelMapSync(region: Region, x: number, y: number, level?: AntiAliasingLevel): PixelMap;

	api/@ohos.multimedia.image.d.ts
新增API	NA	

类名：PixelMap；

API声明：createCroppedAndScaledPixelMap(region: Region, x: number, y: number, level?: AntiAliasingLevel): Promise<PixelMap>;

差异内容：createCroppedAndScaledPixelMap(region: Region, x: number, y: number, level?: AntiAliasingLevel): Promise<PixelMap>;

	api/@ohos.multimedia.image.d.ts
新增API	NA	

类名：ImageSource；

API声明：modifyImagePropertiesEnhanced(records: Record<string, string | null>): Promise<void>;

差异内容：modifyImagePropertiesEnhanced(records: Record<string, string | null>): Promise<void>;

	api/@ohos.multimedia.image.d.ts

## Test Kit

操作	旧版本	新版本	d.ts文件
新增API	NA	

类名：global；

API声明：declare enum WindowChangeType

差异内容：declare enum WindowChangeType

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：WindowChangeType；

API声明：WINDOW_UNDEFINED = 0

差异内容：WINDOW_UNDEFINED = 0

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：WindowChangeType；

API声明：WINDOW_ADDED = 1

差异内容：WINDOW_ADDED = 1

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：WindowChangeType；

API声明：WINDOW_REMOVED = 2

差异内容：WINDOW_REMOVED = 2

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：WindowChangeType；

API声明：WINDOW_BOUNDS_CHANGED = 3

差异内容：WINDOW_BOUNDS_CHANGED = 3

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：global；

API声明：declare enum ComponentEventType

差异内容：declare enum ComponentEventType

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventType；

API声明：COMPONENT_UNDEFINED = 0

差异内容：COMPONENT_UNDEFINED = 0

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventType；

API声明：COMPONENT_CLICKED = 1

差异内容：COMPONENT_CLICKED = 1

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventType；

API声明：COMPONENT_LONG_CLICKED = 2

差异内容：COMPONENT_LONG_CLICKED = 2

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventType；

API声明：COMPONENT_SCROLL_START = 3

差异内容：COMPONENT_SCROLL_START = 3

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventType；

API声明：COMPONENT_SCROLL_END = 4

差异内容：COMPONENT_SCROLL_END = 4

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventType；

API声明：COMPONENT_TEXT_CHANGED = 5

差异内容：COMPONENT_TEXT_CHANGED = 5

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：global；

API声明：declare interface WindowChangeOptions

差异内容：declare interface WindowChangeOptions

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：WindowChangeOptions；

API声明：timeout?: number;

差异内容：timeout?: number;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：WindowChangeOptions；

API声明：bundleName?: string;

差异内容：bundleName?: string;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：global；

API声明：declare interface ComponentEventOptions

差异内容：declare interface ComponentEventOptions

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventOptions；

API声明：timeout?: number;

差异内容：timeout?: number;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：ComponentEventOptions；

API声明：on?: On;

差异内容：on?: On;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：UIElementInfo；

API声明：readonly windowChangeType?: WindowChangeType;

差异内容：readonly windowChangeType?: WindowChangeType;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：UIElementInfo；

API声明：readonly componentEventType?: ComponentEventType;

差异内容：readonly componentEventType?: ComponentEventType;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：UIElementInfo；

API声明：readonly windowId?: number;

差异内容：readonly windowId?: number;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：UIElementInfo；

API声明：readonly componentId?: string;

差异内容：readonly componentId?: string;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：UIElementInfo；

API声明：readonly componentRect?: Rect;

差异内容：readonly componentRect?: Rect;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：UIEventObserver；

API声明：once(type: 'windowChange', windowChangeType: WindowChangeType, options: WindowChangeOptions, callback: Callback<UIElementInfo>): void;

差异内容：once(type: 'windowChange', windowChangeType: WindowChangeType, options: WindowChangeOptions, callback: Callback<UIElementInfo>): void;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：UIEventObserver；

API声明：once(type: 'componentEventOccur', componentEventType: ComponentEventType, options: ComponentEventOptions, callback: Callback<UIElementInfo>): void;

差异内容：once(type: 'componentEventOccur', componentEventType: ComponentEventType, options: ComponentEventOptions, callback: Callback<UIElementInfo>): void;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：Driver；

API声明：isComponentPresentWhenLongClick(on: On, point: Point, duration?: number): Promise<boolean>;

差异内容：isComponentPresentWhenLongClick(on: On, point: Point, duration?: number): Promise<boolean>;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：Driver；

API声明：isComponentPresentWhenDrag(on: On, from: Point, to: Point, speed?: number, duration?: number): Promise<boolean>;

差异内容：isComponentPresentWhenDrag(on: On, from: Point, to: Point, speed?: number, duration?: number): Promise<boolean>;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：Driver；

API声明：isComponentPresentWhenSwipe(on: On, from: Point, to: Point, speed?: number): Promise<boolean>;

差异内容：isComponentPresentWhenSwipe(on: On, from: Point, to: Point, speed?: number): Promise<boolean>;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：Driver；

API声明：touchPadTwoFingersScroll(point: Point, direction: UiDirection, d: number, speed?: number): Promise<void>;

差异内容：touchPadTwoFingersScroll(point: Point, direction: UiDirection, d: number, speed?: number): Promise<void>;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：Driver；

API声明：knuckleKnock(pointers: Array<Point>, times: number): Promise<void>;

差异内容：knuckleKnock(pointers: Array<Point>, times: number): Promise<void>;

	api/@ohos.UiTest.d.ts
新增API	NA	

类名：Driver；

API声明：injectKnucklePointerAction(pointers: PointerMatrix, speed?: number): Promise<void>;

差异内容：injectKnucklePointerAction(pointers: PointerMatrix, speed?: number): Promise<void>;

	api/@ohos.UiTest.d.ts

## UI Design Kit

操作	旧版本	新版本	d.ts文件
API卡片权限变更	

类名：global；

API声明：export declare enum HdsSceneType

差异内容：NA

	

类名：global；

API声明：export declare enum HdsSceneType

差异内容：form

	api/@hms.hds.HdsVisualComponent.d.ets
API卡片权限变更	

类名：global；

API声明：declare type HdsSceneFinishCallback = () => void;

差异内容：NA

	

类名：global；

API声明：declare type HdsSceneFinishCallback = () => void;

差异内容：form

	api/@hms.hds.HdsVisualComponent.d.ets
API卡片权限变更	

类名：global；

API声明：export class HdsSceneController

差异内容：NA

	

类名：global；

API声明：export class HdsSceneController

差异内容：form

	api/@hms.hds.HdsVisualComponent.d.ets
API卡片权限变更	

类名：global；

API声明：export declare class HdsVisualComponentAttribute

差异内容：NA

	

类名：global；

API声明：export declare class HdsVisualComponentAttribute

差异内容：form

	api/@hms.hds.HdsVisualComponent.d.ets
API卡片权限变更	

类名：HdsVisualComponentAttribute；

API声明：scene(sceneType: HdsSceneType, controller: HdsSceneController, callback?: HdsSceneFinishCallback, frameRateRange?: hdsEffect.ExpectedFrameRateRange): HdsVisualComponentAttribute;

差异内容：NA

	

类名：HdsVisualComponentAttribute；

API声明：scene(sceneType: HdsSceneType, controller: HdsSceneController, callback?: HdsSceneFinishCallback, frameRateRange?: hdsEffect.ExpectedFrameRateRange): HdsVisualComponentAttribute;

差异内容：form

	api/@hms.hds.HdsVisualComponent.d.ets
API卡片权限变更	

类名：global；

API声明：export declare const HdsVisualComponent: HdsVisualComponentInterface;

差异内容：NA

	

类名：global；

API声明：export declare const HdsVisualComponent: HdsVisualComponentInterface;

差异内容：form

	api/@hms.hds.HdsVisualComponent.d.ets
