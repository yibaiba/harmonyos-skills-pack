# HarmonyOS 6.0 核心框架 API 变更

> Ability Kit / ArkTS / ArkData 的 API 新增、变更、废弃清单
> 版本范围：6.0.0(API 20) → 6.0.2(API 22)

## Ability Kit

### 6.0.0 变更

操作	旧版本	新版本	d.ts文件
删除错误码	

类名：bundleManager；

API声明：function getProfileByAbility(moduleName: string, abilityName: string, metadataName: string, callback: AsyncCallback<Array<string>>): void;

差异内容：17700026

	

类名：bundleManager；

API声明：function getProfileByAbility(moduleName: string, abilityName: string, metadataName: string, callback: AsyncCallback<Array<string>>): void;

差异内容：NA

	api/@ohos.bundle.bundleManager.d.ts
删除错误码	

类名：bundleManager；

API声明：function getProfileByAbility(moduleName: string, abilityName: string, metadataName?: string): Promise<Array<string>>;

差异内容：17700026

	

类名：bundleManager；

API声明：function getProfileByAbility(moduleName: string, abilityName: string, metadataName?: string): Promise<Array<string>>;

差异内容：NA

	api/@ohos.bundle.bundleManager.d.ts
删除错误码	

类名：bundleManager；

API声明：function getProfileByAbilitySync(moduleName: string, abilityName: string, metadataName?: string): Array<string>;

差异内容：17700026

	

类名：bundleManager；

API声明：function getProfileByAbilitySync(moduleName: string, abilityName: string, metadataName?: string): Array<string>;

差异内容：NA

	api/@ohos.bundle.bundleManager.d.ts
删除错误码	

类名：bundleManager；

API声明：function getProfileByExtensionAbility(moduleName: string, extensionAbilityName: string, metadataName: string, callback: AsyncCallback<Array<string>>): void;

差异内容：17700026

	

类名：bundleManager；

API声明：function getProfileByExtensionAbility(moduleName: string, extensionAbilityName: string, metadataName: string, callback: AsyncCallback<Array<string>>): void;

差异内容：NA

	api/@ohos.bundle.bundleManager.d.ts
删除错误码	

类名：bundleManager；

API声明：function getProfileByExtensionAbility(moduleName: string, extensionAbilityName: string, metadataName?: string): Promise<Array<string>>;

差异内容：17700026

	

类名：bundleManager；

API声明：function getProfileByExtensionAbility(moduleName: string, extensionAbilityName: string, metadataName?: string): Promise<Array<string>>;

差异内容：NA

	api/@ohos.bundle.bundleManager.d.ts
删除错误码	

类名：bundleManager；

API声明：function getProfileByExtensionAbilitySync(moduleName: string, extensionAbilityName: string, metadataName?: string): Array<string>;

差异内容：17700026

	

类名：bundleManager；

API声明：function getProfileByExtensionAbilitySync(moduleName: string, extensionAbilityName: string, metadataName?: string): Array<string>;

差异内容：NA

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：global；

API声明：export default class AppServiceExtensionAbility

差异内容：export default class AppServiceExtensionAbility

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增API	NA	

类名：AppServiceExtensionAbility；

API声明：context: AppServiceExtensionContext;

差异内容：context: AppServiceExtensionContext;

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增API	NA	

类名：AppServiceExtensionAbility；

API声明：onCreate(want: Want): void;

差异内容：onCreate(want: Want): void;

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增API	NA	

类名：AppServiceExtensionAbility；

API声明：onDestroy(): void;

差异内容：onDestroy(): void;

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增API	NA	

类名：AppServiceExtensionAbility；

API声明：onRequest(want: Want, startId: number): void;

差异内容：onRequest(want: Want, startId: number): void;

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增API	NA	

类名：AppServiceExtensionAbility；

API声明：onConnect(want: Want): rpc.RemoteObject;

差异内容：onConnect(want: Want): rpc.RemoteObject;

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增API	NA	

类名：AppServiceExtensionAbility；

API声明：onDisconnect(want: Want): void;

差异内容：onDisconnect(want: Want): void;

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增API	NA	

类名：global；

API声明：export default class CompletionHandler

差异内容：export default class CompletionHandler

	api/@ohos.app.ability.CompletionHandler.d.ts
新增API	NA	

类名：CompletionHandler；

