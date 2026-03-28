# ArkTS并发（离线参考）

> 来源：华为 HarmonyOS 开发者文档

---

## 异步并发 (Promise和async/await)

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/async-concurrency-overview

Promise和async/await是标准的JS异步语法，提供异步并发能力。异步代码执行时会被挂起，稍后继续执行，确保同一时间只有一段代码在运行。以下是典型的异步并发使用场景：

I/O 非阻塞操作：网络请求、文件读写、定时器等。

任务轻量且无 CPU 阻塞：单次任务执行时间短。

逻辑依赖清晰：任务有明确的顺序或并行关系。

异步并发是一种编程语言的特性，允许程序在执行某些操作时不必等待其完成，可以继续执行其他异步代码。

Promise

Promise是一种用于处理异步操作的对象，可将异步操作转换为类似同步操作的风格，便于代码编写和维护。Promise通过状态机制管理异步操作的不同阶段，有三种状态：pending（进行中）、fulfilled（已完成，也叫resolved）和rejected（已拒绝）。创建后处于pending状态，异步操作完成后转换为fulfilled或rejected状态。

Promise提供了then、catch、finally方法来注册回调函数，以处理异步操作的成功或失败结果。当Promise状态改变时，回调函数会被加入微任务队列等待执行，依赖事件循环机制在宏任务执行完成后优先执行微任务，从而保证回调函数的异步调度。

最基本的用法是通过构造函数实例化一个Promise对象，传入一个带有两个参数的函数，称为executor函数。executor函数接收两个参数：resolve和reject，分别表示异步操作成功和失败时的回调函数。

例如，以下代码创建了一个Promise对象并模拟了一个异步操作：

const promise: Promise<number> = new Promise((resolve: Function, reject: Function) => {
  setTimeout(() => {
    const randomNumber: number = Math.random();
    if (randomNumber > 0.5) {
      resolve(randomNumber);
    } else {
      reject(new Error('Random number is too small'));
    }
  }, 1000);
})

在上述代码中，setTimeout函数模拟了一个异步操作，1秒后生成一个随机数。如果随机数大于0.5，调用resolve回调函数并传递该随机数；否则调用reject回调函数并传递一个错误对象。

Promise对象创建后，可以使用then方法和catch方法指定fulfilled状态和rejected状态的回调函数。then方法可接受两个参数，一个处理fulfilled状态的函数，另一个处理rejected状态的函数。只传一个参数则表示当Promise对象状态变为fulfilled时，then方法会自动调用这个回调函数，并将Promise对象的结果作为参数传递给它。使用catch方法注册一个回调函数，用于处理“失败”的结果，即捕获Promise的状态改变为rejected状态或操作失败抛出的异常。Promise还可以使用finally注册回调函数，无论Promise最终状态如何（fulfilled或rejected），都会执行该回调函数。例如：

const promise: Promise<number> = new Promise((resolve: Function, reject: Function) => {
  setTimeout(() => {
    const randomNumber: number = Math.random();
    if (randomNumber > 0.5) {
      resolve(randomNumber);
    } else {
      reject(new Error('Random number is too small'));
    }
  }, 1000);
})


// 使用 then 方法定义成功和失败的回调
promise.then((result: number) => {
  console.info(`The number for success is ${result}`); // 成功时执行
}, (error: Error) => {
  console.error(error.message); // 失败时执行
}
);


// 使用 then 方法定义成功的回调，catch 方法定义失败的回调
promise.then((result: number) => {
  console.info(`Random number is ${result}`); // 成功时执行
}).catch((error: Error) => {
  console.error(error.message); // 失败时执行
});


// 无论成功还是失败都会执行
promise.finally(() => {
  console.info('finally complete');
})

在上述代码中，then方法的回调函数接收Promise对象的成功结果，并输出至控制台。如果Promise对象进入rejected状态，catch方法的回调函数接收错误对象，并输出至控制台。

说明

当Promise被reject且未通过catch方法处理时，会触发globalUnhandledRejectionDetected事件。可使用errorManager.on('globalUnhandledRejectionDetected')接口监听该事件，以全局捕获未处理的Promise reject。

async/await

async/await是用于处理异步操作的Promise语法糖，使编写异步代码更加简单和易读。使用async关键字声明异步函数，并使用await关键字等待Promise的解析（fulfilled或rejected），以同步方式编写异步操作的代码。

async函数返回Promise对象，实现异步操作。函数内部可包含零个或多个await关键字，await会暂停执行，直到关联的Promise完成状态转换（fulfilled或rejected）。若函数执行过程中抛出异常，该异常将直接触发返回的Promise进入rejected状态，错误对象可通过catch方法或then的第二个回调参数捕获。

下面是一个使用async/await的示例，模拟同步方法执行异步操作的场景，3秒后返回一个字符串。

