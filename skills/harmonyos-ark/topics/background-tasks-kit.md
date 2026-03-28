# Background Tasks Kit 后台任务（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V5/API 12）
> 覆盖：后台任务简介、短时任务、长时任务、延迟任务（WorkScheduler）


## 目录

- [Background Tasks Kit简介](#background-tasks-kit简介)
- [短时任务](#短时任务)
- [长时任务](#长时任务)
- [延迟任务](#延迟任务)

---

## Background Tasks Kit简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/background-task-overview-V5

功能介绍

设备返回主界面、锁屏、应用切换等操作会使应用退至后台。应用退至后台后，如果继续活动，可能会造成设备耗电快、用户界面卡顿等现象。为了降低设备耗电速度、保障用户使用流畅度，系统会对退至后台的应用进行管控，包括进程挂起和进程终止。挂起后，应用进程无法使用软件资源（如公共事件、定时器等）和硬件资源（CPU、网络、GPS、蓝牙等）。如何合理使用请参考合理使用后台硬件资源。

应用退至后台一小段时间（由系统定义），应用进程会被挂起。

应用退至后台，在后台被访问一小段时间（由系统定义）后，应用进程会被挂起。

资源不足时，系统会终止部分应用进程（即回收该进程的所有资源）。

同时，为了保障后台音乐播放、日历提醒等功能的正常使用，系统提供了规范内受约束的后台任务，扩展应用在后台运行时间。

资源使用约束

对于运行的进程，系统会给予一定的资源配额约束，包括进程在连续一段时间内内存的使用、CPU使用占比，以及24小时磁盘写的IO量，均有对应的配额上限。超过配额上限时，如果进程处于前台，系统会有对应的warning日志，如果进程处于后台，系统会终止该进程。

后台任务类型

标准系统支持规范内受约束的后台任务，包括短时任务、长时任务、延迟任务、代理提醒和能效资源。

开发者可以根据如下的功能介绍，选择合适的后台任务，以满足应用退至后台后继续运行的需求。

短时任务：适用于实时性要求高、耗时不长的任务，例如状态保存。

长时任务：适用于长时间运行在后台、用户可感知的任务，例如后台播放音乐、导航、设备连接等，使用长时任务避免应用进程被挂起。

延迟任务：对于实时性要求不高、可延迟执行的任务，系统提供了延迟任务，即满足条件的应用退至后台后被放入执行队列，系统会根据内存、功耗等统一调度。

代理提醒：代理提醒是指应用退后台或进程终止后，系统会代理应用做相应的提醒。适用于定时提醒类业务，当前支持的提醒类型包括倒计时、日历和闹钟三类。

图1 后台任务类型选择

说明

系统仅支持规范内受约束的后台任务。应用退至后台后，若未使用规范内的后台任务或选择的后台任务类型不正确，对应的应用进程会被挂起或终止。

应用申请了规范内的后台任务，仅会提升应用进程被回收的优先级。当系统资源严重不足时，即使应用进程申请了规范内的后台任务，系统仍会终止部分进程，用以保障系统稳定性。

---

## 短时任务

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/transient-task-V5

概述

应用退至后台一小段时间后，应用进程会被挂起，无法执行对应的任务。如果应用在后台仍需要执行耗时不长的任务，如状态保存等，可以通过本文申请短时任务，扩展应用在后台的运行时间。

约束与限制

申请时机：应用需要在前台或onBackground回调内，申请短时任务，否则会申请失败。

数量限制：一个应用同一时刻最多申请3个短时任务。以图1为例，在①②③时间段内的任意时刻，应用申请了2个短时任务；在④时间段内的任意时刻，应用申请了1个短时任务。

配额机制：一个应用会有一定的短时任务配额（根据系统状态和用户习惯调整），单日（24小时内）配额默认为10分钟，单次配额最大为3分钟，低电量时单次配额默认为1分钟，配额消耗完后不允许再申请短时任务。同时，系统提供获取对应短时任务剩余时间的查询接口，用以查询本次短时任务剩余时间，以确认是否继续运行其他业务。

配额计算：仅当应用在后台时，对应用下的短时任务计时；同一个应用下的同一个时间段的短时任务，不重复计时。以下图为例：应用有两个短时任务A和B，在前台时申请短时任务A，应用退至后台后开始计时为①，应用进入前台②后不计时，再次进入后台③后开始计时，短时任务A结束后，由于阶段④仍然有短时任务B，所以该阶段继续计时。因此，在这个过程中，该应用短时任务总耗时为①+③+④。

图1 短时任务配额计算原理图

说明

任务完成后，应用需主动取消短时任务，否则会影响应用当日短时任务的剩余配额。

超时：短时任务即将超时时，系统会回调应用，应用需要取消短时任务。如果超时不取消，系统会终止对应的应用进程。

接口说明

表1 主要接口

以下是短时任务开发使用的主要接口，更多接口及使用方式请见后台任务管理。

接口名	描述
requestSuspendDelay(reason: string, callback: Callback<void>): DelaySuspendInfo	申请短时任务。
getRemainingDelayTime(requestId: number): Promise<number>	获取对应短时任务的剩余时间。
cancelSuspendDelay(requestId: number): void	取消短时任务。
开发步骤

导入模块。

import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';

申请短时任务并实现回调。此处回调在短时任务即将结束时触发，与应用的业务功能不耦合，短时任务申请成功后，正常执行应用本身的任务。

let id: number;         // 申请短时任务ID
let delayTime: number;  // 本次申请短时任务的剩余时间


// 申请短时任务
function requestSuspendDelay() {
  let myReason = 'test requestSuspendDelay';   // 申请原因
  let delayInfo = backgroundTaskManager.requestSuspendDelay(myReason, () => {
    // 回调函数。应用申请的短时任务即将超时，通过此函数回调应用，执行一些清理和标注工作，并取消短时任务
    console.info('suspend delay task will timeout');
    backgroundTaskManager.cancelSuspendDelay(id);
  })
  id = delayInfo.requestId;
  delayTime = delayInfo.actualDelayTime;
}


// 执行应用本身业务

获取短时任务剩余时间。查询本次短时任务的剩余时间，用以判断是否继续运行其他业务，例如应用有两个小任务，在执行完第一个小任务后，可以判断本次短时任务是否还有剩余时间来决定是否执行第二个小任务。

let id: number; // 申请短时任务ID


async function getRemainingDelayTime() {
  backgroundTaskManager.getRemainingDelayTime(id).then((res: number) => {
    console.info('Succeeded in getting remaining delay time.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to get remaining delay time. Code: ${err.code}, message: ${err.message}`);
  })
}

取消短时任务。

let id: number; // 申请短时任务ID


function cancelSuspendDelay() {
  backgroundTaskManager.cancelSuspendDelay(id);
}

---

## 长时任务

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/continuous-task-V5

概述
功能介绍

应用退至后台后，在后台需要长时间运行用户可感知的任务，如播放音乐、导航等。为防止应用进程被挂起，导致对应功能异常，可以申请长时任务，使应用在后台长时间运行。在长时任务中，支持同时申请多种类型的任务，也可以对任务类型进行更新。应用退至后台执行业务时，系统会做一致性校验，确保应用在执行相应的长时任务。应用在申请长时任务成功后，通知栏会显示与长时任务相关联的消息，用户删除通知栏消息时，系统会自动停止长时任务。

使用场景

下表给出了当前长时任务支持的类型，包含数据传输、音视频播放、录制、定位导航、蓝牙相关业务、多设备互联和计算任务。可以参考下表中的场景举例，选择合适的长时任务类型。

表1 长时任务类型

参数名	描述	配置项	场景举例
DATA_TRANSFER	数据传输	dataTransfer	非托管形式的上传、下载，如在浏览器后台上传或下载数据。
AUDIO_PLAYBACK	音视频播放	audioPlayback	

音频、视频在后台播放，音视频投播。

说明： 支持在元服务中使用。


AUDIO_RECORDING	录制	audioRecording	录音、录屏退后台。
LOCATION	定位导航	location	定位、导航。
BLUETOOTH_INTERACTION	蓝牙相关业务	bluetoothInteraction	通过蓝牙传输文件时退后台。
MULTI_DEVICE_CONNECTION	多设备互联	multiDeviceConnection	

分布式业务连接、投播。

说明： 支持在元服务中使用。


TASK_KEEPING	计算任务（仅对2in1设备开放）	taskKeeping	如杀毒软件。

关于DATA_TRANSFER（数据传输）说明：

在数据传输时，若应用使用上传下载代理接口托管给系统，即使申请DATA_TRANSFER的后台任务，应用退后台时还是会被挂起。

在数据传输时，应用需要更新进度。如果进度长时间（超过10分钟）不更新，数据传输的长时任务会被取消。更新进度实现可参考startBackgroundRunning()中的示例。

关于AUDIO_PLAYBACK（音视频播放）说明：

若要通过AUDIO_PLAYBACK实现后台播放，须使用媒体会话服务（AVSession）进行音视频开发。

音视频投播，是指将一台设备的音视频投至另一台设备播放。投播退至后台，长时任务会检测音视频播放和投屏两个业务，只要有其一正常运行，长时任务就不会终止。

约束与限制

申请限制：Stage模型中，长时任务仅支持UIAbility申请；FA模型中，长时任务仅支持ServiceAbility申请。长时任务支持设备当前应用申请，也支持跨设备或跨应用申请，跨设备或跨应用仅对系统应用开放。

数量限制：一个UIAbility（FA模型则为ServiceAbility）同一时刻仅支持申请一个长时任务，即在一个长时任务结束后才可能继续申请。如果一个应用同时需要申请多个长时任务，需要创建多个UIAbility；一个应用的一个UIAbility申请长时任务后，整个应用下的所有进程均不会被挂起。

运行限制：

申请长时任务后，应用未执行相应的业务，系统会对应用进行管控。如系统检测到应用申请了AUDIO_PLAYBACK（音视频播放），但实际未播放音乐，长时任务会被取消。

申请长时任务后，应用执行的业务类型与申请的不一致，系统会对应用进行管控。如系统检测到应用只申请了AUDIO_PLAYBACK（音视频播放），但实际上除了播放音乐（对应AUDIO_PLAYBACK类型），还在进行录制（对应AUDIO_RECORDING类型）。

申请长时任务后，应用的业务已执行完，系统会对应用进行管控。

若运行长时任务的进程后台负载持续高于所申请类型的典型负载，系统会对应用进行管控。

说明

应用按需求申请长时任务，当应用无需在后台运行（任务结束）时，要及时主动取消长时任务，否则系统会强行取消。例如用户主动点击音乐暂停播放时，应用需及时取消对应的长时任务；用户再次点击音乐播放时，需重新申请长时任务。

若音频在后台播放时被打断，系统会自行检测和停止长时任务，音频重启播放时，需要再次申请长时任务。

后台播放音频的应用，在停止长时任务的同时，需要暂停或停止音频流，否则应用会被系统强制终止。

接口说明

表2 主要接口

以下是长时任务开发使用的相关接口，下表均以Promise形式为例，更多接口及使用方式请见后台任务管理。

接口名	描述
startBackgroundRunning(context: Context, bgMode: BackgroundMode, wantAgent: WantAgent): Promise<void>	申请长时任务
stopBackgroundRunning(context: Context): Promise<void>	取消长时任务
开发步骤

本文以申请录制长时任务为例，实现如下功能：

点击“申请长时任务”按钮，应用申请录制长时任务成功，通知栏显示“正在运行录制任务”通知。

点击“取消长时任务”按钮，取消长时任务，通知栏撤销相关通知。

Stage模型

需要申请ohos.permission.KEEP_BACKGROUND_RUNNING权限，配置方式请参见声明权限。

声明后台模式类型。在module.json5文件中为需要使用长时任务的UIAbility声明相应的长时任务类型，配置文件中填写长时任务类型的配置项。

 "module": {
     "abilities": [
         {
             "backgroundModes": [
              // 长时任务类型的配置项
             "audioRecording"
             ]
         }
     ],
     // ...
 }

导入模块。

长时任务相关的模块为@ohos.resourceschedule.backgroundTaskManager和@ohos.app.ability.wantAgent，其余模块按实际需要导入。

 import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
 import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
 import { window } from '@kit.ArkUI';
 import { rpc } from '@kit.IPCKit'
 import { BusinessError } from '@kit.BasicServicesKit';
 import { wantAgent, WantAgent } from '@kit.AbilityKit';

申请和取消长时任务。

设备当前应用申请长时任务示例代码如下：

 @Entry
 @Component
 struct Index {
   @State message: string = 'ContinuousTask';
  // 通过getContext方法，来获取page所在的UIAbility上下文。
   private context: Context = getContext(this);


   startContinuousTask() {
     let wantAgentInfo: wantAgent.WantAgentInfo = {
       // 点击通知后，将要执行的动作列表
       // 添加需要被拉起应用的bundleName和abilityName
       wants: [
         {
           bundleName: "com.example.myapplication",
           abilityName: "MainAbility"
         }
       ],
       // 指定点击通知栏消息后的动作是拉起ability
       actionType: wantAgent.OperationType.START_ABILITY,
       // 使用者自定义的一个私有值
       requestCode: 0,
       // 点击通知后，动作执行属性
       actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
     };


     // 通过wantAgent模块下getWantAgent方法获取WantAgent对象
     wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
       backgroundTaskManager.startBackgroundRunning(this.context,
         backgroundTaskManager.BackgroundMode.AUDIO_RECORDING, wantAgentObj).then(() => {
         // 此处执行具体的长时任务逻辑，如放音等。
         console.info(`Succeeded in operationing startBackgroundRunning.`);
       }).catch((err: BusinessError) => {
         console.error(`Failed to operation startBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
       });
     });
   }


   stopContinuousTask() {
      backgroundTaskManager.stopBackgroundRunning(this.context).then(() => {
        console.info(`Succeeded in operationing stopBackgroundRunning.`);
      }).catch((err: BusinessError) => {
        console.error(`Failed to operation stopBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
      });
   }


   build() {
     Row() {
       Column() {
         Text("Index")
           .fontSize(50)
           .fontWeight(FontWeight.Bold)


        Button() {
           Text('申请长时任务').fontSize(25).fontWeight(FontWeight.Bold)
         }
         .type(ButtonType.Capsule)
         .margin({ top: 10 })
         .backgroundColor('#0D9FFB')
         .width(250)
         .height(40)
         .onClick(() => {
           // 通过按钮申请长时任务
           this.startContinuousTask();
         })


         Button() {
           Text('取消长时任务').fontSize(25).fontWeight(FontWeight.Bold)
         }
         .type(ButtonType.Capsule)
         .margin({ top: 10 })
         .backgroundColor('#0D9FFB')
         .width(250)
         .height(40)
         .onClick(() => {
           // 此处结束具体的长时任务的执行


           // 通过按钮取消长时任务
           this.stopContinuousTask();
         })
       }
       .width('100%')
     }
     .height('100%')
   }
 }

---

## 延迟任务

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/work-scheduler-V5

概述
功能介绍

应用退至后台后，需要执行实时性要求不高的任务，例如有网络时不定期主动获取邮件等，可以使用延迟任务。当应用满足设定条件（包括网络类型、充电类型、存储状态、电池状态、定时状态等）时，将任务添加到执行队列，系统会根据内存、功耗、设备温度、用户使用习惯等统一调度拉起应用。

运行原理

图1 延迟任务实现原理

应用调用延迟任务接口添加、删除、查询延迟任务，延迟任务管理模块会根据任务设置的条件（通过WorkInfo参数设置，包括网络类型、充电类型、存储状态等）和系统状态（包括内存、功耗、设备温度、用户使用习惯等）统一决策调度时机。

当满足调度条件或调度结束时，系统会回调应用WorkSchedulerExtensionAbility中 onWorkStart() 或 onWorkStop() 的方法，同时会为应用单独创建一个Extension扩展进程用以承载WorkSchedulerExtensionAbility，并给WorkSchedulerExtensionAbility一定的活动周期，开发者可以在对应回调方法中实现自己的任务逻辑。

约束与限制

数量限制：一个应用同一时刻最多申请10个延迟任务。

执行频率限制：系统会根据应用的活跃分组，对延迟任务做分级管控，限制延迟任务调度的执行频率。

表1 应用活跃程度分组

应用活跃分组	延迟任务执行频率
活跃分组	最小间隔2小时
经常使用分组	最小间隔4小时
常用使用	最小间隔24小时
极少使用分组	最小间隔48小时
受限使用分组	禁止
从未使用分组	禁止

超时：WorkSchedulerExtensionAbility单次回调最长运行2分钟。如果超时不取消，系统会终止对应的Extension进程。

调度延迟：系统会根据内存、功耗、设备温度、用户使用习惯等统一调度，如当系统内存资源不足或温度达到一定挡位时，系统将延迟调度该任务。

WorkSchedulerExtensionAbility接口调用限制：为实现对WorkSchedulerExtensionAbility能力的管控，在WorkSchedulerExtensionAbility中限制以下接口的调用：

@ohos.resourceschedule.backgroundTaskManager (后台任务管理)

@ohos.backgroundTaskManager (后台任务管理)

@ohos.multimedia.camera (相机管理)

@ohos.multimedia.audio (音频管理)

@ohos.multimedia.media (媒体服务)

接口说明

表2 延迟任务主要接口

以下是延迟任务开发使用的相关接口，更多接口及使用方式请见延迟任务调度文档。

接口名	接口描述
startWork(work: WorkInfo): void;	申请延迟任务
stopWork(work: WorkInfo, needCancel?: boolean): void;	取消延迟任务
getWorkStatus(workId: number, callback: AsyncCallback<WorkInfo>): void;	获取延迟任务状态（Callback形式）
getWorkStatus(workId: number): Promise<WorkInfo>;	获取延迟任务状态（Promise形式）
obtainAllWorks(callback: AsyncCallback<Array<WorkInfo>>): void;	获取所有延迟任务（Callback形式）
obtainAllWorks(): Promise<Array<WorkInfo>>;	获取所有延迟任务（Promise形式）
stopAndClearWorks(): void;	停止并清除任务
isLastWorkTimeOut(workId: number, callback: AsyncCallback<boolean>): void;	获取上次任务是否超时（针对RepeatWork，Callback形式）
isLastWorkTimeOut(workId: number): Promise<boolean>;	获取上次任务是否超时（针对RepeatWork，Promise形式）

表3 WorkInfo参数

名称	类型	必填	说明
workId	number	是	延迟任务ID。
bundleName	string	是	延迟任务所在应用的包名。
abilityName	string	是	包内ability名称。
networkType	NetworkType	否	网络类型。
isCharging	boolean	否	

是否充电。

- true表示充电触发延迟回调。

- false表示不充电触发延迟回调。


chargerType	ChargingType	否	充电类型。
batteryLevel	number	否	电量。
batteryStatus	BatteryStatus	否	电池状态。
storageRequest	StorageRequest	否	存储状态。
isRepeat	boolean	否	

是否循环任务。

- true表示循环任务。

- false表示非循环任务。


repeatCycleTime	number	否	循环间隔，单位为毫秒。
repeatCount	number	否	循环次数。
isPersisted	boolean	否	

注册的延迟任务是否可保存在系统中。

- true表示可保存，即系统重启后，任务可恢复。

- false表示不可保存。


isDeepIdle	boolean	否	

是否要求设备进入空闲状态。

- true表示需要。

- false表示不需要。


idleWaitTime	number	否	空闲等待时间，单位为毫秒。
parameters	[key: string]: number | string | boolean	否	携带参数信息。

WorkInfo参数用于设置应用条件，参数设置时需遵循以下规则：

workId、bundleName、abilityName为必填项，bundleName需为本应用包名。

携带参数信息仅支持number、string、boolean三种类型。

至少设置一个满足的条件，包括网络类型、充电类型、存储状态、电池状态、定时状态等。

对于重复任务，任务执行间隔至少2小时。设置重复任务时间间隔时，须同时设置是否循环或循环次数中的一个。

表4 延迟任务回调接口

以下是延迟任务回调开发使用的相关接口，更多接口及使用方式请见延迟任务调度回调文档。

接口名	接口描述
onWorkStart(work: workScheduler.WorkInfo): void	延迟调度任务开始的回调
onWorkStop(work: workScheduler.WorkInfo): void	延迟调度任务结束的回调
开发步骤

延迟任务调度开发步骤分为两步：实现延迟任务调度扩展能力、实现延迟任务调度。

延迟任务调度扩展能力：实现WorkSchedulerExtensionAbility开始和结束的回调接口。

延迟任务调度：调用延迟任务接口，实现延迟任务申请、取消等功能。

实现延迟任务回调拓展能力

新建工程目录。

在工程entry Module对应的ets目录(./entry/src/main/ets)下，新建目录及ArkTS文件，例如新建一个目录并命名为WorkSchedulerExtension。在WorkSchedulerExtension目录下，新建一个ArkTS文件并命名为WorkSchedulerExtension.ets，用以实现延迟任务回调接口。

导入模块。

import { WorkSchedulerExtensionAbility, workScheduler } from '@kit.BackgroundTasksKit';

实现WorkSchedulerExtension生命周期接口。

export default class MyWorkSchedulerExtensionAbility extends WorkSchedulerExtensionAbility {
  // 延迟任务开始回调
  onWorkStart(workInfo: workScheduler.WorkInfo) {
    console.info(`onWorkStart, workInfo = ${JSON.stringify(workInfo)}`);
    // 打印 parameters中的参数，如：参数key1
    // console.info(`work info parameters: ${JSON.parse(workInfo.parameters?.toString()).key1}`)
  }


  // 延迟任务结束回调
  onWorkStop(workInfo: workScheduler.WorkInfo) {
    console.info(`onWorkStop, workInfo is ${JSON.stringify(workInfo)}`);
  }
}

在module.json5配置文件中注册WorkSchedulerExtensionAbility，并设置如下标签：

type标签设置为“workScheduler”。

srcEntry标签设置为当前ExtensionAbility组件所对应的代码路径。

{
  "module": {
      "extensionAbilities": [
        {
          "name": "MyWorkSchedulerExtensionAbility",
          "srcEntry": "./ets/WorkSchedulerExtension/WorkSchedulerExtension.ets",
          "type": "workScheduler"
        }
      ]
  }
}
实现延迟任务调度

导入模块。

import { workScheduler } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';

申请延迟任务。

// 创建workinfo
const workInfo: workScheduler.WorkInfo = {
  workId: 1,
  networkType: workScheduler.NetworkType.NETWORK_TYPE_WIFI,
  bundleName: 'com.example.application',
  abilityName: 'MyWorkSchedulerExtensionAbility'
}


try {
  workScheduler.startWork(workInfo);
  console.info(`startWork success`);
} catch (error) {
  console.error(`startWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
}

取消延迟任务。

// 创建workinfo
const workInfo: workScheduler.WorkInfo = {
  workId: 1,
  networkType: workScheduler.NetworkType.NETWORK_TYPE_WIFI,
  bundleName: 'com.example.application', 
  abilityName: 'MyWorkSchedulerExtensionAbility' 
}


try {
  workScheduler.stopWork(workInfo);
  console.info(`stopWork success`);
} catch (error) {
  console.error(`stopWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
}

---


## See Also

- [Notification Kit 通知服务](notification-kit.md)
- [网络请求与数据持久化](network-data.md)
- [ArkTS 并发](arkts-concurrency.md)
