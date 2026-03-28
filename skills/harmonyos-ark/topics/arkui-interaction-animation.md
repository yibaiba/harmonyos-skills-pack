# ArkUI 交互 — 拖拽、焦点与动画

> 本文件从 arkui-interaction.md 拆分而来
> 内容：拖拽事件、焦点事件、属性动画、粒子动画、动画曲线

## 拖拽事件

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-common-events-drag-event-V5

拖拽事件提供了一种通过鼠标或手势触屏传递数据的机制，即从一个组件位置拖出（drag）数据并将其拖入（drop）到另一个组件位置，以触发响应。在这一过程中，拖出方提供数据，而拖入方负责接收和处理数据。这一操作使用户能够便捷地移动、复制或删除指定内容。

基本概念
拖拽操作：在可响应拖出的组件上长按并滑动以触发拖拽行为，当用户释放手指或鼠标时，拖拽操作即告结束。
拖拽背景（背板）：用户拖动数据时的形象化表示。开发者可以通过onDragStart的CustomerBuilder或DragItemInfo进行设置，也可以通过dragPreview通用属性进行自定义。
拖拽内容：被拖动的数据，使用UDMF统一API UnifiedData 进行封装，确保数据的一致性和安全性。
拖出对象：触发拖拽操作并提供数据的组件，通常具有响应拖拽的特性。
拖入目标：可接收并处理拖动数据的组件，能够根据拖入的数据执行相应的操作。
拖拽点：鼠标或手指与屏幕的接触位置，用于判断是否进入组件范围。判定依据是接触点是否位于组件的范围内。
拖拽流程

拖拽流程包含手势拖拽流程和鼠标拖拽流程，可帮助开发者理解回调事件触发的时机。

​手势拖拽流程

对于手势长按触发拖拽的场景，ArkUI在发起拖拽前会校验当前组件是否具备拖拽功能。对于默认可拖出的组件（Search、TextInput、TextArea、RichEditor、Text、Image、Hyperlink）需要判断是否设置了draggable，需检查是否已设置draggable属性为true（若系统使能分层参数，draggable属性默认为true）。其他组件则需额外确认是否已设置onDragStart回调函数。在满足上述条件后，长按时间达到或超过500ms即可触发拖拽，而长按800ms时，系统开始执行预览图的浮起动效。若与Menu功能结合使用，并通过isShow控制其显示与隐藏，建议避免在用户操作800ms后才控制菜单显示，此举可能引发非预期的行为。

手势拖拽（手指/手写笔）触发拖拽流程：

​鼠标拖拽流程

鼠标拖拽操作遵循即拖即走的模式，当鼠标左键在可拖拽的组件上按下并移动超过1vp时，即可触发拖拽功能。

当前不仅支持应用内部的拖拽，还支持跨应用的拖拽操作。为了帮助开发者更好地感知拖拽状态并调整系统默认的拖拽行为，ArkUI提供了多个回调事件，具体详情如下：

回调事件	说明
onDragStart	

拖出的组件产生拖出动作时，该回调触发。

该回调可以感知拖拽行为的发起，开发者可以在onDragStart方法中设置拖拽过程中传递的数据，并自定义拖拽的背板图像。建议开发者采用pixelmap的方式来返回背板图像，避免使用customBuilder，因为后者可能会带来额外的性能开销。


onDragEnter	当拖拽操作的拖拽点进入组件的范围时，如果该组件监听了onDrop事件，此回调将会被触发。
onDragMove	

当拖拽点在组件范围内移动时，如果该组件监听了onDrop事件，此回调将会被触发。

在这一过程中，可以通过调用DragEvent中的setResult方法来影响系统在部分场景下的外观表现

1. 设置DragResult.DROP_ENABLED。

2. 设置DragResult.DROP_DISABLED。


onDragLeave	

当拖拽点移出组件范围时，如果该组件监听了onDrop事件，此回调将会被触发。

在以下两种情况下，系统默认不会触发onDragLeave事件：

1. 父组件移动到子组件。

2. 目标组件与当前组件布局有重叠。

API version 12开始可通过UIContext中的setDragEventStrictReportingEnabled方法严格触发onDragLeave事件。


onDrop	

当用户在组件范围内释放拖拽操作时，此回调会被触发。开发者需在此回调中通过DragEvent的setResult方法来设置拖拽结果，否则在拖出方组件的onDragEnd方法中，通过getResult方法获取的将只是默认的处理结果DragResult.DRAG_FAILED。

此回调是开发者干预系统默认拖入处理行为的关键点，系统会优先执行开发者定义的onDrop回调。通过在onDrop回调中调用setResult方法，开发者可以告知系统如何处理被拖拽的数据。

1. 设置 DragResult.DRAG_SUCCESSFUL，数据完全由开发者自己处理，系统不进行处理。

2. 设置DragResult.DRAG_FAILED，数据不再由系统继续处理。

3. 设置DragResult.DRAG_CANCELED，系统也不需要进行数据处理。

4. 设置DragResult.DROP_ENABLED或DragResult.DROP_DISABLED会被忽略，等同于设置DragResult.DRAG_FAILED。


onDragEnd	当用户释放拖拽时，拖拽活动终止，发起拖出动作的组件将触发该回调函数。
onPreDrag	

当触发拖拽事件的不同阶段时，绑定此事件的组件会触发该回调函数。

开发者可利用此方法，在拖拽开始前的不同阶段，根据PreDragStatus枚举准备相应数据。

1. ACTION_DETECTING_STATUS：拖拽手势启动阶段。按下50ms时触发。

2. READY_TO_TRIGGER_DRAG_ACTION：拖拽准备完成，可发起拖拽阶段。按下500ms时触发。

3. PREVIEW_LIFT_STARTED：拖拽浮起动效发起阶段。按下800ms时触发。

4. PREVIEW_LIFT_FINISHED：拖拽浮起动效结束阶段。浮起动效完全结束时触发。

5. PREVIEW_LANDING_STARTED：拖拽落回动效发起阶段。落回动效发起时触发。

6. PREVIEW_LANDING_FINISHED：拖拽落回动效结束阶段。落回动效结束时触发。

7. ACTION_CANCELED_BEFORE_DRAG：拖拽浮起落位动效中断。已满足READY_TO_TRIGGER_DRAG_ACTION状态后，未达到动效阶段，手指抬起时触发。

DragEvent支持的get方法可用于获取拖拽行为的详细信息，下表展示了在相应的拖拽回调中，这些get方法是否能够返回有效数据。

