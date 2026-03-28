# ArkTS语言基础（离线参考）

> 来源：华为 HarmonyOS 开发者文档

---

## ArkTS简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-overview

ArkTS是HarmonyOS应用开发的官方高级语言。

ArkTS在TypeScript（简称TS）生态基础上做了进一步扩展，保持了TS的基本风格，同时通过规范定义强化开发期静态检查和分析，提升代码健壮性，并实现更好的程序执行稳定性和性能。对比标准TS的差异可以参考从TypeScript到ArkTS的适配规则。ArkTS同时也支持与TS/JavaScript（简称JS）高效互操作。

ArkTS基础类库和容器类库增强了语言的基础功能，提供包括高精度浮点运算、二进制Buffer、XML生成解析转换和多种容器库等能力，协助开发者简化开发工作，提升开发效率。

针对TS/JS并发能力支持有限的问题，ArkTS对并发编程API和能力进行了增强，提供了TaskPool和Worker两种并发API供开发者选择。另外，ArkTS进一步提出了Sendable的概念来支持对象在并发实例间的引用传递，提升ArkTS对象在并发实例间的通信性能。

方舟编译运行时（ArkCompiler）支持ArkTS、TS和JS的编译运行，目前主要分为ArkTS编译工具链和ArkTS运行时两部分。ArkTS编译工具链负责将高级语言编译为方舟字节码文件（*.abc），ArkTS运行时则负责在设备侧运行字节码文件，执行程序逻辑。

未来，ArkTS会结合应用开发/运行的需求持续演进，逐步提供并发能力增强、系统类型增强、分布式开发范式等更多特性。

模拟器支持情况

本Kit支持模拟器，但与真机存在部分能力差异，具体差异如下。

通用差异：请参见模拟器与真机的差异。
ArkTS基础库与ArkTS并发暂不支持模拟器。

---

## 初识ArkTS语言

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-get-started

ArkTS是HarmonyOS应用的默认开发语言，在TypeScript（简称TS）生态基础上做了扩展，保持TS的基本风格。通过规范定义，从而强化了开发期的静态检查和分析，提升了程序执行的稳定性和性能。

深入学习请看ArkTS学习路线和ArkTS视频课程。

自API version 10起，ArkTS进一步通过规范强化静态检查和分析，其主要特性及标准TS的差异包括从TypeScript到ArkTS的适配规则：

强制使用静态类型：静态类型是ArkTS最重要的特性之一。如果使用静态类型，那么程序中变量的类型就是确定的。同时，由于所有类型在程序实际运行前都是已知的，编译器可以验证代码的正确性，从而减少运行时的类型检查，有助于性能提升。

禁止在运行时改变对象布局：为实现最优性能，ArkTS禁止在程序执行期间更改对象布局。

限制运算符语义：为获得更好的性能并鼓励编写清晰的代码，ArkTS限制了部分运算符的语义。例如，一元加法运算符仅能作用于数字，不能用于其他类型变量。

不支持Structural typing：对Structural typing的支持需要在语言、编译器和运行时进行大量的考虑和仔细的实现，当前ArkTS不支持该特性。根据实际场景的需求和反馈，后续会重新考虑是否支持Structural typing。

ArkTS兼容TS/JavaScript（简称JS）生态，开发者可以使用TS/JS进行开发或复用已有代码。HarmonyOS系统对TS/JS支持的详细情况见兼容TS/JS的约束。

未来，ArkTS会结合应用开发/运行的需求持续演进，逐步增强并行和并发能力、扩展系统类型，以及引入分布式开发范式等更多特性。

如需深入了解ArkTS语言，可参考ArkTS具体指南。

---

## 从TypeScript到ArkTS的适配规则

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/typescript-to-arkts-migration-guide

ArkTS规范约束了TypeScript（简称TS）中影响开发正确性或增加运行时开销的特性。本文罗列了ArkTS中限制的TS特性，并提供重构代码的建议。ArkTS保留了TS大部分语法特性，未在本文中约束的TS特性，ArkTS完全支持。例如，ArkTS支持自定义装饰器，语法与TS一致。按本文约束进行代码重构后，代码仍为合法有效的TS代码。