async function myAsyncFunction(): Promise<string> {
  const result: string = await new Promise((resolve: Function) => {
    setTimeout(() => {
      resolve('Hello, world!');
    }, 3000);
  });
  console.info(result); // 输出： Hello, world!
  return result;
}


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
          .onClick(async () => {
            let res = await myAsyncFunction();
            console.info('res is: ' + res);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}

在上述示例代码中，使用await等待Promise解析，并存储在result变量中。

需要注意的是，等待异步操作时，需将操作放在async函数中，并搭配await使用，且await关键字只在async函数内有效。同时也可使用try/catch块来捕获异常。

async function myAsyncFunction(): Promise<void> {
  try {
    const result: string = await new Promise((resolve: Function) => {
      resolve('Hello, world!');
    });
    console.info(result); // 输出： Hello, world!
  } catch (e) {
    console.error(`Get exception: ${e}`);
  }
}


myAsyncFunction();

---

## TaskPool

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/taskpool-introduction

TaskPool为应用程序提供多线程环境，降低资源消耗并提高系统性能。无需管理线程生命周期。具体接口信息及使用方法，请参见TaskPool。

TaskPool运作机制

TaskPool运作机制示意图

TaskPool支持在宿主线程提交任务到任务队列，系统选择合适的工作线程执行任务，并将结果返回给宿主线程。接口易用，支持任务执行、取消和指定优先级。通过系统统一线程管理，结合动态调度和负载均衡算法，可以节约系统资源。系统默认启动一个任务工作线程，任务多时会自动扩容。工作线程数量上限由设备的物理核数决定，内部管理具体数量，确保调度和执行效率最优。长时间无任务分发时会缩容，减少工作线程数量。具体扩缩容机制请参见TaskPool扩缩容机制。

TaskPool注意事项

实现任务的函数需要使用@Concurrent装饰器标注，且仅支持在.ets文件中使用。

从API version 11开始，跨并发实例传递带方法的实例对象时，该类必须使用装饰器@Sendable装饰器标注，且仅支持在.ets文件中使用。如果不考虑使用@Sendable装饰器标注，可以考虑worker方法，请参考Worker同步调用宿主线程的接口。

任务函数（LongTask除外）在TaskPool工作线程中的执行时长不能超过3分钟。否则，若因任务逻辑导致阻塞，使任务无法完成，将导致该线程后续无法调度其他任务。当所有线程均被超时占用时，后续提交的任务将无法正常调度执行。需要注意的是，这里的3分钟限制仅统计TaskPool线程的​​同步运行时长​​，不包含异步操作（如Promise或async/await）的等待时长。例如，数据库的插入、删除、更新等操作，如果是异步操作，仅计入CPU实际处理时长（如SQL解析），网络传输或磁盘I/O等待时长不计入；如果是同步操作，整个操作时长（含I/O阻塞时间）均计入限制。开发者可通过Task的属性ioDuration、cpuDuration获取执行当前任务的异步IO耗时和CPU耗时。

实现任务的函数入参需满足序列化支持的类型。详情请参见线程间通信对象概述。目前不支持使用@State装饰器、@Prop装饰器、@Link装饰器等装饰器修饰的复杂类型。

ArrayBuffer参数在TaskPool中默认转移，需要设置转移列表的话可通过接口setTransferList()设置。如果需要多次调用使用ArrayBuffer作为参数的task，则需要通过接口setCloneList()把ArrayBuffer在线程中的传输行为改成拷贝传递，避免对原有对象产生影响。

除上述注意事项外，使用TaskPool时还需注意并发注意事项。

import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';


@Concurrent
function printArrayBuffer(buffer: ArrayBuffer) {
  return buffer;
}


function testArrayBuffer() {
  const buffer = new ArrayBuffer(1);
  const group = new taskpool.TaskGroup();
  const task = new taskpool.Task(printArrayBuffer, buffer);
  group.addTask(task);
  task.setCloneList([buffer]);
  for (let i = 0; i < 5; i++) {
    taskpool.execute(group).then(() => {
      console.info('execute group success');
    }).catch((e: BusinessError) => {
      console.error(`execute group error: ${e.message}`);
    })
  }
}

由于不同线程中上下文对象不同，TaskPool工作线程只能使用线程安全的模块。例如，不能使用UI相关的非线程安全模块。TaskPool/Worker等工作线程不支持使用操作UI的模块、线程不安全的模块以及其他只支持在主线程中使用的模块。不支持UI模块是因为目前工作线程不支持操作UI，不支持线程不安全的模块是因为多线程使用该模块可能会导致多线程问题，只支持在主线程中使用的模块明确在文档中说明的有ApplicationContext等。线程安全的模块是指多线程同时使用该模块也不会引入多线程问题，如TaskPool/Worker/hilog等。

序列化传输的数据量限制为16MB。

Priority的IDLE优先级是用来标记需要在后台运行的耗时任务（例如数据同步、备份），它的优先级别是最低的。这种优先级的任务只在所有线程都空闲时触发执行，并且同一时间只会有一个IDLE优先级的任务执行。

Promise不支持跨线程传递。TaskPool返回pending或rejected状态的Promise时会失败，返回fulfilled状态的Promise时TaskPool会解析返回的结果，如果结果可以跨线程传递，则返回成功。

不支持在TaskPool工作线程中使用AppStorage。

TaskPool支持在宿主线程封装任务并提交给任务队列，理论上支持的任务数量没有上限。然而，任务的执行效率受限于任务的优先级和系统资源。当工作线程达到最大数量时，任务的执行效率可能会下降。

TaskPool不支持指定任务所运行的线程，任务会被分配到空闲的线程中执行。如果需要指定任务所运行的线程，建议使用Worker。

@Concurrent装饰器

使用TaskPool时，执行的并发函数必须用该装饰器修饰，否则无法通过校验。

说明

从API version 9开始，支持使用@Concurrent装饰器声明并校验并发函数。

@Concurrent并发装饰器	说明
装饰器参数	无。
使用场景	仅支持在Stage模型的工程中使用。仅支持在.ets文件中使用。
装饰的函数类型	允许标注为async函数或普通函数。禁止标注为generator、箭头函数、类方法。不支持类成员函数或者匿名函数。
装饰的函数内的变量类型	允许使用局部变量、入参和通过import引入的变量，禁止使用闭包变量。
装饰的函数内的返回值类型	支持的类型请查线程间通信对象概述。

由于@Concurrent标记的函数不能访问闭包，因此函数内部不能调用当前文件的其他函数，例如：

function bar() {
}


@Concurrent
function foo() {
  bar(); // 违反闭包原则，报错
}
装饰器使用示例
并发函数一般使用

并发函数为一个计算两数之和的普通函数，taskpool执行该函数并返回结果。

示例：

import { taskpool } from '@kit.ArkTS';


@Concurrent
function add(num1: number, num2: number): number {
  return num1 + num2;
}


async function concurrentFunc(): Promise<void> {
  try {
    const task: taskpool.Task = new taskpool.Task(add, 1, 2);
    console.info(`taskpool res is: ${await taskpool.execute(task)}`); // 输出结果：taskpool res is: 3
  } catch (e) {
    console.error(`taskpool execute error is: ${e}`);
  }
}


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
          .onClick(() => {
            concurrentFunc();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
并发函数返回Promise

在并发函数中返回Promise时需特别注意。如示例所示，testPromise和testPromise1等函数需处理Promise并返回结果。

示例：

import { taskpool } from '@kit.ArkTS';


@Concurrent
function testPromise(args1: number, args2: number): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    resolve(args1 + args2);
  });
}