回调事件	onDragStart	onDragEnter	onDragMove	onDragLeave	onDrop	onDragEnd
getData	—	—	—	—	支持	—
getSummary	—	支持	支持	支持	支持	—
getResult	—	—	—	—	—	支持
getPreviewRect	—	—	—	—	支持	—
getVelocity/X/Y	—	支持	支持	支持	支持	—
getWindowX/Y	支持	支持	支持	支持	支持	—
getDisplayX/Y	支持	支持	支持	支持	支持	—
getX/Y	支持	支持	支持	支持	支持	—
behavior	—	—	—	—	—	支持

DragEvent支持相关set方法向系统传递信息，这些信息部分会影响系统对UI或数据的处理方式。下表列出了set方法应该在回调的哪个阶段执行才会被系统接受并处理。

回调事件	onDragStart	onDragEnter	onDragMove	onDragLeave	onDrop
useCustomDropAnimation	—	—	—	—	支持
setData	支持	—	—	—	—
setResult	支持，可通过set failed或cancel来阻止拖拽发起	支持，不作为最终结果传递给onDragEnd	支持，不作为最终结果传递给onDragEnd	支持，不作为最终结果传递给onDragEnd	支持，作为最终结果传递给onDragEnd
behavior	—	支持	支持	支持	支持
拖拽背板图

在拖拽移动过程中显示的背板图并非组件本身，而是表示用户拖动的数据，开发者可将其设定为任意可显示的图像。具体而言，onDragStart回调中返回的customBuilder或pixelmap可以用于设置拖拽移动过程中的背板图，而浮起图则默认采用组件本身的截图。dragpreview属性中设定的customBuilder或pixelmap可以用于配置浮起和拖拽过程的背板图。若开发者未配置背板图，系统将自动采用组件本身的截图作为拖拽和浮起时的背板图。

拖拽背板图当前支持设置透明度、圆角、阴影和模糊，具体用法见拖拽控制。

约束限制：

对于容器组件，如果内部内容通过position、offset等接口使得绘制区域超出了容器组件范围，则系统截图无法截取到范围之外的内容。此种情况下，如果一定要浮起，即拖拽背板能够包含范围之外的内容，则可考虑通过扩大容器范围或自定义方式实现。
不论是使用自定义builder或是系统默认截图方式，截图都暂时无法应用scale、rotate等图形变换效果。
通用拖拽适配

如下以Image组件为例，介绍组件拖拽开发的基本步骤，以及开发中需要注意的事项。

组件使能拖拽。

设置draggable属性为true，并配置onDragStart回调函数。在回调函数中，可通过UDMF（用户数据管理框架）设置拖拽的数据，并返回自定义的拖拽背景图像。

import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';


Image($r('app.media.app_icon'))
    .width(100)
    .height(100)
    .draggable(true)
    .onDragStart((event) => {
        let data: unifiedDataChannel.Image = new unifiedDataChannel.Image();
        data.imageUri = 'common/pic/img.png';
        let unifiedData = new unifiedDataChannel.UnifiedData(data);
        event.setData(unifiedData);


        let dragItemInfo: DragItemInfo = {
        pixelMap: this.pixmap,
        extraInfo: "this is extraInfo",
        };
        // onDragStart回调函数中返回自定义拖拽背板图
        return dragItemInfo;
    })

手势场景触发的拖拽功能依赖于底层绑定的长按手势。如果开发者在可拖拽组件上也绑定了长按手势，这将与底层的长按手势产生冲突，进而导致拖拽操作失败。为解决此类问题，可以采用并行手势的方案，具体如下。

.parallelGesture(LongPressGesture().onAction(() => {
   promptAction.showToast({ duration: 100, message: 'Long press gesture trigger' });
}))

自定义拖拽背板图。

可以通过在长按50ms时触发的回调中设置onPreDrag回调函数，来提前准备自定义拖拽背板图的pixmap。

.onPreDrag((status: PreDragStatus) => {
    if (preDragStatus == PreDragStatus.ACTION_DETECTING_STATUS) {
        this.getComponentSnapshot();
    }
})

pixmap的生成可以调用componentSnapshot.createFromBuilder函数来实现。

@Builder
pixelMapBuilder() {
    Column() {
      Image($r('app.media.startIcon'))
        .width(120)
        .height(120)
        .backgroundColor(Color.Yellow)
    }
  }
  private getComponentSnapshot(): void {
  this.getUIContext().getComponentSnapshot().createFromBuilder(()=>{this.pixelMapBuilder()},
  (error: Error, pixmap: image.PixelMap) => {
      if(error){
        console.log("error: " + JSON.stringify(error))
        return;
      }
      this.pixmap = pixmap;
  })
}

若开发者需确保触发onDragLeave事件，应通过调用setDragEventStrictReportingEnabled方法进行设置。

import { UIAbility } from '@kit.AbilityKit';
import { window, UIContext } from '@kit.ArkUI';


export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        return;
      }
      windowStage.getMainWindow((err, data) => {
        if (err.code) {
          return;
        }
        let windowClass: window.Window = data;
        let uiContext: UIContext = windowClass.getUIContext();
        uiContext.getDragController().setDragEventStrictReportingEnabled(true);
      });
    });
  }
}

拖拽过程显示角标样式。

通过设置allowDrop来定义接收的数据类型，这将影响角标显示。当拖拽的数据符合定义的允许落入的数据类型时，显示“COPY”角标。当拖拽的数据类型不在允许范围内时，显示“FORBIDDEN”角标。若未设置allowDrop，则显示“MOVE”角标。以下代码示例表示仅接收UnifiedData中定义的HYPERLINK和PLAIN_TEXT类型数据，其他类型数据将被禁止落入。

.allowDrop([uniformTypeDescriptor.UniformDataType.HYPERLINK, uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])

在实现onDrop回调的情况下，还可以通过在onDragMove中设置DragResult为DROP_ENABLED，并将DragBehavior设置为COPY或MOVE，以此来控制角标显示。如下代码将移动时的角标强制设置为“MOVE”。

.onDragMove((event) => {
    event.setResult(DragResult.DROP_ENABLED);
    event.dragBehavior = DragBehavior.MOVE;
})

拖拽数据的接收。

需要设置onDrop回调函数，并在回调函数中处理拖拽数据，显示设置拖拽结果。