示例

包含关键字var的原始TypeScript代码：

function addTen(x: number): number {
  var ten = 10;
  return x + ten;
}

重构后的代码：

function addTen(x: number): number {
  let ten = 10;
  return x + ten;
}

级别

约束分为两个级别：错误、警告。

错误：必须要遵从的约束。如果不遵从该约束，将会导致程序编译失败。
警告：推荐遵从的约束。尽管现在违反该约束不会影响编译流程，但是在将来，违反该约束可能会导致程序编译失败。

不支持的特性

目前，不支持的特性主要包括：

与降低运行时性能的动态类型相关的特性。
需要编译器额外支持从而导致项目构建时间增加的特性。

根据开发者的反馈和实际场景的数据，未来将逐步减少不支持的特性。

概述

本节罗列了ArkTS不支持或部分支持的TypeScript特性。完整的列表以及详细的代码示例和重构建议，请参考约束说明。更多案例请参考适配指导案例。

强制使用静态类型

静态类型是ArkTS的重要特性之一。当程序使用静态类型时，所有类型在编译时已知，这有助于开发者理解代码中的数据结构。编译器可以提前验证代码的正确性，减少运行时的类型检查，从而提升性能。

基于上述考虑，ArkTS中禁止使用any类型。

示例

// 不支持：
let res: any = some_api_function('hello', 'world');
// 支持：
class CallResult {
  public succeeded(): boolean {
    return false;
  }
  public errorMessage(): string {
    return '123';
  }
}
function some_api_function(param1: string, param2: string): CallResult {
  return new CallResult();
}


let res: CallResult = some_api_function('hello', 'world');
if (!res.succeeded()) {
  console.info('Call failed: ' + res.errorMessage());
}

any类型在TypeScript中并不常见，仅约1%的TypeScript代码库使用。代码检查工具（例如ESLint）也制定了一系列规则来禁止使用any。因此，虽然禁止any将导致代码重构，但重构量很小，有助于整体性能提升。

---

## 从Swift到ArkTS的迁移指导

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/getting-started-with-arkts-for-swift-programmers

对于熟悉Swift的开发者而言，ArkTS作为新的开发语言，带来了全新的开发体验与机遇。ArkTS在语法和编程范式上不仅继承了现代语言的特性，还针对生态进行了深度优化。理解Swift与ArkTS的差异和共性，能够帮助开发者快速上手应用开发，避开常见的编程误区。

本文档基于Swift语言对ArkTS语言进行对比和介绍。如需更详细的了解，可参考ArkTS语言介绍。

探索Swift与ArkTS的差异

本文档将帮助Swift开发者梳理在转向ArkTS开发过程中会遇到的误解和陷阱。ArkTS的语法、类型系统以及应用开发模式与Swift存在差异，在学习过程中需特别注意这些关键区别。建议先掌握ArkTS的基础语法和运行时行为，再重点对比其与Swift的不同之处。

基础语法
变量声明

ArkTS示例：

// 类型注解（类似Swift）。
let age: number = 20;
const program: string = 'ArkTS';


// 类型推断（类似Swift的局部变量类型推断）。
let version = 5.0;
基础数据类型
Swift类型	ArkTS类型	示例代码	核心差异说明
Bool	boolean	let isDone: boolean = false;	定义方式相似，均用于逻辑判断。
Int8	number	let count: number = 10;	

Swift的Int8为8位整数。

ArkTS统一用number表示小整数类型。


Int16	number	let count: number = 10;	

Swift的Int16为16位整数。

ArkTS统一用number表示小整数类型。


Int32	number	let count: number = 10;	

Swift的Int32为32位整数。

ArkTS的number是双精度浮点型，可存储整数和浮点数。


Int64	number	let largeNum: number = 9007199254740991;	

Swift需处理大整数。

ArkTS用同一类型表示。


Float	number	let pi: number = 3.14;	

