# 状态管理主题


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
          animateTo({
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
          animateTo({
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

## 状态管理合理使用开发指导

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/properly-use-state-management-to-develope-V5

由于对状态管理当前的特性并不了解，许多开发者在使用状态管理进行开发时会遇到UI不刷新、刷新性能差的情况。对此，本篇将从两个方向，对一共五个典型场景进行分析，同时提供相应的正例和反例，帮助开发者学习如何合理使用状态管理进行开发。

合理使用属性
将简单属性数组合并成对象数组

在开发过程中，我们经常会需要设置多个组件的同一种属性，比如Text组件的内容、组件的宽度、高度等样式信息等。将这些属性保存在一个数组中，配合ForEach进行使用是一种简单且方便的方法。

@Entry
@Component
struct Index {
  @State items: string[] = [];
  @State ids: string[] = [];
  @State age: number[] = [];
  @State gender: string[] = [];


  aboutToAppear() {
    this.items.push("Head");
    this.items.push("List");
    for (let i = 0; i < 20; i++) {
      this.ids.push("id: " + Math.floor(Math.random() * 1000));
      this.age.push(Math.floor(Math.random() * 100 % 40));
      this.gender.push(Math.floor(Math.random() * 100) % 2 == 0 ? "Male" : "Female");
    }
  }


  isRenderText(index: number) : number {
    console.log(`index ${index} is rendered`);
    return 1;
  }


  build() {
    Row() {
      Column() {
        ForEach(this.items, (item: string) => {
          if (item == "Head") {
            Text("Personal Info")
              .fontSize(40)
          } else if (item == "List") {
            List() {
              ForEach(this.ids, (id: string, index) => {
                ListItem() {
                  Row() {
                    Text(id)
                      .fontSize(20)
                      .margin({
                        left: 30,
                        right: 5
                      })
                    Text("age: " + this.age[index as number])
                      .fontSize(20)
                      .margin({
                        left: 5,
                        right: 5
                      })
                      .position({x: 100})
                      .opacity(this.isRenderText(index))
                      .onClick(() => {
                        this.age[index]++;
                      })
                    Text("gender: " + this.gender[index as number])
                      .margin({
                        left: 5,
                        right: 5
                      })
                      .position({x: 180})
                      .fontSize(20)
                  }
                }
                .margin({
                  top: 5,
                  bottom: 5
                })
              })
            }
          }
        })
      }
    }
  }
}

上述代码运行效果如下。

页面内通过ForEach显示了20条信息，当点击某一条信息中age的Text组件时，可以通过日志发现其他的19条信息中age的Text组件也进行了刷新(这体现在日志上，所有的age的Text组件都打出了日志)，但实际上其他19条信息的age的数值并没有改变，也就是说其他19个Text组件并不需要刷新。

这是因为当前状态管理的一个特性。假设存在一个被@State修饰的number类型的数组Num[]，其中有20个元素，值分别为0到19。这20个元素分别绑定了一个Text组件，当改变其中一个元素，例如第0号元素的值从0改成1，除了0号元素绑定的Text组件会刷新之外，其他的19个Text组件也会刷新，即使1到19号元素的值并没有改变。

这个特性普遍的出现在简单类型数组的场景中，当数组中的元素够多时，会对UI的刷新性能有很大的负面影响。这种“不需要刷新的组件被刷新”的现象即是“冗余刷新”，当“冗余刷新”的节点过多时，UI的刷新效率会大幅度降低，因此需要减少“冗余刷新”，也就是做到精准控制组件的更新范围。

为了减少由简单的属性相关的数组引起的“冗余刷新”，需要将属性数组转变为对象数组，配合自定义组件，实现精准控制更新范围。下面为修改后的代码。

@Observed
class InfoList extends Array<Info> {
};
@Observed
class Info {
  ids: number;
  age: number;
  gender: string;


  constructor() {
    this.ids = Math.floor(Math.random() * 1000);
    this.age = Math.floor(Math.random() * 100 % 40);
    this.gender = Math.floor(Math.random() * 100) % 2 == 0 ? "Male" : "Female";
  }
}
@Component
struct Information {
  @ObjectLink info: Info;
  @State index: number = 0;
  isRenderText(index: number) : number {
    console.log(`index ${index} is rendered`);
    return 1;
  }


  build() {
    Row() {
      Text("id: " + this.info.ids)
        .fontSize(20)
        .margin({
          left: 30,
          right: 5
        })
      Text("age: " + this.info.age)
        .fontSize(20)
        .margin({
          left: 5,
          right: 5
        })
        .position({x: 100})
        .opacity(this.isRenderText(this.index))
        .onClick(() => {
          this.info.age++;
        })
      Text("gender: " + this.info.gender)
        .margin({
          left: 5,
          right: 5
        })
        .position({x: 180})
        .fontSize(20)
    }
  }
}
@Entry
@Component
struct Page {
  @State infoList: InfoList = new InfoList();
  @State items: string[] = [];
  aboutToAppear() {
    this.items.push("Head");
    this.items.push("List");
    for (let i = 0; i < 20; i++) {
      this.infoList.push(new Info());
    }
  }


  build() {
    Row() {
      Column() {
        ForEach(this.items, (item: string) => {
          if (item == "Head") {
            Text("Personal Info")
              .fontSize(40)
          } else if (item == "List") {
            List() {
              ForEach(this.infoList, (info: Info, index) => {
                ListItem() {
                  Information({
                    info: info,
                    index: index
                  })
                }
                .margin({
                  top: 5,
                  bottom: 5
                })
              })
            }
          }
        })
      }
    }
  }
}

上述代码的运行效果如下。

修改后的代码使用对象数组代替了原有的多个属性数组，能够避免数组的“冗余刷新”的情况。这是因为对于数组来说，对象内的变化是无法感知的，数组只能观测数组项层级的变化，例如新增数据项，修改数据项（普通数组是直接修改数据项的值，在对象数组的场景下是整个对象被重新赋值，改变某个数据项对象中的属性不会被观测到）、删除数据项等。这意味着当改变对象内的某个属性时，对于数组来说，对象是没有变化的，也就不会去刷新。在当前状态管理的观测能力中，除了数组嵌套对象的场景外，对象嵌套对象的场景也是无法观测到变化的，这一部分内容将在将复杂对象拆分成多个小对象的集合中讲到。同时修改代码时使用了自定义组件与ForEach的结合，这一部分内容将在在ForEach中使用自定义组件搭配对象数组讲到。

将复杂大对象拆分成多个小对象的集合
说明

从API version 11开始，推荐优先使用@Track装饰器解决该场景的问题。

在开发过程中，我们有时会定义一个大的对象，其中包含了很多样式相关的属性，并且在父子组件间传递这个对象，将其中的属性绑定在组件上。

@Observed
class UIStyle {
  translateX: number = 0;
  translateY: number = 0;
  scaleX: number = 0.3;
  scaleY: number = 0.3;
  width: number = 336;
  height: number = 178;
  posX: number = 10;
  posY: number = 50;
  alpha: number = 0.5;
  borderRadius: number = 24;
  imageWidth: number = 78;
  imageHeight: number = 78;
  translateImageX: number = 0;
  translateImageY: number = 0;
  fontSize: number = 20;
}
@Component
struct SpecialImage {
  @ObjectLink uiStyle: UIStyle;
  private isRenderSpecialImage() : number { // 显示组件是否渲染的函数
    console.log("SpecialImage is rendered");
    return 1;
  }
  build() {
    Image($r('app.media.icon')) // 在API12及以后的工程中使用app.media.app_icon
      .width(this.uiStyle.imageWidth)
      .height(this.uiStyle.imageHeight)
      .margin({ top: 20 })
      .translate({
        x: this.uiStyle.translateImageX,
        y: this.uiStyle.translateImageY
      })
      .opacity(this.isRenderSpecialImage()) // 如果Image重新渲染，该函数将被调用
  }
}
@Component
struct PageChild {
  @ObjectLink uiStyle: UIStyle
  // 下面的函数用于显示组件是否被渲染
  private isRenderColumn() : number {
    console.log("Column is rendered");
    return 1;
  }
  private isRenderStack() : number {
    console.log("Stack is rendered");
    return 1;
  }
  private isRenderImage() : number {
    console.log("Image is rendered");
    return 1;
  }
  private isRenderText() : number {
    console.log("Text is rendered");
    return 1;
  }
  build() {
    Column() {
      SpecialImage({
        uiStyle: this.uiStyle
      })
      Stack() {
        Column() {
            Image($r('app.media.icon')) // 在API12及以后的工程中使用app.media.app_icon
              .opacity(this.uiStyle.alpha)
              .scale({
                x: this.uiStyle.scaleX,
                y: this.uiStyle.scaleY
              })
              .padding(this.isRenderImage())
              .width(300)
              .height(300)
        }
        .width('100%')
        .position({ y: -80 })
        Stack() {
          Text("Hello World")
            .fontColor("#182431")
            .fontWeight(FontWeight.Medium)
            .fontSize(this.uiStyle.fontSize)
            .opacity(this.isRenderText())
            .margin({ top: 12 })
        }
        .opacity(this.isRenderStack())
        .position({
          x: this.uiStyle.posX,
          y: this.uiStyle.posY
        })
        .width('100%')
        .height('100%')
      }
      .margin({ top: 50 })
      .borderRadius(this.uiStyle.borderRadius)
      .opacity(this.isRenderStack())
      .backgroundColor("#FFFFFF")
      .width(this.uiStyle.width)
      .height(this.uiStyle.height)
      .translate({
        x: this.uiStyle.translateX,
        y: this.uiStyle.translateY
      })
      Column() {
        Button("Move")
          .width(312)
          .fontSize(20)
          .backgroundColor("#FF007DFF")
          .margin({ bottom: 10 })
          .onClick(() => {
            animateTo({
              duration: 500
            },() => {
              this.uiStyle.translateY = (this.uiStyle.translateY + 180) % 250;
            })
          })
        Button("Scale")
          .borderRadius(20)
          .backgroundColor("#FF007DFF")
          .fontSize(20)
          .width(312)
          .onClick(() => {
            this.uiStyle.scaleX = (this.uiStyle.scaleX + 0.6) % 0.8;
          })
      }
      .position({
        y:666
      })
      .height('100%')
      .width('100%')


    }
    .opacity(this.isRenderColumn())
    .width('100%')
    .height('100%')


  }
}
@Entry
@Component
struct Page {
  @State uiStyle: UIStyle = new UIStyle();
  build() {
    Stack() {
      PageChild({
        uiStyle: this.uiStyle
      })
    }
    .backgroundColor("#F1F3F5")
  }
}

上述代码的运行效果如下。

优化前点击move按钮的脏节点更新耗时如下图：

在上面的示例中，UIStyle定义了多个属性，并且这些属性分别被多个组件关联。当点击任意一个按钮更改其中的某些属性时，会导致所有这些关联uiStyle的组件进行刷新，虽然它们其实并不需要进行刷新（因为组件的属性都没有改变）。通过定义的一系列isRender函数，可以观察到这些组件的刷新。当点击“move”按钮进行平移动画时，由于translateY的值的多次改变，会导致每一次都存在“冗余刷新”的问题，这对应用的性能有着很大的负面影响。

这是因为当前状态管理的一个刷新机制，假设定义了一个有20个属性的类，创建类的对象实例，将20个属性绑定到组件上，这时修改其中的某个属性，除了这个属性关联的组件会刷新之外，其他的19个属性关联的组件也都会刷新，即使这些属性本身并没有发生变化。

这个机制会导致在使用一个复杂大对象与多个组件关联时，刷新性能的下降。对此，推荐将一个复杂大对象拆分成多个小对象的集合，在保留原有代码结构的基础上，减少“冗余刷新”，实现精准控制组件的更新范围。

@Observed
class NeedRenderImage { // 在同一组件中使用的属性可以划分为相同的类
  public translateImageX: number = 0;
  public translateImageY: number = 0;
  public imageWidth:number = 78;
  public imageHeight:number = 78;
}
@Observed
class NeedRenderScale { // 在一起使用的属性可以划分为相同的类
  public scaleX: number = 0.3;
  public scaleY: number = 0.3;
}
@Observed
class NeedRenderAlpha { // 在不同地方使用的属性可以划分为相同的类
  public alpha: number = 0.5;
}
@Observed
class NeedRenderSize { // 在一起使用的属性可以划分为相同的类
  public width: number = 336;
  public height: number = 178;
}
@Observed
class NeedRenderPos { // 在一起使用的属性可以划分为相同的类
  public posX: number = 10;
  public posY: number = 50;
}
@Observed
class NeedRenderBorderRadius { // 在不同地方使用的属性可以划分为相同的类
  public borderRadius: number = 24;
}
@Observed
class NeedRenderFontSize { // 在不同地方使用的属性可以划分为相同的类
  public fontSize: number = 20;
}
@Observed
class NeedRenderTranslate { // 在一起使用的属性可以划分为相同的类
  public translateX: number = 0;
  public translateY: number = 0;
}
@Observed
class UIStyle {
  // 使用NeedRenderxxx类
  needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
  needRenderFontSize: NeedRenderFontSize = new NeedRenderFontSize();
  needRenderBorderRadius: NeedRenderBorderRadius = new NeedRenderBorderRadius();
  needRenderPos: NeedRenderPos = new NeedRenderPos();
  needRenderSize: NeedRenderSize = new NeedRenderSize();
  needRenderAlpha: NeedRenderAlpha = new NeedRenderAlpha();
  needRenderScale: NeedRenderScale = new NeedRenderScale();
  needRenderImage: NeedRenderImage = new NeedRenderImage();
}
@Component
struct SpecialImage {
  @ObjectLink uiStyle : UIStyle;
  @ObjectLink needRenderImage: NeedRenderImage // 从其父组件接收新类
  private isRenderSpecialImage() : number { // 显示组件是否渲染的函数
    console.log("SpecialImage is rendered");
    return 1;
  }
  build() {
    Image($r('app.media.icon')) // 在API12及以后的工程中使用app.media.app_icon
      .width(this.needRenderImage.imageWidth) // 使用this.needRenderImage.xxx
      .height(this.needRenderImage.imageHeight)
      .margin({top:20})
      .translate({
        x: this.needRenderImage.translateImageX,
        y: this.needRenderImage.translateImageY
      })
      .opacity(this.isRenderSpecialImage()) // 如果Image重新渲染，该函数将被调用
  }
}
@Component
struct PageChild {
  @ObjectLink uiStyle: UIStyle;
  @ObjectLink needRenderTranslate: NeedRenderTranslate; // 从其父组件接收新定义的NeedRenderxxx类的实例
  @ObjectLink needRenderFontSize: NeedRenderFontSize;
  @ObjectLink needRenderBorderRadius: NeedRenderBorderRadius;
  @ObjectLink needRenderPos: NeedRenderPos;
  @ObjectLink needRenderSize: NeedRenderSize;
  @ObjectLink needRenderAlpha: NeedRenderAlpha;
  @ObjectLink needRenderScale: NeedRenderScale;
  // 下面的函数用于显示组件是否被渲染
  private isRenderColumn() : number {
    console.log("Column is rendered");
    return 1;
  }
  private isRenderStack() : number {
    console.log("Stack is rendered");
    return 1;
  }
  private isRenderImage() : number {
    console.log("Image is rendered");
    return 1;
  }
  private isRenderText() : number {
    console.log("Text is rendered");
    return 1;
  }
  build() {
    Column() {
      SpecialImage({
        uiStyle: this.uiStyle,
        needRenderImage: this.uiStyle.needRenderImage // 传递给子组件
      })
      Stack() {
        Column() {
          Image($r('app.media.icon')) // 在API12及以后的工程中使用app.media.app_icon
            .opacity(this.needRenderAlpha.alpha)
            .scale({
              x: this.needRenderScale.scaleX, // 使用this.needRenderXxx.xxx
              y: this.needRenderScale.scaleY
            })
            .padding(this.isRenderImage())
            .width(300)
            .height(300)
        }
        .width('100%')
        .position({ y: -80 })


        Stack() {
          Text("Hello World")
            .fontColor("#182431")
            .fontWeight(FontWeight.Medium)
            .fontSize(this.needRenderFontSize.fontSize)
            .opacity(this.isRenderText())
            .margin({ top: 12 })
        }
        .opacity(this.isRenderStack())
        .position({
          x: this.needRenderPos.posX,
          y: this.needRenderPos.posY
        })
        .width('100%')
        .height('100%')
      }
      .margin({ top: 50 })
      .borderRadius(this.needRenderBorderRadius.borderRadius)
      .opacity(this.isRenderStack())
      .backgroundColor("#FFFFFF")
      .width(this.needRenderSize.width)
      .height(this.needRenderSize.height)
      .translate({
        x: this.needRenderTranslate.translateX,
        y: this.needRenderTranslate.translateY
      })


      Column() {
        Button("Move")
          .width(312)
          .fontSize(20)
          .backgroundColor("#FF007DFF")
          .margin({ bottom: 10 })
          .onClick(() => {
            animateTo({
              duration: 500
            }, () => {
              this.needRenderTranslate.translateY = (this.needRenderTranslate.translateY + 180) % 250;
            })
          })
        Button("Scale")
          .borderRadius(20)
          .backgroundColor("#FF007DFF")
          .fontSize(20)
          .width(312)
          .margin({ bottom: 10 })
          .onClick(() => {
            this.needRenderScale.scaleX = (this.needRenderScale.scaleX + 0.6) % 0.8;
          })
        Button("Change Image")
          .borderRadius(20)
          .backgroundColor("#FF007DFF")
          .fontSize(20)
          .width(312)
          .onClick(() => { // 在父组件中，仍使用 this.uiStyle.endRenderXxx.xxx 更改属性
            this.uiStyle.needRenderImage.imageWidth = (this.uiStyle.needRenderImage.imageWidth + 30) % 160;
            this.uiStyle.needRenderImage.imageHeight = (this.uiStyle.needRenderImage.imageHeight + 30) % 160;
          })
      }
      .position({
        y: 616
      })
      .height('100%')
      .width('100%')
    }
    .opacity(this.isRenderColumn())
    .width('100%')
    .height('100%')
  }
}
@Entry
@Component
struct Page {
  @State uiStyle: UIStyle = new UIStyle();
  build() {
    Stack() {
      PageChild({
        uiStyle: this.uiStyle,
        needRenderTranslate: this.uiStyle.needRenderTranslate, // 传递needRenderxxx类给子组件
        needRenderFontSize: this.uiStyle.needRenderFontSize,
        needRenderBorderRadius: this.uiStyle.needRenderBorderRadius,
        needRenderPos: this.uiStyle.needRenderPos,
        needRenderSize: this.uiStyle.needRenderSize,
        needRenderAlpha: this.uiStyle.needRenderAlpha,
        needRenderScale: this.uiStyle.needRenderScale
      })
    }
    .backgroundColor("#F1F3F5")
  }
}

上述代码的运行效果如下。

优化后点击move按钮的脏节点更新耗时如下图：

修改后的代码将原来的大类中的十五个属性拆成了八个小类，并且在绑定的组件上也做了相应的适配。属性拆分遵循以下几点原则：

只作用在同一个组件上的多个属性可以被拆分进同一个新类，即示例中的NeedRenderImage。适用于组件经常被不关联的属性改变而引起刷新的场景，这个时候就要考虑拆分属性，或者重新考虑ViewModel设计是否合理。
经常被同时使用的属性可以被拆分进同一个新类，即示例中的NeedRenderScale、NeedRenderTranslate、NeedRenderPos、NeedRenderSize。适用于属性经常成对出现，或者被作用在同一个样式上的情况，例如.translate、.position、.scale等（这些样式通常会接收一个对象作为参数）。
可能被用在多个组件上或相对较独立的属性应该被单独拆分进一个新类，即示例中的NeedRenderAlpha，NeedRenderBorderRadius、NeedRenderFontSize。适用于一个属性作用在多个组件上或者与其他属性没有联系的情况，例如.opacity、.borderRadius等（这些样式通常相对独立）。

属性拆分的原理和属性合并类似，都是在嵌套场景下，状态管理无法观测二层以上的属性变化，所以不会因为二层的数据变化导致一层关联的其他属性被刷新，同时利用@Observed和@ObjectLink在父子节点间传递二层的对象，从而在子组件中正常的观测二层的数据变化，实现精准刷新。

使用@Track装饰器则无需做属性拆分，也能达到同样控制组件更新范围的作用。

@Observed
class UIStyle {
  @Track translateX: number = 0;
  @Track translateY: number = 0;
  @Track scaleX: number = 0.3;
  @Track scaleY: number = 0.3;
  @Track width: number = 336;
  @Track height: number = 178;
  @Track posX: number = 10;
  @Track posY: number = 50;
  @Track alpha: number = 0.5;
  @Track borderRadius: number = 24;
  @Track imageWidth: number = 78;
  @Track imageHeight: number = 78;
  @Track translateImageX: number = 0;
  @Track translateImageY: number = 0;
  @Track fontSize: number = 20;
}
@Component
struct SpecialImage {
  @ObjectLink uiStyle: UIStyle;
  private isRenderSpecialImage() : number { // 显示组件是否渲染的函数
    console.log("SpecialImage is rendered");
    return 1;
  }
  build() {
    Image($r('app.media.icon')) // 在API12及以后的工程中使用app.media.app_icon
      .width(this.uiStyle.imageWidth)
      .height(this.uiStyle.imageHeight)
      .margin({ top: 20 })
      .translate({
        x: this.uiStyle.translateImageX,
        y: this.uiStyle.translateImageY
      })
      .opacity(this.isRenderSpecialImage()) // 如果Image重新渲染，该函数将被调用
  }
}
@Component
struct PageChild {
  @ObjectLink uiStyle: UIStyle
  // 下面的函数用于显示组件是否被渲染
  private isRenderColumn() : number {
    console.log("Column is rendered");
    return 1;
  }
  private isRenderStack() : number {
    console.log("Stack is rendered");
    return 1;
  }
  private isRenderImage() : number {
    console.log("Image is rendered");
    return 1;
  }
  private isRenderText() : number {
    console.log("Text is rendered");
    return 1;
  }
  build() {
    Column() {
      SpecialImage({
        uiStyle: this.uiStyle
      })
      Stack() {
        Column() {
            Image($r('app.media.icon')) // 在API12及以后的工程中使用app.media.app_icon
              .opacity(this.uiStyle.alpha)
              .scale({
                x: this.uiStyle.scaleX,
                y: this.uiStyle.scaleY
              })
              .padding(this.isRenderImage())
              .width(300)
              .height(300)
        }
        .width('100%')
        .position({ y: -80 })
        Stack() {
          Text("Hello World")
            .fontColor("#182431")
            .fontWeight(FontWeight.Medium)
            .fontSize(this.uiStyle.fontSize)
            .opacity(this.isRenderText())
            .margin({ top: 12 })
        }
        .opacity(this.isRenderStack())
        .position({
          x: this.uiStyle.posX,
          y: this.uiStyle.posY
        })
        .width('100%')
        .height('100%')
      }
      .margin({ top: 50 })
      .borderRadius(this.uiStyle.borderRadius)
      .opacity(this.isRenderStack())
      .backgroundColor("#FFFFFF")
      .width(this.uiStyle.width)
      .height(this.uiStyle.height)
      .translate({
        x: this.uiStyle.translateX,
        y: this.uiStyle.translateY
      })
      Column() {
        Button("Move")
          .width(312)
          .fontSize(20)
          .backgroundColor("#FF007DFF")
          .margin({ bottom: 10 })
          .onClick(() => {
            animateTo({
              duration: 500
            },() => {
              this.uiStyle.translateY = (this.uiStyle.translateY + 180) % 250;
            })
          })
        Button("Scale")
          .borderRadius(20)
          .backgroundColor("#FF007DFF")
          .fontSize(20)
          .width(312)
          .onClick(() => {
            this.uiStyle.scaleX = (this.uiStyle.scaleX + 0.6) % 0.8;
          })
      }
      .position({
        y:666
      })
      .height('100%')
      .width('100%')


    }
    .opacity(this.isRenderColumn())
    .width('100%')
    .height('100%')


  }
}
@Entry
@Component
struct Page {
  @State uiStyle: UIStyle = new UIStyle();
  build() {
    Stack() {
      PageChild({
        uiStyle: this.uiStyle
      })
    }
    .backgroundColor("#F1F3F5")
  }
}
使用@Observed装饰或被声明为状态变量的类对象绑定组件

在开发过程中，会有“重置数据”的场景，将一个新创建的对象赋值给原有的状态变量，实现数据的刷新。如果不注意新创建对象的类型，可能会出现UI不刷新的现象。

@Observed
class Child {
  count: number;
  constructor(count: number) {
    this.count = count
  }
}
@Observed
class ChildList extends Array<Child> {
};
@Observed
class Ancestor {
  childList: ChildList;
  constructor(childList: ChildList) {
    this.childList = childList;
  }
  public loadData() {
    let tempList = [new Child(1), new Child(2), new Child(3), new Child(4), new Child(5)];
    this.childList = tempList;
  }


  public clearData() {
    this.childList = []
  }
}
@Component
struct CompChild {
  @Link childList: ChildList;
  @ObjectLink child: Child;


  build() {
    Row() {
      Text(this.child.count+'')
        .height(70)
        .fontSize(20)
        .borderRadius({
          topLeft: 6,
          topRight: 6
        })
        .margin({left: 50})
      Button('X')
        .backgroundColor(Color.Red)
        .onClick(()=>{
          let index = this.childList.findIndex((item) => {
            return item.count === this.child.count
          })
          if (index !== -1) {
            this.childList.splice(index, 1);
          }
        })
        .margin({
          left: 200,
          right:30
        })
    }
    .margin({
      top:15,
      left: 15,
      right:10,
      bottom:15
    })
    .borderRadius(6)
    .backgroundColor(Color.Grey)
  }
}
@Component
struct CompList {
  @ObjectLink@Watch('changeChildList') childList: ChildList;


  changeChildList() {
    console.log('CompList ChildList change');
  }


  isRenderCompChild(index: number) : number {
    console.log("Comp Child is render" + index);
    return 1;
  }


  build() {
    Column() {
      List() {
        ForEach(this.childList, (item: Child, index) => {
          ListItem() {
            CompChild({
              childList: this.childList,
              child: item
            })
              .opacity(this.isRenderCompChild(index))
          }


        })
      }
      .height('70%')
    }
  }
}
@Component
struct CompAncestor {
  @ObjectLink ancestor: Ancestor;


  build() {
    Column() {
      CompList({ childList: this.ancestor.childList })
      Row() {
        Button("Clear")
          .onClick(() => {
            this.ancestor.clearData()
          })
          .width(100)
          .margin({right: 50})
        Button("Recover")
          .onClick(() => {
            this.ancestor.loadData()
          })
          .width(100)
      }
    }
  }
}
@Entry
@Component
struct Page {
  @State childList: ChildList = [new Child(1), new Child(2), new Child(3), new Child(4),new Child(5)];
  @State ancestor: Ancestor = new Ancestor(this.childList)


  build() {
    Column() {
      CompAncestor({ ancestor: this.ancestor})
    }
  }
}

上述代码运行效果如下。

上述代码维护了一个ChildList类型的数据源，点击"X"按钮删除一些数据后再点击Recover进行恢复ChildList，发现再次点击"X"按钮进行删除时，UI并没有刷新，同时也没有打印出“CompList ChildList change”的日志。

代码中对数据源childList重新赋值时，是通过Ancestor对象的方法loadData。

  public loadData() {
    let tempList = [new Child(1), new Child(2), new Child(3), new Child(4), new Child(5)];
    this.childList = tempList;
  }

在loadData方法中，创建了一个临时的Child类型的数组tempList，并且将Ancestor对象的成员变量的childList指向了tempList。但是这里创建的Child[]类型的数组tempList其实并没有能被观测的能力（也就说它的变化无法主动触发UI刷新）。当它被赋值给childList之后，触发了ForEach的刷新，使得界面完成了重建，但是再次点击删除时，由于此时的childList已经指向了新的tempList代表的数组，并且这个数组并没有被观测的能力，是个静态的量，所以它的更改不会被观测到，也就不会引起UI的刷新。实际上这个时候childList里的数据已经减少了，只是UI没有刷新。

有些开发者会注意到，在Page中初始化定义childList的时候，也是以这样一种方法去进行初始化的。

@State childList: ChildList = [new Child(1), new Child(2), new Child(3), new Child(4),new Child(5)];
@State ancestor: Ancestor = new Ancestor(this.childList)

但是由于这里的childList实际上是被@State装饰了，根据当前状态管理的观测能力，尽管右边赋值的是一个Child[]类型的数据，它并没有被@Observed装饰，这里的childList却依然具备了被观测的能力，所以能够正常的触发UI的刷新。当去掉childList的@State的装饰器后，不去重置数据源，也无法通过点击“X”按钮触发刷新。

因此，需要将具有观测能力的类对象绑定组件，来确保当改变这些类对象的内容时，UI能够正常的刷新。

@Observed
class Child {
  count: number;
  constructor(count: number) {
    this.count = count
  }
}
@Observed
class ChildList extends Array<Child> {
};
@Observed
class Ancestor {
  childList: ChildList;
  constructor(childList: ChildList) {
    this.childList = childList;
  }
  public loadData() {
    let tempList = new ChildList();
    for (let i = 1; i < 6; i ++) {
      tempList.push(new Child(i));
    }
    this.childList = tempList;
  }


  public clearData() {
    this.childList = []
  }
}
@Component
struct CompChild {
  @Link childList: ChildList;
  @ObjectLink child: Child;


  build() {
    Row() {
      Text(this.child.count+'')
        .height(70)
        .fontSize(20)
        .borderRadius({
          topLeft: 6,
          topRight: 6
        })
        .margin({left: 50})
      Button('X')
        .backgroundColor(Color.Red)
        .onClick(()=>{
          let index = this.childList.findIndex((item) => {
            return item.count === this.child.count
          })
          if (index !== -1) {
            this.childList.splice(index, 1);
          }
        })
        .margin({
          left: 200,
          right:30
        })
    }
    .margin({
      top:15,
      left: 15,
      right:10,
      bottom:15
    })
    .borderRadius(6)
    .backgroundColor(Color.Grey)
  }
}
@Component
struct CompList {
  @ObjectLink@Watch('changeChildList') childList: ChildList;


  changeChildList() {
    console.log('CompList ChildList change');
  }


  isRenderCompChild(index: number) : number {
    console.log("Comp Child is render" + index);
    return 1;
  }


  build() {
    Column() {
      List() {
        ForEach(this.childList, (item: Child, index) => {
          ListItem() {
            CompChild({
              childList: this.childList,
              child: item
            })
              .opacity(this.isRenderCompChild(index))
          }


        })
      }
      .height('70%')
    }
  }
}
@Component
struct CompAncestor {
  @ObjectLink ancestor: Ancestor;


  build() {
    Column() {
      CompList({ childList: this.ancestor.childList })
      Row() {
        Button("Clear")
          .onClick(() => {
            this.ancestor.clearData()
          })
          .width(100)
          .margin({right: 50})
        Button("Recover")
          .onClick(() => {
            this.ancestor.loadData()
          })
          .width(100)
      }
    }
  }
}
@Entry
@Component
struct Page {
  @State childList: ChildList = [new Child(1), new Child(2), new Child(3), new Child(4),new Child(5)];
  @State ancestor: Ancestor = new Ancestor(this.childList)


  build() {
    Column() {
      CompAncestor({ ancestor: this.ancestor})
    }
  }
}

上述代码运行效果如下。

核心的修改点是将原本Child[]类型的tempList修改为具有被观测能力的ChildList类。

public loadData() {
    let tempList = new ChildList();
    for (let i = 1; i < 6; i ++) {
      tempList.push(new Child(i));
    }
    this.childList = tempList;
  }

ChildList类型在定义的时候使用了@Observed进行装饰，所以用new创建的对象tempList具有被观测的能力，因此在点击“X”按钮删除其中一条内容时，变量childList就能够观测到变化，所以触发了ForEach的刷新，最终UI渲染刷新。

合理使用ForEach/LazyForEach
减少使用LazyForEach的重建机制刷新UI

开发过程中通常会将LazyForEach和状态变量结合起来使用。

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: StringData[] = [];


  public totalCount(): number {
    return 0;
  }


  public getData(index: number): StringData {
    return this.originDataArray[index];
  }


  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }


  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }


  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }


  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }


  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }


  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }


  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}