@Concurrent
async function testPromise1(args1: number, args2: number): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    resolve(args1 + args2);
  });
}


@Concurrent
async function testPromise2(args1: number, args2: number): Promise<number> {
  return await new Promise<number>((resolve, reject) => {
    resolve(args1 + args2);
  });
}


@Concurrent
function testPromise3() {
  return Promise.resolve(1);
}


@Concurrent
async function testPromise4(): Promise<number> {
  return 1;
}


@Concurrent
async function testPromise5(): Promise<string> {
  return await new Promise((resolve) => {
    setTimeout(() => {
      resolve('Promise setTimeout after resolve');
    }, 1000)
  });
}


async function testConcurrentFunc() {
  const task1: taskpool.Task = new taskpool.Task(testPromise, 1, 2);
  const task2: taskpool.Task = new taskpool.Task(testPromise1, 1, 2);
  const task3: taskpool.Task = new taskpool.Task(testPromise2, 1, 2);
  const task4: taskpool.Task = new taskpool.Task(testPromise3);
  const task5: taskpool.Task = new taskpool.Task(testPromise4);
  const task6: taskpool.Task = new taskpool.Task(testPromise5);


  taskpool.execute(task1).then((d: object) => {
    console.info(`task1 res is: ${d}`); // 输出结果：task1 res is: 3
  }).catch((e: object) => {
    console.error(`task1 catch e: ${e}`);
  })
  taskpool.execute(task2).then((d: object) => {
    console.info(`task2 res is: ${d}`);
  }).catch((e: object) => {
    console.error(`task2 catch e: ${e}`); // 输出结果：task2 catch e: Error: Can't return Promise in pending state
  })
  taskpool.execute(task3).then((d: object) => {
    console.info(`task3 res is: ${d}`); // 输出结果：task3 res is: 3
  }).catch((e: object) => {
    console.error(`task3 catch e: ${e}`);
  })
  taskpool.execute(task4).then((d: object) => {
    console.info(`task4 res is: ${d}`); // 输出结果：task4 res is: 1
  }).catch((e: object) => {
    console.error(`task4 catch e: ${e}`);
  })
  taskpool.execute(task5).then((d: object) => {
    console.info(`task5 res is: ${d}`); // 输出结果：task5 res is: 1
  }).catch((e: object) => {
    console.error(`task5 catch e: ${e}`);
  })
  taskpool.execute(task6).then((d: object) => {
    console.info(`task6 res is: ${d}`); // 输出结果：task6 res is: Promise setTimeout after resolve
  }).catch((e: object) => {
    console.error(`task6 catch e: ${e}`);
  })
}


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';


  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            testConcurrentFunc();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
并发函数中使用自定义类或函数

在并发函数中使用自定义类或函数时，需将其定义在单独的文件中，否则可能被视为闭包。如下示例所示。

示例：

// Index.ets
import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { testAdd, MyTestA, MyTestB } from './Test';


function add(arg: number) {
  return ++arg;
}


class TestA {
  constructor(name: string) {
    this.name = name;
  }


  name: string = 'ClassA';
}


class TestB {
  static nameStr: string = 'ClassB';
}