Swift需显式指定Float。

ArkTS直接使用number。


Double	number	let e: number = 2.71828;	

Swift区分Float和Double。

ArkTS统一用number表示所有数值类型。


Character	string	let c: string = 'a';	ArkTS无Character类型，单字符场景使用string。
String	string	let message: string = 'Hello';	定义方式类似，但ArkTS字符串支持模板字面量和更灵活的操作。
复杂数据类型
Swift类型体系	ArkTS类型体系	ArkTS示例代码	核心差异说明
数组：var arr: [Int] = [1, 2, 3]	Array：let arr: number[] = [1, 2, 3];	

// 动态长度语法糖

let dynamicArr = [4, 5, 6];

	

Swift数组长度可变。

ArkTS的Array是动态数组，支持push/pop等操作；可直接用[]简化初始化。数组不会越界，当数组下标超过数组长度时会得到undefined。


集合 - Set：var mySet: Set<String> = ["a", "b"]	Set：let mySet: Set<string> = new Set(["a", "b"]);	

mySet.add('c'); // 向集合内添加元素

for (const item of mySet) {...); // 迭代访问

	

Swift集合通过类型声明。

ArkTS中集合的类型较灵活，适合动态场景。


字典 - Dictionary：var dict: [String: Int] = ["key": 1]	Map：let map: Map<string, number> = new Map();	

map.set('key', 1); // 添加键值对

let value = map.get('key'); // 获取值

map.has('key'); // 检查键是否存在

	

Swift的Dictionary需显式声明类型。

ArkTS的Map操作更直接，支持链式调用。


协议：protocol Shape { func area() -> Double }	interface：interface Shapes { area(): number; }	

class Rectangles implements Shapes {

public width: number = 0;

public height: number = 0;

area(): number { return this.width * this.height; }

}

	语法结构相似，但ArkTS接口实现无需显式修饰符，且支持可选属性。
类：class Circle: Shape { /* 类定义 */ }	class：class Circles implements Shape { /* 类定义 */ }	

class Circles {

radius: number;

constructor(radius: number = 10) { // 支持参数默认值

this.radius = radius;

}

}

	ArkTS类支持属性默认值、可选参数，语法更简洁。
枚举：enum Color { case red, green, blue }	enum：enum Colors { Red, Green, Blue }	

enum Colors { Red = 1, Green, Blue };

let color = Colors.Green; // 值为2（自动递增）

	基本概念一致，但ArkTS枚举不支持Swift中的自定义构造函数和方法，仅支持简单的数值或字符串枚举。
函数与闭包

Swift和ArkTS在函数方面语法趋同，细节上有差别。

相似点：常规函数定义和箭头函数。

ArkTS示例： 函数定义

// 常规函数定义，与Swift类似。
function add(x: number, y: number): number {
    return x + y;
}


// 简洁的箭头函数形式，类似Swift的闭包语法。
const multiply = (a: number, b: number): number => a * b;

差异点：

ArkTS提供类型声明层面的多态，仅用于类型检查和文档提示，实际只有一个实现函数。

ArkTS示例： ArkTS函数重载

function foo(x: number): void;            /*  第一个函数定义。  */
function foo(x: string): void;            /*  第二个函数定义。  */
function foo(x: number | string): void {  /*  函数实现。       */
}


foo(123);     //  OK，使用第一个定义。
foo('aa'); // OK，使用第二个定义。
ArkTS可选参数使用?，如function foo(name?: string)，而非Swift的默认值语法。
function foo(name?: string){}  /*  name为可选参数。  */


foo('hello');     //  OK，传入name参数。
foo();     //  OK，不传name参数。
基础类库

ArkTS基础类库和容器类库增强了语言的基础功能，包括高精度浮点运算、二进制Buffer、XML生成解析转换和多种容器库等能力，协助开发者简化开发工作，提升开发效率。

语言结构

Swift是一种融合面向对象、函数式和协议导向范式的现代语言，强调安全性、性能与简洁性，适用于跨平台开发。

