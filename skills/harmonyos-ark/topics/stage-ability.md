# Stage 模型与 UIAbility 主题

<!-- Agent 摘要：本文件 1377 行。Stage 模型架构、UIAbility 生命周期、启动模式、Context、应用配置的完整指南。
     路由/页面跳转 → routing-lifecycle.md。
     代码模板 → starter-kit/modules/auth-login.md（含 UIAbility 用法）。 -->

## Scope
- Stage 模型架构、UIAbility 生命周期、启动模式、AbilityStage 容器、应用上下文 Context、组件启动规则、应用配置文件

## 来源
- Ability Kit（程序框架服务）

## Official Entrypoints
- [Stage模型开发概述](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/stage-model-development-overview-V5)
- [UIAbility组件概述](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-overview-V5)
- [UIAbility组件生命周期](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-lifecycle-V5)
- [UIAbility组件启动模式](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-launch-type-V5)
- [UIAbility组件基本用法](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-usage-V5)
- [UIAbility与UI的数据同步](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-data-sync-with-ui-V5)
- [AbilityStage组件容器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/abilitystage-V5)
- [应用上下文Context](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/application-context-stage-V5)
- [组件启动规则](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/component-startup-rules-V5)
- [Stage模型应用配置文件](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/config-file-stage-V5)

---

## Stage模型开发概述

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/stage-model-development-overview-V5

基本概念

下图展示了Stage模型中的基本概念。

图1 Stage模型概念图

AbilityStage

每个Entry类型或者Feature类型的HAP在运行期都有一个AbilityStage类实例，当HAP中的代码首次被加载到进程中的时候，系统会先创建AbilityStage实例。

UIAbility组件和ExtensionAbility组件

Stage模型提供UIAbility和ExtensionAbility两种类型的组件，这两种组件都有具体的类承载，支持面向对象的开发方式。

UIAbility组件是一种包含UI的应用组件，主要用于和用户交互。例如，图库类应用可以在UIAbility组件中展示图片瀑布流，在用户选择某个图片后，在新的页面中展示图片的详细内容。同时用户可以通过返回键返回到瀑布流页面。UIAbility组件的生命周期只包含创建/销毁/前台/后台等状态，与显示相关的状态通过WindowStage的事件暴露给开发者。

ExtensionAbility组件是一种面向特定场景的应用组件。开发者并不直接从ExtensionAbility组件派生，而是需要使用ExtensionAbility组件的派生类。目前ExtensionAbility组件有用于卡片场景的FormExtensionAbility，用于输入法场景的InputMethodExtensionAbility，用于闲时任务场景的WorkSchedulerExtensionAbility等多种派生类，这些派生类都是基于特定场景提供的。例如，用户在桌面创建应用的卡片，需要应用开发者从FormExtensionAbility派生，实现其中的回调函数，并在配置文件中配置该能力。ExtensionAbility组件的派生类实例由用户触发创建，并由系统管理生命周期。在Stage模型上，三方应用开发者不能开发自定义服务，而需要根据自身的业务场景通过ExtensionAbility组件的派生类来实现。

WindowStage

每个UIAbility实例都会与一个WindowStage类实例绑定，该类起到了应用进程内窗口管理器的作用。它包含一个主窗口。也就是说UIAbility实例通过WindowStage持有了一个主窗口，该主窗口为ArkUI提供了绘制区域。

Context

在Stage模型上，Context及其派生类向开发者提供在运行期可以调用的各种资源和能力。UIAbility组件和各种ExtensionAbility组件的派生类都有各自不同的Context类，他们都继承自基类Context，但是各自又根据所属组件，提供不同的能力。

开发流程

基于Stage模型开发应用时，在应用模型部分，涉及如下开发过程。

表1 Stage模型开发流程

任务	简介	相关指导
应用组件开发	本章节介绍了如何使用Stage模型的UIAbility组件和ExtensionAbility组件开发应用。	

- 应用/组件级配置

- UIAbility组件

- ExtensionAbility组件

- AbilityStage组件容器

- 应用上下文Context

- 组件启动规则


了解进程模型	本章节介绍了Stage模型的进程模型以及几种常用的进程间通信方式。	进程模型概述
了解线程模型	本章节介绍了Stage模型的线程模型以及几种常用的线程间通信方式。	线程模型概述
应用配置文件	本章节介绍Stage模型中应用配置文件的开发要求。	Stage模型应用配置文件

---

## UIAbility组件概述

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-overview-V5

概述

UIAbility组件是一种包含UI的应用组件，主要用于和用户交互。

UIAbility的设计理念：

原生支持应用组件级的跨端迁移和多端协同。

支持多设备和多窗口形态。

UIAbility划分原则与建议：

UIAbility组件是系统调度的基本单元，为应用提供绘制界面的窗口。一个应用可以包含一个或多个UIAbility组件。例如，在支付应用中，可以将入口功能和收付款功能分别配置为独立的UIAbility。

每一个UIAbility组件实例都会在最近任务列表中显示一个对应的任务。

对于开发者而言，可以根据具体场景选择单个还是多个UIAbility，划分建议如下：

如果开发者希望在任务视图中看到一个任务，建议使用“一个UIAbility+多个页面”的方式，可以避免不必要的资源加载。

如果开发者希望在任务视图中看到多个任务，或者需要同时开启多个窗口，建议使用多个UIAbility实现不同的功能。

例如，即时通讯类应用中的消息列表与音视频通话采用不同的UIAbility进行开发，既可以方便地切换任务窗口，又可以实现应用的两个任务窗口在一个屏幕上分屏显示。

说明

任务视图用于快速查看和管理当前设备上运行的所有任务或应用。

声明配置

为使应用能够正常使用UIAbility，需要在module.json5配置文件的abilities标签中声明UIAbility的名称、入口、标签等相关信息。

{
  "module": {
    // ...
    "abilities": [
      {
        "name": "EntryAbility", // UIAbility组件的名称
        "srcEntry": "./ets/entryability/EntryAbility.ets", // UIAbility组件的代码路径
        "description": "$string:EntryAbility_desc", // UIAbility组件的描述信息
        "icon": "$media:icon", // UIAbility组件的图标
        "label": "$string:EntryAbility_label", // UIAbility组件的标签
        "startWindowIcon": "$media:icon", // UIAbility组件启动页面图标资源文件的索引
        "startWindowBackground": "$color:start_window_background", // UIAbility组件启动页面背景颜色资源文件的索引
        // ...
      }
    ]
  }
}