@Concurrent
function TestFunc() {
  // case1：在并发函数中直接调用同文件内定义的类或函数


  // 直接调用同文件定义的函数add()，add飘红报错：Only imported variables and local variables can be used in @Concurrent decorated functions. <ArkTSCheck>
  // add(1);
  // 直接使用同文件定义的TestA构造，TestA飘红报错：Only imported variables and local variables can be used in @Concurrent decorated functions. <ArkTSCheck>
  // const a = new TestA('aaa');
  // 直接访问同文件定义的TestB的成员nameStr，TestB飘红报错：Only imported variables and local variables can be used in @Concurrent decorated functions. <ArkTSCheck>
  // console.info(`TestB name is: ${TestB.nameStr}`);


  // case2：在并发函数中调用定义在Test.ets文件并导入当前文件的类或函数


  // 输出结果：res1 is: 2
  console.info(`res1 is: ${testAdd(1)}`);
  const tmpStr = new MyTestA('TEST A');
  // 输出结果：res2 is: TEST A
  console.info(`res2 is: ${tmpStr.name}`);
  // 输出结果：res3 is: MyTestB
  console.info(`res3 is: ${MyTestB.nameStr}`);
}




@Entry
@Component
struct Index {
  @State message: string = 'Hello World';


  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          const task = new taskpool.Task(TestFunc);
          taskpool.execute(task).then(() => {
            console.info('taskpool: execute task success!');
          }).catch((e: BusinessError) => {
            console.error(`taskpool: execute: Code: ${e.code}, message: ${e.message}`);
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}
// Test.ets
export function testAdd(arg: number) {
  return ++arg;
}


@Sendable
export class MyTestA {
  constructor(name: string) {
    this.name = name;
  }
  name: string = 'MyTestA';
}


export class MyTestB {
  static nameStr:string = 'MyTestB';
}
并发异步函数中使用Promise

在并发异步函数中使用Promise时，建议搭配await使用，这样TaskPool可以捕获Promise中的异常。推荐使用示例如下。

示例：

import { taskpool } from '@kit.ArkTS';


@Concurrent
async function testPromiseError() {
  await new Promise<number>((resolve, reject) => {
    resolve(1);
  }).then(() => {
    throw new Error('testPromise error');
  })
}


@Concurrent
async function testPromiseError1() {
  await new Promise<string>((resolve, reject) => {
    reject('testPromiseError1 error msg');
  })
}


@Concurrent
function testPromiseError2() {
  return new Promise<string>((resolve, reject) => {
    reject('testPromiseError2 error msg');
  })
}


async function testConcurrentFunc() {
  const task1: taskpool.Task = new taskpool.Task(testPromiseError);
  const task2: taskpool.Task = new taskpool.Task(testPromiseError1);
  const task3: taskpool.Task = new taskpool.Task(testPromiseError2);


  taskpool.execute(task1).then((d: object) => {
    console.info(`task1 res is: ${d}`);
  }).catch((e: object) => {
    console.error(`task1 catch e: ${e}`); // task1 catch e: Error: testPromise error
  })
  taskpool.execute(task2).then((d: object) => {
    console.info(`task2 res is: ${d}`);
  }).catch((e: object) => {
    console.error(`task2 catch e: ${e}`); // task2 catch e: testPromiseError1 error msg
  })
  taskpool.execute(task3).then((d: object) => {
    console.info(`task3 res is: ${d}`);
  }).catch((e: object) => {
    console.error(`task3 catch e: ${e}`); // task3 catch e: testPromiseError2 error msg
  })
}


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';


  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            testConcurrentFunc();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
TaskPool扩缩容机制
扩容机制

一般情况下，向任务队列提交任务时会触发扩容检测。扩容检测首先判断当前空闲工作线程数是否大于任务数。如果大于，说明线程池中有空闲工作线程，无需扩容。否则，通过负载计算确定所需工作线程数并创建。

缩容机制

扩容后，TaskPool创建多个工作线程，但当任务数减少后，这些线程就会处于空闲状态，造成资源浪费，因此，TaskPool提供了缩容机制。TaskPool使用定时器，每30秒检测一次当前负载，并尝试释放空闲的工作线程。释放的线程需满足以下条件：

该线程空闲时长达到30s。

该线程上未执行长时任务（LongTask）。

该线程上没有业务申请且未释放的句柄，例如Timer(定时器)。

该线程处于非调试调优阶段。

该线程中不存在已创建未销毁的子Worker。

---

## Worker

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/worker-introduction

Worker的主要作用是为应用程序提供一个多线程的运行环境，实现应用程序执行过程与宿主线程分离。通过在后台线程运行脚本处理耗时操作，避免计算密集型或高延迟任务阻塞宿主线程。具体接口信息及使用方法详情请见Worker。

Worker运作机制

图1 Worker运作机制示意图

创建Worker的线程称为宿主线程（不局限于主线程，Worker线程也支持创建Worker子线程）。Worker子线程（或Actor线程、工作线程）是Worker自身运行的线程。每个Worker子线程和宿主线程拥有独立的实例，包含独立执行环境、对象、代码段等。因此，启动每个Worker存在一定的内存开销，需要限制Worker子线程的数量。Worker子线程和宿主线程通过消息传递机制通信，利用序列化、引用传递或转移所有权的机制完成命令和数据的交互。

创建Worker的注意事项

Worker线程文件需要放在"{moduleName}/src/main/ets/"目录层级之下，否则不会被打包到应用中。有手动和自动两种创建Worker线程目录及文件的方式，推荐使用自动创建方式。手动创建Worker线程目录及文件时，需同步进行相关配置。

手动创建：开发者手动创建相关目录及文件，通常是在ets目录下创建一个workers文件夹，用于存放worker.ets文件，需要配置build-profile.json5的相关字段信息，确保Worker线程文件被打包到应用中。

Stage模型：

"buildOption": {
  "sourceOption": {
    "workers": [
      "./src/main/ets/workers/worker.ets"
    ]
  }
}

FA模型：

"buildOption": {
  "sourceOption": {
    "workers": [
      "./src/main/ets/MainAbility/workers/worker.ets"
    ]
  }
}

自动创建：DevEco Studio支持一键生成Worker，在对应的{moduleName}目录下任意位置，单击鼠标右键 > New > Worker，即可自动生成Worker的模板文件及配置信息，无需再手动在build-profile.json5中进行相关配置。

文件路径注意事项

使用Worker模块的具体功能时，需先构造Worker实例对象。构造函数与API版本相关，且需传入Worker线程文件的路径（scriptURL）。

// 导入模块
import { worker } from '@kit.ArkTS';


const worker1: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/worker.ets');
Stage模型下的文件路径规则

针对scriptURL的路径有以下三种写法：

写法一：以{moduleName}/ets/{relativePath}的方式加载Worker线程文件。relativePath是Worker线程文件相对于"{moduleName}/src/main/ets/"目录的相对路径。

路径规则：{moduleName}/ets/{relativePath}。

import { worker } from '@kit.ArkTS';
// worker线程文件所在路径："entry/src/main/ets/workers/worker.ets"
const workerInstance1: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/worker.ets');


// worker线程文件所在路径："testworkers/src/main/ets/ThreadFile/workers/worker.ets"
const workerInstance2: worker.ThreadWorker = new worker.ThreadWorker('testworkers/ets/ThreadFile/workers/worker.ets');

写法二：以@{moduleName}/ets/{relativePath}的方式加载Worker线程文件。

路径规则：@{moduleName}/ets/{relativePath}。

import { worker } from '@kit.ArkTS';
// @标识路径加载形式：
// worker线程文件所在路径: "har/src/main/ets/workers/worker.ets"
const workerInstance3: worker.ThreadWorker = new worker.ThreadWorker('@har/ets/workers/worker.ets');

写法三：以相对路径的方式加载Worker线程文件（仅支持包内加载，不支持跨包加载）。

路径规则：../../{relativePath}。

import { worker } from '@kit.ArkTS';
// 相对路径加载形式：
// worker线程文件所在路径: "har/src/main/ets/workers/worker.ets"
// 创建Worker对象的文件所在路径："har/src/main/ets/components/mainpage/MainPage.ets"
const workerInstance4: worker.ThreadWorker = new worker.ThreadWorker('../../workers/worker.ets');

详细文件路径加载规则如下表：

下表第一列各行表示加载Worker线程文件的所在位置，第一行各列表示被加载的Worker线程文件的所在位置。其余表格内容表示是否支持此类加载及对应路径规则的写法。

例如，下表第二行第四列表示entry模块可以通过写法一加载应用内hsp模块内的Worker线程文件。

说明

当开发者加载entry、feature及hsp包的Worker线程文件时，不建议采用写法三，推荐使用写法一，此写法无需拼接路径，可实现Worker的快速创建。

Worker线程文件的路径后缀.ets/ts可以省略。

跨源码HSP/HAR的场景下，需在创建Worker的模块包对应的oh-package.json5文件中，配置所需HSP/HAR包的依赖项，详见引用共享包。

当feature模块需加载其他模块的Worker线程文件时，应先完成对feature模块的调用。

当开启useNormalizedOHMUrl（在工程目录中与entry同级别的应用级build-profile.json5文件中，将strictMode属性下的useNormalizedOHMUrl字段配置为true）或HAR包被打包成三方包使用时，HAR包中使用Worker仅支持通过相对路径的加载形式创建。

-	entry	feature	应用内hsp	跨工程hsp	源码har	三方har
entry	支持（写法一、三）	支持（写法一）	支持（写法一）	不支持	支持（写法二）	不支持
feature	不支持	跨包支持（写法一），包内场景支持（写法一、三）	支持（写法一）	不支持	支持（写法二）	不支持
应用内hsp	不支持	支持（写法一）	跨包支持（写法一），包内场景支持（写法一、三）	不支持	支持（写法二）	不支持
跨工程hsp	不支持	不支持	不支持	不支持	不支持	不支持
源码har	不支持	支持（写法一）	支持（写法一）	不支持	跨包支持（写法二），包内场景支持（写法二、三）	不支持
三方har	不支持	不支持	不支持	不支持	不支持	仅支持包内场景（写法三）

以entry模块加载源码har包的Worker线程文件为例，具体步骤如下：

创建HAR详情参考开发静态共享包。

在HAR中创建Worker线程文件相关内容。

workerPort.onmessage = (e: MessageEvents) => {
  console.info('worker thread receive message: ', e.data);
  workerPort.postMessage('worker thread post message to main thread');
}

在entry模块的oh-package.json5文件中配置HAR包的依赖。

{
  "name": "entry",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "",
  "author": "",
  "license": "",
  "dependencies": {
    "har": "file:../har"
  }
}

在entry模块中加载HAR包中的Worker线程文件。

import { worker } from '@kit.ArkTS';


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';


  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          // 通过@标识路径加载形式，加载har中Worker线程文件
          let workerInstance = new worker.ThreadWorker('@har/ets/workers/worker.ets');
          workerInstance.onmessage = () => {
            console.info('main thread onmessage');
          };
          workerInstance.postMessage('hello world');
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
FA模型下的文件路径规则

构造函数中的scriptURL为：Worker线程文件与"{moduleName}/src/main/ets/MainAbility"的相对路径。

import { worker } from '@kit.ArkTS';


// 主要说明以下三种场景：


// 场景1： Worker线程文件所在路径："{moduleName}/src/main/ets/MainAbility/workers/worker.ets"
const workerFA1: worker.ThreadWorker = new worker.ThreadWorker('workers/worker.ets', {name:'first worker in FA model'});


// 场景2： Worker线程文件所在路径："{moduleName}/src/main/ets/workers/worker.ets"
const workerFA2: worker.ThreadWorker = new worker.ThreadWorker('../workers/worker.ets');


// 场景3： Worker线程文件所在路径："{moduleName}/src/main/ets/MainAbility/ThreadFile/workers/worker.ets"
const workerFA3: worker.ThreadWorker = new worker.ThreadWorker('ThreadFile/workers/worker.ets');
生命周期注意事项

Worker创建后需要手动管理生命周期。Worker的创建和销毁会消耗较多的系统资源，建议开发者合理管理并重复使用已创建的Worker。Worker空闲时仍会占用资源，当不需要Worker时，可以调用terminate()接口或close()方法主动销毁Worker。需要注意的是，调用完terminate()接口或close()方法后，worker线程的退出是异步的。若开发者注册onexit()，则线程真正退出的时机是在onexit()回调完成之后。若Worker处于已销毁或正在销毁等非运行状态时，调用其功能接口，会抛出相应的错误。

Worker的数量由内存管理策略决定，设定的内存阈值为1.5GB和设备物理内存的60%中的较小值。在内存允许的情况下，系统最多可以同时运行64个Worker，并且与napi_create_ark_runtime创建的runtime总数不超过80。尝试创建的Worker数量超出上限时，系统将抛出错误：“Worker initialization failure, the number of workers exceeds the maximum.”。实际运行的Worker数量会根据当前内存使用情况实时调整。当所有Worker和主线程的累积内存占用超过设定的阈值时，系统将触发内存溢出（OOM）错误，导致应用程序崩溃。

其他注意事项
不同线程中上下文对象是不同的，因此Worker线程只能使用线程安全的库，例如UI相关的非线程安全库不能在Worker子线程中使用。
单次序列化传输的数据量大小限制为16MB。
不支持在Worker工作线程中使用AppStorage。
在Worker文件中禁止使用export语法导出任何内容，否则会导致jscrash问题。
应用挂起后，该应用的Worker线程会暂停运行。
除上述注意事项外，使用Worker时还需注意并发注意事项。
Worker基本用法示例

DevEco Studio支持一键生成Worker，在对应的{moduleName}目录下任意位置，单击鼠标右键 > New > Worker，即可自动生成Worker的模板文件及配置信息。本文以创建“worker”为例。

支持手动创建Worker文件，具体方式和注意事项请参阅创建Worker的注意事项。

导入Worker模块。

// Index.ets
import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS'

在宿主线程中，通过调用ThreadWorker的constructor()方法创建Worker对象，并注册回调函数。

// Index.ets
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';


  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          // 创建Worker对象
          let workerInstance = new worker.ThreadWorker('entry/ets/workers/worker.ets');


          // 注册onmessage回调，捕获宿主线程接收到来自其创建的Worker通过workerPort.postMessage接口发送的消息。该回调在宿主线程执行
          workerInstance.onmessage = (e: MessageEvents) => {
            let data: string = e.data;
            console.info('workerInstance onmessage is: ', data);
          }


          // 注册onAllErrors回调，捕获Worker线程的onmessage回调、timer回调以及文件执行等流程产生的全局异常。该回调在宿主线程执行
          workerInstance.onAllErrors = (err: ErrorEvent) => {
            console.error('workerInstance onAllErrors message is: ' + err.message);
          }


          // 注册onmessageerror回调，当Worker对象接收到无法序列化的消息时被调用，在宿主线程执行
          workerInstance.onmessageerror = () => {
            console.error('workerInstance onmessageerror');
          }


          // 注册onexit回调，当Worker销毁时被调用，在宿主线程执行
          workerInstance.onexit = (e: number) => {
            // Worker正常退出时，code为0；异常退出时，code为1
            console.info('workerInstance onexit code is: ', e);
          }


          // 发送消息给Worker线程
          workerInstance.postMessage('1');
        })
    }
    .height('100%')
    .width('100%')
  }
}