class MyDataSource extends BasicDataSource {
  private dataArray: StringData[] = [];


  public totalCount(): number {
    return this.dataArray.length;
  }


  public getData(index: number): StringData {
    return this.dataArray[index];
  }


  public addData(index: number, data: StringData): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }


  public pushData(data: StringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }


  public reloadData(): void {
    this.notifyDataReload();
  }
}


class StringData {
  message: string;
  imgSrc: Resource;
  constructor(message: string, imgSrc: Resource) {
    this.message = message;
    this.imgSrc = imgSrc;
  }
}


@Entry
@Component
struct MyComponent {
  private data: MyDataSource = new MyDataSource();


  aboutToAppear() {
    for (let i = 0; i <= 9; i++) {
      this.data.pushData(new StringData(`Click to add ${i}`, $r('app.media.icon'))); // 在API12及以后的工程中使用app.media.app_icon
    }
  }


  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: StringData, index: number) => {
        ListItem() {
          Column() {
            Text(item.message).fontSize(20)
              .onAppear(() => {
                console.info("text appear:" + item.message);
              })
            Image(item.imgSrc)
              .width(100)
              .height(100)
              .onAppear(() => {
                console.info("image appear");
              })
          }.margin({ left: 10, right: 10 })
        }
        .onClick(() => {
          item.message += '0';
          this.data.reloadData();
        })
      }, (item: StringData, index: number) => JSON.stringify(item))
    }.cachedCount(5)
  }
}

