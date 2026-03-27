# ArkUI 高级能力（离线参考）

> 来源：华为 HarmonyOS 开发者文档

---

## 使用自定义能力

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-user-defined-capabilities

自定义能力概述

自定义组合

自定义节点

自定义绘制

Modifier机制


---

## UI国际化

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-internationalization

本文介绍如何实现应用程序UI界面的国际化，包含资源配置和镜像布局，关于应用适配国际化的详细参考，请参考Localization Kit（本地化开发服务）。

利用资源限定词配置国际化资源

在开发阶段，通过DevEco Studio，可以为应用在对应语言和地区的资源限定词目录下配置不同的资源，来实现UI国际化。详细介绍请参考资源分类与访问。

使用镜像能力

不同国家对文本对齐方式和读取顺序有所不同，例如英语采用从左到右的顺序，阿拉伯语和希腊语则采用从右到左（RTL）的顺序。为满足不同用户的阅读习惯，ArkUI提供了镜像能力。在特定情况下将显示内容在X轴上进行镜像反转，由从左到右显示变成从右到左显示。

镜像前	镜像后
	

当组件满足以下任意条件时，镜像能力生效：

组件的direction属性设置为Direction.Rtl。

组件的direction属性设置为Direction.Auto，且当前的系统语言（如维吾尔语）的阅读习惯是从右到左。

基本概念
LTR：顺序为从左到右。
RTL：顺序为从右到左。
使用约束

ArkUI 如下能力已默认适配镜像：

类别	名称
基础组件	Swiper、Tabs、TabContent、List、Progress、CalendarPicker、CalendarPickerDialog、TextPicker、TextPickerDialog、DatePicker、DatePickerDialog、Grid、WaterFlow、Scroll、ScrollBar、AlphabetIndexer、Stepper、SideBarContainer、Navigation、NavDestination、Rating、Slider、Toggle、Badge、Counter、Chip、SegmentButton、bindMenu、bindContextMenu、TextInput、TextArea、Search、Stack、GridRow、Text、Select、Marquee、Row、Column、Flex、RelativeContainer、ListItemGroup
高级组件	SelectionMenu 、TreeView 、Filter、SplitLayout、ToolBar、ComposeListItem、EditableTitleBar、ProgressButton、SubHeader 、Popup、Dialog、SwipeRefresher
通用属性	position、markAnchor、offset、alignRules、borderWidth、borderColor、borderRadius、padding、margin
接口	AlertDialog、ActionSheet、promptAction.showDialog、promptAction.showToast

但如下三种场景还需要进行适配：

界面布局、边框设置：关于方向类的通用属性，如果需要支持镜像能力，使用泛化的方向指示词 start/end入参类型替换 left/right、x/y等绝对方向指示词的入参类型，来表示自适应镜像能力。

Canvas组件只有限支持文本绘制的镜像能力。

XComponent组件不支持组件镜像能力。

界面布局和边框设置

目前，以下三类通用属性需要使用新入参类型适配：

位置设置：position、markAnchor、offset、alignRules

边框设置：borderWidth、borderColor、borderRadius

尺寸设置：padding、margin

以position为例，需要把绝对方向x、y描述改为新入参类型start、end的描述，其他属性类似。

import { LengthMetrics } from '@kit.ArkUI';


@Entry
@Component
struct InterfaceLayoutBorderSettings {
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Stack({ alignContent: Alignment.TopStart }) {
        Column()
          .width(100)
          .height(100)
          .backgroundColor(Color.Red)
          .position({
            start: LengthMetrics.px(200),
            top: LengthMetrics.px(200)
          }) //需要同时支持LTR和RTL时使用API12新增的LocalizedEdges入参类型,
        //仅支持LTR时等同于.position({ x: '200px', y: '200px' })


      }.backgroundColor(Color.Blue)
    }.width('100%').height('100%').border({ color: '#880606' })
  }
}
InterfaceLayoutBorderSettings.ets
自定义绘制Canvas组件

Canvas组件的绘制内容和坐标均不支持镜像能力。已绘制到Canvas组件上的内容并不会跟随系统语言的切换自动做镜像效果。

CanvasRenderingContext2D的文本绘制支持镜像能力，在使用时需要与Canvas组件的通用属性direction（组件显示方向）和CanvasRenderingContext2D的属性direction（文本绘制方向）协同使用。具体规格如下：

优先级：CanvasRenderingContext2D的direction属性 > Canvas组件通用属性direction > 系统语言决定的水平显示方向。
Canvas组件本身不会自动跟随系统语言切换镜像效果，需要应用监听到系统语言切换后自行重新绘制。
CanvasRenderingContext2D绘制文本时，只有符号等文本会对绘制方向生效，英文字母和数字不响应绘制方向的变化。
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';


@Entry
@Component
struct CustomizeCanvasComponentDrawing {
  @State message: string = 'Hello world';
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)


  aboutToAppear(): void {
    // 监听系统语言切换
    let subscriber: commonEventManager.CommonEventSubscriber | null = null;
    let subscribeInfo2: commonEventManager.CommonEventSubscribeInfo = {
      events: ['usual.event.LOCALE_CHANGED'],
    }
    commonEventManager.createSubscriber(subscribeInfo2,
      (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        if (err) {
          console.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
          return;
        }


        subscriber = data;
        if (subscriber !== null) {
          commonEventManager.subscribe(subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
            if (err) {
              return;
            }
            // 监听到语言切换后，需要重新绘制Canvas内容
            this.drawText();
          })
        } else {
          console.error(`MayTest Need create subscriber`);
        }
      })
  }


  drawText(): void {
    console.error('MayTest drawText')
    this.context.reset()
    this.context.direction = 'inherit'
    this.context.font = '30px sans-serif'
    this.context.fillText('ab%123&*@', 50, 50)
  }


  build() {
    Row() {
      Canvas(this.context)
        .direction(Direction.Auto)
        .width('100%')
        .height('100%')
        .onReady(() =>{
          this.drawText()
        })
        .backgroundColor(Color.Pink)
    }
    .height('100%')
  }


}
CustomizeCanvasComponentDrawing.ets
镜像前	镜像后
	