在Worker文件中注册回调函数。

// worker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';


const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


// 注册onmessage回调，当Worker线程收到来自其宿主线程通过postMessage接口发送的消息时被调用，在Worker线程执行
workerPort.onmessage = (e: MessageEvents) => {
  let data: string = e.data;
  console.info('workerPort onmessage is: ', data);


  // 向宿主线程发送消息
  workerPort.postMessage('2');
}


// 注册onmessageerror回调，当Worker对象接收到一条无法被序列化的消息时被调用，在Worker线程执行
workerPort.onmessageerror = () => {
  console.error('workerPort onmessageerror');
}


// 注册onerror回调，捕获Worker在执行过程中发生的异常，在Worker线程执行
workerPort.onerror = (err: ErrorEvent) => {
  console.error('workerPort onerror err is: ', err.message);
}
多级Worker生命周期管理

支持创建多级Worker，即父Worker可以创建子Worker，形成层级线程关系。由于Worker线程的生命周期由开发者管理，因此需要正确管理多级Worker的生命周期。当销毁父Worker时未能终止其子Worker的运行，可能会导致不可预期的结果。所以需要确保子Worker的生命周期在父Worker生命周期范围内，销毁父Worker前，先销毁所有子Worker，以防止不可预期的结果。

推荐使用示例
// 在宿主线程中创建Worker线程（父Worker），在worker线程中再次创建Worker线程（子Worker）
import { worker, MessageEvents, ErrorEvent } from '@kit.ArkTS';