---

## UIAbility组件生命周期

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-lifecycle-V5

概述

当用户打开、切换和返回到对应应用时，应用中的UIAbility实例会在其生命周期的不同状态之间转换。UIAbility类提供了一系列回调，通过这些回调可以知道当前UIAbility实例的某个状态发生改变，会经过UIAbility实例的创建和销毁，或者UIAbility实例发生了前后台的状态切换。

UIAbility的生命周期包括Create、Foreground、Background、Destroy四个状态，如下图所示。

图1 UIAbility生命周期状态

生命周期状态说明
Create状态

Create状态为在应用加载过程中，UIAbility实例创建完成时触发，系统会调用onCreate()回调。可以在该回调中进行页面初始化操作，例如变量定义资源加载等，用于后续的UI展示。

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 页面初始化
  }
  // ...
}
说明

Want是对象间信息传递的载体，可以用于应用组件间的信息传递。Want的详细介绍请参见信息传递载体Want。

WindowStageCreate和WindowStageDestroy状态

UIAbility实例创建完成之后，在进入Foreground之前，系统会创建一个WindowStage。WindowStage创建完成后会进入onWindowStageCreate()回调，可以在该回调中设置UI加载、设置WindowStage的事件订阅。

图2 WindowStageCreate和WindowStageDestroy状态

在onWindowStageCreate()回调中通过loadContent()方法设置应用要加载的页面，并根据需要调用on('windowStageEvent')方法订阅WindowStage的事件（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）。

说明

不同开发场景下WindowStage事件的时序可能存在差异。

import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[EntryAbility]';
const DOMAIN_NUMBER: number = 0xFF00;


export default class EntryAbility extends UIAbility {
  // ...
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 设置WindowStage的事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
    try {
      windowStage.on('windowStageEvent', (data) => {
        let stageEventType: window.WindowStageEventType = data;
        switch (stageEventType) {
          case window.WindowStageEventType.SHOWN: // 切到前台
            hilog.info(DOMAIN_NUMBER, TAG, `windowStage foreground.`);
            break;
          case window.WindowStageEventType.ACTIVE: // 获焦状态
            hilog.info(DOMAIN_NUMBER, TAG, `windowStage active.`);
            break;
          case window.WindowStageEventType.INACTIVE: // 失焦状态
            hilog.info(DOMAIN_NUMBER, TAG, `windowStage inactive.`);
            break;
          case window.WindowStageEventType.HIDDEN: // 切到后台
            hilog.info(DOMAIN_NUMBER, TAG, `windowStage background.`);
            break;
          case window.WindowStageEventType.RESUMED: // 前台可交互状态
            hilog.info(DOMAIN_NUMBER, TAG, `windowStage resumed.`);
            break;
          case window.WindowStageEventType.PAUSED: // 前台不可交互状态
            hilog.info(DOMAIN_NUMBER, TAG, `windowStage paused.`);
            break;
          default:
            break;
        }
      });
    } catch (exception) {
      hilog.error(DOMAIN_NUMBER, TAG,
        `Failed to enable the listener for window stage event changes. Cause: ${JSON.stringify(exception)}`);
    }
    hilog.info(DOMAIN_NUMBER, TAG, `%{public}s`, `Ability onWindowStageCreate`);
    // 设置UI加载
    windowStage.loadContent('pages/Index', (err, data) => {
      // ...
    });
  }
}
说明

WindowStage的相关使用请参见窗口开发指导。

对应于onWindowStageCreate()回调。在UIAbility实例销毁之前，则会先进入onWindowStageDestroy()回调，可以在该回调中释放UI资源。

import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';


export default class EntryAbility extends UIAbility {
  windowStage: window.WindowStage | undefined = undefined;


  // ...
  onWindowStageCreate(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
    // ...
  }


  onWindowStageDestroy() {
    // 释放UI资源
  }
}
WindowStageWillDestroy状态

对应onWindowStageWillDestroy()回调，在WindowStage销毁前执行，此时WindowStage可以使用。

import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[EntryAbility]';
const DOMAIN_NUMBER: number = 0xFF00;


export default class EntryAbility extends UIAbility {
  windowStage: window.WindowStage | undefined = undefined;
  // ...
  onWindowStageCreate(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
    // ...
  }