API声明：onRequestSuccess(elementName: ElementName, message: string): void;

差异内容：onRequestSuccess(elementName: ElementName, message: string): void;

	api/@ohos.app.ability.CompletionHandler.d.ts
新增API	NA	

类名：CompletionHandler；

API声明：onRequestFailure(elementName: ElementName, message: string): void;

差异内容：onRequestFailure(elementName: ElementName, message: string): void;

	api/@ohos.app.ability.CompletionHandler.d.ts
新增API	NA	

类名：global；

API声明：declare interface IntentDecoratorInfo

差异内容：declare interface IntentDecoratorInfo

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：intentName: string;

差异内容：intentName: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：domain: string;

差异内容：domain: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：intentVersion: string;

差异内容：intentVersion: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：displayName: string;

差异内容：displayName: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：displayDescription?: string;

差异内容：displayDescription?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：schema?: string;

差异内容：schema?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：icon?: ResourceStr;

差异内容：icon?: ResourceStr;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：llmDescription?: string;

差异内容：llmDescription?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：keywords?: string[];

差异内容：keywords?: string[];

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：parameters?: Record<string, Object>;

差异内容：parameters?: Record<string, Object>;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：result?: Record<string, Object>;

差异内容：result?: Record<string, Object>;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：IntentDecoratorInfo；

API声明：example?: string;

差异内容：example?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：declare interface LinkIntentDecoratorInfo

差异内容：declare interface LinkIntentDecoratorInfo

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：LinkIntentDecoratorInfo；

API声明：uri: string;

差异内容：uri: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：LinkIntentDecoratorInfo；

API声明：paramMappings?: LinkIntentParamMapping[];

差异内容：paramMappings?: LinkIntentParamMapping[];

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：declare enum LinkParamCategory

差异内容：declare enum LinkParamCategory

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：LinkParamCategory；

API声明：LINK = 'link'

差异内容：LINK = 'link'

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：LinkParamCategory；

API声明：WANT = 'want'

差异内容：WANT = 'want'

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：declare interface LinkIntentParamMapping

差异内容：declare interface LinkIntentParamMapping

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：LinkIntentParamMapping；

API声明：paramName: string;

差异内容：paramName: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：LinkIntentParamMapping；

API声明：paramMappingName?: string;

差异内容：paramMappingName?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：LinkIntentParamMapping；

API声明：paramCategory?: LinkParamCategory;

差异内容：paramCategory?: LinkParamCategory;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：export declare const InsightIntentLink: ((intentInfo: LinkIntentDecoratorInfo) => ClassDecorator);

差异内容：export declare const InsightIntentLink: ((intentInfo: LinkIntentDecoratorInfo) => ClassDecorator);

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：declare interface PageIntentDecoratorInfo

差异内容：declare interface PageIntentDecoratorInfo

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：PageIntentDecoratorInfo；

API声明：uiAbility?: string;

差异内容：uiAbility?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：PageIntentDecoratorInfo；

API声明：pagePath: string;

差异内容：pagePath: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：PageIntentDecoratorInfo；

API声明：navigationId?: string;

差异内容：navigationId?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：PageIntentDecoratorInfo；

API声明：navDestinationName?: string;

差异内容：navDestinationName?: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：export declare const InsightIntentPage: ((intentInfo: PageIntentDecoratorInfo) => ClassDecorator);

差异内容：export declare const InsightIntentPage: ((intentInfo: PageIntentDecoratorInfo) => ClassDecorator);

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：declare interface FunctionIntentDecoratorInfo

差异内容：declare interface FunctionIntentDecoratorInfo

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：export declare const InsightIntentFunctionMethod: ((intentInfo: FunctionIntentDecoratorInfo) => MethodDecorator);

差异内容：export declare const InsightIntentFunctionMethod: ((intentInfo: FunctionIntentDecoratorInfo) => MethodDecorator);

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：export declare const InsightIntentFunction: (() => ClassDecorator);

差异内容：export declare const InsightIntentFunction: (() => ClassDecorator);

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：declare interface EntryIntentDecoratorInfo

差异内容：declare interface EntryIntentDecoratorInfo

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：EntryIntentDecoratorInfo；

API声明：abilityName: string;

差异内容：abilityName: string;

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：EntryIntentDecoratorInfo；

