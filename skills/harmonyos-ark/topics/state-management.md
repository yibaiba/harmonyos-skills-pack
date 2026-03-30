# 状态管理主题

<!-- Agent 摘要：782 行。@State/@Prop/@Link/@Provide 等装饰器 + 基础用法指南。
     反模式/高级用法 → state-management-advanced.md。
     代码模板 → starter-kit/snippets/state-management.md。 -->


## 目录

- [Scope](#scope)
- [来源](#来源)
- [Official Entrypoints](#official-entrypoints)
- [状态管理概述](#状态管理概述)
- [管理组件拥有的状态](#管理组件拥有的状态)
- [管理应用拥有的状态](#管理应用拥有的状态)
- [状态管理优秀实践](#状态管理优秀实践)
- [状态管理合理使用开发指导](#状态管理合理使用开发指导)

---

## Scope
- 状态管理 V1/V2 概述、组件状态（@State/@Prop/@Link/@Provide/@Consume）、应用状态（AppStorage/LocalStorage/PersistentStorage/Environment）、最佳实践

## 来源
- ArkUI（方舟UI框架）> 状态管理

## Official Entrypoints
- [状态管理概述](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-state-management-overview-V5)
- [管理组件拥有的状态](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-component-state-management-V5)
- [管理应用拥有的状态](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-application-state-management-V5)
- [其他状态管理](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-other-state-mgmt-functions-V5)
- [状态管理优秀实践](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-state-management-best-practices-V5)
- [状态管理合理使用开发指导](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/properly-use-state-management-to-develope-V5)

---

## 状态管理概述

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-state-management-overview-V5

在前文的描述中，我们构建的页面多为静态界面。如果希望构建一个动态的、有交互的界面，就需要引入“状态”的概念。

图1 效果图

上面的示例中，用户与应用程序的交互触发了文本状态变更，状态变更引起了UI渲染，UI从“Hello World”变更为“Hello ArkUI”。

在声明式UI编程框架中，UI是程序状态的运行结果，用户构建了一个UI模型，其中应用的运行时的状态是参数。当参数改变时，UI作为返回结果，也将进行对应的改变。这些运行时的状态变化所带来的UI的重新渲染，在ArkUI中统称为状态管理机制。

自定义组件拥有变量，变量必须被装饰器装饰才可以成为状态变量，状态变量的改变会引起UI的渲染刷新。如果不使用状态变量，UI只能在初始化时渲染，后续将不会再刷新。 下图展示了State和View（UI）之间的关系。

View(UI)：UI渲染，指将build方法内的UI描述和@Builder装饰的方法内的UI描述映射到界面。

State：状态，指驱动UI更新的数据。用户通过触发组件的事件方法，改变状态数据。状态数据的改变，引起UI的重新渲染。

在阅读状态管理文档前，开发者需要对UI范式基本语法有基本的了解。建议提前阅读：基本语法概述，声明式UI描述，自定义组件-创建自定义组件。

基本概念

状态变量：被状态装饰器装饰的变量，状态变量值的改变会引起UI的渲染更新。示例：@State num: number = 1,其中，@State是状态装饰器，num是状态变量。

常规变量：没有被状态装饰器装饰的变量，通常应用于辅助计算。它的改变永远不会引起UI的刷新。以下示例中increaseBy变量为常规变量。

数据源/同步源：状态变量的原始来源，可以同步给不同的状态数据。通常意义为父组件传给子组件的数据。以下示例中数据源为count: 1。

命名参数机制：父组件通过指定参数传递给子组件的状态变量，为父子传递同步参数的主要手段。示例：CompA({ aProp: this.aProp })。

从父组件初始化：父组件使用命名参数机制，将指定参数传递给子组件。子组件初始化的默认值在有父组件传值的情况下，会被覆盖。示例：

@Component
struct MyComponent {
  @State count: number = 0;
  private increaseBy: number = 1;


  build() {
  }
}


@Entry
@Component
struct Parent {
  build() {
    Column() {
      // 从父组件初始化，覆盖本地定义的默认值
      MyComponent({ count: 1, increaseBy: 2 })
    }
  }
}

初始化子组件：父组件中状态变量可以传递给子组件，初始化子组件对应的状态变量。示例同上。

本地初始化：在变量声明的时候赋值，作为变量的默认值。示例：@State count: number = 0。

说明

当前状态管理的功能仅支持在UI主线程使用，不能在子线程、worker、taskpool中使用。

状态管理（V1）

开发者可以选择使用状态管理V1版本进行应用开发。

装饰器总览

ArkUI状态管理V1提供了多种装饰器，通过使用这些装饰器，状态变量不仅可以观察在组件内的改变，还可以在不同组件层级间传递，比如父子组件、跨组件层级，也可以观察全局范围内的变化。根据状态变量的影响范围，将所有的装饰器可以大致分为：

管理组件内状态的装饰器：组件级别的状态管理，可以观察同一个组件树上（即同一个页面内）组件内或不同组件层级的变量变化。

管理应用级状态的装饰器：应用级别的状态管理，可以观察不同页面，甚至不同UIAbility的状态变化，是应用内全局的状态管理。

从数据的传递形式和同步类型层面看，装饰器也可分为：

只读的单向传递；

可变更的双向传递。

图示如下，具体装饰器的介绍，可详见管理组件拥有的状态和管理应用拥有的状态。开发者可以灵活地利用这些能力来实现数据和UI的联动。

上图中，Components部分的装饰器为组件级别的状态管理，Application部分为应用的状态管理。开发者可以通过@StorageLink/@LocalStorageLink实现应用和组件状态的双向同步，通过@StorageProp/@LocalStorageProp实现应用和组件状态的单向同步。

管理组件拥有的状态，即图中Components级别的状态管理：

@State：@State装饰的变量拥有其所属组件的状态，可以作为其子组件单向和双向同步的数据源。当其数值改变时，会引起相关组件的渲染刷新。

@Prop：@Prop装饰的变量可以和父组件建立单向同步关系，@Prop装饰的变量是可变的，但修改不会同步回父组件。

@Link：@Link装饰的变量可以和父组件建立双向同步关系，子组件中@Link装饰变量的修改会同步给父组件中建立双向数据绑定的数据源，父组件的更新也会同步给@Link装饰的变量。

@Provide/@Consume：@Provide/@Consume装饰的变量用于跨组件层级（多层组件）同步状态变量，可以不需要通过参数命名机制传递，通过alias（别名）或者属性名绑定。

@Observed：@Observed装饰class，需要观察多层嵌套场景的class需要被@Observed装饰。单独使用@Observed没有任何作用，需要和@ObjectLink、@Prop联用。

@ObjectLink：@ObjectLink装饰的变量接收@Observed装饰的class的实例，应用于观察多层嵌套场景，和父组件的数据源构建双向同步。

说明

仅@Observed/@ObjectLink可以观察嵌套场景，其他的状态变量仅能观察第一层，详情见各个装饰器章节的“观察变化和行为表现”小节。

管理应用拥有的状态，即图中Application级别的状态管理：

AppStorage是应用程序中的一个特殊的单例LocalStorage对象，是应用级的数据库，和进程绑定，通过@StorageProp和@StorageLink装饰器可以和组件联动。

AppStorage是应用状态的“中枢”，将需要与组件（UI）交互的数据存入AppStorage，比如持久化数据PersistentStorage和环境变量Environment。UI再通过AppStorage提供的装饰器或者API接口，访问这些数据。

框架还提供了LocalStorage，AppStorage是LocalStorage特殊的单例。LocalStorage是应用程序声明的应用状态的内存“数据库”，通常用于页面级的状态共享，通过@LocalStorageProp和@LocalStorageLink装饰器可以和UI联动。

其他状态管理V1功能

@Watch用于监听状态变量的变化。

$$运算符：给内置组件提供TS变量的引用，使得TS变量和内置组件的内部状态保持同步。

状态管理（V2）

为了增强状态管理V1版本的部分能力，例如深度观察、属性级更新等，ArkUI推出状态管理V2供开发者使用。

说明

当前状态管理V2能力相较于状态管理V1能力仍有GAP，请开发者慎重选择。

状态管理V1现状以及V2优点

状态管理V1使用代理观察数据，当创建一个状态变量时，同时也创建了一个数据代理观察者。该观察者可感知代理变化，但无法感知实际数据变化，因此在使用上有如下限制：

状态变量不能独立于UI存在，同一个数据被多个视图代理时，在其中一个视图的更改不会通知其他视图更新。
只能感知对象属性第一层的变化，无法做到深度观测和深度监听。
在更改对象中属性以及更改数组中元素的场景下存在冗余更新的问题。
装饰器间配合使用限制多，不易用。组件中没有明确状态变量的输入与输出，不利于组件化。

状态管理V2将观察能力增强到数据本身，数据本身就是可观察的，更改数据会触发相应的视图的更新。相较于状态管理V1，状态管理V2有如下优点：

状态变量独立于UI，更改数据会触发相应视图的更新。

支持对象的深度观测和深度监听，且深度观测机制不影响观测性能。

支持对象中属性级精准更新及数组中元素的最小化更新。

装饰器易用性高、拓展性强，在组件中明确输入与输出，有利于组件化。

装饰器总览

状态管理（V2）提供了一套全新的装饰器。

@ObservedV2：@ObservedV2装饰器装饰class，使得被装饰的class具有深度监听的能力。@ObservedV2和@Trace配合使用可以使class中的属性具有深度观测的能力。

@Trace：@Trace装饰器装饰被@ObservedV2装饰的class中的属性，被装饰的属性具有深度观测的能力。

@ComponentV2：使用@ComponentV2装饰的struct中能使用新的装饰器。例如：@Local、@Param、@Event、@Once、@Monitor、@Provider、@Consumer。

@Local：@Local装饰的变量为组件内部状态，无法从外部初始化。

@Param：@Param装饰的变量作为组件的输入，可以接受从外部传入初始化并同步。

@Once：@Once装饰的变量仅初始化时同步一次，需要与@Param一起使用。

@Event：@Event装饰方法类型，作为组件输出，可以通过该方法影响父组件中变量。

@Monitor：@Monitor装饰器用于@ComponentV2装饰的自定义组件或@ObservedV2装饰的类中，能够对状态变量进行深度监听。

@Provider和@Consumer：用于跨组件层级双向同步。

@Computed：计算属性，在被计算的值变化的时候，只会计算一次。主要应用于解决UI多次重用该属性从而重复计算导致的性能问题。

!!语法：双向绑定语法糖。

状态管理V1与V2能力对比
V1能力	V2能力	说明
@Observed	@ObservedV2	

表明当前对象为可观察对象。但两者能力并不相同。

@Observed可观察第一层的属性，需要搭配@ObjectLink使用才能生效。

@ObservedV2本身无观察能力，仅代表当前class可被观察，如果要观察其属性，需要搭配@Trace使用。


@Track	@Trace	

V1装饰器@Track为精确观察，不使用则无法做到类属性的精准观察。

V2@Trace装饰的属性可以被精确跟踪观察。


@Component	@ComponentV2	

@Component为搭配V1状态变量使用的自定义组件装饰器。

@ComponentV2为搭配V2状态变量使用的自定义组件装饰器。


@State	

无外部初始化：@Local

外部初始化一次：@Param@Once

	@State和@Local类似都是数据源的概念，区别是@State可以外部传入初始化，而@Local无法外部传入初始化。
@Prop	@Param	@Prop和@Param类似都是自定义组件参数的概念。当输入参数为复杂类型时，@Prop为深拷贝，@Param为引用。
@Link	@Param@Event	@Link是框架自己封装实现的双向同步，对于V2开发者可以通过@Param@Event自己实现双向同步。
@ObjectLink	@Param	直接兼容，@ObjectLink需要被@Observed装饰的class的实例初始化，@Param没有此限制。
@Provide	@Provider	兼容。
@Consume	@Consumer	兼容。
@Watch	@Monitor	

@Watch用于监听V1状态变量的变化，具有监听状态变量本身和其第一层属性变化的能力。状态变量可观察到的变化会触发其@Watch监听事件。

@Monitor用于监听V2状态变量的变化，搭配@Trace使用，可有深层监听的能力。状态变量在一次事件中多次变化时，仅会以最终的结果判断是否触发@Monitor监听事件。


LocalStorage	全局@ObservedV2@Trace	兼容。
AppStorage	AppStorageV2	兼容。
Environment	调用Ability接口获取系统环境变量	Environment获取环境变量能力和AppStorage耦合。在V2中可直接调用Ability接口获取系统环境变量。
PersistentStorage	PersistenceV2	PersistentStorage持久化能力和AppStorage耦合，PersistenceV2持久化能力可独立使用。
自定义组件生命周期	自定义组件生命周期	均支持。aboutToAppear、onDidBuild、aboutToDisappear。
页面生命周期	页面生命周期	均支持。onPageShow、onPageHide、onBackPress。
@Reusable	暂未提供	组件复用。包括：aboutToReuse、aboutToRecycle。
$$	!!	双向绑定。V2建议使用!!实现双向绑定。
@CustomDialog	openCustomDialog接口	自定义弹窗。V2建议使用openCustomDialog实现自定义弹窗功能。
withTheme	暂未提供	主题。用于设置应用局部页面自定义主题风格。包括：onWillApplyTheme。
高级组件	暂未提供	高级组件。例如：DownloadFileButton、ProgressButton、SegmentButton。
animateTo	部分场景不支持	当前某些场景下，在状态管理V2中使用animateTo动画，会产生异常效果，详见：在状态管理V2中使用animateTo动画效果异常。

有关V1向V2的迁移可参考迁移指导，有关V1与V2的混用可参考混用文档。

---

## 管理组件拥有的状态

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-component-state-management-V5

@State装饰器：组件内状态

@Prop装饰器：父子单向同步

@Link装饰器：父子双向同步

@Provide装饰器和@Consume装饰器：与后代组件双向同步

@Observed装饰器和@ObjectLink装饰器：嵌套类对象属性变化

---

## 管理应用拥有的状态

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-application-state-management-V5

管理应用拥有的状态概述

LocalStorage：页面级UI状态存储

AppStorage：应用全局的UI状态存储

PersistentStorage：持久化存储UI状态

Environment：设备环境查询

---

## 状态管理优秀实践

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-state-management-best-practices-V5

为了帮助应用程序开发人员提高其应用程序质量，特别是在高效的状态管理方面。本章节面向开发者提供了多个在开发ArkUI应用中常见的低效开发的场景，并给出了对应的解决方案。此外，还提供了同一场景下，推荐用法和不推荐用法的对比和解释说明，更直观地展示两者区别，从而帮助开发者学习如何正确地在应用开发中使用状态变量，进行高性能开发。

使用@ObjectLink代替@Prop减少不必要的深拷贝

在应用开发中，开发者经常会进行父子组件的数值传递，而在不会改变子组件内状态变量值的情况下，使用@Prop装饰状态变量会导致组件创建的耗时增加，从而影响一部分性能。

【反例】

@Observed
class MyClass {
  public num: number = 0;


  constructor(num: number) {
    this.num = num;
  }
}


@Component
struct PropChild {
  @Prop testClass: MyClass; // @Prop 装饰状态变量会深拷贝


  build() {
    Text(`PropChild testNum ${this.testClass.num}`)
  }
}


@Entry
@Component
struct Parent {
  @State testClass: MyClass[] = [new MyClass(1)];


  build() {
    Column() {
      Text(`Parent testNum ${this.testClass[0].num}`)
        .onClick(() => {
          this.testClass[0].num += 1;
        })


      // PropChild没有改变@Prop testClass: MyClass的值，所以这时最优的选择是使用@ObjectLink
      PropChild({ testClass: this.testClass[0] })
    }
  }
}

在上文的示例中，PropChild组件没有改变@Prop testClass: MyClass的值，所以这时较优的选择是使用@ObjectLink，因为@Prop是会深拷贝数据，具有拷贝的性能开销，所以这个时候@ObjectLink是比@Link和@Prop更优的选择。

【正例】

@Observed
class MyClass {
  public num: number = 0;


  constructor(num: number) {
    this.num = num;
  }
}


@Component
struct PropChild {
  @ObjectLink testClass: MyClass; // @ObjectLink 装饰状态变量不会深拷贝


  build() {
    Text(`PropChild testNum ${this.testClass.num}`)
  }
}


@Entry
@Component
struct Parent {
  @State testClass: MyClass[] = [new MyClass(1)];


  build() {
    Column() {
      Text(`Parent testNum ${this.testClass[0].num}`)
        .onClick(() => {
          this.testClass[0].num += 1;
        })


      // 当子组件不需要发生本地改变时，优先使用@ObjectLink，因为@Prop是会深拷贝数据，具有拷贝的性能开销，所以这个时候@ObjectLink是比@Link和@Prop更优的选择
      PropChild({ testClass: this.testClass[0] })
    }
  }
}
不使用状态变量强行更新非状态变量关联组件

【反例】

@Entry
@Component
struct MyComponent {
  @State needsUpdate: boolean = true;
  realStateArr: Array<number> = [4, 1, 3, 2]; // 未使用状态变量装饰器
  realState: Color = Color.Yellow;


  updateUIArr(param: Array<number>): Array<number> {
    const triggerAGet = this.needsUpdate;
    return param;
  }
  updateUI(param: Color): Color {
    const triggerAGet = this.needsUpdate;
    return param;
  }
  build() {
    Column({ space: 20 }) {
      ForEach(this.updateUIArr(this.realStateArr),
        (item: Array<number>) => {
          Text(`${item}`)
        })
      Text("add item")
        .onClick(() => {
          // 改变realStateArr不会触发UI视图更新
          this.realStateArr.push(this.realStateArr[this.realStateArr.length-1] + 1);


          // 触发UI视图更新
          this.needsUpdate = !this.needsUpdate;
        })
      Text("chg color")
        .onClick(() => {
          // 改变realState不会触发UI视图更新
          this.realState = this.realState == Color.Yellow ? Color.Red : Color.Yellow;


          // 触发UI视图更新
          this.needsUpdate = !this.needsUpdate;
        })
    }.backgroundColor(this.updateUI(this.realState))
    .width(200).height(500)
  }
}

上述示例存在以下问题：

应用程序希望控制UI更新逻辑，但在ArkUI中，UI更新的逻辑应该是由框架来检测应用程序状态变量的更改去实现。

this.needsUpdate是一个自定义的UI状态变量，应该仅应用于其绑定的UI组件。变量this.realStateArr、this.realState没有被装饰，他们的变化将不会触发UI刷新。

但是在该应用中，用户试图通过this.needsUpdate的更新来带动常规变量this.realStateArr、this.realState的更新，此方法不合理且更新性能较差。

【正例】

要解决此问题，应将realStateArr和realState成员变量用@State装饰。一旦完成此操作，就不再需要变量needsUpdate。

@Entry
@Component
struct CompA {
  @State realStateArr: Array<number> = [4, 1, 3, 2];
  @State realState: Color = Color.Yellow;
  build() {
    Column({ space: 20 }) {
      ForEach(this.realStateArr,
        (item: Array<number>) => {
          Text(`${item}`)
        })
      Text("add item")
        .onClick(() => {
          // 改变realStateArr触发UI视图更新
          this.realStateArr.push(this.realStateArr[this.realStateArr.length-1] + 1);
        })
      Text("chg color")
        .onClick(() => {
          // 改变realState触发UI视图更新
          this.realState = this.realState == Color.Yellow ? Color.Red : Color.Yellow;
        })
    }.backgroundColor(this.realState)
    .width(200).height(500)
  }
}
精准控制状态变量关联的组件数

建议每个状态变量关联的组件数应该少于20个。精准控制状态变量关联的组件数能减少不必要的组件刷新，提高组件的刷新效率。有时开发者会将同一个状态变量绑定多个同级组件的属性，当状态变量改变时，会让这些组件做出相同的改变，这有时会造成组件的不必要刷新，如果存在某些比较复杂的组件，则会大大影响整体的性能。但是如果将这个状态变量绑定在这些同级组件的父组件上，则可以减少需要刷新的组件数，从而提高刷新的性能。

【反例】

@Observed
class Translate {
  translateX: number = 20;
}
@Component
struct Title {
  @ObjectLink translateObj: Translate;
  build() {
    Row() {
      // 此处'app.media.icon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
      Image($r('app.media.icon'))
        .width(50)
        .height(50)
        .translate({
          x:this.translateObj.translateX // this.translateObj.translateX 绑定在Image和Text组件上
        })
      Text("Title")
        .fontSize(20)
        .translate({
          x: this.translateObj.translateX
        })
    }
  }
}
@Entry
@Component
struct Page {
  @State translateObj: Translate = new Translate();
  build() {
    Column() {
      Title({
        translateObj: this.translateObj
      })
      Stack() {
      }
      .backgroundColor("black")
      .width(200)
      .height(400)
      .translate({
        x:this.translateObj.translateX //this.translateObj.translateX 绑定在Stack和Button组件上
      })
      Button("move")
        .translate({
          x:this.translateObj.translateX
        })
        .onClick(() => {
          this.getUIContext()?.animateTo({
            duration: 50
          },()=>{
            this.translateObj.translateX = (this.translateObj.translateX + 50) % 150
          })
        })
    }
  }
}

在上面的示例中，状态变量this.translateObj.translateX被用在多个同级的子组件下，当this.translateObj.translateX变化时，会导致所有关联它的组件一起刷新，但实际上由于这些组件的变化是相同的，因此可以将这个属性绑定到他们共同的父组件上，来实现减少组件的刷新数量。经过分析，所有的子组件其实都处于Page下的Column中，因此将所有子组件相同的translate属性统一到Column上，来实现精准控制状态变量关联的组件数。

【正例】

@Observed
class Translate {
  translateX: number = 20;
}
@Component
struct Title {
  build() {
    Row() {
      // 此处'app.media.icon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
      Image($r('app.media.icon'))
        .width(50)
        .height(50)
      Text("Title")
        .fontSize(20)
    }
  }
}
@Entry
@Component
struct Page1 {
  @State translateObj: Translate = new Translate();
  build() {
    Column() {
      Title()
      Stack() {
      }
      .backgroundColor("black")
      .width(200)
      .height(400)
      Button("move")
        .onClick(() => {
          this.getUIContext()?.animateTo({
            duration: 50
          },()=>{
            this.translateObj.translateX = (this.translateObj.translateX + 50) % 150
          })
        })
    }
    .translate({ // 子组件Stack和Button设置了同一个translate属性，可以统一到Column上设置
      x: this.translateObj.translateX
    })
  }
}
合理控制对象类型状态变量关联的组件数量

如果将一个复杂对象定义为状态变量，需要合理控制其关联的组件数。当对象中某一个成员属性发生变化时，会导致该对象关联的所有组件刷新，尽管这些组件可能并没有直接使用到该改变的属性。为了避免这种“冗余刷新”对性能产生影响，建议合理拆分该复杂对象，控制对象关联的组件数量。具体可参考精准控制组件的更新范围和状态管理合理使用开发指导 两篇文章。

查询状态变量关联的组件数

在应用开发中，可以通过HiDumper查看状态变量关联的组件数，进行性能优化。具体可参考状态变量组件定位工具实践。

避免在for、while等循环逻辑中频繁读取状态变量

在应用开发中，应避免在循环逻辑中频繁读取状态变量，而是应该放在循环外面读取。

【反例】

import hilog from '@ohos.hilog';


@Entry
@Component
struct Index {
  @State message: string = '';


  build() {
    Column() {
      Button('点击打印日志')
        .onClick(() => {
          for (let i = 0; i < 10; i++) {
            hilog.info(0x0000, 'TAG', '%{public}s', this.message);
          }
        })
        .width('90%')
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .margin({
          top: 10
        })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: 15
    })
  }
}

【正例】

import hilog from '@ohos.hilog';


@Entry
@Component
struct Index {
  @State message: string = '';


  build() {
    Column() {
      Button('点击打印日志')
        .onClick(() => {
          let logMessage: string = this.message;
          for (let i = 0; i < 10; i++) {
            hilog.info(0x0000, 'TAG', '%{public}s', logMessage);
          }
        })
        .width('90%')
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .margin({
          top: 10
        })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: 15
    })
  }
}
建议使用临时变量替换状态变量

在应用开发中，应尽量减少对状态变量的直接赋值，通过临时变量完成数据计算操作。

状态变量发生变化时，ArkUI会查询依赖该状态变量的组件并执行依赖该状态变量的组件的更新方法，完成组件渲染的行为。通过使用临时变量的计算代替直接操作状态变量，可以使ArkUI仅在最后一次状态变量变更时查询并渲染组件，减少不必要的行为，从而提高应用性能。状态变量行为可参考@State装饰器：组件内状态。

【反例】

import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';


@Entry
@Component
struct Index {
  @State message: string = '';


  appendMsg(newMsg: string) {
    // 性能打点
    hiTraceMeter.startTrace('StateVariable', 1);
    this.message += newMsg;
    this.message += ';';
    this.message += '<br/>';
    hiTraceMeter.finishTrace('StateVariable', 1);
  }


  build() {
    Column() {
      Button('点击打印日志')
        .onClick(() => {
          this.appendMsg('操作状态变量');
        })
        .width('90%')
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .margin({
          top: 10
        })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: 15
    })
  }
}

直接操作状态变量，三次触发计算函数，运行耗时结果如下

【正例】

import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';


@Entry
@Component
struct Index {
  @State message: string = '';


  appendMsg(newMsg: string) {
    // 性能打点
    hiTraceMeter.startTrace('TemporaryVariable', 2);
    let message = this.message;
    message += newMsg;
    message += ';';
    message += '<br/>';
    this.message = message;
    hiTraceMeter.finishTrace('TemporaryVariable', 2);
  }


  build() {
    Column() {
      Button('点击打印日志')
        .onClick(() => {
          this.appendMsg('操作临时变量');
        })
        .width('90%')
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .margin({
          top: 10
        })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: 15
    })
  }
}

使用临时变量取代状态变量的计算，三次触发计算函数，运行耗时结果如下

【总结】

计算方式	耗时(局限不同设备和场景，数据仅供参考)	说明
直接操作状态变量	1.01ms	增加了ArkUI不必要的查询和渲染行为，导致性能劣化
使用临时变量计算	0.63ms	减少了ArkUI不必要的行为，优化性能

---


---

> 📎 状态管理高级用法与反模式见 [state-management-advanced.md](./state-management-advanced.md)

## See Also

- [state-management-advanced.md](./state-management-advanced.md) — 状态管理合理使用指导
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) — 状态代码模式
- [arkts.md](./arkts.md) — ArkTS 语言特性