  onWindowStageWillDestroy(windowStage: window.WindowStage) {
    // 释放通过windowStage对象获取的资源
    // 在onWindowStageWillDestroy()中注销WindowStage事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
    try {
      if (this.windowStage) {
        this.windowStage.off('windowStageEvent');
      }
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to disable the listener for windowStageEvent. Code is ${code}, message is ${message}`);
    }
  }


  onWindowStageDestroy() {
    // 释放UI资源
  }
}
说明

WindowStage的相关使用请参见窗口开发指导。

Foreground和Background状态

Foreground和Background状态分别在UIAbility实例切换至前台和切换至后台时触发，对应于onForeground()回调和onBackground()回调。

onForeground()回调，在UIAbility的UI可见之前，如UIAbility切换至前台时触发。可以在onForeground()回调中申请系统需要的资源，或者重新申请在onBackground()中释放的资源。

onBackground()回调，在UIAbility的UI完全不可见之后，如UIAbility切换至后台时候触发。可以在onBackground()回调中释放UI不可见时无用的资源，或者在此回调中执行较为耗时的操作，例如状态保存等。

例如应用在使用过程中需要使用用户定位时，假设应用已获得用户的定位权限授权。在UI显示之前，可以在onForeground()回调中开启定位功能，从而获取到当前的位置信息。

当应用切换到后台状态，可以在onBackground()回调中停止定位功能，以节省系统的资源消耗。

import { UIAbility } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  // ...


  onForeground(): void {
    // 申请系统需要的资源，或者重新申请在onBackground()中释放的资源
  }


  onBackground(): void {
    // 释放UI不可见时无用的资源，或者在此回调中执行较为耗时的操作
    // 例如状态保存等
  }
}

当应用的UIAbility实例已创建，且UIAbility配置为singleton启动模式时，再次调用startAbility()方法启动该UIAbility实例时，只会进入该UIAbility的onNewWant()回调，不会进入其onCreate()和onWindowStageCreate()生命周期回调。应用可以在该回调中更新要加载的资源和数据等，用于后续的UI展示。

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  // ...


  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 更新资源、数据
  }
}
Destroy状态

Destroy状态在UIAbility实例销毁时触发。可以在onDestroy()回调中进行系统资源的释放、数据的保存等操作。

例如，调用terminateSelf()方法停止当前UIAbility实例，执行onDestroy()回调，并完成UIAbility实例的销毁。

import { UIAbility } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  // ...


  onDestroy() {
    // 系统资源的释放、数据的保存等
  }
}

---

## UIAbility组件启动模式

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-launch-type-V5

UIAbility的启动模式是指UIAbility实例在启动时的不同呈现状态。针对不同的业务场景，系统提供了三种启动模式：

singleton（单实例模式）

multiton（多实例模式）

specified（指定实例模式）

说明

standard是multiton的曾用名，效果与多实例模式一致。

singleton启动模式

singleton启动模式为单实例模式，也是默认情况下的启动模式。

每次调用startAbility()方法时，如果应用进程中该类型的UIAbility实例已经存在，则复用系统中的UIAbility实例。系统中只存在唯一一个该UIAbility实例，即在最近任务列表中只存在一个该类型的UIAbility实例。

图1 单实例模式演示效果

说明

应用的UIAbility实例已创建，该UIAbility配置为单实例模式，再次调用startAbility()方法启动该UIAbility实例。由于启动的还是原来的UIAbility实例，并未重新创建一个新的UIAbility实例，此时只会进入该UIAbility的onNewWant()回调，不会进入其onCreate()和onWindowStageCreate()生命周期回调。

如果需要使用singleton启动模式，在module.json5配置文件中的launchType字段配置为singleton即可。

{
  "module": {
    // ...
    "abilities": [
      {
        "launchType": "singleton",
        // ...
      }
    ]
  }
}
multiton启动模式

multiton启动模式为多实例模式，每次调用startAbility()方法时，都会在应用进程中创建一个新的该类型UIAbility实例。即在最近任务列表中可以看到有多个该类型的UIAbility实例。这种情况下可以将UIAbility配置为multiton（多实例模式）。

图2 多实例模式演示效果

multiton启动模式的开发使用，在module.json5配置文件中的launchType字段配置为multiton即可。

{
  "module": {
    // ...
    "abilities": [
      {
        "launchType": "multiton",
        // ...
      }
    ]
  }
}
specified启动模式

specified启动模式为指定实例模式，针对一些特殊场景使用（例如文档应用中每次新建文档希望都能新建一个文档实例，重复打开一个已保存的文档希望打开的都是同一个文档实例）。

图3 指定实例启动模式原理

假设应用有两个UIAbility实例，即EntryAbility和SpecifiedAbility。EntryAbility以specified模式启动SpecifiedAbility。基本原理如下：

EntryAbility调用startAbility()方法，并在Want的parameters字段中设置唯一的Key值，用于标识SpecifiedAbility。
系统在拉起SpecifiedAbility之前，会先进入对应的AbilityStage的onAcceptWant()生命周期回调，获取用于标识目标UIAbility的Key值。
系统会根据获取的Key值来匹配UIAbility。
如果匹配到对应的UIAbility，则会启动该UIAbility实例，并进入onNewWant()生命周期回调。
如果无法匹配对应的UIAbility，则会创建一个新的UIAbility实例，并进入该UIAbility实例的onCreate()生命周期回调和onWindowStageCreate()生命周期回调。

图4 指定实例模式演示效果

在SpecifiedAbility中，需要将module.json5配置文件的launchType字段配置为specified。

{
  "module": {
    // ...
    "abilities": [
      {
        "launchType": "specified",
        // ...
      }
    ]
  }
}

在EntryAbility中，调用startAbility()方法时，可以在want参数中传入了自定义参数instanceKey作为唯一标识符，以此来区分不同的UIAbility实例。示例中instanceKey的value值设置为字符串'KEY'。

 // 在启动指定实例模式的UIAbility时，给每一个UIAbility实例配置一个独立的Key标识
 // 例如在文档使用场景中，可以用文档路径作为Key标识
 import { common, Want } from '@kit.AbilityKit';
 import { hilog } from '@kit.PerformanceAnalysisKit';
 import { BusinessError } from '@kit.BasicServicesKit';


 const TAG: string = '[Page_StartModel]';
 const DOMAIN_NUMBER: number = 0xFF00;


 function getInstance(): string {
   return 'KEY';
 }


 @Entry
 @Component
 struct Page_StartModel {
   private KEY_NEW = 'KEY';


   build() {
     Row() {
       Column() {
         // ...
         Button()
           .onClick(() => {
             let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
             // context为调用方UIAbility的UIAbilityContext;
             let want: Want = {
               deviceId: '', // deviceId为空表示本设备
               bundleName: 'com.samples.stagemodelabilitydevelop',
               abilityName: 'SpecifiedFirstAbility',
               moduleName: 'entry', // moduleName非必选
               parameters: {
                 // 自定义信息
                 instanceKey: this.KEY_NEW
               }
             };
             context.startAbility(want).then(() => {
               hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting SpecifiedAbility.');
             }).catch((err: BusinessError) => {
               hilog.error(DOMAIN_NUMBER, TAG, `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
             })
             this.KEY_NEW = this.KEY_NEW + 'a';
           })
         // ...
         Button()
           .onClick(() => {
             let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
             // context为调用方UIAbility的UIAbilityContext;
             let want: Want = {
               deviceId: '', // deviceId为空表示本设备
               bundleName: 'com.samples.stagemodelabilitydevelop',
               abilityName: 'SpecifiedSecondAbility',
               moduleName: 'entry', // moduleName非必选
               parameters: {
                 // 自定义信息
                 instanceKey: getInstance()
               }
             };
             context.startAbility(want).then(() => {
               hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting SpecifiedAbility.');
             }).catch((err: BusinessError) => {
               hilog.error(DOMAIN_NUMBER, TAG, `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
             })
             this.KEY_NEW = this.KEY_NEW + 'a';
           })
         // ...
       }
       .width('100%')
     }
     .height('100%')
   }
 }

开发者根据业务在SpecifiedAbility的onAcceptWant()生命周期回调设置该UIAbility的标识。示例中标识设置为SpecifiedAbilityInstance_KEY。

 import { AbilityStage, Want } from '@kit.AbilityKit';


 export default class MyAbilityStage extends AbilityStage {
   onAcceptWant(want: Want): string {
     // 在被调用方的AbilityStage中，针对启动模式为specified的UIAbility返回一个UIAbility实例对应的一个Key值
     // 当前示例指的是module1 Module的SpecifiedAbility
     if (want.abilityName === 'SpecifiedFirstAbility' || want.abilityName === 'SpecifiedSecondAbility') {
       // 返回的字符串KEY标识为自定义拼接的字符串内容
       if (want.parameters) {
         return `SpecifiedAbilityInstance_${want.parameters.instanceKey}`;
       }
     }
     // ...
     return 'MyAbilityStage';
   }
 }
说明
当应用的UIAbility实例已经被创建，并且配置为指定实例模式时，如果再次调用startAbility()方法启动该UIAbility实例，且AbilityStage的onAcceptWant()回调匹配到一个已创建的UIAbility实例，则系统会启动原来的UIAbility实例，并且不会重新创建一个新的UIAbility实例。此时，该UIAbility实例的onNewWant()回调会被触发，而不会触发onCreate()和onWindowStageCreate()生命周期回调。
DevEco Studio默认工程中未自动生成AbilityStage，AbilityStage文件的创建请参见AbilityStage组件容器。

例如在文档应用中，可以为不同的文档实例内容绑定不同的Key值。每次新建文档时，可以传入一个新的Key值（例如可以将文件的路径作为一个Key标识），此时AbilityStage中启动UIAbility时都会创建一个新的UIAbility实例；当新建的文档保存之后，回到桌面，或者新打开一个已保存的文档，回到桌面，此时再次打开该已保存的文档，此时AbilityStage中再次启动该UIAbility时，打开的仍然是之前原来已保存的文档界面。

以如下步骤所示进行举例说明。

打开文件A，对应启动一个新的UIAbility实例，例如启动UIAbility实例1。
在最近任务列表中关闭文件A的任务进程，此时UIAbility实例1被销毁，回到桌面，再次打开文件A，此时对应启动一个新的UIAbility实例，例如启动UIAbility实例2。
回到桌面，打开文件B，此时对应启动一个新的UIAbility实例，例如启动UIAbility实例3。
回到桌面，再次打开文件A，此时仍然启动之前的UIAbility实例2，因为系统会自动匹配UIAbility实例的Key值，如果存在与之匹配的Key，则会启动与之绑定的UIAbility实例。在此例中，之前启动的UIAbility实例2与文件A绑定的Key是相同的，因此系统会拉回UIAbility实例2并让其获焦，而不会创建新的实例。
示例代码
UIAbility的启动方式

---

## UIAbility组件基本用法

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-usage-V5

UIAbility组件的基本用法包括：指定UIAbility的启动页面以及获取UIAbility的上下文UIAbilityContext。

指定UIAbility的启动页面

应用中的UIAbility在启动过程中，需要指定启动页面，否则应用启动后会因为没有默认加载页面而导致白屏。可以在UIAbility的onWindowStageCreate()生命周期回调中，通过WindowStage对象的loadContent()方法设置启动页面。

import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';


export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    windowStage.loadContent('pages/Index', (err, data) => {
      // ...
    });
  }
  // ...
}
说明

在DevEco Studio中创建的UIAbility中，该UIAbility实例默认会加载Index页面，根据需要将Index页面路径替换为需要的页面路径即可。

获取UIAbility的上下文信息

UIAbility类拥有自身的上下文信息，该信息为UIAbilityContext类的实例，UIAbilityContext类拥有abilityInfo、currentHapModuleInfo等属性。通过UIAbilityContext可以获取UIAbility的相关配置信息，如包代码路径、Bundle名称、Ability名称和应用程序需要的环境状态等属性信息，以及可以获取操作UIAbility实例的方法（如startAbility()、connectServiceExtensionAbility()、terminateSelf()等）。

如果需要在页面中获得当前Ability的Context，可调用getContext接口获取当前页面关联的UIAbilityContext或ExtensionContext。

在UIAbility中可以通过this.context获取UIAbility实例的上下文信息。

import { UIAbility, AbilityConstant, Want } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 获取UIAbility实例的上下文
    let context = this.context;
    // ...
  }
}

在页面中获取UIAbility实例的上下文信息，包括导入依赖资源context模块和在组件中定义一个context变量两个部分。

import { common, Want } from '@kit.AbilityKit';


@Entry
@Component
struct Page_EventHub {
  private context = getContext(this) as common.UIAbilityContext;


  startAbilityTest(): void {
    let want: Want = {
      // Want参数信息
    };
    this.context.startAbility(want);
  }


  // 页面展示
  build() {
    // ...
  }
}

也可以在导入依赖资源context模块后，在具体使用UIAbilityContext前进行变量定义。

import { common, Want } from '@kit.AbilityKit';


@Entry
@Component
struct Page_UIAbilityComponentsBasicUsage {
  startAbilityTest(): void {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      // Want参数信息
    };
    context.startAbility(want);
  }


  // 页面展示
  build() {
    // ...
  }
}

当业务完成后，开发者如果想要终止当前UIAbility实例，可以通过调用terminateSelf()方法实现。

import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';


@Entry
@Component
struct Page_UIAbilityComponentsBasicUsage {
  // 页面展示
  build() {
    Column() {
      //...
      Button('FuncAbilityB')
        .onClick(() => {
          let context = getContext(this) as common.UIAbilityContext;
          try {
            context.terminateSelf((err: BusinessError) => {
              if (err.code) {
                // 处理业务逻辑错误
                console.error(`terminateSelf failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              // 执行正常业务
              console.info('terminateSelf succeed');
            });
          } catch (err) {
            // 捕获同步的参数错误
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            console.error(`terminateSelf failed, code is ${code}, message is ${message}`);
          }
        })
    }
  }
}