镜像状态字符对齐

Direction是指文字的方向，即文本在屏幕上呈现时字符的顺序。在从左到右（LTR）文本中，显示顺序是从左向右；在从右到左（RTL）文本中，显示顺序是从右到左。

TextAlign是将文本作为一个整体，在布局上的影响，具体位置会受Direction影响，以TextAlign为start为例，当Direction为LTR时，布局位置靠左；当Direction为RTL时，布局位置靠右。

在LTR与RTL文本混排时，如一个英文句子中包含阿拉伯语的单词或短语，显示顺序将变得复杂。下图为数字和维吾尔语混合时对应的字符逻辑顺序。

此时，文本渲染引擎会采用名为“双向算法”或“Unicode双向算法”（Unicode Bidirectional Algorithm）的方法来确定字符的显示顺序。下图展示了LTR与RTL文本混合时对应的字符显示顺序，确定字符方向的基本原则如下：

强字符的方向性：强字符具有明确的方向性，例如，中文为LTR，阿拉伯语为RTL，这类字符的方向性会影响其周围的中性字符。

弱字符的方向性：弱字符不具备明确的方向性，这些字符不会影响其周围中性字符的方向。

中性字符的方向性：中性字符无固定方向性，它们会继承其最近的强字符的方向；若附近无强字符，则采用全局方向。

---

## 无障碍与适老化

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-support-accessibility-friendliness

无障碍开发指导

支持适老化


---

## 主题设置

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-theme

应用深浅色适配

设置应用内主题换肤


---

## UI系统场景化能力

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-ui-system-scenarization-capability

使用UI上下文接口操作界面（UIContext）

使用组件截图（ComponentSnapshot）

感知组件可见性

检查页面布局

媒体查询 (@ohos.mediaquery)

嵌入式组件


---

## UI高性能开发

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-performance-overview

优化应用的性能对于提升用户体验至关重要。当发现性能问题后，一般可按照以下步骤进行分析：

复现问题：根据用户的反馈复现性能问题是分析的第一步，开发者可通过回访用户或在应用中增加自己的性能监测埋点来获得性能问题的发生场景和复现步骤。
利用工具找到性能瓶颈点：问题复现后可使用DevEco Studio中提供的CPU Profiler工具获取问题发生过程中的Trace，可以方便的找到Trace中的耗时点。
确定解决方案：找到耗时点后可以根据Trace中的ArkTS CallStack信息或Review流程相关业务代码来找到瓶颈点相关的实现，根据下面的核心优化思路对问题代码进行优化。
验证解决效果：优化代码修改后，应重新复现问题场景体验效果，并使用CPU Profiler工具抓取Trace，确认修改符合预期，问题解决。
UI性能优化的核心思路
工具驱动优化

性能优化的过程中使用数据而非直觉指导优化方向是提升优化效率的关键。当前DevEco Studio中提供了两个性能分析工具，可以进行UI的性能分析，帮助我们高效的进行性能问题定位：

CPU Profiler：用于在运行过程中抓取trace和调用栈对耗时点进行分析，使用方法可以参考CPU Profiler的使用指导分析的思路可以参考常用Trace的含义。

ArkUI Inspector：用于可视化的展示UI组件树，分析UI的布局层次和参数，使用方法可以参考ArkUI Inspector使用说明。

在分析性能问题的过程中，应当先通过CPU Profiler工具发现实际的性能瓶颈点，再针对性的进行优化。

惰性加载优先

推迟非可视区域的资源消耗可有效的加快应用启动和页面的切换速度。ArkUI提供了LazyForEach组件，便于应用实现数据的懒加载。

布局计算简化

应用开发中的UI布局是用户与应用程序交互的关键部分。不合理的布局越多，视图的创建、布局、渲染等流程所需的时间就越长。因此，减少嵌套层次或者使用高性能布局节点，可以减少丢帧卡顿。可以参考这些布局技巧来优化布局性能。

更新代替重建

对于会反复使用的组件，可将其缓存起来，用更新代替重建来提升性能。例如，在滚动容器的滑动过程中，一边的组件划出可视范围被释放，另一边的组件划入可视范围需要创建，反复的释放和创建相同的ListItem显然是冗余的。针对这一需要对特定组件进行缓存、复用的场景，ArkUI提供了组件复用能力，可以对自定义组件进行标记，在被标记的自定义组件释放时将其放入缓存池，在下次需要创建时从缓存池中拿出，用刷新代替创建。使用场景可以参考组件复用的基本原理和使用技巧。

状态精确控制

状态管理是ArkUI声明式的核心机制，它负责将数据与UI联系起来，在UI刷新的过程中会反复执行状态管理的相关逻辑，创建过多的状态变量会影响性能。开发者在使用的过程中应注意状态管理常见问题。