API声明：executeMode: insightIntent.ExecuteMode[];

差异内容：executeMode: insightIntent.ExecuteMode[];

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：export declare const InsightIntentEntry: ((intentInfo: EntryIntentDecoratorInfo) => ClassDecorator);

差异内容：export declare const InsightIntentEntry: ((intentInfo: EntryIntentDecoratorInfo) => ClassDecorator);

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增API	NA	

类名：global；

API声明：export default class InsightIntentEntryExecutor

差异内容：export default class InsightIntentEntryExecutor

	api/@ohos.app.ability.InsightIntentEntryExecutor.d.ts
新增API	NA	

类名：InsightIntentEntryExecutor；

API声明：executeMode: insightIntent.ExecuteMode;

差异内容：executeMode: insightIntent.ExecuteMode;

	api/@ohos.app.ability.InsightIntentEntryExecutor.d.ts
新增API	NA	

类名：InsightIntentEntryExecutor；

API声明：context: InsightIntentContext;

差异内容：context: InsightIntentContext;

	api/@ohos.app.ability.InsightIntentEntryExecutor.d.ts
新增API	NA	

类名：InsightIntentEntryExecutor；

API声明：windowStage?: window.WindowStage;

差异内容：windowStage?: window.WindowStage;

	api/@ohos.app.ability.InsightIntentEntryExecutor.d.ts
新增API	NA	

类名：InsightIntentEntryExecutor；

API声明：uiExtensionSession?: UIExtensionContentSession;

差异内容：uiExtensionSession?: UIExtensionContentSession;

	api/@ohos.app.ability.InsightIntentEntryExecutor.d.ts
新增API	NA	

类名：InsightIntentEntryExecutor；

API声明：onExecute(): Promise<insightIntent.IntentResult<T>>;

差异内容：onExecute(): Promise<insightIntent.IntentResult<T>>;

	api/@ohos.app.ability.InsightIntentEntryExecutor.d.ts
新增API	NA	

类名：global；

API声明：export default class AppServiceExtensionContext

差异内容：export default class AppServiceExtensionContext

	api/application/AppServiceExtensionContext.d.ts
新增API	NA	

类名：AppServiceExtensionContext；

API声明：connectServiceExtensionAbility(want: Want, options: ConnectOptions): number;

差异内容：connectServiceExtensionAbility(want: Want, options: ConnectOptions): number;

	api/application/AppServiceExtensionContext.d.ts
新增API	NA	

类名：AppServiceExtensionContext；

API声明：disconnectServiceExtensionAbility(connection: number): Promise<void>;

差异内容：disconnectServiceExtensionAbility(connection: number): Promise<void>;

	api/application/AppServiceExtensionContext.d.ts
新增API	NA	

类名：AppServiceExtensionContext；

API声明：terminateSelf(): Promise<void>;

差异内容：terminateSelf(): Promise<void>;

	api/application/AppServiceExtensionContext.d.ts
新增API	NA	

类名：startupManager；

API声明：function run(startupTasks: Array<string>, context: common.AbilityStageContext, config: StartupConfig): Promise<void>;

差异内容：function run(startupTasks: Array<string>, context: common.AbilityStageContext, config: StartupConfig): Promise<void>;

	api/@ohos.app.appstartup.startupManager.d.ts
新增API	NA	

类名：bundleManager；

API声明：enum AbilityFlag

差异内容：enum AbilityFlag

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_DEFAULT = 0x00000000

差异内容：GET_ABILITY_INFO_DEFAULT = 0x00000000

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_WITH_PERMISSION = 0x00000001

差异内容：GET_ABILITY_INFO_WITH_PERMISSION = 0x00000001

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_WITH_APPLICATION = 0x00000002

差异内容：GET_ABILITY_INFO_WITH_APPLICATION = 0x00000002

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_WITH_METADATA = 0x00000004

差异内容：GET_ABILITY_INFO_WITH_METADATA = 0x00000004

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_WITH_DISABLE = 0x00000008

差异内容：GET_ABILITY_INFO_WITH_DISABLE = 0x00000008

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_ONLY_SYSTEM_APP = 0x00000010

差异内容：GET_ABILITY_INFO_ONLY_SYSTEM_APP = 0x00000010

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_WITH_APP_LINKING = 0x00000040