---

## UIAbility与UI的数据同步

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/uiability-data-sync-with-ui-V5

基于当前的应用模型，可以通过以下几种方式来实现UIAbility组件与UI之间的数据同步。

使用EventHub进行数据通信：在基类Context中提供了EventHub对象，可以通过发布订阅方式来实现事件的传递。在事件传递前，订阅者需要先进行订阅，当发布者发布事件时，订阅者将接收到事件并进行相应处理。
使用AppStorage/LocalStorage进行数据同步：ArkUI提供了AppStorage和LocalStorage两种应用级别的状态管理方案，可用于实现应用级别和UIAbility级别的数据同步。
使用EventHub进行数据通信

EventHub为UIAbility组件提供了事件机制，使它们能够进行订阅、取消订阅和触发事件等数据通信能力。

在基类Context中，提供了EventHub对象，可用于在UIAbility组件实例内通信。使用EventHub实现UIAbility与UI之间的数据通信需要先获取EventHub对象，本章节将以此为例进行说明。

在UIAbility中调用eventHub.on()方法注册一个自定义事件“event1”，eventHub.on()有如下两种调用方式，使用其中一种即可。

import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIAbility, Context, Want, AbilityConstant } from '@kit.AbilityKit';


const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[EventAbility]';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 获取eventHub
    let eventhub = this.context.eventHub;
    // 执行订阅操作
    eventhub.on('event1', this.eventFunc);
    eventhub.on('event1', (data: string) => {
      // 触发事件，完成相应的业务操作
    });
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onCreate');
  }


  // ...
  eventFunc(argOne: Context, argTwo: Context): void {
    hilog.info(DOMAIN_NUMBER, TAG, '1. ' + `${argOne}, ${argTwo}`);
    return;
  }
}