.onDrop((dragEvent?: DragEvent) => {
    // 获取拖拽数据
    this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
    let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
    let rect: Rectangle = event.getPreviewRect();
    this.imageWidth = Number(rect.width);
    this.imageHeight = Number(rect.height);
    this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri;
    this.imgState = Visibility.None；
    // 显式设置result为successful，则将该值传递给拖出方的onDragEnd
    event.setResult(DragResult.DRAG_SUCCESSFUL);
})

数据的传递是通过UDMF实现的，在数据较大时可能存在时延，因此在首次获取数据失败时建议加1500ms的延迟重试机制。

getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
   try {
     let data: UnifiedData = event.getData();
     if (!data) {
       return false;
     }
     let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
     if (!records || records.length <= 0) {
       return false;
     }
     callback(event);
     return true;
   } catch (e) {
     console.log("getData failed, code: " + (e as BusinessError).code + ", message: " + (e as BusinessError).message);
     return false;
   }
}


getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
  if (this.getDataFromUdmfRetry(event, callback)) {
    return;
  }
  setTimeout(() => {
    this.getDataFromUdmfRetry(event, callback);
  }, 1500);
}

拖拽发起方可以通过设置onDragEnd回调感知拖拽结果。

import { promptAction } from '@kit.ArkUI';


.onDragEnd((event) => {
    // onDragEnd里取到的result值在接收方onDrop设置
  if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
    promptAction.showToast({ duration: 100, message: 'Drag Success' });
  } else if (event.getResult() === DragResult.DRAG_FAILED) {
    promptAction.showToast({ duration: 100, message: 'Drag failed' });
  }
})

完整示例：

import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';


@Entry
@Component
struct Index {
  @State targetImage: string = '';
  @State imageWidth: number = 100;
  @State imageHeight: number = 100;
  @State imgState: Visibility = Visibility.Visible;
  @State pixmap: image.PixelMap|undefined = undefined


  @Builder
  pixelMapBuilder() {
    Column() {
      Image($r('app.media.startIcon'))
        .width(120)
        .height(120)
        .backgroundColor(Color.Yellow)
    }
  }


  getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
    try {
      let data: UnifiedData = event.getData();
      if (!data) {
        return false;
      }
      let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (e) {
      console.log("getData failed, code: " + (e as BusinessError).code + ", message: " + (e as BusinessError).message);
      return false;
    }
  }
  // 获取UDMF数据，首次获取失败后添加1500ms延迟重试机制
  getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
    if (this.getDataFromUdmfRetry(event, callback)) {
      return;
    }
    setTimeout(() => {
      this.getDataFromUdmfRetry(event, callback);
    }, 1500);
  }
  // 调用componentSnapshot中的createFromBuilder接口截取自定义builder的截图
  private getComponentSnapshot(): void {
    this.getUIContext().getComponentSnapshot().createFromBuilder(()=>{this.pixelMapBuilder()},
      (error: Error, pixmap: image.PixelMap) => {
        if(error){
          console.log("error: " + JSON.stringify(error))
          return;
        }
        this.pixmap = pixmap;
      })
  }
  // 长按50ms时提前准备自定义截图的pixmap
  private PreDragChange(preDragStatus: PreDragStatus): void {
    if (preDragStatus == PreDragStatus.ACTION_DETECTING_STATUS) {
      this.getComponentSnapshot();
    }
  }


  build() {
    Row() {
      Column() {
        Text('start Drag')
          .fontSize(18)
          .width('100%')
          .height(40)
          .margin(10)
          .backgroundColor('#008888')
        Row() {
          Image($r('app.media.app_icon'))
            .width(100)
            .height(100)
            .draggable(true)
            .margin({ left: 15 })
            .visibility(this.imgState)
            // 绑定平行手势，可同时触发应用自定义长按手势
            .parallelGesture(LongPressGesture().onAction(() => {
              promptAction.showToast({ duration: 100, message: 'Long press gesture trigger' });
            }))
            .onDragStart((event) => {
              let data: unifiedDataChannel.Image = new unifiedDataChannel.Image();
              data.imageUri = 'common/pic/img.png';
              let unifiedData = new unifiedDataChannel.UnifiedData(data);
              event.setData(unifiedData);


              let dragItemInfo: DragItemInfo = {
                pixelMap: this.pixmap,
                extraInfo: "this is extraInfo",
              };
              return dragItemInfo;
            })
              // 提前准备拖拽自定义背板图
            .onPreDrag((status: PreDragStatus) => {
              this.PreDragChange(status);

<!-- 原始 651 行，截取前 400 行。完整版请访问上方链接 -->

---

## 焦点事件

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-common-events-focus-event-V5

基础概念与规范
基础概念

焦点、焦点链和走焦

焦点：指向当前应用界面上唯一的一个可交互元素，当用户使用键盘、电视遥控器、车机摇杆/旋钮等非指向性输入设备与应用程序进行间接交互时，基于焦点的导航和交互是重要的输入手段。
焦点链：在应用的组件树形结构中，当一个组件获得焦点时，从根节点到该组件节点的整条路径上的所有节点都会被视为处于焦点状态，形成一条连续的焦点链。
走焦：指焦点在应用内的组件之间转移的行为。这一过程对用户是透明的，但开发者可以通过监听onFocus（焦点获取）和onBlur（焦点失去）事件来捕捉这些变化。关于走焦的具体方式和规则，详见走焦规范。

焦点态

用来指向当前获焦组件的样式。

显示规则：默认情况下焦点态不会显示，只有当应用进入激活态后，焦点态才会显示。因此，虽然获得焦点的组件不一定显示焦点态（取决于是否处于激活态），但显示焦点态的组件必然是获得焦点的。大部分组件内置了焦点态样式，开发者同样可以使用样式接口进行自定义，一旦自定义，组件将不再显示内置的焦点态样式。在焦点链中，若多个组件同时拥有焦点态，系统将采用子组件优先的策略，优先显示子组件的焦点态，并且仅显示一个焦点态。
进入激活态：仅使用外接键盘按下TAB键时才会进入焦点的激活态，进入激活态后，才可以使用键盘TAB键/方向键进行走焦。首次用来激活焦点态的TAB键不会触发走焦。
退出激活态：当应用收到点击事件时（包括手指触屏的按下事件和鼠标左键的按下事件），焦点的激活态会退出。

层级页面

层级页面是焦点框架中特定容器组件的统称，涵盖Page、Dialog、SheetPage、ModalPage、Menu、Popup、NavBar、NavDestination等。这些组件通常具有以下关键特性：

视觉层级独立性：从视觉呈现上看，这些组件独立于其他页面内容，并通常位于其上方，形成视觉上的层级差异。
焦点跟随：此类组件在首次创建并展示之后，会立即将应用内焦点抢占。
走焦范围限制：当焦点位于这些组件内部时，用户无法通过键盘按键将焦点转移到组件外部的其他元素上，焦点移动仅限于组件内部。

在一个应用程序中，任何时候都至少存在一个层级页面组件，并且该组件会持有当前焦点。当该层级页面关闭或不再可见时，焦点会自动转移到下一个可用的层级页面组件上，确保用户交互的连贯性和一致性。

说明

Popup组件在focusable属性（组件属性，非通用属性）为false的时候，不会有第2条特性。

NavBar、NavDestination没有第3条特性，对于它们的走焦范围，是与它们的首个父层级页面相同的。

根容器

根容器是层级页面内的概念，当某个层级页面首次创建并展示时，根据层级页面的特性，焦点会立即被该页面抢占。此时，该层级页面所在焦点链的末端节点将成为默认焦点，而这个默认焦点通常位于该层级页面的根容器上。

在缺省状态下，层级页面的默认焦点位于其根容器上，但开发者可以通过defaultFocus属性来自定义这一行为。

当焦点位于根容器时，首次按下TAB键不仅会使焦点进入激活状态，还会触发焦点向子组件的传递。如果子组件本身也是一个容器，则焦点会继续向下传递，直至到达叶子节点。传递规则是：优先传递给上一次获得焦点的子节点，如果不存在这样的节点，则默认传递给第一个子节点。

走焦规范

根据走焦的触发方式，可以分为主动走焦和被动走焦。

主动走焦

指开发者/用户主观行为导致的焦点移动，包括：使用外接键盘的按键走焦（TAB键/Shift+TAB键/方向键）、使用requestFocus申请焦点、clearFocus清除焦点、focusOnTouch点击申请焦点等接口导致的焦点转移。

按键走焦
前提：当前应用需处于焦点激活态。
范围限制：按键走焦仅在当前获得焦点的层级页面内进行，具体参见“层级页面”中的“走焦范围限制”部分。

按键类型：

TAB键：遵循Z字型遍历逻辑，完成当前范围内所有叶子节点的遍历，到达当前范围内的最后一个组件后，继续按下TAB键，焦点将循环至范围内的第一个可获焦组件，实现循环走焦。

Shift+TAB键：与TAB键具有相反的焦点转移效果。

方向键（上、下、左、右）：遵循十字型移动策略，在单层容器中，焦点的转移由该容器的特定走焦算法决定。若算法判定下一个焦点应落在某个容器组件上，系统将采用中心点距离优先的算法来进一步确定容器内的目标子节点。

走焦算法：每个可获焦的容器组件都有其特定的走焦算法，用于定义焦点转移的规则。
子组件优先：当子组件处理按键走焦事件，父组件将不再介入。

requestFocus

详见主动获焦失焦，可以主动将焦点转移到指定组件上。

不可跨窗口，不可跨ArkUI实例申请焦点，可以跨层级页面申请焦点。

clearFocus

详见clearFocus，会清除当前层级页面中的焦点，最终焦点停留在根容器上。

focusOnTouch

详见focusOnTouch，使绑定组件具备点击后获得焦点的能力。若组件本身不可获焦，则此功能无效。若绑定的是容器组件，点击后优先将焦点转移给上一次获焦的子组件，否则转移给第一个可获焦的子组件。

被动走焦

被动走焦是指组件焦点因系统或其他操作而自动转移，无需开发者直接干预，这是焦点系统的默认行为。

目前会被动走焦的机制有：

组件删除：当处于焦点状态的组件被删除时，焦点框架首先尝试将焦点转移到相邻的兄弟组件上，遵循先向后再向前的顺序。若所有兄弟组件均不可获焦，则焦点将释放，并通知其父组件进行焦点处理。
属性变更：若将处于焦点状态的组件的focusable或enabled属性设置为false，或者将visibility属性设置为不可见，系统将自动转移焦点至其他可获焦组件，转移方式与1中相同。
层级页面切换：当发生层级页面切换时，如从一个页面跳转到另一个页面，当前页面的焦点将自动释放，新页面可能会根据预设逻辑自动获得焦点。
Web组件初始化：对于Web组件，当其被创建时，若其设计需要立即获得焦点（如某些弹出框或输入框），则可能触发焦点转移至该Web组件，其行为属于组件自身的行为逻辑，不属于焦点框架的规格范围。
走焦算法

在焦点管理系统中，每个可获焦的容器都配备有特定的走焦算法，这些算法定义了当使用TAB键、Shift+TAB键或方向键时，焦点如何从当前获焦的子组件转移到下一个可获焦的子组件。

容器采用何种走焦算法取决于其UX（用户体验）规格，并由容器组件进行适配。目前，焦点框架支持三种走焦算法：线性走焦、投影走焦和自定义走焦。

线性走焦算法

线性走焦算法是默认的走焦策略，它基于容器中子节点在节点树中的挂载顺序进行走焦，常用于单方向布局的容器，如Row、Column和Flex容器。运行规则如下：

顺序依赖：走焦顺序完全基于子节点在节点树中的挂载顺序，与它们在界面上的实际布局位置无关。
TAB键走焦：使用TAB键时，焦点将按照子节点的挂载顺序依次遍历。
方向键走焦：当使用与容器定义方向垂直的方向键时，容器不接受该方向的走焦请求。例如，在横向的Row容器中，无法使用方向键进行上下移动。
边界处理：当焦点位于容器的首尾子节点时，容器将拒绝与当前焦点方向相反的方向键走焦请求。例如，焦点在一个横向的Row容器的第一个子节点上时，该容器无法处理方向键左的走焦请求。

投影走焦算法

投影走焦算法基于当前获焦组件在走焦方向上的投影，结合子组件与投影的重叠面积和中心点距离进行胜出判定。该算法特别适用于子组件大小不一的容器，目前仅有配置了wrap属性的Flex组件。运行规则如下：

方向键走焦时，判断投影与子组件区域的重叠面积，在所有面积不为0的子组件中，计算它们与当前获焦组件的中心点直线距离，距离最短的胜出，若存在多个备选，则节点树上更靠前的胜出。若无任何子组件与投影由重叠，说明该容器已经无法处理该方向键的走焦请求。
TAB键走焦时，先使用规格1，按照方向键右进行判定，若找到则成功退出，若无法找到，则将当前获焦子组件的位置模拟往下移动该获焦子组件的高度，然后再按照方向键左进行投影判定，有投影重叠且中心点直线距离最远的子组件胜出，若无投影重叠的子组件，则表示该容器无法处理本次TAB键走焦请求。
Shift+TAB键走焦时，先使用规格1，按照方向键左进行判定，找到则成功退出。若无法找到，则将当前获焦子组件的位置模拟向上移动该获焦子组件的高度，然后再按照方向键右进行投影判定，有投影重叠且中心点直线距离最远的子组件胜出，若无投影重叠的子组件，则表示该容器无法处理本次的Shift+TAB键走焦请求。

自定义走焦算法

由组件自定义的走焦算法，规格由组件定义。

获焦/失焦事件
onFocus(event: () => void)

获焦事件回调，绑定该接口的组件获焦时，回调响应。

onBlur(event:() => void)

失焦事件回调，绑定该接口的组件失焦时，回调响应。

onFocus和onBlur两个接口通常成对使用，来监听组件的焦点变化。

// xxx.ets
@Entry
@Component
struct FocusEventExample {
  @State oneButtonColor: Color = Color.Gray;
  @State twoButtonColor: Color = Color.Gray;
  @State threeButtonColor: Color = Color.Gray;


  build() {
    Column({ space: 20 }) {
      // 通过外接键盘的上下键可以让焦点在三个按钮间移动，按钮获焦时颜色变化，失焦时变回原背景色
      Button('First Button')
        .width(260)
        .height(70)
        .backgroundColor(this.oneButtonColor)
        .fontColor(Color.Black)
          // 监听第一个组件的获焦事件，获焦后改变颜色
        .onFocus(() => {
          this.oneButtonColor = Color.Green;
        })
          // 监听第一个组件的失焦事件，失焦后改变颜色
        .onBlur(() => {
          this.oneButtonColor = Color.Gray;
        })


      Button('Second Button')
        .width(260)
        .height(70)
        .backgroundColor(this.twoButtonColor)
        .fontColor(Color.Black)
          // 监听第二个组件的获焦事件，获焦后改变颜色
        .onFocus(() => {
          this.twoButtonColor = Color.Green;
        })
          // 监听第二个组件的失焦事件，失焦后改变颜色
        .onBlur(() => {
          this.twoButtonColor = Color.Grey;
        })


      Button('Third Button')
        .width(260)
        .height(70)
        .backgroundColor(this.threeButtonColor)
        .fontColor(Color.Black)
          // 监听第三个组件的获焦事件，获焦后改变颜色
        .onFocus(() => {
          this.threeButtonColor = Color.Green;
        })
          // 监听第三个组件的失焦事件，失焦后改变颜色
        .onBlur(() => {
          this.threeButtonColor = Color.Gray ;
        })
    }.width('100%').margin({ top: 20 })
  }
}

上述示例包含以下3步：

应用打开，按下TAB键激活走焦，“First Button”显示焦点态样式：组件外围有一个蓝色的闭合框，onFocus回调响应，背景色变成绿色。
按下TAB键，触发走焦，“Second Button”获焦，onFocus回调响应，背景色变成绿色；“First Button”失焦，onBlur回调响应，背景色变回灰色。
按下TAB键，触发走焦，“Third Button”获焦，onFocus回调响应，背景色变成绿色；“Second Button”失焦，onBlur回调响应，背景色变回灰色。
设置组件是否可获焦
focusable(value: boolean)

设置组件是否可获焦。

按照组件的获焦能力可大致分为三类：

默认可获焦的组件，通常是有交互行为的组件，例如Button、Checkbox、TextInput组件，此类组件无需设置任何属性，默认即可获焦。

有获焦能力，但默认不可获焦的组件，典型的是Text、Image组件，此类组件缺省情况下无法获焦，若需要使其获焦，可使用通用属性focusable(true)使能。对于没有配置focusable属性，有获焦能力但默认不可获焦的组件，为其配置onClick或是单指单击的Tap手势，该组件会隐式地成为可获焦组件。如果其focusable属性被设置为false，即使配置了上述事件，该组件依然不可获焦。

无获焦能力的组件，通常是无任何交互行为的展示类组件，例如Blank、Circle组件，此类组件即使使用focusable属性也无法使其可获焦。

enabled(value: boolean)

设置组件可交互性属性enabled为false，则组件不可交互，无法获焦。

visibility(value: Visibility)

设置组件可见性属性visibility为Visibility.None或Visibility.Hidden，则组件不可见，无法获焦。

focusOnTouch(value: boolean)

设置当前组件是否支持点击获焦能力。

说明

当某组件处于获焦状态时，将其的focusable属性或enabled属性设置为false，会自动使该组件失焦，然后焦点按照走焦规范将焦点转移给其他组件。

// xxx.ets
@Entry
@Component
struct FocusableExample {
  @State textFocusable: boolean = true;
  @State textEnabled: boolean = true;
  @State color1: Color = Color.Yellow;
  @State color2: Color = Color.Yellow;
  @State color3: Color = Color.Yellow;


  build() {
    Column({ space: 5 }) {
      Text('Default Text')    // 第一个Text组件未设置focusable属性，默认不可获焦
        .borderColor(this.color1)
        .borderWidth(2)
        .width(300)
        .height(70)
        .onFocus(() => {
          this.color1 = Color.Blue;
        })
        .onBlur(() => {
          this.color1 = Color.Yellow;
        })
      Divider()


      Text('focusable: ' + this.textFocusable)    // 第二个Text设置了focusable初始为true，focusableOnTouch为true
        .borderColor(this.color2)
        .borderWidth(2)
        .width(300)
        .height(70)
        .focusable(this.textFocusable)
        .focusOnTouch(true)
        .onFocus(() => {
          this.color2 = Color.Blue;
        })
        .onBlur(() => {
          this.color2 = Color.Yellow;
        })


      Text('enabled: ' + this.textEnabled)    // 第三个Text设置了focusable为true，enabled初始为true
        .borderColor(this.color3)
        .borderWidth(2)
        .width(300)
        .height(70)
        .focusable(true)
        .enabled(this.textEnabled)
        .focusOnTouch(true)
        .onFocus(() => {
          this.color3 = Color.Blue;
        })
        .onBlur(() => {
          this.color3 = Color.Yellow;
        })


      Divider()


      Row() {
        Button('Button1')
          .width(140).height(70)
        Button('Button2')
          .width(160).height(70)
      }


      Divider()
      Button('Button3')
        .width(300).height(70)


      Divider()
    }.width('100%').justifyContent(FlexAlign.Center)
    .onKeyEvent((e) => {
      // 绑定onKeyEvent，在该Column组件获焦时，按下'F'键，可将第二个Text的focusable置反
      if (e.keyCode === 2022 && e.type === KeyType.Down) {
        this.textFocusable = !this.textFocusable;
      }
      // 绑定onKeyEvent，在该Column组件获焦时，按下'G'键，可将第三个Text的enabled置反
      if (e.keyCode === 2023 && e.type === KeyType.Down) {
        this.textEnabled = !this.textEnabled;
      }
    })
  }
}

运行效果：

上述示例包含以下3步：

第一个Text组件没有设置focusable(true)属性，该Text组件无法获焦。
点击第二个Text组件，由于设置了focusOnTouch(true)，第二个组件获焦。按下TAB键，触发走焦，仍然是第二个Text组件获焦。按键盘F键，触发onKeyEvent，focusable置为false，第二个Text组件变成不可获焦，焦点自动转移，会自动从Text组件寻找下一个可获焦组件，焦点转移到第三个Text组件上。
按键盘G键，触发onKeyEvent，enabled置为false，第三个Text组件变成不可获焦，焦点自动转移，使焦点转移到Row容器上，容器中使用的是默认配置，会转移到Button1上。
默认焦点
页面的默认焦点
defaultFocus(value: boolean)

设置当前组件是否为当前页面上的默认焦点。

// xxx.ets
@Entry
@Component
struct morenjiaodian {
  @State oneButtonColor: Color = Color.Gray;
  @State twoButtonColor: Color = Color.Gray;
  @State threeButtonColor: Color = Color.Gray;


  build() {
    Column({ space: 20 }) {
      // 通过外接键盘的上下键可以让焦点在三个按钮间移动，按钮获焦时颜色变化，失焦时变回原背景色
      Button('First Button')
        .width(260)
        .height(70)
        .backgroundColor(this.oneButtonColor)
        .fontColor(Color.Black)
          // 监听第一个组件的获焦事件，获焦后改变颜色
        .onFocus(() => {
          this.oneButtonColor = Color.Green;
        })
          // 监听第一个组件的失焦事件，失焦后改变颜色
        .onBlur(() => {
          this.oneButtonColor = Color.Gray;
        })


      Button('Second Button')
        .width(260)
        .height(70)
        .backgroundColor(this.twoButtonColor)
        .fontColor(Color.Black)
          // 监听第二个组件的获焦事件，获焦后改变颜色
        .onFocus(() => {
          this.twoButtonColor = Color.Green;
        })
          // 监听第二个组件的失焦事件，失焦后改变颜色
        .onBlur(() => {
          this.twoButtonColor = Color.Grey;
        })


      Button('Third Button')
        .width(260)
        .height(70)
        .backgroundColor(this.threeButtonColor)
        .fontColor(Color.Black)
          // 设置默认焦点
        .defaultFocus(true)
          // 监听第三个组件的获焦事件，获焦后改变颜色
        .onFocus(() => {
          this.threeButtonColor = Color.Green;
        })
          // 监听第三个组件的失焦事件，失焦后改变颜色
        .onBlur(() => {
          this.threeButtonColor = Color.Gray ;
        })
    }.width('100%').margin({ top: 20 })
  }
}

上述示例包含以下2步：

在第三个Button组件上设置了defaultFocus(true)，进入页面后第三个Button默认获焦，显示为绿色。
按下TAB键，触发走焦，第三个Button正处于获焦状态，会出现焦点框。
容器的默认焦点

容器的默认焦点受到获焦优先级的影响。

defaultFocus与FocusPriority的区别

defaultFocus是用于指定页面首次展示时的默认获焦节点，FocusPriority是用于指定某个容器首次获焦时其子节点的获焦优先级。上述两个属性在某些场景同时配置时行为未定义，例如下面的场景，页面首次展示无法同时满足defaultFocus获焦和高优先级组件获焦。

示例

@Entry
@Component
struct Index {
  build() {

<!-- 原始 834 行，截取前 400 行。完整版请访问上方链接 -->

---

## 属性动画

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-attribute-animation-apis-V5

通过可动画属性改变引起UI上产生的连续视觉效果，即为属性动画。属性动画是最基础易懂的动画，ArkUI提供两种属性动画接口animateTo和animation驱动组件属性按照动画曲线等动画参数进行连续的变化，产生属性动画。

属性动画接口	作用域	原理	使用场景
animateTo	

闭包内改变属性引起的界面变化。

作用于出现消失转场。

	

通用函数，对闭包前界面和闭包中的状态变量引起的界面之间的差异做动画。

支持多次调用，支持嵌套。

	

适用对多个可动画属性配置相同动画参数的动画。

需要嵌套使用动画的场景。


animation	组件通过属性接口绑定的属性变化引起的界面变化。	

识别组件的可动画属性变化，自动添加动画。

组件的接口调用是从下往上执行，animation只会作用于在其之上的属性调用。

组件可以根据调用顺序对多个属性设置不同的animation。

	适用于对多个可动画属性配置不同参数动画的场景。
使用animateTo产生属性动画
animateTo(value: AnimateParam, event: () => void): void

animateTo接口参数中，value指定AnimateParam对象（包括时长、Curve等）event为动画的闭包函数，闭包内变量改变产生的属性动画将遵循相同的动画参数。

说明

直接使用animateTo可能导致实例不明确的问题，建议使用getUIContext获取UIContext实例，并使用animateTo调用绑定实例的animateTo。

import { curves } from '@kit.ArkUI';


@Entry
@Component
struct AnimateToDemo {
  @State animate: boolean = false;
  // 第一步: 声明相关状态变量
  @State rotateValue: number = 0; // 组件一旋转角度
  @State translateX: number = 0; // 组件二偏移量
  @State opacityValue: number = 1; // 组件二透明度


  // 第二步：将状态变量设置到相关可动画属性接口
  build() {
    Row() {
      // 组件一
      Column() {
      }
      .rotate({ angle: this.rotateValue })
      .backgroundColor('#317AF7')
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .borderRadius(30)
      .onClick(() => {
        this.getUIContext()?.animateTo({ curve: curves.springMotion() }, () => {
          this.animate = !this.animate;
          // 第三步：闭包内通过状态变量改变UI界面
          // 这里可以写任何能改变UI的逻辑比如数组添加，显隐控制，系统会检测改变后的UI界面与之前的UI界面的差异，对有差异的部分添加动画
          // 组件一的rotate属性发生变化，所以会给组件一添加rotate旋转动画
          this.rotateValue = this.animate ? 90 : 0;
          // 组件二的透明度发生变化，所以会给组件二添加透明度的动画
          this.opacityValue = this.animate ? 0.6 : 1;
          // 组件二的translate属性发生变化，所以会给组件二添加translate偏移动画
          this.translateX = this.animate ? 50 : 0;
        })
      })


      // 组件二
      Column() {


      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#D94838')
      .borderRadius(30)
      .opacity(this.opacityValue)
      .translate({ x: this.translateX })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

使用animation产生属性动画

相比于animateTo接口需要把要执行动画的属性的修改放在闭包中，animation接口无需使用闭包，把animation接口加在要做属性动画的可动画属性后即可。animation只要检测到其绑定的可动画属性发生变化，就会自动添加属性动画，animateTo则必须在动画闭包内改变可动画属性的值从而生成动画。

import { curves } from '@kit.ArkUI';


@Entry
@Component
struct AnimationDemo {
  @State animate: boolean = false;
  // 第一步: 声明相关状态变量
  @State rotateValue: number = 0; // 组件一旋转角度
  @State translateX: number = 0; // 组件二偏移量
  @State opacityValue: number = 1; // 组件二透明度


  // 第二步：将状态变量设置到相关可动画属性接口
  build() {
    Row() {
      // 组件一
      Column() {
      }
      .opacity(this.opacityValue)
      .rotate({ angle: this.rotateValue })
      // 第三步：通过属性动画接口开启属性动画
      .animation({ curve: curves.springMotion() })
      .backgroundColor('#317AF7')
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .borderRadius(30)
      .onClick(() => {
        this.animate = !this.animate;
        // 第四步：闭包内通过状态变量改变UI界面
        // 这里可以写任何能改变UI的逻辑比如数组添加，显隐控制，系统会检测改变后的UI界面与之前的UI界面的差异，对有差异的部分添加动画
        // 组件一的rotate属性发生变化，所以会给组件一添加rotate旋转动画
        this.rotateValue = this.animate ? 90 : 0;
        // 组件二的translate属性发生变化，所以会给组件二添加translate偏移动画
        this.translateX = this.animate ? 50 : 0;
        // 父组件column的opacity属性有变化，会导致其子节点的透明度也变化，所以这里会给column和其子节点的透明度属性都加动画
        this.opacityValue = this.animate ? 0.6 : 1;
      })


      // 组件二
      Column() {
      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#D94838')
      .borderRadius(30)
      .opacity(this.opacityValue)
      .translate({ x: this.translateX })
      .animation({ curve: curves.springMotion() })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

说明

在对组件的位置大小的变化做动画的时候，由于布局属性的改变会触发测量布局，性能开销大。scale属性的改变不会触发测量布局，性能开销小。因此，在组件位置大小持续发生变化的场景，如跟手触发组件大小变化的场景，推荐适用scale。

属性动画应该作用于始终存在的组件，对于将要出现或者将要消失的组件的动画应该使用转场动画。

尽量不要使用动画结束回调。属性动画是对已经发生的状态进行的动画，不需要开发者去处理结束的逻辑。如果要使用结束回调，一定要正确处理连续操作的数据管理。

---

## 粒子动画

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-particle-animation-V5

粒子动画是通过在限定区域内随机生成大量粒子的运动，进而组合成的动画效果，通过Particle组件来实现。动画的基本构成元素为单个粒子，这些粒子可以表现为圆点或图片等形式。开发者能够通过对粒子在颜色、透明度、大小、速度、加速度、自旋角度等多个维度上的动态变化做动画，以营造特定的氛围，例如模拟下雪场景时，飘舞的雪花实际上是由一个个雪花粒子的动画效果所构成。

粒子动画的简单实现如下所示。

@Entry
@Component
struct ParticleExample {
  build() {
    Stack() {
      Text()
        .width(300).height(300).backgroundColor('rgb(240, 250, 255)')
      Particle({ particles: [
        {
          emitter: {
            particle: {
              type: ParticleType.POINT, // 粒子类型
              config: {
                radius: 5 // 圆点半径
              },
              count: 100, // 粒子总数
            },
          },
          color:{
            range:['rgb(39, 135, 217)','rgb(0, 74, 175)'],//初始颜色范围
          },
        },
      ]
      }).width(250).height(250)
    }.width("100%").height("100%").align(Alignment.Center)
  }
}

实现粒子发射器

粒子发射器（Particle Emitter）主要定义粒子的初始属性（如类型、位置和颜色），控制粒子的生成速率，以及管理粒子的生命周期。可通过emitter方法调整粒子发射器的位置、发射速率和发射窗口的大小，实现发射器位置的动态更新。

// ...
@State emitterProperties: Array<EmitterProperty> = [
  {
    index: 0,
    emitRate: 100,
    position: { x: 60, y: 80 },
    size: { width: 200, height: 200 }
  }
]


Particle(...).width(300).height(300).emitter(this.emitterProperties) // 动态调整粒子发射器的位置
// ...

设置粒子颜色

可以通过range来确定粒子的初始颜色范围，而distributionType则用于指定粒子初始颜色随机值的分布方式，具体可选择均匀分布或者高斯（正态）分布。

// ...
color: {
  range: ['rgb(39, 135, 217)','rgb(0, 74, 175)'], // 初始颜色范围
  distributionType: DistributionType.GAUSSIAN // 初始颜色随机值分布
},
// ...

粒子的生命周期

粒子的生命周期（Lifecycle）是粒子从生成至消亡的整个过程，用于确定粒子的存活时间长度。粒子的生命周期可通过设置lifetime和lifetimeRange来指定。

// ...
emitter: {
  particle: {
    // ...
    lifetime: 300, // 粒子生命周期，单位ms
    lifetimeRange: 100 // 粒子生命周期取值范围，单位ms
  },
  emitRate: 10, // 每秒发射粒子数
  position: [0, 0],
  shape: ParticleEmitterShape.RECTANGLE // 发射器形状
},
color: {
  range: ['rgb(39, 135, 217)','rgb(0, 74, 175)'], // 初始颜色范围
},
// ...

设置粒子扰动场

扰动场（Disturbance Field）是一种影响粒子运动的机制。通过在粒子所在的空间区域内施加特定的力，扰动场能够改变粒子的轨迹和行为，进而实现更为复杂和自然的动画效果。扰动场的配置可以通过disturbanceFields方法来完成。

// ...
Particle({ particles: [
  {
    emitter: // ...
    color: // ...
    scale: {
      range: [0.0, 0.0],
      updater: {
        type: ParticleUpdater.CURVE,
        config: [
          {
            from: 0.0,
            to: 0.5,
            startMillis: 0,
            endMillis: 3000,
            curve: Curve.EaseIn
          }
        ]
      }
    },
    acceleration: { //加速度的配置，从大小和方向两个维度变化，speed表示加速度大小，angle表示加速度方向
      speed: {
        range: [3, 9],
        updater: {
          type: ParticleUpdater.RANDOM,
          config: [1, 20]
        }
      },
      angle: {
        range: [90, 90]
      }
    }


  }
]
}).width(300).height(300).disturbanceFields([{
  strength: 10,
  shape: DisturbanceFieldShape.RECT,
  size: { width: 100, height: 100 },
  position: { x: 100, y: 100 },
  feather: 15,
  noiseScale: 10,
  noiseFrequency: 15,
  noiseAmplitude: 5
}])
// ...

---

## 动画曲线

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-animation-smoothing-V5

UI界面除了运行动画之外，还承载着与用户进行实时交互的功能。当用户行为根据意图变化发生改变时，UI界面应做到即时响应。例如用户在应用启动过程中，上滑退出，那么启动动画应该立即过渡到退出动画，而不应该等启动动画完成后再退出，从而减少用户等待时间。对于桌面翻页类从跟手到离手触发动画的场景，离手后动画的初始速度应承继手势速度，避免由于速度不接续导致停顿感的产生。针对以上场景，系统已提供动画与动画、手势与动画之间的衔接能力，保证各类场景下动画平稳光滑地过渡的同时，尽可能降低开发难度。

假设对于某一可动画属性，存在正在运行的动画。当UI侧行为改变该属性终点值时，开发者仅需在animateTo动画闭包中改变属性值或者改变animation接口作用的属性值，即可产生动画。系统会自动衔接之前的动画和当前的动画，开发者仅需要关注当前单次动画的实现。

示例如下。通过点击click，红色方块的缩放属性会发生变化。当连续快速点击click时，缩放属性的终点值连续发生变化，当前动画也会平滑过渡到朝着新的缩放属性终点值运动。

import { curves } from '@kit.ArkUI';


class SetSlt {
  isAnimation: boolean = true


  set(): void {
    this.isAnimation = !this.isAnimation;
  }
}


@Entry
@Component
struct AnimationToAnimationDemo {
  // 第一步：声明相关状态变量
  @State SetAnimation: SetSlt = new SetSlt();


  build() {
    Column() {
      Text('ArkUI')
        .fontWeight(FontWeight.Bold)
        .fontSize(12)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .borderRadius(10)
        .backgroundColor(0xf56c6c)
        .width(100)
        .height(100)
        .scale({
          // 第二步：将状态变量设置到相关可动画属性接口
          x: this.SetAnimation.isAnimation ? 2 : 1,
          y: this.SetAnimation.isAnimation ? 2 : 1
        })
        .animation({ curve: curves.springMotion(0.4, 0.8) }) // 第四步：通过隐式动画接口开启隐式动画，动画终点值改变时，系统自动添加衔接动画


      Button('Click')
        .margin({ top: 200 })
        .onClick(() => {
          // 第三步：通过点击事件改变状态变量值，影响可动画属性值
          this.SetAnimation.set()
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

手势与动画的衔接

使用滑动、捏合、旋转等手势的场景中，跟手过程中一般会触发属性的改变。离手后，这部分属性往往会继续发生变化，直到到达属性终点值。

离手阶段的属性变化初始速度应与离手前一刻的属性改变速度保持一致。如果离手后属性变化速度从0开始，就好像正在运行的汽车紧急刹车，造成观感上的骤变是用户和开发者都不希望看到的。

针对在TapGesture和动画之间进行衔接的场景（如列表滑动），可以在跟手阶段每一次更改组件属性时，都做成使用跟手弹簧曲线的属性动画。离手时再用离手弹簧曲线产生离手阶段的属性动画。对于采用springMotion曲线的动画，离手阶段动画将自动继承跟手阶段动画的速度，并以跟手动画当前位置为起点，运动到指定的属性终点。

示例代码如下，小球跟手运动。

import { curves } from '@kit.ArkUI';


@Entry
@Component
struct SpringMotionDemo {
  // 第一步：声明相关状态变量
  @State positionX: number = 100;
  @State positionY: number = 100;
  diameter: number = 50;


  build() {
    Column() {
      Row() {
        Circle({ width: this.diameter, height: this.diameter })
          .fill(Color.Blue)
          .position({ x: this.positionX, y: this.positionY })// 第二步：将状态变量设置到相关可动画属性接口
          .onTouch((event?: TouchEvent) => {
            // 第三步：在跟手过程改变状态变量值，并且采用responsiveSpringMotion动画运动到新的值
            if (event) {
              if (event.type === TouchType.Move) {
                // 跟手过程，使用responsiveSpringMotion曲线
                this.getUIContext()?.animateTo({ curve: curves.responsiveSpringMotion() }, () => {
                  // 减去半径，以使球的中心运动到手指位置
                  this.positionX = event.touches[0].windowX - this.diameter / 2;
                  this.positionY = event.touches[0].windowY - this.diameter / 2;
                  console.info(`move, animateTo x:${this.positionX}, y:${this.positionY}`);
                })
              } else if (event.type === TouchType.Up) {
                // 第四步：在离手过程设定状态变量终点值，并且用springMotion动画运动到新的值，springMotion动画将继承跟手阶段的动画速度
                this.getUIContext()?.animateTo({ curve: curves.springMotion() }, () => {
                  this.positionX = 100;
                  this.positionY = 100;
                  console.info(`touchUp, animateTo x:100, y:100`);
                })
              }
            }
          })
      }
      .width("100%").height("80%")
      .clip(true) // 如果球超出父组件范围，使球不可见
      .backgroundColor(Color.Orange)


      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
        Text("拖动小球").fontSize(16)
      }
      .width("100%")


      Row() {
        Text('点击位置: [x: ' + Math.round(this.positionX) + ', y:' + Math.round(this.positionY) + ']').fontSize(16)
      }
      .padding(10)
      .width("100%")
    }.height('100%').width('100%')
  }
}

---



## See Also

- [arkui-interaction.md](./arkui-interaction.md) — 键鼠与手势事件
- [arkui-advanced.md](./arkui-advanced.md) — ArkUI 高级特性
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) — 动画代码片段