差异内容：GET_ABILITY_INFO_WITH_APP_LINKING = 0x00000040

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：AbilityFlag；

API声明：GET_ABILITY_INFO_WITH_SKILL = 0x00000080

差异内容：GET_ABILITY_INFO_WITH_SKILL = 0x00000080

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：ExtensionAbilityType；

API声明：LIVE_FORM = 30

差异内容：LIVE_FORM = 30

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：ExtensionAbilityType；

API声明：APP_SERVICE = 29

差异内容：APP_SERVICE = 29

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：bundleManager；

API声明：function getAbilityInfo(uri: string, abilityFlags: number): Promise<Array<AbilityInfo>>;

差异内容：function getAbilityInfo(uri: string, abilityFlags: number): Promise<Array<AbilityInfo>>;

	api/@ohos.bundle.bundleManager.d.ts
新增API	NA	

类名：abilityAccessCtrl；

API声明：export enum PermissionStatus

差异内容：export enum PermissionStatus

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：PermissionStatus；

API声明：DENIED = -1

差异内容：DENIED = -1

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：PermissionStatus；

API声明：GRANTED = 0

差异内容：GRANTED = 0

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：PermissionStatus；

API声明：NOT_DETERMINED = 1

差异内容：NOT_DETERMINED = 1

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：PermissionStatus；

API声明：INVALID = 2

差异内容：INVALID = 2

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：PermissionStatus；

API声明：RESTRICTED = 3

差异内容：RESTRICTED = 3

	api/@ohos.abilityAccessCtrl.d.ts
新增API	NA	

类名：abilityManager；

API声明：export type AbilityStateData = _AbilityStateData.default;

差异内容：export type AbilityStateData = _AbilityStateData.default;

	api/@ohos.app.ability.abilityManager.d.ts
新增API	NA	

类名：appManager；

API声明：export type AbilityStateData = _AbilityStateData.default;

差异内容：export type AbilityStateData = _AbilityStateData.default;

	api/@ohos.app.ability.appManager.d.ts
新增API	NA	

类名：appManager；

API声明：export type AppStateData = _AppStateData.default;

差异内容：export type AppStateData = _AppStateData.default;

	api/@ohos.app.ability.appManager.d.ts
新增API	NA	

类名：appManager；

API声明：export type ProcessData = _ProcessData.default;

差异内容：export type ProcessData = _ProcessData.default;

	api/@ohos.app.ability.appManager.d.ts
新增API	NA	

类名：common；

API声明：export type AppServiceExtensionContext = _AppServiceExtensionContext.default;

差异内容：export type AppServiceExtensionContext = _AppServiceExtensionContext.default;

	api/@ohos.app.ability.common.d.ts
新增API	NA	

类名：insightIntent；

API声明：interface IntentEntity

差异内容：interface IntentEntity

	api/@ohos.app.ability.insightIntent.d.ts
新增API	NA	

类名：IntentEntity；

API声明：entityId: string;

差异内容：entityId: string;

	api/@ohos.app.ability.insightIntent.d.ts
新增API	NA	

类名：insightIntent；

API声明：interface IntentResult

差异内容：interface IntentResult

	api/@ohos.app.ability.insightIntent.d.ts
新增API	NA	

类名：IntentResult；

API声明：code: number;

差异内容：code: number;

	api/@ohos.app.ability.insightIntent.d.ts
新增API	NA	

类名：IntentResult；

API声明：result?: T;

差异内容：result?: T;

	api/@ohos.app.ability.insightIntent.d.ts
新增API	NA	

类名：sendableContextManager；

API声明：function setEventHubMultithreadingEnabled(context: common.Context, enabled: boolean): void;

差异内容：function setEventHubMultithreadingEnabled(context: common.Context, enabled: boolean): void;

	api/@ohos.app.ability.sendableContextManager.d.ets
新增kit	

类名：global；

API声明：

差异内容：NA

	

类名：global；

API声明：api@ohos.app.ability.AppServiceExtensionAbility.d.ts

差异内容：AbilityKit

	api/@ohos.app.ability.AppServiceExtensionAbility.d.ts
新增kit	

类名：global；

API声明：

差异内容：NA

	

类名：global；

API声明：api@ohos.app.ability.CompletionHandler.d.ts

差异内容：AbilityKit

	api/@ohos.app.ability.CompletionHandler.d.ts