在UI中通过eventHub.emit()方法触发该事件，在触发事件的同时，根据需要传入参数信息。

import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';


@Entry
@Component
struct Page_EventHub {
  private context = getContext(this) as common.UIAbilityContext;


  eventHubFunc(): void {
    // 不带参数触发自定义“event1”事件
    this.context.eventHub.emit('event1');
    // 带1个参数触发自定义“event1”事件
    this.context.eventHub.emit('event1', 1);
    // 带2个参数触发自定义“event1”事件
    this.context.eventHub.emit('event1', 2, 'test');
    // 开发者可以根据实际的业务场景设计事件传递的参数
  }


  build() {
    Column() {
      // ...
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // ...
          }
          .onClick(() => {
            this.eventHubFunc();
            promptAction.showToast({
              message: 'EventHubFuncA'
            });
          })
        }


        // ...
        ListItem() {
          Row() {
            // ...
          }
          .onClick(() => {
            this.context.eventHub.off('event1');
            promptAction.showToast({
              message: 'EventHubFuncB'
            });
          })
        }
        // ...
      }
      // ...
    }
    // ...
  }
}

在UIAbility的注册事件回调中可以得到对应的触发事件结果，运行日志结果如下所示。

[Example].[Entry].[EntryAbility] 1. []
[Example].[Entry].[EntryAbility] 1. [1]
[Example].[Entry].[EntryAbility] 1. [2,"test"]

在自定义事件“event1”使用完成后，可以根据需要调用eventHub.off()方法取消该事件的订阅。

import { UIAbility } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  // ... 
  onDestroy(): void {
    this.context.eventHub.off('event1');
  }
}
使用AppStorage/LocalStorage进行数据同步

ArkUI提供了AppStorage和LocalStorage两种应用级别的状态管理方案，可用于实现应用级别和UIAbility级别的数据同步。使用这些方案可以方便地管理应用状态，提高应用性能和用户体验。其中，AppStorage是一个全局的状态管理器，适用于多个UIAbility共享同一状态数据的情况；而LocalStorage则是一个局部的状态管理器，适用于单个UIAbility内部使用的状态数据。通过这两种方案，开发者可以更加灵活地控制应用状态，提高应用的可维护性和可扩展性。详细请参见应用级变量的状态管理。

---

## AbilityStage组件容器

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/abilitystage-V5

AbilityStage是一个Module级别的组件容器，应用的HAP在首次加载时会创建一个AbilityStage实例，可以对该Module进行初始化等操作。

AbilityStage与Module一一对应，即一个Module拥有一个AbilityStage。

DevEco Studio默认工程中未自动生成AbilityStage，如需要使用AbilityStage的能力，可以手动新建一个AbilityStage文件，具体步骤如下。

在工程Module对应的ets目录下，右键选择“New > Directory”，新建一个目录并命名为myabilitystage。

在myabilitystage目录，右键选择“New > ArkTS File”，新建一个文件并命名为MyAbilityStage.ets。

打开MyAbilityStage.ets文件，导入AbilityStage的依赖包，自定义类继承AbilityStage并加上需要的生命周期回调，示例中增加了一个onCreate()生命周期回调。

import { AbilityStage, Want } from '@kit.AbilityKit';


export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    // 应用HAP首次加载时触发，可以在此执行该Module的初始化操作（例如资源预加载、线程创建等）。
  }


  onAcceptWant(want: Want): string {
    // 仅specified模式下触发
    return 'MyAbilityStage';
  }
}

在module.json5配置文件中，通过配置 srcEntry 参数来指定模块对应的代码路径，以作为HAP加载的入口。

{
  "module": {
    "name": "entry",
    "type": "entry",
    "srcEntry": "./ets/myabilitystage/MyAbilityStage.ets",
    // ...
  }
}

AbilityStage拥有onCreate()生命周期回调和onAcceptWant()、onConfigurationUpdated()、onMemoryLevel()事件回调。

onCreate()生命周期回调：在开始加载对应Module的第一个UIAbility实例之前会先创建AbilityStage，并在AbilityStage创建完成之后执行其onCreate()生命周期回调。AbilityStage模块提供在Module加载的时候，通知开发者，可以在此进行该Module的初始化（如资源预加载，线程创建等）能力。

onAcceptWant()事件回调：UIAbility指定实例模式（specified）启动时候触发的事件回调，具体使用请参见UIAbility启动模式综述。