上述代码运行效果如下。

可以观察到在点击更改message之后，图片“闪烁”了一下，同时输出了组件的onAppear日志，这说明组件进行了重建。这是因为在更改message之后，导致LazyForEach中这一项的key值发生了变化，使得LazyForEach在reloadData的时候将这一项ListItem进行了重建。Text组件仅仅更改显示的内容却发生了重建，而不是更新。而尽管Image组件没有需要重新绘制的内容，但是因为触发LazyForEach的重建，会使得同样位于ListItem下的Image组件重新创建。

当前LazyForEach与状态变量都能触发UI的刷新，两者的性能开销是不一样的。使用LazyForEach刷新会对组件进行重建，如果包含了多个组件，则会产生比较大的性能开销。使用状态变量刷新会对组件进行刷新，具体到状态变量关联的组件上，相对于LazyForEach的重建来说，范围更小更精确。因此，推荐使用状态变量来触发LazyForEach中的组件刷新，这就需要使用自定义组件。

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: StringData[] = [];


  public totalCount(): number {
    return 0;
  }


  public getData(index: number): StringData {
    return this.originDataArray[index];
  }


  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }


  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }


  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }


  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }


  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }


  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }


  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}


class MyDataSource extends BasicDataSource {
  private dataArray: StringData[] = [];