ArkTS融合声明式UI、函数式和面向对象范式，通过响应式系统和跨设备适配能力，高效构建多端一致的高性能应用。

模块与包管理

在Swift中，开发者使用模块（module）来组织代码，通过import语句引入其他模块中的类。

ArkTS也有自己的模块和包管理机制，同样通过import语句引入其他模块中的功能。

ArkTS示例：

// 引入ArkTS标准库中的ArkTS容器集。


import { collections } from '@kit.ArkTS';

由于ArkTS的模块系统更注重模块化开发和代码复用，能够更便捷地管理不同功能模块之间的依赖关系，所以在使用方式上，与Swift的模块管理会有所区别。

类与命名空间特性

ArkTS的类系统在语法层面与Swift相似，但在高阶特性上展现出更现代的设计理念。

特性	Swift实现方式	ArkTS实现方式	说明
命名空间组织	嵌套结构/内部类	namespace关键字或模块文件结构。	支持显式命名空间与模块化组织的混合模式。
类继承机制	基于类的继承体系	基于原型链的继承机制。	语法相似但底层机制不同。
类成员可见性	public/private/internal	同Swift，但支持模块级可见性控制。	增加了模块导出控制的维度。

命名空间管理

ArkTS支持显式命名空间（namespace）和模块化组织。

ArkTS示例：

namespace Models {
    export class User {
        // 实现细节。
    }
    
    export interface Repository {
        // 接口定义。
    }
}

相比Swift的模块+内部类组合，ArkTS的命名空间能更直观地实现代码分层。

异步编程模型

单线程vs多线程

Swift使用async/await + Task实现异步编程，使用多线程和DispatchQueue实现并发。

ArkTS基于事件循环，使用Promise/async/await处理异步，避免阻塞主线程。

错误处理

Swift的同步代码通过try/catch捕获异常，异步异常需特殊处理。

ArkTS中未捕获的Promise错误可能导致静默失败，需显式使用try/catch或.catch。

this的绑定

Swift的方法中，self始终指向类的实例对象，由代码结构在编译时确定。在方法中，self指向调用该方法的对象实例，无法通过调用方式改变self的指向。

Swift示例：

class MyClass {
  func method() {
    print(self) // 始终指向MyClass的实例。
  }
}

ArkTS的this指向取决于函数调用时的上下文。

ArkTS示例：

class A {
  bar: string = 'I am A';


  foo() {
    console.info(this.bar);
  }
}


class B {
  bar: string = 'I am B';


  callFunction(fn: () => void) {
    fn();
  }
}


function callFunction(fn: () => void) {
  fn();
}


let a: A = new A();
let b: B = new B();


callFunction(a.foo); // 程序crash。this的上下文发生了变化。
b.callFunction(a.foo); // 程序crash。this的上下文发生了变化。
b.callFunction(a.foo.bind(b)) // 输出'I'm B'。
类型系统

ArkTS与Swift的类型系统也存在差异。

类型推断与可选类型

相较于Swift需要显式类型声明和严格的nil检查，ArkTS的类型系统提供了更灵活的表达方式。

ArkTS具有强大的类型推断能力，编译器能够根据上下文自动推断出变量的类型，所以很多时候不需要显式声明变量的类型。

ArkTS示例：

let num = 10; // 编译器自动推断num为number类型。

同时，ArkTS支持可选类型，通过在类型后面添加问号（?）来表示该变量可以为null或undefined。

ArkTS示例：

interface Person {
  name: string;
  age?: number;  // age是可选属性。
}


const person: Person = {
  name: "Alice",
};
联合类型

联合类型这种类型组合能力为复杂场景提供了更强的表达力，是ArkTS类型系统的重要创新点。

ArkTS支持联合类型（|）。联合类型表示一个值可以是多种类型中的一种。

ArkTS示例：

// 联合类型示例。


let value: string | number;
value = 'hello';
value = 123;

---

## ArkTS编程规范

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-coding-style-guide

目标和适用范围

本文参考业界标准和实践，结合ArkTS语言特点，提供编码指南，以提高代码的规范性、安全性和性能。