onConfigurationUpdated()事件回调：当系统全局配置发生变更时触发的事件，系统语言、深浅色等，配置项目前均定义在Configuration类中。

onMemoryLevel()事件回调：当系统调整内存时触发的事件。

应用被切换到后台时，系统会将在后台的应用保留在缓存中。即使应用处于缓存中，也会影响系统整体性能。当系统资源不足时，系统会通过多种方式从应用中回收内存，必要时会完全停止应用，从而释放内存用于执行关键任务。为了进一步保持系统内存的平衡，避免系统停止用户的应用进程，可以在AbilityStage中的onMemoryLevel()生命周期回调中订阅系统内存的变化情况，释放不必要的资源。

import { AbilityStage, AbilityConstant } from '@kit.AbilityKit';


export default class MyAbilityStage extends AbilityStage {
  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    // 根据系统可用内存的变化情况，释放不必要的内存
  }
}

---

## 应用上下文Context

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/application-context-stage-V5

概述

Context是应用中对象的上下文，其提供了应用的一些基础信息，例如resourceManager（资源管理）、applicationInfo（当前应用信息）、dir（应用文件路径）、area（文件分区）等，以及应用的一些基本方法，例如createBundleContext()、getApplicationContext()等。UIAbility组件和各种ExtensionAbility派生类组件都有各自不同的Context类。分别有基类Context、ApplicationContext、AbilityStageContext、UIAbilityContext、ExtensionContext、ServiceExtensionContext等Context。

各类Context的继承关系

各类Context的持有关系

各类Context的获取方式

获取UIAbilityContext。每个UIAbility中都包含了一个Context属性，提供操作应用组件、获取应用组件的配置信息等能力。

import { UIAbility, AbilityConstant, Want } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let uiAbilityContext = this.context;
    //...
  }
}
说明

页面中获取UIAbility实例的上下文信息请参见获取UIAbility的上下文信息。

获取特定场景ExtensionContext。以ServiceExtensionContext为例，表示后台服务的上下文环境，继承自ExtensionContext，提供后台服务相关的接口能力。

import { ServiceExtensionAbility, Want } from '@kit.AbilityKit';


export default class ServiceExtAbility extends ServiceExtensionAbility {
  onCreate(want: Want) {
    let serviceExtensionContext = this.context;
    //...
  }
}

获取AbilityStageContext（Module级别的Context）。和基类Context相比，额外提供HapModuleInfo、Configuration等信息。

import { AbilityStage } from '@kit.AbilityKit';


export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    let abilityStageContext = this.context;
    //...
  }
}

获取ApplicationContext（应用级别的Context）。ApplicationContext在基类Context的基础上提供了订阅应用内应用组件的生命周期的变化、订阅系统内存变化、订阅应用内系统环境变化、设置应用语言、设置应用颜色模式、清除应用自身数据的同时撤销应用向用户申请的权限等能力，在UIAbility、ExtensionAbility、AbilityStage中均可以获取。

import { UIAbility, AbilityConstant, Want } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let applicationContext = this.context.getApplicationContext();
    //...
  }
}
Context的典型使用场景

本章节通过如下典型场景来介绍Context的用法：

获取应用文件路径
获取和修改加密分区
获取本应用中其他module的context
订阅进程内UIAbility生命周期变化
获取应用文件路径

基类Context提供了获取应用文件路径的能力，ApplicationContext、AbilityStageContext、UIAbilityContext和ExtensionContext均继承该能力。不同类型的Context获取的路径可能存在差异。

通过ApplicationContext可以获取应用级的文件路径。该路径用于存放应用全局信息，路径下的文件会跟随应用的卸载而删除。

通过AbilityStageContext、UIAbilityContext、ExtensionContext，可以获取Module级的文件路径。该路径用于存放Module相关信息，路径下的文件会跟随HAP/HSP的卸载而删除。HAP/HSP的卸载不会影响应用级路径下的文件，除非该应用的HAP/HSP已全部卸载。

UIAbilityContext：可以获取UIAbility所在Module的文件路径。
ExtensionContext：可以获取ExtensionAbility所在Module的文件路径。
AbilityStageContext：由于AbilityStageContext创建时机早于UIAbilityContext和ExtensionContext，通常用于在AbilityStage中获取文件路径。
说明

应用文件路径属于应用沙箱路径，具体请参见应用沙箱目录。

表1 不同级别Context获取的应用文件路径说明

属性	说明	ApplicationContext获取的路径	AbilityStageContext、UIAbilityContext、ExtensionContext获取的路径
bundleCodeDir	安装包目录。	<路径前缀>/el1/bundle	<路径前缀>/el1/bundle
cacheDir	缓存目录。	<路径前缀>/<加密等级>/base/cache	<路径前缀>/<加密等级>/base/haps/<module-name>/cache
filesDir	文件目录。	<路径前缀>/<加密等级>/base/files	<路径前缀>/<加密等级>/base/haps/<module-name>/files
preferencesDir	preferences目录。	<路径前缀>/<加密等级>/base/preferences	<路径前缀>/<加密等级>/base/haps/<module-name>/preferences
tempDir	临时目录。	<路径前缀>/<加密等级>/base/temp	<路径前缀>/<加密等级>/base/haps/<module-name>/temp
databaseDir	数据库目录。	<路径前缀>/<加密等级>/database	<路径前缀>/<加密等级>/database/<module-name>
distributedFilesDir	分布式文件目录。	<路径前缀>/el2/distributedFiles	<路径前缀>/el2/distributedFiles/
resourceDir11+	

资源目录。

说明：

需要开发者手动在\<module-name>\resource路径下创建resfile目录。

	不涉及	<路径前缀>/el1/bundle/<module-name>/resources/resfile
cloudFileDir12+	云文件目录。	<路径前缀>/el2/cloud	<路径前缀>/el2/cloud/

本节以使用ApplicationContext获取filesDir为例，介绍如何获取应用文件路径，并在对应文件路径下新建文件和读写文件。示例代码如下：