  public totalCount(): number {
    return this.dataArray.length;
  }


  public getData(index: number): StringData {
    return this.dataArray[index];
  }


  public addData(index: number, data: StringData): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }


  public pushData(data: StringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}


@Observed
class StringData {
  @Track message: string;
  @Track imgSrc: Resource;
  constructor(message: string, imgSrc: Resource) {
    this.message = message;
    this.imgSrc = imgSrc;
  }
}


@Entry
@Component
struct MyComponent {
  @State data: MyDataSource = new MyDataSource();


  aboutToAppear() {
    for (let i = 0; i <= 9; i++) {
      this.data.pushData(new StringData(`Click to add ${i}`, $r('app.media.icon'))); // 在API12及以后的工程中使用app.media.app_icon
    }
  }


  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: StringData, index: number) => {
        ListItem() {
          ChildComponent({data: item})
        }
        .onClick(() => {
          item.message += '0';
        })
      }, (item: StringData, index: number) => index.toString())
    }.cachedCount(5)
  }
}


@Component
struct ChildComponent {
  @ObjectLink data: StringData
  build() {
    Column() {
      Text(this.data.message).fontSize(20)
        .onAppear(() => {
          console.info("text appear:" + this.data.message)
        })
      Image(this.data.imgSrc)
        .width(100)
        .height(100)
    }.margin({ left: 10, right: 10 })
  }
}