本文适用于使用ArkTS编写的开发场景。

规则来源

ArkTS在保持TypeScript基本语法风格的基础上，进一步强化静态检查和分析。本文部分规则筛选自《OpenHarmony应用TS&JS编程指南》，为ArkTS语言新增的语法添加了规则，旨在提高代码可读性、执行性能。

章节概览
代码风格

包含命名和格式。

编程实践

包含声明与初始化、数据类型、运算与表达式、异常等。

参考了《OpenHarmony应用TS&JS编程指南》中的规则，去除了ArkTS语言不涉及的部分，并为新增的语法添加了规则。

术语和定义
术语	缩略语	中文解释
ArkTS	无	ArkTS编程语言
TypeScript	TS	TypeScript编程语言
JavaScript	JS	JavaScript编程语言
ESObject	无	在ArkTS跨语言调用的场景中，用以标注JS/TS对象的类型
总体原则

规则分为两个级别：要求和建议。

要求：表示原则上应该遵从。本文所有内容目前均为针对ArkTS的要求。

建议：表示该条款属于最佳实践，可结合实际情况考虑是否纳入。

命名
为标识符取一个好名字，提高代码可读性

【描述】

好的标识符命名应遵循以下原则：

清晰表达意图，避免使用单个字母或非标准缩写命名。
使用正确的英文单词并符合英文语法，不要使用中文拼音。
确保语句清晰，避免歧义。
类名、枚举名、命名空间名采用UpperCamelCase风格

【级别】建议

【描述】

类采用首字母大写的驼峰命名法。

类名通常是名词或名词短语，例如Person、Student、Worker。不应使用动词，也应该避免类似Data、Info这样的模糊词。

【正例】

// 类名
class User {
  username: string


  constructor(username: string) {
    this.username = username;
  }


  sayHi() {
    console.info('hi' + this.username);
  }
}


// 枚举名
enum UserType {
  TEACHER = 0,
  STUDENT = 1
};


// 命名空间
namespace Base64Utils {
  function encrypt() {
    // todo encrypt
  }


  function decrypt() {
    // todo decrypt
  }
};
变量名、方法名、参数名采用lowerCamelCase风格

【级别】建议

【描述】

函数的命名通常是动词或动词短语，采用小驼峰命名。示例如下：

load + 属性名()
put + 属性名()
is + 布尔属性名()
has + 名词/形容词()
动词()
动词 + 宾语()

变量名通常是名词或名词短语，采用小驼峰命名，便于理解。

【正例】

let msg = 'Hello world';


function sendMsg(msg: string) {
  // todo send message
}


let userName = 'Zhangsan';


function findUser(userName: string) {
  // todo find user by user name
}
常量名、枚举值名采用全部大写，单词间使用下划线隔开

【级别】建议

【描述】

常量命名，应该由全大写单词与下划线组成，单词间用下划线分割。常量命名要尽量表达完整的语义。

【正例】

const MAX_USER_SIZE = 10000;


enum UserType {
  TEACHER = 0,
  STUDENT = 1
};
避免使用否定的布尔变量名，布尔型的局部变量或方法需加上表达是非意义的前缀

【级别】建议

【描述】

布尔型的局部变量建议加上表达是非意义的前缀，比如is，也可以是has、can、should等。但是，当使用逻辑非运算符，并出现双重否定时，会出现理解问题，比如!isNotError，难以理解。因此，应避免定义否定的布尔变量名。

【反例】

let isNoError = true;
let isNotFound = false;


function empty() {}
function next() {}

【正例】

let isError = false;
let isFound = true;


function isEmpty() {}
function hasNext() {}
格式
使用空格缩进，禁止使用tab字符

【级别】建议

【描述】

只允许使用空格(space)进行缩进。

建议大部分场景优先使用2个空格，换行导致的缩进优先使用4个空格。

不允许插入制表符Tab。当前几乎所有的集成开发环境（IDE）和代码编辑器都支持配置将Tab键自动扩展为2个空格输入，应在代码编辑器中配置使用空格进行缩进。

