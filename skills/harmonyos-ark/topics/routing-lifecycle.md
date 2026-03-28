# 页面路由与导航主题


## 目录

- [Scope](#scope)
- [来源](#来源)
- [Official Entrypoints](#official-entrypoints)
- [组件导航和页面路由概述](#组件导航和页面路由概述)
- [组件导航Navigation](#组件导航navigation)
- [导航转场](#导航转场)
- [页面路由@ohos.router](#页面路由@ohosrouter)
- [Router切换Navigation](#router切换navigation)

---

## ⚡ 快速决策：Navigation vs Router

| 维度 | Navigation（✅ 推荐） | @ohos.router（⚠️ 不推荐） |
|------|---------------------|--------------------------|
| **适用场景** | 所有新项目、复杂导航 | 仅旧项目兼容 |
| **跨模块跳转** | ✅ 原生支持 | ⚠️ 需额外配置 |
| **自适应布局** | ✅ 自动适配手机/平板/桌面 | ❌ 不支持 |
| **导航栏自定义** | ✅ 灵活 | ❌ 有限 |
| **转场动画** | ✅ 内置 + 自定义 | ⚠️ 基础支持 |
| **生命周期** | ✅ onShown/onHidden | ✅ onPageShow/onPageHide |
| **共享元素转场** | ✅ 支持 | ❌ 不支持 |
| **官方维护态度** | 持续迭代 | 仅维护，不再新增功能 |

> **结论**：新项目一律用 Navigation。旧项目用 Router 的，按"Router切换Navigation"章节迁移。

---

## Scope
- Navigation 组件导航（推荐）、页面路由 @ohos.router（不推荐）、导航转场动画、Router 迁移 Navigation 指南

## 来源
- ArkUI（方舟UI框架）> 设置组件导航和页面路由

## Official Entrypoints
- [组件导航和页面路由概述](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-introduction-V5)
- [组件导航Navigation](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-navigation-V5)
- [导航转场](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-transition-V5)
- [页面路由@ohos.router](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-routing-V5)
- [Router切换Navigation](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-router-to-navigation-V5)

---

## 组件导航和页面路由概述

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-introduction-V5

组件导航（Navigation）和页面路由（@ohos.router）均支持应用内的页面跳转，但组件导航支持在组件内部进行跳转，使用更灵活。组件导航具备更强的一次开发多端部署能力，可以进行更加灵活的页面栈操作，同时支持更丰富的动效和生命周期。因此，推荐使用组件导航（Navigation）来实现页面跳转以及组件内的跳转，以获得更佳的使用体验。

架构差异

从ArkUI组件树层级上来看，原先由Router管理的page在页面栈管理节点stage的下面。Navigation作为导航容器组件，可以挂载在单个page节点下，也可以叠加、嵌套。Navigation管理了标题栏、内容区和工具栏，内容区用于显示用户自定义页面的内容，并支持页面的路由能力。Navigation的这种设计上有如下优势：

接口上显式区分标题栏、内容区和工具栏，实现更加灵活的管理和UX动效能力；

显式提供路由容器概念，由开发者决定路由容器的位置，支持在全模态、半模态、弹窗中显示；

整合UX设计和一多能力，默认提供统一的标题显示、页面切换和单双栏适配能力；

基于通用UIBuilder能力，由开发者决定页面别名和页面UI对应关系，提供更加灵活的页面配置能力；

基于组件属性动效和共享元素动效能力，将页面切换动效转换为组件属性动效实现，提供更加丰富和灵活的切换动效；

开放了页面栈对象，开发者可以继承，能更好的管理页面显示。

能力对比
业务场景	Navigation	Router
一多能力	支持，Auto模式自适应单栏跟双栏显示	不支持
跳转指定页面	pushPath & pushDestination	pushUrl & pushNameRoute
跳转HSP中页面	支持	支持
跳转HAR中页面	支持	支持
跳转传参	支持	支持
获取指定页面参数	支持	不支持
传参类型	传参为对象形式	传参为对象形式，对象中暂不支持方法变量
跳转结果回调	支持	支持
跳转单例页面	支持	支持
页面返回	支持	支持
页面返回传参	支持	支持
返回指定路由	支持	支持
页面返回弹窗	支持，通过路由拦截实现	showAlertBeforeBackPage
路由替换	replacePath & replacePathByName	replaceUrl & replaceNameRoute
路由栈清理	clear	clear
清理指定路由	removeByIndexes & removeByName	不支持
转场动画	支持	支持
自定义转场动画	支持	支持，动画类型受限
屏蔽转场动画	支持全局和单次	支持 设置pageTransition方法duration为0
geometryTransition共享元素动画	支持（NavDestination之间共享）	不支持
页面生命周期监听	UIObserver.on('navDestinationUpdate')	UIObserver.on('routerPageUpdate')
获取页面栈对象	支持	不支持
路由拦截	支持通过setInterception做路由拦截	不支持
路由栈信息查询	支持	getState() & getLength()
路由栈move操作	moveToTop & moveIndexToTop	不支持
沉浸式页面	支持	不支持，需通过window配置
设置页面标题栏（titlebar）和工具栏（toolbar）	支持	不支持
模态嵌套路由	支持	不支持

---

## 组件导航Navigation

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-navigation-V5

组件导航（Navigation）主要用于实现页面间以及组件内部的页面跳转，支持在不同组件间传递跳转参数，提供灵活的跳转栈操作，从而更便捷地实现对不同页面的访问和复用。本文将从组件导航（Navigation）的显示模式、路由操作、子页面管理、跨包跳转以及跳转动效等几个方面进行详细介绍。

Navigation是路由导航的根视图容器，一般作为页面（@Entry）的根容器，包括单栏（Stack）、分栏（Split）和自适应（Auto）三种显示模式。Navigation组件适用于模块内和跨模块的路由切换，通过组件级路由能力实现更加自然流畅的转场体验，并提供多种标题栏样式来呈现更好的标题和内容联动效果。一次开发，多端部署场景下，Navigation组件能够自动适配窗口显示大小，在窗口较大的场景下自动切换分栏展示效果。

Navigation组件主要包含​导航页和子页。导航页由标题栏（包含菜单栏）、内容区和工具栏组成，可以通过hideNavBar属性进行隐藏，导航页不存在页面栈中，与子页，以及子页之间可以通过路由操作进行切换。

在API Version 9上，Navigation需要配合NavRouter组件实现页面路由。从API Version 10开始，更推荐使用NavPathStack实现页面路由。

设置页面显示模式

Navigation组件通过mode属性设置页面的显示模式。

自适应模式

Navigation组件默认为自适应模式，此时mode属性为NavigationMode.Auto。自适应模式下，当页面宽度大于等于一定阈值( API version 9及以前：520vp，API version 10及以后：600vp )时，Navigation组件采用分栏模式，反之采用单栏模式。

Navigation() {
  // ...
}
.mode(NavigationMode.Auto)

单页面模式

图1 单页面布局示意图

将mode属性设置为NavigationMode.Stack，Navigation组件即可设置为单页面显示模式。

Navigation() {
  // ...
}
.mode(NavigationMode.Stack)

分栏模式

图2 分栏布局示意图

将mode属性设置为NavigationMode.Split，Navigation组件即可设置为分栏显示模式。

@Entry
@Component
struct NavigationExample {
  @State TooTmp: ToolbarItem = {
    'value': "func", 'icon': "./image/ic_public_highlights.svg", 'action': () => {
    }
  }
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  private arr: number[] = [1, 2, 3];


  @Builder
  PageMap(name: string) {
    if (name === "NavDestinationTitle1") {
      pageOneTmp()
    } else if (name === "NavDestinationTitle2") {
      pageTwoTmp()
    } else if (name === "NavDestinationTitle3") {
      pageThreeTmp()
    }
  }


  build() {
    Column() {
      Navigation(this.pageInfos) {
        TextInput({ placeholder: 'search...' })
          .width("90%")
          .height(40)
          .backgroundColor('#FFFFFF')


        List({ space: 12 }) {
          ForEach(this.arr, (item: number) => {
            ListItem() {
              Text("Page" + item)
                .width("100%")
                .height(72)
                .backgroundColor('#FFFFFF')
                .borderRadius(24)
                .fontSize(16)
                .fontWeight(500)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.pageInfos.pushPath({ name: "NavDestinationTitle" + item })
                })
            }
          }, (item: number) => item.toString())
        }
        .width("90%")
        .margin({ top: 12 })
      }
      .title("主标题")
      .mode(NavigationMode.Split)
      .navDestination(this.PageMap)
      .menus([
        {
          value: "", icon: "./image/ic_public_search.svg", action: () => {
          }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
          }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
          }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
          }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
          }
        }
      ])
      .toolbarConfiguration([this.TooTmp, this.TooTmp, this.TooTmp])
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}


// PageOne.ets
@Component
export struct pageOneTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;


  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent1")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle1")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}


// PageTwo.ets
@Component
export struct pageTwoTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;


  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent2")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle2")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}