上述代码运行效果如下。

可以观察到UI能够正常刷新，图片没有“闪烁”，且没有输出日志信息，说明没有对Text组件和Image组件进行重建。

这是因为使用自定义组件之后，可以通过@Observed和@ObjectLink配合去直接更改自定义组件内的状态变量实现刷新，而不需要利用LazyForEach进行重建。使用@Track装饰器分别装饰StringData类型中的message和imgSrc属性可以使更新范围进一步缩小到指定的Text组件。

在ForEach中使用自定义组件搭配对象数组

开发过程中经常会使用对象数组和ForEach结合起来使用，但是写法不当的话会出现UI不刷新的情况。

@Observed
class StyleList extends Array<TextStyles> {
};
@Observed
class TextStyles {
  fontSize: number;


  constructor(fontSize: number) {
    this.fontSize = fontSize;
  }
}
@Entry
@Component
struct Page {
  @State styleList: StyleList = new StyleList();
  aboutToAppear() {
    for (let i = 15; i < 50; i++)
    this.styleList.push(new TextStyles(i));
  }
  build() {
    Column() {
      Text("Font Size List")
        .fontSize(50)
        .onClick(() => {
          for (let i = 0; i < this.styleList.length; i++) {
            this.styleList[i].fontSize++;
          }
          console.log("change font size");
        })
      List() {
        ForEach(this.styleList, (item: TextStyles) => {
          ListItem() {
            Text("Hello World")
              .fontSize(item.fontSize)
          }
        })
      }
    }
  }
}