【正例】

class DataSource {
  id: number = 0
  title: string = ''
  content: string = ''
}


const dataSource: DataSource[] = [
  {
    id: 1,
    title: 'Title 1',
    content: 'Content 1'
  },
  {
    id: 2,
    title: 'Title 2',
    content: 'Content 2'
  }


];


function test(dataSource: DataSource[]) {
  if (!dataSource.length) {
    return;
  }


  for (let data of dataSource) {
    if (!data || !data.id || !data.title || !data.content) {
      continue;
    }
    // some code
  }


  // some code
}
行宽不超过120个字符

【级别】建议

【描述】

代码行宽不宜过长，否则不利于阅读。

控制行宽可以间接引导程序员缩短函数和变量的命名，减少嵌套层数，精炼注释，从而提升代码可读性。

建议每行字符数不超过120个，除非需要显著增加可读性（超过120个），且不会隐藏信息。

例外：如果一行注释包含了超过120个字符的命令或URL，则可以保持一行，以方便复制、粘贴和通过grep查找；预处理的error信息在一行便于阅读和理解，即使超过120个字符。

条件语句和循环语句的实现建议使用大括号

【级别】建议

【描述】

在if、for、do、while等语句的执行体加大括号{}是一种最佳实践，因为省略大括号可能导致错误，并且降低代码的清晰度。

【反例】

let condition = true;
if (condition)
  console.info('success');
for (let idx = 0; idx < 5; ++idx)
  console.info('', idx);

【正例】

let condition = true;
if (condition) {
  console.info('success');
}
for (let idx = 0; idx < 5; ++idx) {
  console.info('', idx);
}
switch语句的case和default需缩进一层

【级别】建议

【描述】

switch的case和default要缩进一层（2个空格）。开关标签之后换行的语句，需再缩进一层（2个空格）。

【正例】

switch (condition) {
  case 0: {
    doSomething();
    break;
  }
  case 1: {
    doOtherthing();
    break;
  }
  default:
    break;
}
表达式换行需保持一致性，运算符放行末

【级别】建议

【描述】

当语句过长或可读性不佳时，需要在合适的地方进行换行。

换行时将操作符放在行末，表示“未结束，后续还有”，保持与常用的格式化工具的默认配置一致。

【正例】

// 假设条件语句超出行宽
if (userCount > MAX_USER_COUNT ||
  userCount < MIN_USER_COUNT) {
  doSomething();
}
多个变量定义和赋值语句不允许写在一行

【级别】要求

【描述】

每个语句的变量声明都应只声明一个变量。

这种方式更便于添加变量声明，无需考虑将分号改为逗号，以免引入错误。此外，每个语句只声明一个变量，使用调试器逐个调试也很方便，而不是一次跳过所有变量。

【反例】

let maxCount = 10, isCompleted = false;
let pointX, pointY;
pointX = 10; pointY = 0;

【正例】

let maxCount = 10;
let isCompleted = false;
let pointX = 0;
let pointY = 0;
空格应该突出关键字和重要信息，避免不必要的空格

【级别】建议

【描述】

空格应该突出关键字和重要信息。总体建议如下：

if, for, while, switch等关键字与左括号(之间加空格。
在函数定义和调用时，函数名称与参数列表的左括号(之间不加空格。
关键字else或catch与其之前的大括号}之间加空格。
任何打开大括号({)之前加空格，有两个例外：

a) 在作为函数的第一个参数或数组中的第一个元素时，对象之前不用加空格，例如：foo({ name: 'abc' })。

b) 在模板中，不用加空格，例如：abc${name}。

5. 二元操作符(+ - * = < > <= >= === !== && ||)前后加空格；三元操作符(? :)符号两侧均加空格。

6. 数组初始化中的逗号和函数中多个参数之间的逗号后加空格。

7. 在逗号(,)或分号(;)之前不加空格。

8. 数组的中括号([])内侧不要加空格。