新增kit	

类名：global；

API声明：

差异内容：NA

	

类名：global；

API声明：api@ohos.app.ability.InsightIntentDecorator.d.ts

差异内容：AbilityKit

	api/@ohos.app.ability.InsightIntentDecorator.d.ts
新增kit	

类名：global；

API声明：

差异内容：NA

	

类名：global；

API声明：api@ohos.app.ability.InsightIntentEntryExecutor.d.ts

差异内容：AbilityKit

	api/@ohos.app.ability.InsightIntentEntryExecutor.d.ts
新增kit	

类名：global；

API声明：

差异内容：NA

	

类名：global；

API声明：api\application\AppServiceExtensionContext.d.ts

差异内容：AbilityKit

	api/application/AppServiceExtensionContext.d.ts
类新增可选成员	

类名：global；

API声明：

差异内容：NA

	

类名：StartOptions；

API声明：completionHandler?: CompletionHandler;

差异内容：completionHandler?: CompletionHandler;

	api/@ohos.app.ability.StartOptions.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：AbilityStage；

API声明：onAcceptWantAsync(want: Want): Promise<string>;

差异内容：onAcceptWantAsync(want: Want): Promise<string>;

	api/@ohos.app.ability.AbilityStage.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：AbilityStage；

API声明：onNewProcessRequestAsync(want: Want): Promise<string>;

差异内容：onNewProcessRequestAsync(want: Want): Promise<string>;

	api/@ohos.app.ability.AbilityStage.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：UIAbility；

API声明：onSaveStateAsync(stateType: AbilityConstant.StateType, wantParam: Record<string, Object>): Promise<AbilityConstant.OnSaveResult>;

差异内容：onSaveStateAsync(stateType: AbilityConstant.StateType, wantParam: Record<string, Object>): Promise<AbilityConstant.OnSaveResult>;

	api/@ohos.app.ability.UIAbility.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：StartupConfigEntry；

API声明：onRequestCustomMatchRule(want: Want): string;

差异内容：onRequestCustomMatchRule(want: Want): string;

	api/@ohos.app.appstartup.StartupConfigEntry.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：UIAbilityContext；

API声明：startAppServiceExtensionAbility(want: Want): Promise<void>;

差异内容：startAppServiceExtensionAbility(want: Want): Promise<void>;

	api/application/UIAbilityContext.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：UIAbilityContext；

API声明：stopAppServiceExtensionAbility(want: Want): Promise<void>;

差异内容：stopAppServiceExtensionAbility(want: Want): Promise<void>;

	api/application/UIAbilityContext.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：UIAbilityContext；

API声明：connectAppServiceExtensionAbility(want: Want, options: ConnectOptions): number;

差异内容：connectAppServiceExtensionAbility(want: Want, options: ConnectOptions): number;

	api/application/UIAbilityContext.d.ts
类新增必选属性或非同名方法	

类名：global；

API声明：

差异内容：NA

	

类名：UIAbilityContext；

API声明：disconnectAppServiceExtensionAbility(connection: number): Promise<void>;

差异内容：disconnectAppServiceExtensionAbility(connection: number): Promise<void>;

	api/application/UIAbilityContext.d.ts
接口新增可选或必选方法	

类名：global；

API声明：

差异内容：NA

	

类名：AtManager；

API声明：getSelfPermissionStatus(permissionName: Permissions): PermissionStatus;

差异内容：getSelfPermissionStatus(permissionName: Permissions): PermissionStatus;

	api/@ohos.abilityAccessCtrl.d.ts
接口新增可选属性	

类名：global；

API声明：

差异内容：NA

	

类名：LastExitDetailInfo；

API声明：processState?: appManager.ProcessState;

差异内容：processState?: appManager.ProcessState;

	api/@ohos.app.ability.AbilityConstant.d.ts
接口新增可选属性	

类名：global；

API声明：

差异内容：NA

	

类名：Configuration；

API声明：locale?: Intl.Locale;

差异内容：locale?: Intl.Locale;

	api/@ohos.app.ability.Configuration.d.ts
接口新增可选属性	

类名：global；

API声明：

差异内容：NA

	

类名：Configuration；

API声明：locale?: Intl.Locale;

差异内容：locale?: Intl.Locale;

	api/@ohos.app.ability.Configuration.d.ts

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