// PageThree.ets
@Component
export struct pageThreeTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;


  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent3")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle3")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

设置标题栏模式

标题栏在界面顶部，用于呈现界面名称和操作入口，Navigation组件通过titleMode属性设置标题栏模式。

说明

Navigation或NavDestination未设置主副标题并且没有返回键时，不显示标题栏。

Mini模式

普通型标题栏，用于一级页面不需要突出标题的场景。

图3 Mini模式标题栏

Navigation() {
  // ...
}
.titleMode(NavigationTitleMode.Mini)

Full模式

强调型标题栏，用于一级页面需要突出标题的场景。

图4 Full模式标题栏

Navigation() {
  // ...
}
.titleMode(NavigationTitleMode.Full)
设置菜单栏

菜单栏位于Navigation组件的右上角，开发者可以通过menus属性进行设置。menus支持Array<NavigationMenuItem>和CustomBuilder两种参数类型。使用Array<NavigationMenuItem>类型时，竖屏最多支持显示3个图标，横屏最多支持显示5个图标，多余的图标会被放入自动生成的更多图标。

图5 设置了3个图标的菜单栏

let TooTmp: NavigationMenuItem = {'value': "", 'icon': "./image/ic_public_highlights.svg", 'action': ()=> {}}
Navigation() {
  // ...
}
.menus([TooTmp,
  TooTmp,
  TooTmp])

图片也可以引用resources中的资源。

let TooTmp: NavigationMenuItem = {'value': "", 'icon': "resources/base/media/ic_public_highlights.svg", 'action': ()=> {}}
Navigation() {
  // ...
}
.menus([TooTmp,
  TooTmp,
  TooTmp])

图6 设置了4个图标的菜单栏

let TooTmp: NavigationMenuItem = {'value': "", 'icon': "./image/ic_public_highlights.svg", 'action': ()=> {}}
Navigation() {
  // ...
}
// 竖屏最多支持显示3个图标，多余的图标会被放入自动生成的更多图标。
.menus([TooTmp,
  TooTmp,
  TooTmp,
  TooTmp])
设置工具栏

工具栏位于Navigation组件的底部，开发者可以通过toolbarConfiguration属性进行设置。

图7 工具栏

let TooTmp: ToolbarItem = {'value': "func", 'icon': "./image/ic_public_highlights.svg", 'action': ()=> {}}
let TooBar: ToolbarItem[] = [TooTmp,TooTmp,TooTmp]
Navigation() {
  // ...
}
.toolbarConfiguration(TooBar)
路由操作

Navigation路由相关的操作都是基于页面栈NavPathStack提供的方法进行，每个Navigation都需要创建并传入一个NavPathStack对象，用于管理页面。主要涉及页面跳转、页面返回、页面替换、页面删除、参数获取、路由拦截等功能。

从API version 12开始，页面栈允许被继承。开发者可以在派生类中自定义属性和方法，也可以重写父类的方法。派生类对象可以替代基类NavPathStack对象使用。具体示例代码参见：页面栈继承示例代码。

说明

不建议开发者通过监听生命周期的方式管理自己的页面栈。

@Entry
@Component
struct Index {
  // 创建一个页面栈对象并传入Navigation
  pageStack: NavPathStack = new NavPathStack()


  build() {
    Navigation(this.pageStack) {
    }
    .title('Main')
  }
}
页面跳转

NavPathStack通过Push相关的接口去实现页面跳转的功能，主要分为以下三类:

普通跳转，通过页面的name去跳转，并可以携带param。

this.pageStack.pushPath({ name: "PageOne", param: "PageOne Param" })
this.pageStack.pushPathByName("PageOne", "PageOne Param")

带返回回调的跳转，跳转时添加onPop回调，能在页面出栈时获取返回信息，并进行处理。