// 宿主线程中创建父Worker对象
const parentWorker = new worker.ThreadWorker('entry/ets/workers/ParentWorker.ets');


// 接收父Worker返回的消息
parentWorker.onmessage = (e: MessageEvents) => {
  console.info('宿主线程收到父worker线程信息 ' + e.data);
}


// 父Worker正常退出后的回调
parentWorker.onexit = () => {
  console.info('父worker退出');
}


// 父Worker运行过程中发生未被捕获的异常或运行错误时的回调
parentWorker.onAllErrors = (err: ErrorEvent) => {
  console.error('宿主线程接收到父worker报错 ' + err.message);
}


// 向父Worker发送启动消息，用于触发其onmessage中的处理逻辑
parentWorker.postMessage('宿主线程发送消息给父worker-推荐示例');
// ParentWorker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';


// 父Worker线程中与宿主线程通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


workerPort.onmessage = (e : MessageEvents) => {
  // 收到宿主线程指令后，创建子Worker
  if (e.data == '宿主线程发送消息给父worker-推荐示例') {
    let childWorker = new worker.ThreadWorker('entry/ets/workers/ChildWorker.ets');


    // 接收子Worker的执行结果
    childWorker.onmessage = (e: MessageEvents) => {
      console.info('父Worker收到子Worker的信息 ' + e.data);
      if (e.data == '子Worker向父Worker发送信息') {
        // 子Worker任务完成后，通知宿主线程
        workerPort.postMessage('父Worker向宿主线程发送信息');
      }
    }


    // 子Worker退出后再销毁父Worker
    childWorker.onexit = () => {
      console.info('子Worker退出');
      workerPort.close();
    }


    // 子Worker运行过程中发生未被捕获的异常或运行错误时的回调
    childWorker.onAllErrors = (err: ErrorEvent) => {
      console.error('子Worker发生报错 ' + err.message);
    }


    // 向子Worker发送启动消息，用于触发其onmessage中的处理逻辑
    childWorker.postMessage('父Worker向子Worker发送信息-推荐示例');
  }
}
// ChildWorker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';