9. 不要出现多个连续空格。在某行中，多个空格若不是用来作缩进的，通常是个错误。

【反例】

// if 和左括号 ( 之间没有加空格
if(isJedi) {
  fight();
}


// 函数名fight和左括号 ( 之间加了空格
function fight (): void {
  console.info('Swooosh!');
}

【正例】

// if 和左括号之间加一个空格
if (isJedi) {
  fight();
}


// 函数名fight和左括号 ( 之间不加空格
function fight(): void {
  console.info('Swooosh!');
}

【反例】

if (flag) {
  // ...
}else { // else 与其前面的大括号 } 之间没有加空格
  // ...
}

【正例】

if (flag) {
  // ...
} else { // else 与其前面的大括号 } 之间增加空格
  // ...
}

【正例】

function foo() {  // 函数声明时，左大括号 { 之前加个空格
  // ...
}


bar('attr', {  // 左大括号前加个空格
  age: '1 year',
  sbreed: 'Bernese Mountain Dog',
});

【正例】

const arr = [1, 2, 3];  // 数组初始化中的逗号后面加个空格，逗号前面不加空格
myFunc(bar, foo, baz);  // 函数的多个参数之间的逗号后加个空格，逗号前面不加空格
建议字符串使用单引号

【级别】建议

【描述】

为了保持代码一致性和可读性，建议使用单引号。

【反例】

let message = "world";
console.info(message);

【正例】

let message = 'world';
console.info(message);
对象字面量属性超过4个，需要都换行

【级别】建议

【描述】

对象字面量的属性应保持一致的格式：要么每个属性都换行，要么所有属性都在同一行。当对象字面量的属性超过4个时，建议统一换行。

【反例】

interface I {
  name: string
  age: number
  value: number
  sum: number
  foo: boolean
  bar: boolean
}


let obj: I = { name: 'tom', age: 16, value: 1, sum: 2, foo: true, bar: false }

【正例】

interface I {
  name: string
  age: number
  value: number
  sum: number
  foo: boolean
  bar: boolean
}


let obj: I = {
  name: 'tom',
  age: 16,
  value: 1,
  sum: 2,
  foo: true,
  bar: false
}
把else/catch放在if/try代码块关闭括号的同一行

【级别】建议

【描述】

编写条件语句时，建议将else放在if代码块关闭括号的同一行。同样，编写异常处理语句时，建议将catch放在try代码块关闭括号的同一行。

【反例】

if (isOk) {
  doThing1();
  doThing2();
}
else {
  doThing3();
}

【正例】

if (isOk) {
  doThing1();
  doThing2();
} else {
  doThing3();
}

【反例】

try {
  doSomething();
}
catch (err) {
  // 处理错误
}

【正例】

