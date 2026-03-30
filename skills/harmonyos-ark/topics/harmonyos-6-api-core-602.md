# HarmonyOS 6.0.2 核心框架 API 变更（Ability Kit）

> Ability Kit 的 6.0.2 (API 22) 变更清单
> 从 harmonyos-6-api-core.md 拆分

<!-- Agent 摘要：Ability Kit 6.0.2 变更。6.0.0 变更见 harmonyos-6-api-core.md。 -->

## Ability Kit

### 6.0.2 变更

操作	旧版本	新版本	d.ts文件
API废弃版本变更	

类名：global；

API声明：declare namespace continuationManager

差异内容：NA

	

类名：global；

API声明：declare namespace continuationManager

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function on(type: 'deviceSelected', token: number, callback: Callback<Array<ContinuationResult>>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function on(type: 'deviceSelected', token: number, callback: Callback<Array<ContinuationResult>>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function off(type: 'deviceSelected', token: number): void;

差异内容：NA

	

类名：continuationManager；

API声明：function off(type: 'deviceSelected', token: number): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function on(type: 'deviceUnselected', token: number, callback: Callback<Array<ContinuationResult>>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function on(type: 'deviceUnselected', token: number, callback: Callback<Array<ContinuationResult>>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function off(type: 'deviceUnselected', token: number): void;

差异内容：NA

	

类名：continuationManager；

API声明：function off(type: 'deviceUnselected', token: number): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function registerContinuation(callback: AsyncCallback<number>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function registerContinuation(callback: AsyncCallback<number>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function registerContinuation(options: ContinuationExtraParams, callback: AsyncCallback<number>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function registerContinuation(options: ContinuationExtraParams, callback: AsyncCallback<number>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function registerContinuation(options?: ContinuationExtraParams): Promise<number>;

差异内容：NA

	

类名：continuationManager；

API声明：function registerContinuation(options?: ContinuationExtraParams): Promise<number>;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function unregisterContinuation(token: number, callback: AsyncCallback<void>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function unregisterContinuation(token: number, callback: AsyncCallback<void>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function unregisterContinuation(token: number): Promise<void>;

差异内容：NA

	

类名：continuationManager；

API声明：function unregisterContinuation(token: number): Promise<void>;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function updateContinuationState(token: number, deviceId: string, status: DeviceConnectState, callback: AsyncCallback<void>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function updateContinuationState(token: number, deviceId: string, status: DeviceConnectState, callback: AsyncCallback<void>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function updateContinuationState(token: number, deviceId: string, status: DeviceConnectState): Promise<void>;

差异内容：NA

	

类名：continuationManager；

API声明：function updateContinuationState(token: number, deviceId: string, status: DeviceConnectState): Promise<void>;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function startContinuationDeviceManager(token: number, callback: AsyncCallback<void>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function startContinuationDeviceManager(token: number, callback: AsyncCallback<void>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function startContinuationDeviceManager(token: number, options: ContinuationExtraParams, callback: AsyncCallback<void>): void;

差异内容：NA

	

类名：continuationManager；

API声明：function startContinuationDeviceManager(token: number, options: ContinuationExtraParams, callback: AsyncCallback<void>): void;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：function startContinuationDeviceManager(token: number, options?: ContinuationExtraParams): Promise<void>;

差异内容：NA

	

类名：continuationManager；

API声明：function startContinuationDeviceManager(token: number, options?: ContinuationExtraParams): Promise<void>;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：export enum DeviceConnectState

差异内容：NA

	

类名：continuationManager；

API声明：export enum DeviceConnectState

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：DeviceConnectState；

API声明：IDLE = 0

差异内容：NA

	

类名：DeviceConnectState；

API声明：IDLE = 0

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：DeviceConnectState；

API声明：CONNECTING = 1

差异内容：NA

	

类名：DeviceConnectState；

API声明：CONNECTING = 1

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：DeviceConnectState；

API声明：CONNECTED = 2

差异内容：NA

	

类名：DeviceConnectState；

API声明：CONNECTED = 2

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：DeviceConnectState；

API声明：DISCONNECTING = 3

差异内容：NA

	

类名：DeviceConnectState；

API声明：DISCONNECTING = 3

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：export enum ContinuationMode

差异内容：NA

	

类名：continuationManager；

API声明：export enum ContinuationMode

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：ContinuationMode；

API声明：COLLABORATION_SINGLE = 0

差异内容：NA

	

类名：ContinuationMode；

API声明：COLLABORATION_SINGLE = 0

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：ContinuationMode；

API声明：COLLABORATION_MULTIPLE = 1

差异内容：NA

	

类名：ContinuationMode；

API声明：COLLABORATION_MULTIPLE = 1

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：export type ContinuationResult = _ContinuationResult;

差异内容：NA

	

类名：continuationManager；

API声明：export type ContinuationResult = _ContinuationResult;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：continuationManager；

API声明：export type ContinuationExtraParams = _ContinuationExtraParams;

差异内容：NA

	

类名：continuationManager；

API声明：export type ContinuationExtraParams = _ContinuationExtraParams;

差异内容：22

	api/@ohos.continuation.continuationManager.d.ts
API废弃版本变更	

类名：global；

API声明：export interface ContinuationExtraParams

差异内容：NA

	

类名：global；

API声明：export interface ContinuationExtraParams

差异内容：22

	api/continuation/continuationExtraParams.d.ts
API废弃版本变更	

类名：ContinuationExtraParams；

API声明：deviceType?: Array<string>;

差异内容：NA

	

类名：ContinuationExtraParams；

API声明：deviceType?: Array<string>;

差异内容：22

	api/continuation/continuationExtraParams.d.ts
API废弃版本变更	

类名：ContinuationExtraParams；

API声明：targetBundle?: string;

差异内容：NA

	

类名：ContinuationExtraParams；

API声明：targetBundle?: string;

差异内容：22

	api/continuation/continuationExtraParams.d.ts
API废弃版本变更	

类名：ContinuationExtraParams；

API声明：description?: string;

差异内容：NA

	

类名：ContinuationExtraParams；

API声明：description?: string;

差异内容：22

	api/continuation/continuationExtraParams.d.ts
API废弃版本变更	

类名：ContinuationExtraParams；

API声明：filter?: any;

差异内容：NA

	

类名：ContinuationExtraParams；

API声明：filter?: any;

差异内容：22

	api/continuation/continuationExtraParams.d.ts
API废弃版本变更	

类名：ContinuationExtraParams；

API声明：continuationMode?: continuationManager.ContinuationMode;

差异内容：NA

	

类名：ContinuationExtraParams；

API声明：continuationMode?: continuationManager.ContinuationMode;

差异内容：22

	api/continuation/continuationExtraParams.d.ts
API废弃版本变更	

类名：ContinuationExtraParams；

API声明：authInfo?: Record<string, Object>;

差异内容：NA

	

类名：ContinuationExtraParams；

API声明：authInfo?: Record<string, Object>;

差异内容：22

	api/continuation/continuationExtraParams.d.ts
API废弃版本变更	

类名：global；

API声明：export interface ContinuationResult

差异内容：NA

	

类名：global；

API声明：export interface ContinuationResult

差异内容：22

	api/continuation/continuationResult.d.ts
API废弃版本变更	

类名：ContinuationResult；

API声明：id: string;

差异内容：NA

	

类名：ContinuationResult；

API声明：id: string;

差异内容：22

	api/continuation/continuationResult.d.ts
API废弃版本变更	

类名：ContinuationResult；

API声明：type: string;

差异内容：NA

	

类名：ContinuationResult；

API声明：type: string;

差异内容：22

	api/continuation/continuationResult.d.ts
API废弃版本变更	

类名：ContinuationResult；

API声明：name: string;

差异内容：NA

	

类名：ContinuationResult；

API声明：name: string;

差异内容：22

	api/continuation/continuationResult.d.ts
新增API	NA	

类名：AtManager；

API声明：openPermissionOnSetting(context: Context, permission: Permissions): Promise<SelectedResult>;

差异内容：openPermissionOnSetting(context: Context, permission: Permissions): Promise<SelectedResult>;

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：abilityAccessCtrl；

API声明：export enum SelectedResult

差异内容：export enum SelectedResult

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：SelectedResult；

API声明：REJECTED = -1

差异内容：REJECTED = -1

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：SelectedResult；

API声明：OPENED = 0

差异内容：OPENED = 0

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：SelectedResult；

API声明：GRANTED = 1

差异内容：GRANTED = 1

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：application；

API声明：export enum AppPreloadType

差异内容：export enum AppPreloadType

	api/@ohos.app.ability.application.d.ts
新增API	NA	

类名：AppPreloadType；

API声明：UNSPECIFIED = 0

差异内容：UNSPECIFIED = 0

	api/@ohos.app.ability.application.d.ts
新增API	NA	

类名：AppPreloadType；

API声明：TYPE_CREATE_PROCESS = 1

差异内容：TYPE_CREATE_PROCESS = 1

	api/@ohos.app.ability.application.d.ts
新增API	NA	

类名：AppPreloadType；

API声明：TYPE_CREATE_ABILITY_STAGE = 2

差异内容：TYPE_CREATE_ABILITY_STAGE = 2

	api/@ohos.app.ability.application.d.ts
新增API	NA	

类名：AppPreloadType；

API声明：TYPE_CREATE_WINDOW_STAGE = 3

差异内容：TYPE_CREATE_WINDOW_STAGE = 3

	api/@ohos.app.ability.application.d.ts
新增API	NA	

类名：application；

API声明：export function getAppPreloadType(): AppPreloadType;

差异内容：export function getAppPreloadType(): AppPreloadType;

	api/@ohos.app.ability.application.d.ts
新增API	NA	

类名：common；

API声明：export type FormEditExtensionContext = _FormEditExtensionContext.default;

差异内容：export type FormEditExtensionContext = _FormEditExtensionContext.default;

	api/@ohos.app.ability.common.d.ts
新增API	NA	

类名：common；

API声明：export type LiveFormExtensionContext = _LiveFormExtensionContext.default;

差异内容：export type LiveFormExtensionContext = _LiveFormExtensionContext.default;

	api/@ohos.app.ability.common.d.ts
新增API	NA	

类名：ExtensionAbilityType；

API声明：NOTIFICATION_SUBSCRIBER = 34

差异内容：NOTIFICATION_SUBSCRIBER = 34

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：ExtensionAbilityType；

API声明：CRYPTO = 35

差异内容：CRYPTO = 35

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：bundleManager；

API声明：function getPluginBundlePathForSelf(pluginBundleName: string): string;

差异内容：function getPluginBundlePathForSelf(pluginBundleName: string): string;

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：Context；

API声明：get logFileDir(): string;

差异内容：get logFileDir(): string;

	api/application/Context.d.ts
新增API	NA	

类名：UIAbilityContext；

API声明：restartApp(want: Want): Promise<void>;

差异内容：restartApp(want: Want): Promise<void>;

	api/application/UIAbilityContext.d.ts
新增API	NA	

类名：UIAbilityContext；

API声明：setMissionWindowIcon(windowIcon: image.PixelMap): Promise<void>;

差异内容：setMissionWindowIcon(windowIcon: image.PixelMap): Promise<void>;

	api/application/UIAbilityContext.d.ts
新增API	NA	

类名：UIAbilityContext；

API声明：startSelfUIAbilityInCurrentProcess(want: Want, specifiedFlag: string, options?: StartOptions): Promise<void>;

差异内容：startSelfUIAbilityInCurrentProcess(want: Want, specifiedFlag: string, options?: StartOptions): Promise<void>;

	api/application/UIAbilityContext.d.ts


---

> 📎 ArkTS / ArkData API 变更见 [harmonyos-6-api-core-arkts.md](./harmonyos-6-api-core-arkts.md)

## See Also

- [harmonyos-6-api-core-arkts.md](./harmonyos-6-api-core-arkts.md) — ArkTS + ArkData API 变更
- [harmonyos-6-api-arkui.md](./harmonyos-6-api-arkui.md) — ArkUI API 变更
- [harmonyos-6-overview.md](./harmonyos-6-overview.md) — 6.0 新特性总览
