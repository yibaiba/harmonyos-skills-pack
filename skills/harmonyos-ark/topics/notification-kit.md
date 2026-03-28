# Notification Kit 通知服务（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V5/API 12）
> 覆盖：通知简介、授权请求、角标管理、渠道管理、文本/进度条通知发布、行为意图、取消通知

<!-- Agent 摘要：632 行。通知权限/文本/进度条/按钮交互通知完整指南。
     代码模板 → starter-kit/modules/notification-handling.md。 -->


## 目录

- [Notification Kit简介](#notification-kit简介)
- [请求通知授权](#请求通知授权)
- [管理通知角标](#管理通知角标)
- [管理通知渠道](#管理通知渠道)
- [取消通知](#取消通知)
- [发布通知](#发布通知)

---

## Notification Kit简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/notification-overview-V5

Notification Kit（用户通知服务）为开发者提供本地通知发布通道，开发者可借助Notification Kit将应用产生的通知直接在客户端本地推送给用户，本地通知根据通知类型及发布场景会产生对应的铃声、震动、横幅、锁屏、息屏、通知栏提醒和显示。

使用场景

当应用处于前台运行时，开发者可以使用Notification Kit向用户发布通知。当应用转为后台时，本地通知发布通道关闭，开发者需要接入Push Kit进行云侧离线通知的发布。

开发者可以在多种场景中运用本地通知能力。如同步用户的上传下载进度、发布即时的客服支付通知、更新运动步数等。

能力范围

Notification Kit支持的能力主要包括:

发布文本、进度条等类型通知。
携带或更新应用通知数字角标。
取消曾经发布的某条或全部通知。
查询已发布的通知列表。
查询应用自身通知开关状态。
应用通知用户的能力默认关闭，开发者可拉起授权框，请求用户授权发布通知。

业务流程

使用Notification Kit的主要业务流程如下：

1.请求通知授权。

2.应用发布通知到通知服务。

3.将通知展示到通知中心。

通知样式
说明

实际显示效果依赖设备能力和通知中心UI设计样式。

Notification Kit中常用的通知样式如下：

类型	通知样式	规格描述
文本		通知文本内容最多显示三行，超长后以“...”截断。
多行文本		最多可显示三行内容，每行内容超长后以“...”截断。
通知角标		以数字的形式展示在右上角。
进度条		进度类通知。
约束限制
单个应用已发布的通知在通知中心等系统入口的留存数量有限（当前规格最多24条）。
通知的长度不能超过200KB（跨进程序列化大小限制）。
系统所有应用发布新通知的频次累计不能超过每秒10条，更新通知的频次累计不能超过每秒20条。
与相关Kit的关系
Notification Kit创建的通知会即时显示在通知中心等系统入口，如果开发者希望在应用退到后台或进程终止后仍然有一些提醒用户的定时类通知，例如购物类应用抢购提醒等，可通过BackGroundTask Kit创建，目前支持基于倒计时、日历、闹钟等类型的通知提醒功能。
开发者可通过Ability Kit设置用户点击通知后的行为意图。
开发者可通过Push Kit远程推送用户通知到本地。

---

## 请求通知授权

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/notification-enable-V5

应用需要获取用户授权才能发送通知。在通知发布前调用requestEnableNotification()方法，弹窗让用户选择是否允许发送通知，后续再次调用requestEnableNotification()方法时，则不再弹窗。

接口说明

接口详情参见API参考。

表1 通知授权接口功能介绍

接口名	描述
isNotificationEnabled():Promise<boolean>	查询通知是否授权。
requestEnableNotification(context: UIAbilityContext): Promise<void>	请求发送通知的许可，第一次调用会弹窗让用户选择。
开发步骤

导入NotificationManager模块。

import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';


const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

请求通知授权。

可通过requestEnableNotification的错误码判断用户是否授权。若返回的错误码为1600004，即为拒绝授权。

let context = getContext(this) as common.UIAbilityContext;
notificationManager.isNotificationEnabled().then((data: boolean) => {
  hilog.info(DOMAIN_NUMBER, TAG, "isNotificationEnabled success, data: " + JSON.stringify(data));
  if(!data){
    notificationManager.requestEnableNotification(context).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification success`);
    }).catch((err : BusinessError) => {
      if(1600004 == err.code){
        hilog.error(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification refused, code is ${err.code}, message is ${err.message}`);
      } else {
        hilog.error(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
      }
    });
  }
}).catch((err : BusinessError) => {
    hilog.error(DOMAIN_NUMBER, TAG, `isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
});

---

## 管理通知角标

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/notification-badge-V5

针对未读的通知，系统提供了角标设置接口，将未读通知个数显示在桌面图标的右上角角标上。

通知增加时，角标上显示的未读通知个数需要增加。

通知被查看后，角标上显示的未读通知个数需要减少，没有未读通知时，不显示角标。

接口说明

当角标设定个数取值0时，表示清除角标。取值大于99时，通知角标将显示99+。

增加角标数，支持如下两种方法：

发布通知时，在NotificationRequest的badgeNumber字段里携带，桌面收到通知后，在原角标数上累加、呈现。

调用接口setBadgeNumber()设置，桌面按设置的角标数呈现。

减少角标数，目前仅支持通过setBadgeNumber()设置。

接口名	描述
setBadgeNumber(badgeNumber: number, callback: AsyncCallback<void>): void	设置角标个数。
开发步骤

导入NotificationManager模块。

import { notificationManager } from '@kit.NotificationKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';


const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

增加角标个数。

发布通知在NotificationRequest的badgeNumber字段里携带，可参考通知发布章节。

示例为调用setBadgeNumber接口增加角标，在发布完新的通知后，调用该接口。

let setBadgeNumberCallback = (err: BusinessError): void => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
    return;
  }
  hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
}


let badgeNumber = 9;
notificationManager.setBadgeNumber(badgeNumber, setBadgeNumberCallback);

减少角标个数。

一条通知被查看后，应用需要调用接口设置剩下未读通知个数，桌面刷新角标。

let setBadgeNumberCallback = (err: BusinessError): void => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
    return;
  }
  hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
}


let badgeNumber = 8;
notificationManager.setBadgeNumber(badgeNumber, setBadgeNumberCallback);
常见问题

由于setBadgeNumber为异步接口，使用setBadgeNumber连续设置角标时，为了确保执行顺序符合预期，需要确保上一次设置完成后才能进行下一次设置。

反例

每次接口调用是相互独立的、没有依赖关系的，实际执行时无法保证调用顺序。

示例如下：

let badgeNumber: number = 10;
notificationManager.setBadgeNumber(badgeNumber).then(() => {
  hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 10 success.`);
});
badgeNumber = 11;
notificationManager.setBadgeNumber(badgeNumber).then(() => {
  hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 11 success.`);
});

正例

多次接口调用存在依赖关系，确保上一次设置完成后才能进行下一次设置。

示例如下：

let badgeNumber: number = 10;
notificationManager.setBadgeNumber(badgeNumber).then(() => {
  hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 10 success.`);
  badgeNumber = 11;
  notificationManager.setBadgeNumber(badgeNumber).then(() => {
    hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 11 success.`);
  });
});

---

## 管理通知渠道

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/notification-slot-V5

系统支持多种通知渠道，不同通知渠道对应的通知提醒方式不同，可以根据应用的实际场景选择适合的通知渠道，并对通知渠道进行管理（支持创建、查询、删除等操作）。

通知渠道类型说明

不同类型的通知渠道对应的通知提醒方式不同，详见下表。其中，Y代表支持，N代表不支持。

SlotType	取值	分类	通知中心	横幅	锁屏	铃声/振动	状态栏图标	自动亮屏
UNKNOWN_TYPE	0	未知类型	Y	N	N	N	N	N
SOCIAL_COMMUNICATION	1	社交通信	Y	Y	Y	Y	Y	Y
SERVICE_INFORMATION	2	服务提醒	Y	Y	Y	Y	Y	Y
CONTENT_INFORMATION	3	内容资讯	Y	N	N	N	N	N
CUSTOMER_SERVICE	5	客服消息	Y	N	N	Y	Y	N
OTHER_TYPES	0xFFFF	其他	Y	N	N	N	N	N
接口说明

通知渠道主要接口如下。其他接口介绍详情参见API参考。

接口名	描述
addSlot(type: SlotType): Promise<void>	创建指定类型的通知渠道。
getSlot(slotType: SlotType): Promise<NotificationSlot>	获取一个指定类型的通知渠道。
removeSlot(slotType: SlotType): Promise<void>	删除此应用程序指定类型的通知渠道。

除了可以使用addslot()创建通知渠道，还可以在发布通知的NotificationRequest中携带notificationSlotType字段，如果对应渠道不存在，会自动创建。

开发步骤

导入notificationManager模块。

import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

创建指定类型的通知渠道。

// addslot回调
let addSlotCallBack = (err: BusinessError): void => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `addSlot failed, code is ${err.code}, message is ${err.message}`);
  } else {
    hilog.info(DOMAIN_NUMBER, TAG, `addSlot success`);
  }
}
notificationManager.addSlot(notificationManager.SlotType.SOCIAL_COMMUNICATION, addSlotCallBack);

查询指定类型的通知渠道。

获取对应渠道是否创建以及该渠道支持的通知提醒方式，比如是否有声音提示，是否有震动，锁屏是否可见等。

// getSlot回调
let getSlotCallback = (err: BusinessError, data: notificationManager.NotificationSlot): void => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to get slot. Code is ${err.code}, message is ${err.message}`);
  } else {
    hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in getting slot.`);
    if (data != null) {
      hilog.info(DOMAIN_NUMBER, TAG, `slot enable status is ${JSON.stringify(data.enabled)}`);
      hilog.info(DOMAIN_NUMBER, TAG, `slot level is ${JSON.stringify(data.level)}`);
      hilog.info(DOMAIN_NUMBER, TAG, `vibrationEnabled status is ${JSON.stringify(data.vibrationEnabled)}`);
      hilog.info(DOMAIN_NUMBER, TAG, `lightEnabled status is ${JSON.stringify(data.lightEnabled)}`);
    }
  }
}
let slotType: notificationManager.SlotType = notificationManager.SlotType.SOCIAL_COMMUNICATION;
notificationManager.getSlot(slotType, getSlotCallback);

删除指定类型的通知渠道。

// removeSlot回调
let removeSlotCallback = (err: BusinessError): void => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `removeSlot failed, code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err.message)}`);
  } else {
    hilog.info(DOMAIN_NUMBER, TAG, "removeSlot success");
  }
}
let slotType: notificationManager.SlotType = notificationManager.SlotType.SOCIAL_COMMUNICATION;
notificationManager.removeSlot(slotType, removeSlotCallback);

---

## 取消通知

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/notification-cancel-V5

用户收到通知提醒后，点击通知并拉起应用到前台时，应用可以选择取消某条通知或所有通知。

例如，用户收到某个好友的IM消息，点击通知进入应用查看消息后，应用可以取消相关通知提醒。

接口说明

通知取消接口如下。接口详情参见API参考。

接口名	描述
cancel(id: number, callback: AsyncCallback<void>): void	取消指定的通知。
cancelAll(callback: AsyncCallback<void>): void	取消所有该应用发布的通知。
开发步骤

本文以取消文本类型通知为例进行说明，其他类型通知取消操作与此类似。

导入模块。

import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

发布通知。

参考发布文本类型通知。

取消通知。

 // 当拉起应用到前台，查看消息后，调用该接口取消通知。
 notificationManager.cancel(1, (err: BusinessError) => {
   if (err) {
     hilog.error(DOMAIN_NUMBER, TAG, `Failed to cancel notification. Code is ${err.code}, message is ${err.message}`);
     return;
   }
   hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in canceling notification.');
 });

---


## 发布通知

### 发布文本类型通知

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/text-notification-V5

文本类型通知主要应用于发送短信息、提示信息等，支持普通文本类型和多行文本类型。

表1 基础类型通知中的内容分类

类型	描述
NOTIFICATION_CONTENT_BASIC_TEXT	普通文本类型。
NOTIFICATION_CONTENT_MULTILINE	多行文本类型。
接口说明

通知发布接口说明详见下表，通知发布的详情可通过入参NotificationRequest来进行指定，可以包括通知内容、通知ID、通知的通道类型和通知发布时间等信息。

接口名	描述
publish(request: NotificationRequest, callback: AsyncCallback<void>): void	发布通知。
开发步骤

导入模块。

import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

构造NotificationRequest对象，并发布通知。

普通文本类型通知由标题、文本内容和附加信息三个字段组成，其中标题和文本内容是必填字段，大小均需要小于200字节，超出部分会被截断。

let notificationRequest: notificationManager.NotificationRequest = {
  id: 1,
  content: {
    notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 普通文本类型通知
    normal: {
      title: 'test_title',
      text: 'test_text',
      additionalText: 'test_additionalText',
    }
  }
};
notificationManager.publish(notificationRequest, (err: BusinessError) => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
    return;
  }
  hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
});

多行文本类型通知继承了普通文本类型的字段，同时新增了多行文本内容、内容概要和通知展开时的标题，其字段均小于200字节，超出部分会被截断。通知默认显示与普通文本相同，展开后，标题显示为展开后标题内容，多行文本内容多行显示。

let notificationRequest: notificationManager.NotificationRequest = {
  id: 3,
  content: {
    notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE, // 多行文本类型通知
    multiLine: {
      title: 'test_title',
      text: 'test_text',
      briefText: 'test_briefText',
      longTitle: 'test_longTitle',
      lines: ['line_01', 'line_02', 'line_03', 'line_04'],
    }
  }
};
// 发布通知
notificationManager.publish(notificationRequest, (err: BusinessError) => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
    return;
  }
  hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
});

---

### 发布进度条类型通知

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/progress-bar-notification-V5

进度条通知也是常见的通知类型，主要应用于文件下载、事务处理进度显示。当前系统提供了进度条模板，发布通知应用设置好进度条模板的属性值，如模板名、模板数据，通过通知子系统发送到通知栏显示。

目前系统模板仅支持进度条模板，通知模板NotificationTemplate中的data参数为用户自定义数据，用于显示与模块相关的数据。

接口说明

isSupportTemplate()是查询模板是否支持接口，目前仅支持进度条模板。

接口名	描述
isSupportTemplate(templateName: string): Promise<boolean>	查询模板是否存在。
开发步骤

导入模块。

import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

查询系统是否支持进度条模板，查询结果为支持downloadTemplate模板类通知。

notificationManager.isSupportTemplate('downloadTemplate').then((data:boolean) => {
  hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in supporting download template notification.');
  let isSupportTpl: boolean = data; // isSupportTpl的值为true表示支持downloadTemplate模板类通知，false表示不支持
}).catch((err: BusinessError) => {
  hilog.error(DOMAIN_NUMBER, TAG, `Failed to support download template notification. Code is ${err.code}, message is ${err.message}`);
});
说明

查询系统支持进度条模板后，再进行后续的步骤操作。

构造进度条模板对象，并发布通知。

let notificationRequest: notificationManager.NotificationRequest = {
  id: 5,
  content: {
    notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: 'test_title',
      text: 'test_text',
      additionalText: 'test_additionalText'
    }
  },
  // 构造进度条模板，name字段当前需要固定配置为downloadTemplate
  template: {
    name: 'downloadTemplate',
    data: { title: 'File Title', fileName: 'music.mp4', progressValue: 45 }
  }
}


// 发布通知
notificationManager.publish(notificationRequest, (err: BusinessError) => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
    return;
  }
  hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
});

---

### 为通知添加行为意图

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/notification-with-wantagent-V5

当发布通知时，如果期望用户可以通过点击通知栏拉起目标应用组件或发布公共事件，可以通过Ability Kit申请WantAgent封装至通知消息中。

图1 携带行为意图的通知运行机制

接口说明

具体接口描述，详见WantAgent接口文档。

接口名	描述
getWantAgent(info: WantAgentInfo, callback: AsyncCallback<WantAgent>): void	创建WantAgent。
开发步骤

导入模块。

import { notificationManager } from '@kit.NotificationKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

创建WantAgentInfo信息。

场景一：创建拉起UIAbility的WantAgent的WantAgentInfo信息。

let wantAgentObj:WantAgent; // 用于保存创建成功的wantAgent对象，后续使用其完成触发的动作。


// 通过WantAgentInfo的operationType设置动作类型
let wantAgentInfo:wantAgent.WantAgentInfo = {
  wants: [
    {
      deviceId: '',
      bundleName: 'com.samples.notification',
      abilityName: 'SecondAbility',
      action: '',
      entities: [],
      uri: '',
      parameters: {}
    }
  ],
  actionType: wantAgent.OperationType.START_ABILITY,
  requestCode: 0,
  wantAgentFlags:[wantAgent.WantAgentFlags.CONSTANT_FLAG]
};

场景二：创建发布公共事件的WantAgent的WantAgentInfo信息。

let wantAgentObj:WantAgent; // 用于保存创建成功的WantAgent对象，后续使用其完成触发的动作。


// 通过WantAgentInfo的operationType设置动作类型
let wantAgentInfo:wantAgent.WantAgentInfo = {
  wants: [
    {
      action: 'event_name', // 设置事件名
      parameters: {},
    }
  ],
  actionType: wantAgent.OperationType.SEND_COMMON_EVENT,
  requestCode: 0,
  wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
};

调用getWantAgent()方法进行创建WantAgent。

// 创建WantAgent
wantAgent.getWantAgent(wantAgentInfo, (err: BusinessError, data:WantAgent) => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to get want agent. Code is ${err.code}, message is ${err.message}`);
    return;
  }
  hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in getting want agent.');
  wantAgentObj = data;
});

构造NotificationRequest对象，并发布WantAgent通知。

// 构造NotificationRequest对象
let notificationRequest: notificationManager.NotificationRequest = {
  content: {
    notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: 'Test_Title',
      text: 'Test_Text',
      additionalText: 'Test_AdditionalText',
    },
  },
  id: 6,
  label: 'TEST',
  // wantAgentObj使用前需要保证已被赋值（即步骤3执行完成）
  wantAgent: wantAgentObj,
}


notificationManager.publish(notificationRequest, (err: BusinessError) => {
  if (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
    return;
  }
  hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
});

用户通过点击通知栏上的通知，系统会自动触发WantAgent的动作。

---


## See Also

- [Background Tasks Kit 后台任务](background-tasks-kit.md)
- [媒体与设备能力](media-device.md)