上述代码运行效果如下。

由于ForEach中生成的item是一个常量，因此当点击改变item中的内容时，没有办法观测到UI刷新，尽管日志表面item中的值已经改变了(这体现在打印了“change font size”的日志)。因此，需要使用自定义组件，配合@ObjectLink来实现观测的能力。

@Observed
class StyleList extends Array<TextStyles> {
};
@Observed
class TextStyles {
  fontSize: number;


  constructor(fontSize: number) {
    this.fontSize = fontSize;
  }
}
@Component
struct TextComponent {
  @ObjectLink textStyle: TextStyles;
  build() {
    Text("Hello World")
      .fontSize(this.textStyle.fontSize)
  }
}
@Entry
@Component
struct Page {
  @State styleList: StyleList = new StyleList();
  aboutToAppear() {
    for (let i = 15; i < 50; i++)
      this.styleList.push(new TextStyles(i));
  }
  build() {
    Column() {
      Text("Font Size List")
        .fontSize(50)
        .onClick(() => {
          for (let i = 0; i < this.styleList.length; i++) {
            this.styleList[i].fontSize++;
          }
          console.log("change font size");
        })
      List() {
        ForEach(this.styleList, (item: TextStyles) => {
          ListItem() {
            TextComponent({ textStyle: item})
          }
        })
      }
    }
  }
}

上述代码的运行效果如下。

使用@ObjectLink接受传入的item后，使得TextComponent组件内的textStyle变量具有了被观测的能力。在父组件更改styleList中的值时，由于@ObjectLink是引用传递，所以会观测到styleList每一个数据项的地址指向的对应item的fontSize的值被改变，因此触发UI的刷新。

这是一个较为实用的使用状态管理进行刷新的开发方式。


---

## See Also

- [ArkUI 主题](arkui.md)
- [页面路由与导航](routing-lifecycle.md)
- [网络请求与数据持久化](network-data.md)
