# 页面路由 — Router API 与迁移指南

> 本文件从 routing-lifecycle.md 拆分而来
> 内容：@ohos.router API、Router→Navigation 迁移

<!-- Agent 摘要：本文件 1198 行。旧版 Router API 用法 + Router→Navigation 迁移指南。
     Navigation 组件/生命周期 → routing-lifecycle.md。
     新项目建议直接用 Navigation，仅迁移旧项目时读本文件。 -->

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

- [routing-lifecycle.md](./routing-lifecycle.md) — Navigation 组件导航
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) — 路由代码模式
- [tabbar-navigation.md](../starter-kit/modules/tabbar-navigation.md) — Tab 导航模板