this.pageStack.pushPathByName('PageOne', "PageOne Param", (popInfo) => {
  console.log('Pop page name is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result))
});

带错误码的跳转，跳转结束会触发异步回调，返回错误码信息。

this.pageStack.pushDestination({name: "PageOne", param: "PageOne Param"})
  .catch((error: BusinessError) => {
    console.error(`Push destination failed, error code = ${error.code}, error.message = ${error.message}.`);
  }).then(() => {
    console.info('Push destination succeed.');
  });
this.pageStack.pushDestinationByName("PageOne", "PageOne Param")
  .catch((error: BusinessError) => {
    console.error(`Push destination failed, error code = ${error.code}, error.message = ${error.message}.`);
  }).then(() => {
    console.info('Push destination succeed.');
  });
页面返回

NavPathStack通过Pop相关接口去实现页面返回功能。

// 返回到上一页
this.pageStack.pop()
// 返回到上一个PageOne页面
this.pageStack.popToName("PageOne")
// 返回到索引为1的页面
this.pageStack.popToIndex(1)
// 返回到根首页（清除栈中所有页面）
this.pageStack.clear()
页面替换

NavPathStack通过Replace相关接口去实现页面替换功能。

// 将栈顶页面替换为PageOne
this.pageStack.replacePath({ name: "PageOne", param: "PageOne Param" })
this.pageStack.replacePathByName("PageOne", "PageOne Param")
// 带错误码的替换，跳转结束会触发异步回调，返回错误码信息
this.pageStack.replaceDestination({name: "PageOne", param: "PageOne Param"})
  .catch((error: BusinessError) => {
    console.error(`Replace destination failed, error code = ${error.code}, error.message = ${error.message}.`);
  }).then(() => {
    console.info('Replace destination succeed.');
  })
页面删除

NavPathStack通过Remove相关接口去实现删除页面栈中特定页面的功能。

// 删除栈中name为PageOne的所有页面
this.pageStack.removeByName("PageOne")
// 删除指定索引的页面
this.pageStack.removeByIndexes([1,3,5])
// 删除指定id的页面
this.pageStack.removeByNavDestinationId("1");
移动页面

NavPathStack通过Move相关接口去实现移动页面栈中特定页面到栈顶的功能。

// 移动栈中name为PageOne的页面到栈顶
this.pageStack.moveToTop("PageOne");
// 移动栈中索引为1的页面到栈顶
this.pageStack.moveIndexToTop(1);
参数获取

NavPathStack通过Get相关接口去获取页面的一些参数。

// 获取栈中所有页面name集合
this.pageStack.getAllPathName()
// 获取索引为1的页面参数
this.pageStack.getParamByIndex(1)
// 获取PageOne页面的参数
this.pageStack.getParamByName("PageOne")
// 获取PageOne页面的索引集合
this.pageStack.getIndexByName("PageOne")
路由拦截

NavPathStack提供了setInterception方法，用于设置Navigation页面跳转拦截回调。该方法需要传入一个NavigationInterception对象，该对象包含三个回调函数：

名称	描述
willShow	页面跳转前回调，允许操作栈，在当前跳转生效。
didShow	页面跳转后回调，在该回调中操作栈会在下一次跳转生效。
modeChange	Navigation单双栏显示状态发生变更时触发该回调。
说明

无论是哪个回调，在进入回调时页面栈都已经发生了变化。

开发者可以在willShow回调中通过修改路由栈来实现路由拦截重定向的能力。

this.pageStack.setInterception({
  willShow: (from: NavDestinationContext | "navBar", to: NavDestinationContext | "navBar",
    operation: NavigationOperation, animated: boolean) => {
    if (typeof to === "string") {
      console.log("target page is navigation home page.");
      return;
    }
    // 将跳转到PageTwo的路由重定向到PageOne
    let target: NavDestinationContext = to as NavDestinationContext;
    if (target.pathInfo.name === 'PageTwo') {
      target.pathStack.pop();
      target.pathStack.pushPathByName('PageOne', null);
    }
  }
})
子页面

NavDestination是Navigation子页面的根容器，用于承载子页面的一些特殊属性以及生命周期等。NavDestination可以设置独立的标题栏和菜单栏等属性，使用方法与Navigation相同。NavDestination也可以通过mode属性设置不同的显示类型，用于满足不同页面的诉求。

页面显示类型

标准类型

NavDestination组件默认为标准类型，此时mode属性为NavDestinationMode.STANDARD。标准类型的NavDestination的生命周期跟随其在NavPathStack页面栈中的位置变化而改变。

弹窗类型

NavDestination设置mode为NavDestinationMode.DIALOG弹窗类型，此时整个NavDestination默认透明显示。弹窗类型的NavDestination显示和消失时不会影响下层标准类型的NavDestination的显示和生命周期，两者可以同时显示。

// Dialog NavDestination
@Entry
@Component
 struct Index {
   @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()


   @Builder
   PagesMap(name: string) {
     if (name == 'DialogPage') {
       DialogPage()
     }
   }


   build() {
     Navigation(this.pageStack) {
       Button('Push DialogPage')
         .margin(20)
         .width('80%')
         .onClick(() => {
           this.pageStack.pushPathByName('DialogPage', '');
         })
     }
     .mode(NavigationMode.Stack)
     .title('Main')
     .navDestination(this.PagesMap)
   }
 }


 @Component
 export struct DialogPage {
   @Consume('NavPathStack') pageStack: NavPathStack;


   build() {
     NavDestination() {
       Stack({ alignContent: Alignment.Center }) {
         Column() {
           Text("Dialog NavDestination")
             .fontSize(20)
             .margin({ bottom: 100 })
           Button("Close").onClick(() => {
             this.pageStack.pop()
           }).width('30%')
         }
         .justifyContent(FlexAlign.Center)
         .backgroundColor(Color.White)
         .borderRadius(10)
         .height('30%')
         .width('80%')
       }.height("100%").width('100%')
     }
     .backgroundColor('rgba(0,0,0,0.5)')
     .hideTitleBar(true)
     .mode(NavDestinationMode.DIALOG)
   }
 }

页面生命周期

Navigation作为路由容器，其生命周期承载在NavDestination组件上，以组件事件的形式开放。

其生命周期大致可分为三类，自定义组件生命周期、通用组件生命周期和自有生命周期。其中，aboutToAppear和aboutToDisappear是自定义组件的生命周期(NavDestination外层包含的自定义组件)，OnAppear和OnDisappear是组件的通用生命周期。剩下的六个生命周期为NavDestination独有。

生命周期时序如下图所示：

aboutToAppear：在创建自定义组件后，执行其build()函数之前执行（NavDestination创建之前），允许在该方法中改变状态变量，更改将在后续执行build()函数中生效。
onWillAppear：NavDestination创建后，挂载到组件树之前执行，在该方法中更改状态变量会在当前帧显示生效。
onAppear：通用生命周期事件，NavDestination组件挂载到组件树时执行。
onWillShow：NavDestination组件布局显示之前执行，此时页面不可见（应用切换到前台不会触发）。
onShown：NavDestination组件布局显示之后执行，此时页面已完成布局。
onWillHide：NavDestination组件触发隐藏之前执行（应用切换到后台不会触发）。
onHidden：NavDestination组件触发隐藏后执行（非栈顶页面push进栈，栈顶页面pop出栈或应用切换到后台）。
onWillDisappear：NavDestination组件即将销毁之前执行，如果有转场动画，会在动画前触发（栈顶页面pop出栈）。
onDisappear：通用生命周期事件，NavDestination组件从组件树上卸载销毁时执行。
aboutToDisappear：自定义组件析构销毁之前执行，不允许在该方法中改变状态变量。
页面监听和查询

为了方便组件跟页面解耦，在NavDestination子页面内部的自定义组件可以通过全局方法监听或查询到页面的一些状态信息。

页面信息查询

自定义组件提供queryNavDestinationInfo方法，可以在NavDestination内部查询到当前所属页面的信息，返回值为NavDestinationInfo，若查询不到则返回undefined。

 import { uiObserver } from '@kit.ArkUI';


 // NavDestination内的自定义组件
 @Component
 struct MyComponent {
   navDesInfo: uiObserver.NavDestinationInfo | undefined


   aboutToAppear(): void {
     this.navDesInfo = this.queryNavDestinationInfo();
   }


   build() {
       Column() {
         Text("所属页面Name: " + this.navDesInfo?.name)
       }.width('100%').height('100%')
   }
 }

页面状态监听

通过observer.on('navDestinationUpdate')提供的注册接口可以注册NavDestination生命周期变化的监听，使用方式如下：

uiObserver.on('navDestinationUpdate', (info) => {
     console.info('NavDestination state update', JSON.stringify(info));
 });

也可以注册页面切换的状态回调，能在页面发生路由切换的时候拿到对应的页面信息NavDestinationSwitchInfo，并且提供了UIAbilityContext和UIContext不同范围的监听：

 // 在UIAbility中使用
 import { UIContext, uiObserver } from '@kit.ArkUI';


 // callBackFunc 是开发者定义的监听回调函数
 function callBackFunc(info: uiObserver.NavDestinationSwitchInfo) {}
 uiObserver.on('navDestinationSwitch', this.context, callBackFunc);


 // 可以通过窗口的getUIContext()方法获取对应的UIContent
 uiContext: UIContext | null = null;
 uiObserver.on('navDestinationSwitch', this.uiContext, callBackFunc);
页面转场

Navigation默认提供了页面切换的转场动画，通过页面栈操作时，会触发不同的转场效果（Dialog类型的页面默认无转场动画），Navigation也提供了关闭系统转场、自定义转场以及共享元素转场的能力。

关闭转场

全局关闭

Navigation通过NavPathStack中提供的disableAnimation方法可以在当前Navigation中关闭或打开所有转场动画。

pageStack: NavPathStack = new NavPathStack()


aboutToAppear(): void {
  this.pageStack.disableAnimation(true)
}

单次关闭

NavPathStack中提供的Push、Pop、Replace等接口中可以设置animated参数，默认为true表示有转场动画，需要单次关闭转场动画可以置为false，不影响下次转场动画。

pageStack: NavPathStack = new NavPathStack()


this.pageStack.pushPath({ name: "PageOne" }, false)
this.pageStack.pop(false)
自定义转场

Navigation通过customNavContentTransition事件提供自定义转场动画的能力，通过如下三步可以定义一个自定义的转场动画。

构建一个自定义转场动画工具类CustomNavigationUtils，通过一个Map管理各个页面自定义动画对象CustomTransition，页面在创建的时候将自己的自定义转场动画对象注册进去，销毁的时候解注册；
实现一个转场协议对象NavigationAnimatedTransition，其中timeout属性表示转场结束的超时时间，默认为1000ms，transition属性为自定义的转场动画方法，开发者要在这里实现自己的转场动画逻辑，系统会在转场开始时调用该方法，onTransitionEnd为转场结束时的回调。
调用customNavContentTransition方法，返回实现的转场协议对象，如果返回undefined，则使用系统默认转场。

具体示例代码可以参考Navigation自定义转场示例。

共享元素转场

NavDestination之间切换时可以通过geometryTransition实现共享元素转场。配置了共享元素转场的页面同时需要关闭系统默认的转场动画。

为需要实现共享元素转场的组件添加geometryTransition属性，id参数必须在两个NavDestination之间保持一致。

// 起始页配置共享元素id
NavDestination() {
  Column() {
    // ...
    Image($r('app.media.startIcon'))
    .geometryTransition('sharedId')
    .width(100)
    .height(100)
  }
}
.title('FromPage')


// 目的页配置共享元素id
NavDestination() {
  Column() {
    // ...
    Image($r('app.media.startIcon'))
    .geometryTransition('sharedId')
    .width(200)
    .height(200)
  }
}
.title('ToPage')

将页面路由的操作，放到animateTo动画闭包中，配置对应的动画参数以及关闭系统默认的转场。

NavDestination() {
  Column() {
    Button('跳转目的页')
    .width('80%')
    .height(40)
    .margin(20)
    .onClick(() => {
        this.getUIContext()?.animateTo({ duration: 1000 }, () => {
          this.pageStack.pushPath({ name: 'ToPage' }, false)
        })
    })
  }
}
.title('FromPage')
跨包动态路由

通过静态import页面再进行路由跳转的方式会造成不同模块之间的依赖耦合，以及首页加载时间长等问题。

动态路由设计的初衷旨在解决多个模块（HAR/HSP）能够复用相同的业务逻辑，实现各业务模块间的解耦，同时支持路由功能的扩展与整合。

动态路由的优势：

路由定义除了跳转的URL以外，可以丰富的配置扩展信息，如横竖屏默认模式，是否需要鉴权等等，做路由跳转时统一处理。
给每个路由页面设置一个名字，按照名称进行跳转而不是文件路径。
页面的加载可以使用动态import（按需加载），防止首个页面加载大量代码导致卡顿。

动态路由提供系统路由表和自定义路由表两种实现方式。

系统路由表相对自定义路由表，使用更简单，只需要添加对应页面跳转配置项，即可实现页面跳转。

自定义路由表使用起来更复杂，但是可以根据应用业务进行定制处理。

支持自定义路由表和系统路由表混用。

系统路由表

从API version 12开始，Navigation支持使用系统路由表的方式进行动态路由。各业务模块（HSP/HAR）中需要独立配置route_map.json文件，在触发路由跳转时，应用只需要通过NavPathStack提供的路由方法，传入需要路由的页面配置名称，此时系统会自动完成路由模块的动态加载、页面组件构建，并完成路由跳转，从而实现了开发层面的模块解耦。系统路由表不支持预览器，跨平台及模拟器。其主要步骤如下：

在跳转目标模块的配置文件module.json5添加路由表配置：

  {
    "module" : {
      "routerMap": "$profile:route_map"
    }
  }

添加完路由配置文件地址后，需要在工程resources/base/profile中创建route_map.json文件。添加如下配置信息：

  {
    "routerMap": [
      {
        "name": "PageOne",
        "pageSourceFile": "src/main/ets/pages/PageOne.ets",
        "buildFunction": "PageOneBuilder",
        "data": {
          "description" : "this is PageOne"
        }
      }
    ]
  }

配置说明如下：

配置项	说明
name	跳转页面名称。
pageSourceFile	跳转目标页在包内的路径，相对src目录的相对路径。
buildFunction	跳转目标页的入口函数名称，必须以@Builder修饰。
data	应用自定义字段。可以通过配置项读取接口getConfigInRouteMap获取。

在跳转目标页面中，需要配置入口Builder函数，函数名称需要和route_map.json配置文件中的buildFunction保持一致，否则在编译时会报错。

  // 跳转页面入口函数
  @Builder
  export function PageOneBuilder() {
    PageOne()
  }


  @Component
  struct PageOne {
    pathStack: NavPathStack = new NavPathStack()


    build() {
      NavDestination() {
      }
      .title('PageOne')
      .onReady((context: NavDestinationContext) => {
         this.pathStack = context.pathStack
      })
    }
  }

通过pushPathByName等路由接口进行页面跳转。(注意：此时Navigation中可以不用配置navDestination属性)。

  @Entry
  @Component
  struct Index {
    pageStack : NavPathStack = new NavPathStack();


    build() {
      Navigation(this.pageStack){
      }.onAppear(() => {
        this.pageStack.pushPathByName("PageOne", null, false);
      })
      .hideNavBar(true)
    }
  }
自定义路由表

开发者可以通过自定义路由表的方式来实现跨包动态路由，具体实现方法请参考Navigation自定义动态路由 示例。

实现方案：

定义页面跳转配置项。
使用资源文件进行定义，通过资源管理@ohos.resourceManager在运行时对资源文件解析。
在ets文件中配置路由加载配置项，一般包括路由页面名称（即pushPath等接口中页面的别名），文件所在模块名称（hsp/har的模块名），加载页面在模块内的路径（相对src目录的路径）。
加载目标跳转页面，通过动态import将跳转目标页面所在的模块在运行时加载, 在模块加载完成后，调用模块中的方法，通过import在模块的方法中加载模块中显示的目标页面，并返回页面加载完成后定义的Builder函数。
触发页面跳转，在Navigation的navDestination属性执行步骤2中加载的Builder函数，即可跳转到目标页面。
示例代码
Navigation系统路由

---

## 导航转场

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-transition-V5

导航转场是页面的路由转场方式，也就是一个界面消失，另外一个界面出现的动画效果。开发者也可以自定义导航转场的动画效果，具体请参考Navigation示例3。

导航转场推荐使用Navigation组件实现，可搭配NavDestination组件实现导航功能。

完整的代码示例和效果如下。

创建导航页

实现步骤为：

1.使用Navigation创建导航主页，并创建路由栈NavPathStack以此来实现不同页面之间的跳转。

2.在Navigation中增加List组件，来定义导航主页中不同的一级界面。

3.在List内的组件添加onClick方法，并在其中使用路由栈NavPathStack的pushPathByName方法，使组件可以在点击之后从当前页面跳转到输入参数name在路由表内对应的页面。

//PageOne.ets
@Entry
@Component
struct NavigationDemo {
  @Provide('pathInfos') pathInfos: NavPathStack = new NavPathStack();
  private listArray: Array<string> = ['WLAN', 'Bluetooth', 'Personal Hotpot', 'Connect & Share'];


  build() {
    Column() {
      Navigation(this.pathInfos) {
        TextInput({ placeholder: '输入关键字搜索' })
          .width('90%')
          .height(40)
          .margin({ bottom: 10 })


        // 通过List定义导航的一级界面
        List({ space: 12, initialIndex: 0 }) {
          ForEach(this.listArray, (item: string) => {
            ListItem() {
              Row() {
                Row() {
                  Text(`${item.slice(0, 1)}`)
                    .fontColor(Color.White)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                }
                .width(30)
                .height(30)
                .backgroundColor('#a8a8a8')
                .margin({ right: 20 })
                .borderRadius(20)
                .justifyContent(FlexAlign.Center)


                Column() {
                  Text(item)
                    .fontSize(16)
                    .margin({ bottom: 5 })
                }
                .alignItems(HorizontalAlign.Start)


                Blank()


                Row()
                  .width(12)
                  .height(12)
                  .margin({ right: 15 })
                  .border({
                    width: { top: 2, right: 2 },
                    color: 0xcccccc
                  })
                  .rotate({ angle: 45 })
              }
              .borderRadius(15)
              .shadow({ radius: 100, color: '#ededed' })
              .width('90%')
              .alignItems(VerticalAlign.Center)
              .padding({ left: 15, top: 15, bottom: 15 })
              .backgroundColor(Color.White)
            }
            .width('100%')
            .onClick(() => {
              this.pathInfos.pushPathByName(`${item}`, '详情页面参数')//将name指定的NaviDestination页面信息入栈,传递的参数为param
            })
          }, (item: string): string => item)
        }
        .listDirection(Axis.Vertical)
        .edgeEffect(EdgeEffect.Spring)
        .sticky(StickyStyle.Header)
        .chainAnimation(false)
        .width('100%')
      }
      .width('100%')
      .mode(NavigationMode.Auto)
      .title('设置') // 设置标题文字
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor(0xf4f4f5)
  }
}
创建导航子页

导航子页1实现步骤为：

1.使用NavDestination，来创建导航子页CommonPage。

2.创建路由栈NavPathStack并在onReady时进行初始化，获取当前所在的页面栈，以此来实现不同页面之间的跳转。

3.在子页面内的组件添加onClick，并在其中使用路由栈NavPathStack的pop方法，使组件可以在点击之后弹出路由栈栈顶元素实现页面的返回。

//PageOne.ets


@Builder
export function MyCommonPageBuilder(name: string, param: string) {
  MyCommonPage({ name: name, value: param })
}


@Component
export struct MyCommonPage {
  pathInfos: NavPathStack = new NavPathStack();
  name: String = '';
  @State value: String = '';


  build() {
    NavDestination() {
      Column() {
        Text(`${this.name}设置页面`)
          .width('100%')
          .fontSize(20)
          .fontColor(0x333333)
          .textAlign(TextAlign.Center)
          .textShadow({
            radius: 2,
            offsetX: 4,
            offsetY: 4,
            color: 0x909399
          })
          .padding({ top: 30 })
        Text(`${JSON.stringify(this.value)}`)
          .width('100%')
          .fontSize(18)
          .fontColor(0x666666)
          .textAlign(TextAlign.Center)
          .padding({ top: 45 })
        Button('返回')
          .width('50%')
          .height(40)
          .margin({ top: 50 })
          .onClick(() => {
            //弹出路由栈栈顶元素，返回上个页面
            this.pathInfos.pop();
          })
      }
      .size({ width: '100%', height: '100%' })
    }.title(`${this.name}`)
    .onReady((ctx: NavDestinationContext) => {
      //NavDestinationContext获取当前所在的页面栈
      this.pathInfos = ctx.pathStack;
    }) 


  }
}



导航子页2实现步骤为：

1.使用NavDestination，来创建导航子页SharePage。

2.创建路由栈NavPathStack并在onReady时进行初始化，获取当前所在的页面栈，以此来实现不同页面之间的跳转。

3.在子页面内的组件添加onClick，并在其中使用路由栈NavPathStack的pushPathByName方法，使组件可以在点击之后从当前页面跳转到输入参数name在路由表内对应的页面。

//PageTwo.ets
@Builder
export function MySharePageBuilder(name: string, param: string) {
  MySharePage({ name: name })
}


@Component
export struct MySharePage {
  pathInfos: NavPathStack = new NavPathStack();
  name: String = '';
  private listArray: Array<string> = ['Projection', 'Print', 'VPN', 'Private DNS', 'NFC'];


  build() {
    NavDestination() {
      Column() {
        List({ space: 12, initialIndex: 0 }) {
          ForEach(this.listArray, (item: string) => {
            ListItem() {
              Row() {
                Row() {
                  Text(`${item.slice(0, 1)}`)
                    .fontColor(Color.White)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                }
                .width(30)
                .height(30)
                .backgroundColor('#a8a8a8')
                .margin({ right: 20 })
                .borderRadius(20)
                .justifyContent(FlexAlign.Center)


                Column() {
                  Text(item)
                    .fontSize(16)
                    .margin({ bottom: 5 })
                }
                .alignItems(HorizontalAlign.Start)


                Blank()


                Row()
                  .width(12)
                  .height(12)
                  .margin({ right: 15 })
                  .border({
                    width: { top: 2, right: 2 },
                    color: 0xcccccc
                  })
                  .rotate({ angle: 45 })
              }
              .borderRadius(15)
              .shadow({ radius: 100, color: '#ededed' })
              .width('90%')
              .alignItems(VerticalAlign.Center)
              .padding({ left: 15, top: 15, bottom: 15 })
              .backgroundColor(Color.White)
            }
            .width('100%')
            .onClick(() => {
              this.pathInfos.pushPathByName(`${item}`, '页面设置参数')
            })
          }, (item: string): string => item)
        }
        .listDirection(Axis.Vertical)
        .edgeEffect(EdgeEffect.Spring)
        .sticky(StickyStyle.Header)
        .width('100%')
      }
      .size({ width: '100%', height: '100%' })
    }.title(`${this.name}`)
    .onReady((ctx: NavDestinationContext) => {
      //NavDestinationContext获取当前所在的页面栈
      this.pathInfos = ctx.pathStack;
    }) 
  }
}
创建路由跳转

实现步骤为：

1.工程配置文件module.json5中配置 {"routerMap": "$profile:route_map"}。

2.route_map.json中配置全局路由表，路由栈NavPathStack可根据路由表中的name将对应页面信息入栈。

{
  "routerMap" : [
    {
      "name" : "WLAN",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    },
    {
      "name" : "Bluetooth",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    },
    {
      "name" : "Personal Hotpot",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    },
    {
      "name" : "Connect & Share",
      "pageSourceFile"  : "src/main/ets/pages/PageTwo.ets",
      "buildFunction" : "MySharePageBuilder"
    },
    {
      "name" : "Projection",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    },
    {
      "name" : "Print",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    },
    {
      "name" : "VPN",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    },
    {
      "name" : "Private DNS",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    },
    {
      "name" : "NFC",
      "pageSourceFile"  : "src/main/ets/pages/PageOne.ets",
      "buildFunction" : "MyCommonPageBuilder"
    }
  ]
}

---

## 页面路由@ohos.router

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-routing-V5

页面路由指在应用程序中实现不同页面之间的跳转和数据传递。Router模块通过不同的url地址，可以方便地进行页面路由，轻松地访问不同的页面。本文将从页面跳转、页面返回、页面返回前增加一个询问框和命名路由这几个方面，介绍如何通过Router模块实现页面路由。

说明

组件导航 (Navigation)具有更强的功能和自定义能力，推荐使用该组件作为应用的路由框架。Navigation和Router的差异可参考Router切换Navigation指导。

页面跳转

页面跳转是开发过程中的一个重要组成部分。在使用应用程序时，通常需要在不同的页面之间跳转，有时还需要将数据从一个页面传递到另一个页面。

图1 页面跳转

Router模块提供了两种跳转模式，分别是router.pushUrl和router.replaceUrl。这两种模式决定了目标页面是否会替换当前页。

router.pushUrl：目标页面不会替换当前页，而是压入页面栈。这样可以保留当前页的状态，并且可以通过返回键或者调用router.back方法返回到当前页。

router.replaceUrl：目标页面会替换当前页，并销毁当前页。这样可以释放当前页的资源，并且无法返回到当前页。

说明

创建新页面时，请参考构建第二个页面配置第二个页面的路由。

页面栈的最大容量为32个页面。如果超过这个限制，可以调用router.clear方法清空历史页面栈，释放内存空间。

同时，Router模块提供了两种实例模式，分别是Standard和Single。这两种模式决定了目标url是否会对应多个实例。

Standard：多实例模式，也是默认情况下的跳转模式。目标页面会被添加到页面栈顶，无论栈中是否存在相同url的页面。

Single：单实例模式。如果目标页面的url已经存在于页面栈中，则会将离栈顶最近的同url页面移动到栈顶，该页面成为新建页。如果目标页面的url在页面栈中不存在同url页面，则按照默认的多实例模式进行跳转。

在使用Router相关功能之前，需要在代码中先导入Router模块。

import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

场景一：有一个主页（Home）和一个详情页（Detail），希望从主页点击一个商品，跳转到详情页。同时，需要保留主页在页面栈中，以便返回时恢复状态。这种场景下，可以使用pushUrl方法，并且使用Standard实例模式（或者省略）。

import { router } from '@kit.ArkUI';


// 在Home页面中
function onJumpClick(): void {
  router.pushUrl({
    url: 'pages/Detail' // 目标url
  }, router.RouterMode.Standard, (err) => {
    if (err) {
      console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    console.info('Invoke pushUrl succeeded.');
  });
}
说明

多实例模式下，router.RouterMode.Standard参数可以省略。

场景二：有一个登录页（Login）和一个个人中心页（Profile），希望从登录页成功登录后，跳转到个人中心页。同时，销毁登录页，在返回时直接退出应用。这种场景下，可以使用replaceUrl方法，并且使用Standard实例模式（或者省略）。

import { router } from '@kit.ArkUI';


// 在Login页面中
function onJumpClick(): void {
  router.replaceUrl({
    url: 'pages/Profile' // 目标url
  }, router.RouterMode.Standard, (err) => {
    if (err) {
      console.error(`Invoke replaceUrl failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    console.info('Invoke replaceUrl succeeded.');
  })
}
说明

多实例模式下，router.RouterMode.Standard参数可以省略。

场景三：有一个设置页（Setting）和一个主题切换页（Theme），希望从设置页点击主题选项，跳转到主题切换页。同时，需要保证每次只有一个主题切换页存在于页面栈中，在返回时直接回到设置页。这种场景下，可以使用pushUrl方法，并且使用Single实例模式。

import { router } from '@kit.ArkUI';


// 在Setting页面中
function onJumpClick(): void {
  router.pushUrl({
    url: 'pages/Theme' // 目标url
  }, router.RouterMode.Single, (err) => {
    if (err) {
      console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    console.info('Invoke pushUrl succeeded.');
  });
}

场景四：有一个搜索结果列表页（SearchResult）和一个搜索结果详情页（SearchDetail），希望从搜索结果列表页点击某一项结果，跳转到搜索结果详情页。同时，如果该结果已经被查看过，则不需要再新建一个详情页，而是直接跳转到已经存在的详情页。这种场景下，可以使用replaceUrl方法，并且使用Single实例模式。

import { router } from '@kit.ArkUI';


// 在SearchResult页面中
function onJumpClick(): void {
  router.replaceUrl({
    url: 'pages/SearchDetail' // 目标url
  }, router.RouterMode.Single, (err) => {
    if (err) {
      console.error(`Invoke replaceUrl failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    console.info('Invoke replaceUrl succeeded.');
  })
}

以上是不带参数传递的场景。

如果需要在跳转时传递一些数据给目标页面，则可以在调用Router模块的方法时，添加一个params属性，并指定一个对象作为参数。例如：

import { router } from '@kit.ArkUI';


class DataModelInfo {
  age: number = 0;
}


class DataModel {
  id: number = 0;
  info: DataModelInfo | null = null;
}


function onJumpClick(): void {
  // 在Home页面中
  let paramsInfo: DataModel = {
    id: 123,
    info: {
      age: 20
    }
  };


  router.pushUrl({
    url: 'pages/Detail', // 目标url
    params: paramsInfo // 添加params属性，传递自定义参数
  }, (err) => {
    if (err) {
      console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    console.info('Invoke pushUrl succeeded.');
  })
}

在目标页面中，可以通过调用Router模块的getParams方法来获取传递过来的参数。例如：

import { router } from '@kit.ArkUI';


class InfoTmp {
  age: number = 0
}


class RouTmp {
  id: object = () => {
  }
  info: InfoTmp = new InfoTmp()
}


const params: RouTmp = router.getParams() as RouTmp; // 获取传递过来的参数对象
const id: object = params.id // 获取id属性的值
const age: number = params.info.age // 获取age属性的值
页面返回

当用户在一个页面完成操作后，通常需要返回到上一个页面或者指定页面，这就需要用到页面返回功能。在返回的过程中，可能需要将数据传递给目标页面，这就需要用到数据传递功能。

图2 页面返回

在使用页面路由Router相关功能之前，需要在代码中先导入Router模块。

import { router } from '@kit.ArkUI';

可以使用以下几种方式返回页面：

方式一：返回到上一个页面。

import { router } from '@kit.ArkUI';


router.back();

这种方式会返回到上一个页面，即上一个页面在页面栈中的位置。但是，上一个页面必须存在于页面栈中才能够返回，否则该方法将无效。

方式二：返回到指定页面。

返回普通页面。

import { router } from '@kit.ArkUI';


router.back({
  url: 'pages/Home'
});

返回命名路由页面。

import { router } from '@kit.ArkUI';


router.back({
  url: 'myPage' //myPage为返回的命名路由页面别名
});

这种方式可以返回到指定页面，需要指定目标页面的路径。目标页面必须存在于页面栈中才能够返回。

方式三：返回到指定页面，并传递自定义参数信息。

返回到普通页面。

import { router } from '@kit.ArkUI';


router.back({
  url: 'pages/Home',
  params: {
    info: '来自Home页'
  }
});

返回命名路由页面。

import { router } from '@kit.ArkUI';


router.back({
  url: 'myPage', //myPage为返回的命名路由页面别名
  params: {
    info: '来自Home页'
  }
});

这种方式不仅可以返回到指定页面，还可以在返回的同时传递自定义参数信息。这些参数信息可以在目标页面中通过调用router.getParams方法进行获取和解析。

在目标页面中，在需要获取参数的位置调用router.getParams方法即可，例如在onPageShow生命周期回调中：

说明

直接使用router可能导致实例不明确的问题，建议使用getUIContext获取UIContext实例，并使用getRouter获取绑定实例的router。

@Entry
@Component
struct Home {
  @State message: string = 'Hello World';


  onPageShow() {
    const params = this.getUIContext().getRouter().getParams() as Record<string, string>; // 获取传递过来的参数对象
    if (params) {
      const info: string = params.info as string; // 获取info属性的值
    }
  }


  // ...
}
说明

当使用router.back方法返回到指定页面时，原栈顶页面（包括）到指定页面（不包括）之间的所有页面栈都将从栈中弹出并销毁。

另外，如果使用router.back方法返回到原来的页面，原页面不会被重复创建，因此使用@State声明的变量不会重复声明，也不会触发页面的aboutToAppear生命周期回调。如果需要在原页面中使用返回页面传递的自定义参数，可以在需要的位置进行参数解析。例如，在onPageShow生命周期回调中进行参数解析。

页面返回前增加一个询问框

在开发应用时，为了避免用户误操作或者丢失数据，有时候需要在用户从一个页面返回到另一个页面之前，弹出一个询问框，让用户确认是否要执行这个操作。

本文将从系统默认询问框和自定义询问框两个方面来介绍如何实现页面返回前增加一个询问框的功能。

图3 页面返回前增加一个询问框

系统默认询问框

为了实现这个功能，可以使用页面路由Router模块提供的两个方法：router.showAlertBeforeBackPage和router.back来实现这个功能。

在使用页面路由Router相关功能之前，需要在代码中先导入Router模块。

import { router } from '@kit.ArkUI';

如果想要在目标界面开启页面返回询问框，需要在调用router.back方法之前，通过调用router.showAlertBeforeBackPage方法设置返回询问框的信息。例如，在支付页面中定义一个返回按钮的点击事件处理函数：

import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';


// 定义一个返回按钮的点击事件处理函数
function onBackClick(): void {
  // 调用router.showAlertBeforeBackPage()方法，设置返回询问框的信息
  try {
    router.showAlertBeforeBackPage({
      message: '您还没有完成支付，确定要返回吗？' // 设置询问框的内容
    });
  } catch (err) {
    let message = (err as BusinessError).message
    let code = (err as BusinessError).code
    console.error(`Invoke showAlertBeforeBackPage failed, code is ${code}, message is ${message}`);
  }


  // 调用router.back()方法，返回上一个页面
  router.back();
}

其中，router.showAlertBeforeBackPage方法接收一个对象作为参数，该对象包含以下属性：

message：string类型，表示询问框的内容。

如果调用成功，则会在目标界面开启页面返回询问框；如果调用失败，则会抛出异常，并通过err.code和err.message获取错误码和错误信息。

当用户点击“返回”按钮时，会弹出确认对话框，询问用户是否确认返回。选择“取消”将停留在当前页目标页面；选择“确认”将触发router.back方法，并根据参数决定如何执行跳转。

自定义询问框

自定义询问框的方式，可以使用弹窗promptAction.showDialog或者自定义弹窗实现。这样可以让应用界面与系统默认询问框有所区别，提高应用的用户体验度。本文以弹窗为例，介绍如何实现自定义询问框。

在使用页面路由Router相关功能之前，需要在代码中先导入Router模块。

import { router } from '@kit.ArkUI';

在事件回调中，调用弹窗的promptAction.showDialog方法：

import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';


function onBackClick() {
  // 弹出自定义的询问框
  promptAction.showDialog({
    message: '您还没有完成支付，确定要返回吗？',
    buttons: [
      {
        text: '取消',
        color: '#FF0000'
      },
      {
        text: '确认',
        color: '#0099FF'
      }
    ]
  }).then((result: promptAction.ShowDialogSuccessResponse) => {
    if (result.index === 0) {
      // 用户点击了“取消”按钮
      console.info('User canceled the operation.');
    } else if (result.index === 1) {
      // 用户点击了“确认”按钮
      console.info('User confirmed the operation.');
      // 调用router.back()方法，返回上一个页面
      router.back();
    }
  }).catch((err: Error) => {
    let message = (err as BusinessError).message
    let code = (err as BusinessError).code
    console.error(`Invoke showDialog failed, code is ${code}, message is ${message}`);
  })
}

当用户点击“返回”按钮时，会弹出自定义的询问框，询问用户是否确认返回。选择“取消”将停留在当前页目标页面；选择“确认”将触发router.back方法，并根据参数决定如何执行跳转。

命名路由

在开发中为了跳转到共享包HAR或者HSP中的页面（即共享包中路由跳转），可以使用router.pushNamedRoute来实现。

图4 命名路由跳转

在使用页面路由Router相关功能之前，需要在代码中先导入Router模块。

import { router } from '@kit.ArkUI';

在想要跳转到的共享包HAR或者HSP页面里，给@Entry修饰的自定义组件EntryOptions命名：

// library/src/main/ets/pages/Index.ets
// library为新建共享包自定义的名字
@Entry({ routeName: 'myPage' })
@Component
export struct MyComponent {
  build() {
    Row() {
      Column() {
        Text('Library Page')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

配置成功后需要在跳转的页面中引入命名路由的页面：

import { BusinessError } from '@kit.BasicServicesKit';
import '@ohos/library/src/main/ets/pages/Index'; // 引入共享包中的命名路由页面


@Entry
@Component
struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('Hello World')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .backgroundColor('#ccc')
        .onClick(() => { // 点击跳转到其他共享包中的页面
          try {
            this.getUIContext().getRouter().pushNamedRoute({
              name: 'myPage',
              params: {
                data1: 'message',
                data2: {
                  data3: [123, 456, 789]
                }
              }
            })
          } catch (err) {
            let message = (err as BusinessError).message
            let code = (err as BusinessError).code
            console.error(`pushNamedRoute failed, code is ${code}, message is ${message}`);
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
说明

使用命名路由方式跳转时，需要在当前应用包的oh-package.json5文件中配置依赖。例如：

"dependencies": {
   "@ohos/library": "file:../library",
   ...
}

---

## Router切换Navigation

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-router-to-navigation-V5

鉴于组件导航(Navigation)支持更丰富的动效、一次开发多端部署能力和更灵活的栈操作。本文主要从页面跳转、动效和生命周期等方面介绍如何从Router切换到Navigation。

页面结构

Router路由的页面是一个@Entry修饰的Component，每一个页面都需要在main_page.json中声明。

// main_page.json
{
  "src": [
    "pages/Index",
    "pages/pageOne",
    "pages/pageTwo"
  ]
}

以下为Router页面的示例。

// index.ets
import { router } from '@kit.ArkUI';


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';


  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('router to pageOne', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/pageOne' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              console.info('Invoke pushUrl succeeded.');
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// pageOne.ets
import { router } from '@kit.ArkUI';


@Entry
@Component
struct pageOne {
  @State message: string = 'This is pageOne';


  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('router back to Index', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            router.back();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}

而基于Navigation的路由页面分为导航页和子页，导航页又叫Navbar，是Navigation包含的子组件，子页是NavDestination包含的子组件。

以下为Navigation导航页的示例。

// index.ets
@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack()


  build() {
    Navigation(this.pathStack) {
      Column() {
        Button('Push PageOne', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pathStack.pushPathByName('pageOne', null)
          })
      }.width('100%').height('100%')
    }
    .title("Navigation")
    .mode(NavigationMode.Stack)
  }
}

以下为Navigation子页的示例。

// PageOne.ets


@Builder
export function PageOneBuilder() {
  PageOne()
}


@Component
export struct PageOne {
  pathStack: NavPathStack = new NavPathStack()


  build() {
    NavDestination() {
      Column() {
        Button('回到首页', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pathStack.clear()
          })
      }.width('100%').height('100%')
    }.title('PageOne')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

每个子页也需要配置到系统配置文件route_map.json中（参考系统路由表）。

// 工程配置文件module.json5中配置 {"routerMap": "$profile:route_map"}
// route_map.json
{
  "routerMap": [
    {
      "name": "pageOne",
      "pageSourceFile": "src/main/ets/pages/PageOne.ets",
      "buildFunction": "PageOneBuilder",
      "data": {
        "description": "this is pageOne"
      }
    }
  ]
}
路由操作

Router通过@ohos.router模块提供的方法来操作页面，使用前需要先import。

import { router } from '@kit.ArkUI';


// push page
router.pushUrl({ url:"pages/pageOne", params: null })


// pop page
router.back({ url: "pages/pageOne" })


// replace page
router.replaceUrl({ url: "pages/pageOne" })


// clear all page
router.clear()


// 获取页面栈大小
let size = router.getLength()


// 获取页面状态
let pageState = router.getState()

Navigation通过页面栈对象NavPathStack提供的方法来操作页面，需要创建一个栈对象并传入Navigation中。

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack()


  build() {
    // 设置NavPathStack并传入Navigation
    Navigation(this.pathStack) {
      // ...
    }.width('100%').height('100%')
    .title("Navigation")
    .mode(NavigationMode.Stack)
  }
}




// push page
this.pathStack.pushPath({ name: 'pageOne' })


// pop page
this.pathStack.pop()
this.pathStack.popToIndex(1)
this.pathStack.popToName('pageOne')


// replace page
this.pathStack.replacePath({ name: 'pageOne' })


// clear all page
this.pathStack.clear()


// 获取页面栈大小
let size: number = this.pathStack.size()


// 删除栈中name为PageOne的所有页面
this.pathStack.removeByName("pageOne")


// 删除指定索引的页面
this.pathStack.removeByIndexes([1, 3, 5])


// 获取栈中所有页面name集合
this.pathStack.getAllPathName()


// 获取索引为1的页面参数
this.pathStack.getParamByIndex(1)


// 获取PageOne页面的参数
this.pathStack.getParamByName("pageOne")


// 获取PageOne页面的索引集合
this.pathStack.getIndexByName("pageOne")
// ...

Router作为全局通用模块，可以在任意页面中调用，Navigation作为组件，子页面想要做路由需要拿到Navigation持有的页面栈对象NavPathStack，可以通过如下几种方式获取：

方式一：通过@Provide和@Consume传递给子页面（有耦合，不推荐）。

// Navigation根容器
@Entry
@Component
struct Index {
  // Navigation创建一个Provide修饰的NavPathStack
 @Provide('pathStack') pathStack: NavPathStack = new NavPathStack()


  build() {
    Navigation(this.pathStack) {
        // ...
    }
    .title("Navigation")
    .mode(NavigationMode.Stack)
  }
}


// Navigation子页面
@Component
export struct PageOne {
  // NavDestination通过Consume获取到
  @Consume('pathStack') pathStack: NavPathStack;


  build() {
    NavDestination() {
      // ...
    }
    .title("PageOne")
  }
}

方式二：子页面通过OnReady回调获取。

@Component
export struct PageOne {
  pathStack: NavPathStack = new NavPathStack()


  build() {
    NavDestination() {
      // ...
    }.title('PageOne')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

方式三： 通过全局的AppStorage接口设置获取。

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack()


  // 全局设置一个NavPathStack
  aboutToAppear(): void {
     AppStorage.setOrCreate("PathStack", this.pathStack)
   }


  build() {
    Navigation(this.pathStack) {
      // ...
    }.title("Navigation")
    .mode(NavigationMode.Stack)
  }
}


// Navigation子页面
@Component
export struct PageOne {
  // 子页面中获取全局的NavPathStack
  pathStack: NavPathStack = AppStorage.get("PathStack") as NavPathStack


  build() {
    NavDestination() {
      // ...
    }
    .title("PageOne")
  }
}

方式四：通过自定义组件查询接口获取，参考queryNavigationInfo。

// 子页面中的自定义组件
@Component
struct CustomNode {
  pathStack: NavPathStack = new NavPathStack()


  aboutToAppear() {
    // query navigation info
    let navigationInfo: NavigationInfo = this.queryNavigationInfo() as NavigationInfo
    this.pathStack = navigationInfo.pathStack;
  }


  build() {
    Row() {
      Button('跳转到PageTwo')
        .onClick(() => {
          this.pathStack.pushPath({ name: 'pageTwo' })
        })
    }
  }
}
生命周期

Router页面生命周期为@Entry页面中的通用方法，主要有如下四个生命周期：

// 页面创建后挂树的回调
aboutToAppear(): void {
}


// 页面销毁前下树的回调  
aboutToDisappear(): void {
}


// 页面显示时的回调  
onPageShow(): void {
}


// 页面隐藏时的回调  
onPageHide(): void {
}

其生命周期时序如下图所示：

Navigation作为路由容器，其生命周期承载在NavDestination组件上，以组件事件的形式开放。

具体生命周期描述请参考Navigation页面生命周期。

@Component
struct PageOne {
  aboutToDisappear() {
  }


  aboutToAppear() {
  }


  build() {
    NavDestination() {
      // ...
    }
    .onWillAppear(() => {
    })
    .onAppear(() => {
    })
    .onWillShow(() => {
    })
    .onShown(() => {
    })
    .onWillHide(() => {
    })
    .onHidden(() => {
    })
    .onWillDisappear(() => {
    })
    .onDisAppear(() => {
    })
  }
}
转场动画

Router和Navigation都提供了系统的转场动画也提供了自定义转场的能力。

其中Router自定义页面转场通过通用方法pageTransition()实现，具体可参考Router页面转场动画。

Navigation作为路由容器组件，其内部的页面切换动画本质上属于组件跟组件之间的属性动画，可以通过Navigation中的customNavContentTransition事件提供自定义转场动画的能力，具体实现可以参考Navigation自定义转场。（注意：Dialog类型的页面当前没有转场动画）

共享元素转场

页面和页面之间跳转的时候需要进行共享元素过渡动画，Router可以通过通用属性sharedTransition来实现共享元素转场，具体可以参考如下链接：

Router共享元素转场动画。

Navigation也提供了共享元素一镜到底的转场能力，需要配合geometryTransition属性，在子页面（NavDestination）之间切换时，可以实现共享元素转场，具体可参考Navigation共享元素转场动画。

跨包路由

Router可以通过命名路由的方式实现跨包跳转。

在想要跳转到的共享包HAR或者HSP页面里，给@Entry修饰的自定义组件EntryOptions命名。

// library/src/main/ets/pages/Index.ets
// library为新建共享包自定义的名字
@Entry({ routeName: 'myPage' })
@Component
export struct MyComponent {
  build() {
    Row() {
      Column() {
        Text('Library Page')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

配置成功后需要在跳转的页面中引入命名路由的页面并跳转。

import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import('library/src/main/ets/pages/Index');  // 引入共享包中的命名路由页面


@Entry
@Component
struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('Hello World')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .backgroundColor('#ccc')
        .onClick(() => { // 点击跳转到其他共享包中的页面
          try {
            router.pushNamedRoute({
              name: 'myPage',
              params: {
                data1: 'message',
                data2: {
                  data3: [123, 456, 789]
                }
              }
            })
          } catch (err) {
            let message = (err as BusinessError).message
            let code = (err as BusinessError).code
            console.error(`pushNamedRoute failed, code is ${code}, message is ${message}`);
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}

Navigation作为路由组件，默认支持跨包跳转。

从HSP（HAR）中完成自定义组件（需要跳转的目标页面）开发，将自定义组件申明为export。

@Component
export struct PageInHSP {
  build() {
    NavDestination() {
        // ...
    }
  }
}

在HSP（HAR）的index.ets中导出组件。

export { PageInHSP } from "./src/main/ets/pages/PageInHSP"

配置好HSP（HAR）的项目依赖后，在mainPage中导入自定义组件，并添加到pageMap中，即可正常调用。

// 1.导入跨包的路由页面
import { PageInHSP } from 'library/src/main/ets/pages/PageInHSP'


@Entry
@Component
struct mainPage {
 pageStack: NavPathStack = new NavPathStack()


 @Builder pageMap(name: string) {
   if (name === 'PageInHSP') {
        // 2.定义路由映射表
        PageInHSP()
   }
 }


 build() {
   Navigation(this.pageStack) {
     Button("Push HSP Page")
       .onClick(() => {
         // 3.跳转到Hsp中的页面
         this.pageStack.pushPath({ name: "PageInHSP" });
       })
   }
   .mode(NavigationMode.Stack)
   .navDestination(this.pageMap)
 }
}

以上是通过静态依赖的形式完成了跨包的路由，在大型的项目中一般跨模块的开发需要解耦，那就需要依赖动态路由的能力。

动态路由

动态路由设计的目的是解决多个产品（Hap）之间可以复用相同的业务模块，各个业务模块之间解耦（模块之间跳转通过路由表跳转，不需要互相依赖）和路由功能扩展整合。

业务特性模块对外暴露的就是模块内支持完成具体业务场景的多个页面的集合；路由管理就是将每个模块支持的页面都用统一的路由表结构管理起来。 当产品需要某个业务模块时，就会注册对应的模块的路由表。

动态路由的优势：

路由定义除了跳转的URL以外，可以丰富的配置任意扩展信息，如横竖屏默认模式，是否需要鉴权等等，做路由跳转时的统一处理。
给每个路由设置一个名字，按照名称进行跳转而不是ets文件路径。
页面的加载可以使用动态Import（按需加载），防止首个页面加载大量代码导致卡顿。

Router实现动态路由主要有下面三个过程：

定义过程： 路由表定义新增路由 -> 页面文件绑定路由名称（装饰器） -> 加载函数和页面文件绑定（动态import函数）

定义注册过程： 路由注册（可在入口ability中按需注入依赖模块的路由表）。

跳转过程： 路由表检查(是否注册过对应路由名称) -> 路由前置钩子（路由页面加载-动态Import） -> 路由跳转 -> 路由后置钩子（公共处理，如打点）。

Navigation实现动态路由有如下两种实现方案：

方案一： 自定义路由表

基本实现跟上述Router动态路由类似。

开发者自定义路由管理模块，各个提供路由页面的模块均依赖此模块；
构建Navigation组件时，将NavPathStack注入路由管理模块，路由管理模块对NavPathStack进行封装，对外提供路由能力；
各个路由页面不再提供组件，转为提供@build封装的构建函数，并再通过WrappedBuilder封装后，实现全局封装；
各个路由页面将模块名称、路由名称、WrappedBuilder封装后构建函数注册如路由模块。
当路由需要跳转到指定路由时，路由模块完成对指定路由模块的动态导入，并完成路由跳转。

具体的构建过程，可以参考Navigation自动生成动态路由示例。

方案二： 系统路由表

从API version 12版本开始，Navigation支持系统跨模块的路由表方案，整体设计是将路由表方案下沉到系统中管理，即在需要路由的各个业务模块（HSP/HAR）中独立配置router_map.json文件，在触发路由跳转时，应用只需要通过NavPathStack进行路由跳转，此时系统会自动完成路由模块的动态加载、组件构建，并完成路由跳转功能，从而实现了开发层面的模块解耦。

具体可参考Navigation系统路由表。

生命周期监听

Router可以通过observer实现注册监听，接口定义请参考Router无感监听observer.on('routerPageUpdate')。

import { uiObserver } from '@kit.ArkUI';


function callBackFunc(info: uiObserver.RouterPageInfo) {
    console.info("RouterPageInfo is : " + JSON.stringify(info))
}


// used in ability context.
uiObserver.on('routerPageUpdate', this.context, callBackFunc);


// used in UIContext.
uiObserver.on('routerPageUpdate', this.getUIContext(), callBackFunc);

在页面状态发生变化时，注册的回调将会触发，开发者可以通过回调中传入的入参拿到页面的相关信息，如：页面的名字，索引，路径，生命周期状态等。

Navigation同样可以通过在observer中实现注册监听。

// EntryAbility.ets
import { BusinessError } from '@kit.BasicServicesKit';
import { UIObserver } from '@kit.ArkUI';


export default class EntryAbility extends UIAbility {
  // ...
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // ...
    windowStage.getMainWindow((err: BusinessError, data) => {
      // ...
      let windowClass = data;
      // 获取UIContext实例。
      let uiContext: UIContext = windowClass.getUIContext();
      // 获取UIObserver实例。
      let uiObserver : UIObserver = uiContext.getUIObserver();
      // 注册DevNavigation的状态监听.
      uiObserver.on("navDestinationUpdate",(info) => {
        // NavDestinationState.ON_SHOWN = 0, NavDestinationState.ON_HIDE = 1
        if (info.state == 0) {
          // NavDestination组件显示时操作
          console.info('page ON_SHOWN:' + info.name.toString());
        }
      })
    })
  }
}
页面信息查询

为了实现页面内自定义组件跟页面解耦，自定义组件中提供了全局查询页面信息的接口。

Router可以通过queryRouterPageInfo接口查询当前自定义组件所在的Page页面的信息，其返回值包含如下几个属性，其中pageId是页面的唯一标识符：

名称	类型	必填	说明
context	UIAbilityContext/ UIContext	是	routerPage页面对应的上下文信息
index	number	是	routerPage在栈中的位置。
name	string	是	routerPage页面的名称。
path	string	是	routerPage页面的路径。
state	RouterPageState	是	routerPage页面的状态
pageId12+	string	是	routerPage页面的唯一标识
import { uiObserver } from '@kit.ArkUI';


// 页面内的自定义组件
@Component
struct MyComponent {
  aboutToAppear() {
    let info: uiObserver.RouterPageInfo | undefined = this.queryRouterPageInfo();
  }


  build() {
    // ...
  }
}

Navigation也可以通过queryNavDestinationInfo接口查询当前自定义组件所在的NavDestination的信息，其返回值包含如下几个属性，其中navDestinationId是页面的唯一标识符：

名称	类型	必填	说明
navigationId	ResourceStr	是	包含NavDestination组件的Navigation组件的id。
name	ResourceStr	是	NavDestination组件的名称。
state	NavDestinationState	是	NavDestination组件的状态。
index12+	number	是	NavDestination在页面栈中的索引。
param12+	Object	否	NavDestination组件的参数。
navDestinationId12+	string	是	NavDestination组件的唯一标识ID。
import { uiObserver } from '@kit.ArkUI';


@Component
export struct NavDestinationExample {
  build() {
    NavDestination() {
      MyComponent()
    }
  }
}


@Component
struct MyComponent {
  navDesInfo: uiObserver.NavDestinationInfo | undefined


  aboutToAppear() {
    this.navDesInfo = this.queryNavDestinationInfo();
    console.log('get navDestinationInfo: ' + JSON.stringify(this.navDesInfo))
  }


  build() {
    // ...
  }
}
路由拦截

Router原生没有提供路由拦截的能力，开发者需要自行封装路由跳转接口，并在自己封装的接口中做路由拦截的判断并重定向路由。

Navigation提供了setInterception方法，用于设置Navigation页面跳转拦截回调。具体可以参考文档：Navigation路由拦截


---

## See Also

- [Stage 模型与 UIAbility](stage-ability.md)
- [状态管理](state-management.md)
- [ArkUI 主题](arkui.md)