import { common } from '@kit.AbilityKit';
import { buffer } from '@kit.ArkTS';
import { fileIo, ReadOptions } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[Page_Context]';
const DOMAIN_NUMBER: number = 0xFF00;


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private context = getContext(this) as common.UIAbilityContext;


  build() {
    Row() {
      Column() {
        Text(this.message)
        // ...
        Button() {
          Text('create file')
            // ...
            .onClick(() => {
              let applicationContext = this.context.getApplicationContext();
              // 获取应用文件路径
              let filesDir = applicationContext.filesDir;
              hilog.info(DOMAIN_NUMBER, TAG, `filePath: ${filesDir}`);
              // 文件不存在时创建并打开文件，文件存在时打开文件
              let file = fileIo.openSync(filesDir + '/test.txt', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
              // 写入一段内容至文件
              let writeLen = fileIo.writeSync(file.fd, "Try to write str.");
              hilog.info(DOMAIN_NUMBER, TAG, `The length of str is: ${writeLen}`);
              // 创建一个大小为1024字节的ArrayBuffer对象，用于存储从文件中读取的数据
              let arrayBuffer = new ArrayBuffer(1024);
              // 设置读取的偏移量和长度
              let readOptions: ReadOptions = {
                offset: 0,
                length: arrayBuffer.byteLength
              };
              // 读取文件内容到ArrayBuffer对象中，并返回实际读取的字节数
              let readLen = fileIo.readSync(file.fd, arrayBuffer, readOptions);
              // 将ArrayBuffer对象转换为Buffer对象，并转换为字符串输出
              let buf = buffer.from(arrayBuffer, 0, readLen);
              hilog.info(DOMAIN_NUMBER, TAG, `the content of file: ${buf.toString()}`);
              // 关闭文件
              fileIo.closeSync(file);
            })
        }
        // ...
      }
      // ...
    }
    // ...
  }
}
获取和修改加密分区

应用文件加密是一种保护数据安全的方法，可以使得文件在未经授权访问的情况下得到保护。在不同的场景下，应用需要不同程度的文件保护。

在实际应用中，开发者需要根据不同场景的需求选择合适的加密分区，从而保护应用数据的安全。通过合理使用不同级别的加密分区，可以有效提高应用数据的安全性。关于不同分区的权限说明，详见ContextConstant的AreaMode。

EL1：对于私有文件，如闹铃、壁纸等，应用可以将这些文件放到设备级加密分区（EL1）中，以保证在用户输入密码前就可以被访问。
EL2：对于更敏感的文件，如个人隐私信息等，应用可以将这些文件放到更高级别的加密分区（EL2）中，以保证更高的安全性。
EL3：对于应用中的记录步数、文件下载、音乐播放，需要在锁屏时读写和创建新文件，放在（EL3）的加密分区比较合适。
EL4：对于用户安全信息相关的文件，锁屏时不需要读写文件、也不能创建文件，放在（EL4）的加密分区更合适。
EL5：对于用户隐私敏感数据文件，锁屏后默认不可读写，如果锁屏后需要读写文件，则锁屏前可以调用Access接口申请继续读写文件，或者锁屏后也需要创建新文件且可读写，放在（EL5）的应用级加密分区更合适。

要实现获取和设置当前加密分区，可以通过读写Context的area属性来实现。

// EntryAbility.ets
import { UIAbility, contextConstant, AbilityConstant, Want } from '@kit.AbilityKit';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 存储普通信息前，切换到EL1设备级加密
    this.context.area = contextConstant.AreaMode.EL1; // 切换area
    // 存储普通信息


    // 存储敏感信息前，切换到EL2用户级加密
    this.context.area = contextConstant.AreaMode.EL2; // 切换area
    // 存储敏感信息


    // 存储敏感信息前，切换到EL3用户级加密
    this.context.area = contextConstant.AreaMode.EL3; // 切换area
    // 存储敏感信息


    // 存储敏感信息前，切换到EL4用户级加密
    this.context.area = contextConstant.AreaMode.EL4; // 切换area
    // 存储敏感信息


    // 存储敏感信息前，切换到EL5应用级加密
    this.context.area = contextConstant.AreaMode.EL5; // 切换area
    // 存储敏感信息
  }
}
// Index.ets
import { contextConstant, common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';


@Entry
@Component
struct Page_Context {
  private context = getContext(this) as common.UIAbilityContext;


  build() {
    Column() {
      //...
      List({ initialIndex: 0 }) {
        //...
        ListItem() {
          Row() {
            //...
          }
          .onClick(() => {
            // 存储普通信息前，切换到EL1设备级加密
            if (this.context.area === contextConstant.AreaMode.EL2) { // 获取area
              this.context.area = contextConstant.AreaMode.EL1; // 修改area
              promptAction.showToast({
                message: 'SwitchToEL1'
              });
            }
            // 存储普通信息
          })
        }
        //...
        ListItem() {
          Row() {
            //...
          }
          .onClick(() => {
            // 存储敏感信息前，切换到EL2用户级加密
            if (this.context.area === contextConstant.AreaMode.EL1) { // 获取area
              this.context.area = contextConstant.AreaMode.EL2; // 修改area
              promptAction.showToast({
                message: 'SwitchToEL2'
              });
            }
            // 存储敏感信息
          })
        }
        //...
      }
      //...
    }
    //...
  }
}
获取本应用中其他Module的Context

调用createModuleContext(context: Context, moduleName: string)方法，获取本应用中其他Module的Context。获取到其他Module的Context之后，即可获取到相应Module的资源信息。

import { common, application } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';


let storageEventCall = new LocalStorage();


@Entry(storageEventCall)
@Component
struct Page_Context {
  private context = getContext(this) as common.UIAbilityContext;


  build() {
    Column() {
      //...
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            //...
          }
          .onClick(() => {
            let moduleName2: string = 'entry';
            application.createModuleContext(this.context, moduleName2)
              .then((data: common.Context) => {
                console.info(`CreateModuleContext success, data: ${JSON.stringify(data)}`);
                if (data !== null) {
                  promptAction.showToast({
                    message: ('成功获取Context')
                  });
                }
              })
              .catch((err: BusinessError) => {
                console.error(`CreateModuleContext failed, err code:${err.code}, err msg: ${err.message}`);
              });
          })
        }
        //...
      }
      //...
    }
    //...
  }
}
订阅进程内UIAbility生命周期变化