// 子Worker线程中与父Worker线程通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


workerPort.onmessage = (e: MessageEvents) => {
  if (e.data == '父Worker向子Worker发送信息-推荐示例') {
    // 子Worker线程业务逻辑...
    console.info('业务执行结束，然后子Worker销毁');
    // 子Worker任务完成后退出
    workerPort.close();
  }
}
不推荐使用示例

不建议在父Worker销毁后，子Worker继续向父Worker发送消息。

import { worker, MessageEvents, ErrorEvent } from '@kit.ArkTS';


// 宿主线程中创建父Worker对象
const parentWorker = new worker.ThreadWorker('entry/ets/workers/ParentWorker.ets');


// 接收父Worker返回的消息
parentWorker.onmessage = (e: MessageEvents) => {
  console.info('宿主线程收到父Worker信息' + e.data);
}


// 父Worker正常退出后的回调
parentWorker.onexit = () => {
  console.info('父Worker退出');
}


// 父Worker运行过程中发生未被捕获的异常或运行错误时的回调
parentWorker.onAllErrors = (err: ErrorEvent) => {
  console.error('宿主线程接收到父Worker报错 ' + err.message);
}


// 向父Worker发送启动消息，用于触发其onmessage中的处理逻辑
parentWorker.postMessage('宿主线程发送消息给父Worker');
// ParentWorker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';


// 父Worker线程中与宿主线程通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


workerPort.onmessage = (e : MessageEvents) => {
  console.info('父Worker收到宿主线程的信息 ' + e.data);


  // 收到宿主线程指令后，创建子Worker
  let childWorker = new worker.ThreadWorker('entry/ets/workers/ChildWorker.ets')


  // 接收子Worker的执行结果
  childWorker.onmessage = (e: MessageEvents) => {
    console.info('父Worker收到子Worker的信息 ' + e.data);
  }


  // 子Worker正常退出后的回调
  childWorker.onexit = () => {
    console.info('子Worker退出');
    // 父Worker已经或即将退出时，再次通过父Worker端口发送消息
    workerPort.postMessage('父Worker向宿主线程发送信息');
  }


  // 子Worker运行过程中发生未被捕获的异常或运行错误时的回调
  childWorker.onAllErrors = (err: ErrorEvent) => {
    console.error('子Worker发生报错 ' + err.message);
  }


  // 向子Worker发送启动消息，用于触发其onmessage中的处理逻辑
  childWorker.postMessage('父Worker向子Worker发送信息');


  // 创建子Worker后，销毁父Worker
  workerPort.close();
}
// ChildWorker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';