try {
  doSomething();
} catch (err) {
  // 处理错误
}
大括号{和语句在同一行

【级别】建议

【描述】

应保持一致的大括号风格。建议将大括号置于控制语句或声明语句的同一行。

【反例】

function foo()
{
  // ...
}

【正例】

function foo() {
  // ...
}
编程实践
建议添加类属性的可访问修饰符

【级别】建议

【描述】

ArkTS提供了private, protected和public可访问修饰符。默认情况下，属性的可访问修饰符为public。选取适当的可访问修饰符可以提升代码的安全性和可读性。注意：如果类中包含private属性，无法通过对象字面量初始化该类。

【反例】

class C {
  count: number = 0


  getCount(): number {
    return this.count
  }
}

【正例】

class C {
  private count: number = 0


  public getCount(): number {
    return this.count
  }
}
不建议省略浮点数小数点前后的0

【级别】建议

【描述】

ArkTS中，浮点值包含一个小数点，不要求小数点之前或之后必须有一个数字。在小数点前面和后面都添加数字可以提高代码的可读性。

【反例】

const num = .5;
const num = 2.;
const num = -.7;

【正例】

const num = 0.5;
const num = 2.0;
const num = -0.7;
判断变量是否为Number.NaN时必须使用Number.isNaN()方法

【级别】要求

【描述】

在ArkTS中，Number.NaN是Number类型的一个特殊值。它被用来表示非数值，这里的数值是指在IEEE浮点数算术标准中定义的双精度64位格式的值。

在ArkTS中，Number.NaN的独特之处在于它不等于任何值，包括其本身。与Number.NaN进行比较时，结果是令人困惑的：Number.NaN !== Number.NaN 和 Number.NaN != Number.NaN 的值都是 true。

因此，必须使用Number.isNaN()函数来测试一个值是否是Number.NaN。

【反例】

if (foo == Number.NaN) {
  // ...
}


if (foo != Number.NaN) {
  // ...
}

【正例】

if (Number.isNaN(foo)) {
  // ...
}


if (!Number.isNaN(foo)) {
  // ...
}
数组遍历优先使用Array对象方法

【级别】要求

【描述】

对于数组遍历，应该优先使用Array对象方法，如：forEach(), map(), every(), filter(), find(), findIndex(), reduce(), some()。

【反例】

const numbers = [1, 2, 3, 4, 5];
// 依赖已有数组来创建新的数组时，通过for遍历，生成一个新数组
const increasedByOne: number[] = [];
for (let i = 0; i < numbers.length; i++) {
  increasedByOne.push(numbers[i] + 1);
}

【正例】

const numbers = [1, 2, 3, 4, 5];
// better: 使用map方法是更好的方式
const increasedByOne: number[] = numbers.map(num => num + 1);
不要在控制性条件表达式中执行赋值操作

【级别】要求

【描述】

控制性条件表达式用于 if、while、for 以及 ?: 等条件判断语句中。

在控制性条件表达式中执行赋值容易导致意外行为，且降低代码的可读性。

【反例】

// 在控制性判断中赋值不易理解
if (isFoo = false) {
  // ...
}

【正例】

const isFoo = false; // 在上面赋值，if条件判断中直接使用
if (isFoo) {
  // ...
}
在finally代码块中，不要使用return、break、continue或抛出异常，避免finally块非正常结束

【级别】要求

【描述】

在finally代码块中，直接使用return、break、continue、throw语句或调用方法时未处理异常，会导致finally代码块无法正常结束。finally代码块异常结束会影响try或catch代码块中异常的抛出，也可能影响方法的返回值。因此，必须确保finally代码块正常结束。

【反例】

function foo() {
  try {
    // ...
    return 1;
  } catch (err) {
    // ...
    return 2;
  } finally {
    return 3;
 }
}

【正例】

function foo() {
  try {
    // ...
    return 1;
  } catch (err) {
    // ...
    return 2;
  } finally {
    console.info('XXX!');
  }
}
避免使用ESObject

【级别】建议

【描述】

ESObject主要用于ArkTS和TS/JS的跨语言调用场景中的类型标注。在非跨语言调用场景中使用ESObject标注类型，会引入不必要的跨语言调用，导致额外的性能开销。

【反例】

// lib.ets
export interface I {
  sum: number
}


export function getObject(value: number): I {
  let obj: I = { sum: value };
  return obj
}


// app.ets
import { getObject } from 'lib'
let obj: ESObject = getObject(123);

【正例】

// lib.ets
export interface I {
  sum: number
}


export function getObject(value: number): I {
  let obj: I = { sum: value };
  return obj
}
// Index.ets
import { getObject2, I } from './lib';
// ...
let obj2: I = getObject2(123);
使用T[]表示数组类型

【级别】建议

【描述】

ArkTS提供了两种数组类型的表示方式：T[]和Array<T>。建议所有数组类型均使用T[]表示，以提高代码可读性。

【反例】

let x: Array<number> = [1, 2, 3];
let y: Array<string> = ['a', 'b', 'c'];

【正例】

// 统一使用T[]语法
let x: number[] = [1, 2, 3];
let y: string[] = ['a', 'b', 'c'];


---

## See Also

- [ArkTS 主题](arkts.md)
- [ArkTS 基础类库](arkts-stdlib.md)
- [ArkTS 并发](arkts-concurrency.md)