在应用内的DFX统计场景中，如需要统计对应页面停留时间和访问频率等信息，可以使用订阅进程内UIAbility生命周期变化功能。

通过ApplicationContext提供的能力，可以订阅进程内UIAbility生命周期变化。当进程内的UIAbility生命周期变化时，如创建、可见/不可见、获焦/失焦、销毁等，会触发相应的回调函数。每次注册回调函数时，都会返回一个监听生命周期的ID，此ID会自增+1。当超过监听上限数量2^63-1时，会返回-1。以UIAbilityContext中的使用为例进行说明。

import { AbilityConstant, AbilityLifecycleCallback, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import  { BusinessError } from '@kit.BasicServicesKit';


const TAG: string = '[LifecycleAbility]';
const DOMAIN_NUMBER: number = 0xFF00;


export default class LifecycleAbility extends UIAbility {
  // 定义生命周期ID
  lifecycleId: number = -1;


  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 定义生命周期回调对象
    let abilityLifecycleCallback: AbilityLifecycleCallback = {
      // 当UIAbility创建时被调用
      onAbilityCreate(uiAbility) {
        hilog.info(DOMAIN_NUMBER, TAG, `onAbilityCreate uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当窗口创建时被调用
      onWindowStageCreate(uiAbility, windowStage: window.WindowStage) {
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageCreate uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageCreate windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当窗口处于活动状态时被调用
      onWindowStageActive(uiAbility, windowStage: window.WindowStage) {
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageActive uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageActive windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当窗口处于非活动状态时被调用
      onWindowStageInactive(uiAbility, windowStage: window.WindowStage) {
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageInactive uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageInactive windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当窗口被销毁时被调用
      onWindowStageDestroy(uiAbility, windowStage: window.WindowStage) {
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageDestroy uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageDestroy windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当UIAbility被销毁时被调用
      onAbilityDestroy(uiAbility) {
        hilog.info(DOMAIN_NUMBER, TAG, `onAbilityDestroy uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当UIAbility从后台转到前台时触发回调
      onAbilityForeground(uiAbility) {
        hilog.info(DOMAIN_NUMBER, TAG, `onAbilityForeground uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当UIAbility从前台转到后台时触发回调
      onAbilityBackground(uiAbility) {
        hilog.info(DOMAIN_NUMBER, TAG, `onAbilityBackground uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当UIAbility迁移时被调用
      onAbilityContinue(uiAbility) {
        hilog.info(DOMAIN_NUMBER, TAG, `onAbilityContinue uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      }
    };
    // 获取应用上下文
    let applicationContext = this.context.getApplicationContext();
    try {
      // 注册应用内生命周期回调
      this.lifecycleId = applicationContext.on('abilityLifecycle', abilityLifecycleCallback);
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to register applicationContext. Code is ${code}, message is ${message}`);
    }


    hilog.info(DOMAIN_NUMBER, TAG, `register callback number: ${this.lifecycleId}`);
  }
  //...
  onDestroy(): void {
    // 获取应用上下文
    let applicationContext = this.context.getApplicationContext();
    try {
      // 取消应用内生命周期回调
      applicationContext.off('abilityLifecycle', this.lifecycleId);
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to unregister applicationContext. Code is ${code}, message is ${message}`);
    }
  }
}

---

## 组件启动规则

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/component-startup-rules-V5

启动组件是指一切启动或连接应用组件的行为：

启动UIAbility、ServiceExtensionAbility、DataShareExtensionAbility，如使用startAbility()、startServiceExtensionAbility()、startAbilityByCall()、openLink()等相关接口。

连接ServiceExtensionAbility、DataShareExtensionAbility，如使用connectServiceExtensionAbility()、createDataShareHelper()等相关接口。

组件启动总体规则

为了保证用户具有更好的使用体验，对以下几种易影响用户体验与系统安全的行为做了限制：

后台应用任意弹框，如各种广告弹窗，影响用户使用。

后台应用相互唤醒，不合理的占用系统资源，导致系统功耗增加或系统卡顿。

前台应用任意跳转至其他应用，如随意跳转到其他应用的支付页面，存在安全风险。

鉴于此，制订了一套组件启动规则，主要包括：

跨应用启动组件，需校验目标组件是否可以被其他应用调用。

若目标组件exported字段配置为true，表示可以被其他应用调用；若目标组件exported字段配置为false，表示不可以被其他应用调用，还需进一步校验ohos.permission.START_INVISIBLE_ABILITY权限（该权限仅系统应用可申请）。组件exported字段说明可参考abilities标签。

位于后台的UIAbility应用，启动组件需校验BACKGROUND权限ohos.permission.START_ABILITIES_FROM_BACKGROUND（该权限仅系统应用可申请）。

说明：

前后台应用的判断依据：若应用进程获焦或所属的UIAbility组件位于前台则判定为前台应用，否则为后台应用。

跨设备使用startAbilityByCall接口，需校验分布式权限ohos.permission.DISTRIBUTED_DATASYNC。

上述组件启动规则自API 9版本开始生效。开发者需熟知组件启动规则，避免业务功能异常。启动组件的具体校验流程见下文。

同设备组件启动规则

设备内启动组件，不同场景下的规则不同，可分为如下三种场景：

启动UIAbility。

启动ServiceExtensionAbility、DataShareExtensionAbility。

通过startAbilityByCall接口启动UIAbility。

分布式跨设备组件启动规则

跨设备启动组件，不同场景下的规则不同，可分为如下三种场景：

启动UIAbility。

启动ServiceExtensionAbility、DataShareExtensionAbility。

通过startAbilityByCall接口启动UIAbility。

---

## Stage模型应用配置文件

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/config-file-stage-V5

应用配置文件中包含应用配置信息、应用组件信息、权限信息、开发者自定义信息等，这些信息在编译构建、分发和运行解决分别提供给编译工具、应用市场和操作系统使用。

在基于Stage模型开发的应用项目代码下，都存在app.json5（一个）及module.json5（一个或多个）两种配置文件，常用配置项请参见应用/组件级配置。对于这两种配置文件的更多介绍，请参见应用配置文件概述（Stage模型）。


---

## See Also

- [页面路由与导航](routing-lifecycle.md)
- [状态管理](state-management.md)