// 子Worker与父Worker通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


workerPort.onmessage = (e: MessageEvents) => {
  console.info('子Worker收到信息 ' + e.data);


  // 父Worker销毁后，子Worker向父Worker发送信息
  workerPort.postMessage('子Worker向父Worker发送信息');


  // 延迟再次发送
  setTimeout(() => {
    workerPort.postMessage('子Worker向父Worker发送信息');
  }, 1000);
}

不建议在父Worker发起销毁操作的执行阶段创建子Worker。在创建子Worker线程之前，需确保父Worker线程始终处于存活状态，建议在确定父Worker未发起销毁操作的情况下创建子Worker。

import { worker, MessageEvents, ErrorEvent } from '@kit.ArkTS';


// 宿主线程中创建父Worker对象
const parentWorker = new worker.ThreadWorker('entry/ets/workers/ParentWorker.ets');


// 接收父Worker返回的消息
parentWorker.onmessage = (e: MessageEvents) => {
  console.info('宿主线程收到父Worker信息' + e.data);
}


// 父Worker正常退出后的回调
parentWorker.onexit = () => {
  console.info('父Worker退出');
}


// 父Worker运行过程中发生未被捕获的异常或运行错误时的回调
parentWorker.onAllErrors = (err: ErrorEvent) => {
  console.error('宿主线程接收到父Worker报错 ' + err.message);
}


// 向父Worker发送启动消息，用于触发其onmessage中的处理逻辑
parentWorker.postMessage('宿主线程发送消息给父Worker');
// ParentWorker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';


// 父Worker线程中与宿主线程通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


workerPort.onmessage = (e : MessageEvents) => {
  console.info('父Worker收到宿主线程的信息 ' + e.data);


  // 父Worker销毁后创建子Worker
  workerPort.close();
  let childWorker = new worker.ThreadWorker('entry/ets/workers/ChildWorker.ets');


  // 子Worker线程未确认创建成功前销毁父Worker
  // let childWorker = new worker.ThreadWorker('entry/ets/workers/ChildWorker.ets');
  // workerPort.close();


  // 接收子Worker返回的消息
  childWorker.onmessage = (e: MessageEvents) => {
    console.info('父Worker收到子Worker的信息 ' + e.data);
  }


  // 子Worker正常退出后的回调
  childWorker.onexit = () => {
    console.info('子Worker退出');
    // 父Worker已经或即将退出时，再次通过父Worker端口发送消息
    workerPort.postMessage('父Worker向宿主线程发送信息');
  }


  // 子Worker运行过程中发生未被捕获的异常或运行错误时的回调
  childWorker.onAllErrors = (err: ErrorEvent) => {
    console.error('子Worker发生报错 ' + err.message);
  }


  // 向子Worker发送启动消息
  childWorker.postMessage('父Worker向子Worker发送信息');
}
// ChildWorker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';


// 子Worker与父Worker通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


// 接收子Worker返回的消息
workerPort.onmessage = (e: MessageEvents) => {
  console.info('子Worker收到信息 ' + e.data);
}

---

## ArkTS线程间通信概述

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/interthread-communication-overview

线程间通信指并发多线程间的数据交换行为。由于ArkTS语言兼容TS/JS，其运行时实现与其它JS引擎一样，采用基于Actor内存隔离的并发模型。

在ArkTS线程间通信中，不同数据对象的行为存在差异。例如，普通JS对象、ArrayBuffer对象和SharedArrayBuffer对象在跨线程时的处理方式不同，涉及序列化、反序列化、数据转移和数据共享等操作。

以JS对象为例，其在并发任务间的通信采用了标准的Structured Clone算法（序列化和反序列化）。该算法通过序列化将JS对象转换为与引擎无关的数据（如字符串或内存块），在另一个并发任务中通过反序列化还原成与原JS对象内容一致的新对象。因此，需要进行深拷贝，效率较低。除了支持JS标准的序列化和反序列化能力，还支持绑定Native的JS对象的传输，以及Sendable对象的共享能力。

ArkTS目前主要提供两种并发能力支持线程间通信：TaskPool和Worker。

Worker是Actor并发模型标准的跨线程通信API，与Web Worker或者Node.js Worker的使用方式基本一致。

TaskPool提供了功能更强、并发编程更简易的任务池API。其中TaskPool涉及跨并发任务的对象传递行为与Worker一致，还是采用了标准的Structured Clone算法，并发通信的对象越大，耗时就越长。

基于ArkTS提供的TaskPool和Worker并发接口，支持多种线程间通信能力，可以满足不同线程间通信场景。如独立的耗时任务、多个耗时任务、TaskPool线程与宿主线程通信、Worker与宿主线程的即时消息通信、Worker同步调用宿主线程的接口等。此外，通过Node-API机制，C++线程可以跨线程调用ArkTS接口。

图1 序列化反序列化原理图

---

## 并发线程间通信

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/interthread-communication

ArkTS线程间通信概述

线程间通信对象

线程间通信场景


---

## See Also

- [ArkTS 语言基础](arkts-lang-basics.md)
- [ArkTS 基础类库](arkts-stdlib.md)
- [Background Tasks Kit 后台任务](background-tasks-kit.md)
