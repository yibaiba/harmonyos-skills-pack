# ArkTS跨语言交互（离线参考）

> 来源：华为 HarmonyOS 开发者文档

---

## Node-API简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/napi-introduction

场景介绍

HarmonyOS Node-API是基于Node.js 18.x LTS的Node-API规范扩展开发的机制，为开发者提供了ArkTS/JS与C/C++模块之间的交互能力。它提供了一组稳定的、跨平台的API，可以在不同的操作系统上使用。

本文中如无特别说明，后续均使用Node-API指代HarmonyOS Node-API能力。

说明

HarmonyOS Node-API与Node.js 18.x LTS的Node-API规范的接口异同点，详见Node-API参考文档

一般情况下HarmonyOS应用开发使用ArkTS/JS语言，但部分场景由于性能、效率等要求，比如游戏、物理模拟等，需要依赖使用现有的C/C++库。Node-API规范封装了I/O、CPU密集型、OS底层等能力并对外暴露C接口，使用C/C++模块的注册机制，向ArkTS/JS对象上挂载属性和方法的方式来实现ArkTS/JS和C/C++的交互。主要场景如下：

系统可以将框架层丰富的模块功能通过Node-API的模块注册机制对外暴露ArkTS/JS的接口，将C/C++的能力开放给应用的ArkTS/JS层。

应用开发者也可以选择将一些对性能、底层系统调用有要求的核心功能用C/C++封装实现，再通过ArkTS/JS接口使用，提高应用本身的执行效率。

Node-API的组成架构

图1 Node-API的组成架构

Native Module：开发者使用Node-API开发的模块，用于在ArkTS侧导入使用。

Node-API：实现ArkTS与C/C++交互的逻辑。

ModuleManager：Native模块管理，包括加载、查找等。

ScopeManager：管理napi_value的生命周期。

ReferenceManager：管理napi_ref的生命周期。

NativeEngine：ArkTS引擎抽象层，统一ArkTS引擎在Node-API层的接口行为。

ArkCompiler ArkTS Runtime：ArkTS运行时。

Node-API的关键交互流程

图2 Node-API的关键交互流程

ArkTS和C++之间的交互流程，主要分为以下两步：

初始化阶段：当ArkTS侧在import一个Native模块时，ArkTS引擎会调用ModuleManager加载模块对应的so及其依赖。首次加载时会触发模块的注册，将模块定义的方法属性挂载到exports对象上并返回该对象。

调用阶段：当ArkTS侧通过上述import返回的对象调用方法时，ArkTS引擎会找到并调用对应的C/C++方法。

---

## 使用Node-API进行跨语言开发流程

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/use-napi-process

使用Node-API实现跨语言交互，首先需要按照Node-API的机制实现模块的注册和加载等相关动作。

ArkTS/JS侧：实现C++方法的调用，通过import所需的so库后，可以调用C++方法。

Native侧：.cpp文件，实现模块的注册。需要提供注册lib库的名称，并在注册回调方法中定义接口的映射关系，即Native方法及对应的JS/ArkTS接口名称等。

此处以在ArkTS/JS侧调用callNative()接口、在Native侧实现加法操作的CallNative()接口，从而实现跨语言交互为例，呈现使用Node-API进行跨语言交互的流程。

创建Native C++工程

在DevEco Studio中New > Create Project，选择Native C++模板，点击Next，选择API版本，设置好工程名称，点击Finish，创建得到新工程。

创建工程后工程结构可以分两部分，cpp部分和ets部分，工程结构具体介绍可见C++工程目录结构。

Native侧方法的实现

设置模块注册信息

ArkTS侧import native模块时，会加载其对应的so。加载so时，首先会调用napi_module_register方法，将模块注册到系统中，并调用模块初始化函数。

napi_module有两个关键属性：一个是.nm_register_func，定义模块初始化函数；另一个是.nm_modname，定义模块的名称，也就是ArkTS侧引入的so库的名称，模块系统会根据此名称来区分不同的so。

// entry/src/main/cpp/napi_init.cpp


// 准备模块加载相关信息，将上述Init函数与本模块名等信息记录下来。
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = {0},
};


// 加载so时，该函数会自动被调用，将上述demoModule模块注册到系统中。
extern "C" __attribute__((constructor)) void RegisterDemoModule() {
    napi_module_register(&demoModule);
}

注：以上代码无须复制，创建Native C++工程以后在napi_init.cpp代码中已配置好。

模块初始化

实现ArkTS接口与C++接口的绑定和映射。

// entry/src/main/cpp/napi_init.cpp
EXTERN_C_START
// 模块初始化
static napi_value Init(napi_env env, napi_value exports) {
    // ArkTS接口与C++接口的绑定和映射
    napi_property_descriptor desc[] = {
        // 注：仅需复制以下两行代码，Init在完成创建Native C++工程以后在napi_init.cpp中已配置好。
        {"callNative", nullptr, CallNative, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"nativeCallArkTS", nullptr, NativeCallArkTS, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    // 在exports对象上挂载CallNative/NativeCallArkTS两个Native方法
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

在index.d.ts文件中，提供JS侧的接口方法。

// entry/src/main/cpp/types/libentry/index.d.ts
export const callNative: (a: number, b: number) => number;
export const nativeCallArkTS: (cb: (a: number) => number) => number;

在oh-package.json5文件中将index.d.ts与cpp文件关联起来。

// entry/src/main/cpp/types/libentry/oh-package.json5
{
  "name": "libentry.so",
  "types": "./index.d.ts",
  "version": "",
  "description": "Please describe the basic information."
}

在CMakeLists.txt文件中配置CMake打包参数。

# entry/src/main/cpp/CMakeLists.txt
cmake_minimum_required(VERSION 3.4.1)
project(MyApplication2)


set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})


include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)


# 添加名为entry的库
add_library(entry SHARED napi_init.cpp)
# 构建此可执行文件需要链接的库
target_link_libraries(entry PUBLIC libace_napi.z.so)

实现Native侧的CallNative以及NativeCallArkTS接口。具体代码如下：

// entry/src/main/cpp/napi_init.cpp
static napi_value CallNative(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    // 声明参数数组
    napi_value args[2] = {nullptr};


    // 获取传入的参数并依次放入参数数组中
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);


    // 依次获取参数
    double value0;
    napi_get_value_double(env, args[0], &value0);
    double value1;
    napi_get_value_double(env, args[1], &value1);


    // 返回两数相加的结果
    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);
    return sum;
}


static napi_value NativeCallArkTS(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    // 声明参数数组
    napi_value args[1] = {nullptr};


    // 获取传入的参数并依次放入参数数组中
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);


    // 创建一个int，作为ArkTS的入参
    napi_value argv = nullptr;
    napi_create_int32(env, 2, &argv);


    // 调用传入的callback，并将其结果返回
    napi_value result = nullptr;
    napi_call_function(env, nullptr, args[0], 1, &argv, &result);
    return result;
}
ArkTS侧调用C/C++方法实现

ArkTS侧通过import引入Native侧包含处理逻辑的so来使用C/C++的方法。

// entry/src/main/ets/pages/Index.ets
// 通过import的方式，引入Native能力。
import nativeModule from 'libentry.so'


@Entry
@Component
struct Index {
  @State message: string = 'Test Node-API callNative result: ';
  @State message2: string = 'Test Node-API nativeCallArkTS result: ';
  build() {
    Row() {
      Column() {
        // 第一个按钮，调用callNative方法，对应到Native侧的CallNative方法，进行两数相加。
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message += nativeModule.callNative(2, 3);
            })
        // 第二个按钮，调用nativeCallArkTS方法，对应到Native的NativeCallArkTS，在Native调用ArkTS function。
        Text(this.message2)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message2 += nativeModule.nativeCallArkTS((a: number)=> {
                return a * 2;
            });
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
Node-API的约束限制
SO命名规则

导入使用的模块名和注册时的模块名大小写保持一致，如模块名为entry，则so的名字为libentry.so，napi_module中nm_modname字段应为entry，ArkTS侧使用时写作：import xxx from 'libentry.so'。

注册建议

nm_register_func对应的函数（如上述Init函数）需要加上static，防止与其他so里的符号冲突。

模块注册的入口，即使用__attribute__((constructor))修饰的函数的函数名（如上述RegisterDemoModule函数）需要确保不与其它模块重复。

多线程限制

每个引擎实例对应一个ArkTS线程，实例上的对象不能跨线程操作，否则会引起应用crash。使用时需要遵循如下原则：

Node-API接口只能在ArkTS线程使用。
Native接口入参env与特定ArkTS线程绑定，只能在创建该env的线程使用。
使用Node-API接口创建的数据需在env完全销毁前进行释放，避免内存泄漏。此外，在napi_env销毁后访问/使用这些数据，可能会导致进程崩溃。
代码调试设备选择

建议开发者优先使用真机进行代码调试，若无真机或者真机无权限则可使用模拟器进行调试，模拟器调试中遇到的问题详见bm工具

开发者不要使用预览器进行功能调试，预览器的主要功能是调试界面组件，若用于功能调试可能会出现如下报错：

TypeError: undefined is not callable

部分常见错误用法已增加维测手段覆盖，详见使用Node-API接口产生的异常日志/崩溃分析。

---

## Node-API开发规范

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/napi-guidelines

获取JS传入参数及其数量

【规则】 当传入napi_get_cb_info的argv不为nullptr时，argv的长度必须大于等于传入argc声明的大小。

当argv不为nullptr时，napi_get_cb_info会根据argc声明的数量将JS实际传入的参数写入argv。如果argc小于等于实际JS传入参数的数量，该接口仅会将声明的argc数量的参数写入argv；而当argc大于实际参数数量时，该接口会在argv的尾部填充undefined。

错误示例

static napi_value IncorrectDemo1(napi_env env, napi_callback_info info) {
    // argc 未正确的初始化，其值为不确定的随机值，导致 argv 的长度可能小于 argc 声明的数量，数据越界。
    size_t argc;
    napi_value argv[10] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    return nullptr;
}


static napi_value IncorrectDemo2(napi_env env, napi_callback_info info) {
    // argc 声明的数量大于 argv 实际初始化的长度，导致 napi_get_cb_info 接口在写入 argv 时数据越界。
    size_t argc = 5;
    napi_value argv[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    return nullptr;
}

正确示例

static napi_value GetArgvDemo1(napi_env env, napi_callback_info info) {
    size_t argc = 0;
    // argv 传入 nullptr 来获取传入参数真实数量
    napi_get_cb_info(env, info, &argc, nullptr, nullptr, nullptr);
    // JS 传入参数为0，不执行后续逻辑
    if (argc == 0) {
        return nullptr;
    }
    // 创建数组用以获取JS传入的参数
    napi_value* argv = new napi_value[argc];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 业务代码
    // ... ...
    // argv 为 new 创建的对象，在使用完成后手动释放
    delete[] argv;
    return nullptr;
}


static napi_value GetArgvDemo2(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    // napi_get_cb_info 会向 argv 中写入 argc 个 JS 传入参数或 undefined
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 业务代码
    // ... ...
    return nullptr;
}
生命周期管理

【规则】 合理使用napi_open_handle_scope和napi_close_handle_scope管理napi_value的生命周期，做到生命周期最小化，避免发生内存泄漏问题。

每个napi_value属于特定的HandleScope，HandleScope通过napi_open_handle_scope和napi_close_handle_scope来建立和关闭，HandleScope关闭后，所属的napi_value就会自动释放。

正确示例：

// 在for循环中频繁调用napi接口创建js对象时，要加handle_scope及时释放不再使用的资源。
// 下面例子中，每次循环结束局部变量res的生命周期已结束，因此加scope及时释放其持有的js对象，防止内存泄漏
for (int i = 0; i < 100000; i++) {
    napi_handle_scope scope = nullptr;
    napi_open_handle_scope(env, &scope);
    if (scope == nullptr) {
        return;
    }
    napi_value res;
    napi_create_object(env, &res);
    napi_close_handle_scope(env, scope);
}
上下文敏感

【规则】 多引擎实例场景下，禁止通过Node-API跨引擎实例访问JS对象。

引擎实例是一个独立运行环境，JS对象创建访问等操作必须在同一个引擎实例中进行。若在不同引擎实例中操作同一个对象，可能会引发程序崩溃。引擎实例在接口中体现为napi_env。

错误示例：

// 线程1执行，在env1创建string对象，值为"bar"、
napi_create_string_utf8(env1, "bar", NAPI_AUTO_LENGTH, &string);
// 线程2执行，在env2创建object对象，并将上述的string对象设置到object对象中
napi_status status = napi_create_object(env2, &object);
if (status != napi_ok) {
    napi_throw_error(env, ...);
    return;
}


status = napi_set_named_property(env2, object, "foo", string);
if (status != napi_ok) {
    napi_throw_error(env, ...);
    return;
}

所有的JS对象都隶属于具体的某一napi_env，不可将env1的对象，设置到env2中的对象中。在env2中一旦访问到env1的对象，程序可能会发生崩溃。

异常处理

【建议】 Node-API接口调用发生异常需要及时处理，不能遗漏异常到后续逻辑，否则程序可能发生不可预期行为。

正确示例：

// 1.创建对象
napi_status status = napi_create_object(env, &object);
if (status != napi_ok) {
    napi_throw_error(env, ...);
    return;
}
// 2.创建属性值
status = napi_create_string_utf8(env, "bar", NAPI_AUTO_LENGTH, &string);
if (status != napi_ok) {
    napi_throw_error(env, ...);
    return;
}
// 3.将步骤2的结果设置为对象object属性foo的值
status = napi_set_named_property(env, object, "foo", string);
if (status != napi_ok) {
    napi_throw_error(env, ...);
    return;
}

如上示例中，步骤1或者步骤2出现异常时，步骤3都不会正常进行。只有当方法的返回值是napi_ok时，才能保持继续正常运行；否则后续流程可能会出现不可预期的行为。

异步任务

【规则】 当使用uv_queue_work方法将任务抛到JS线程上面执行的时候，对JS线程的回调方法，一般情况下需要加上napi_handle_scope来管理回调方法创建的napi_value的生命周期。

使用uv_queue_work方法，不会走Node-API框架，此时需要开发者自己合理使用napi_handle_scope来管理napi_value的生命周期。

说明

本规则旨在强调napi_value生命周期情况，若只想往JS线程抛任务，不推荐使用uv_queue_work方法。如有抛任务的需要，请使用napi_threadsafe_function系列接口。

正确示例：

void CallbackTest(CallbackContext* context)
{
    uv_loop_s* loop = nullptr;
    napi_get_uv_event_loop(context->env, &loop);
    uv_work_t* work = new uv_work_t;
    context->retData = 1;
    work->data = (void*)context;
    uv_queue_work(
        loop, work,
        // 请注意，uv_queue_work会创建一个线程并执行该回调函数，若开发者只想往JS线程抛任务，不推荐使用uv_queue_work，以避免冗余的线程创建
        [](uv_work_t* work) {
            // 执行一些业务逻辑
        },
        // 该回调会执行在loop所在的JS线程上
        [](uv_work_t* work, int status) {
            CallbackContext* context = (CallbackContext*)work->data;
            napi_handle_scope scope = nullptr;
            napi_open_handle_scope(context->env, &scope);
            if (scope == nullptr) {
                if (work != nullptr) {
                    delete work;
                }
                return;
            }
            napi_value callback = nullptr;
            napi_get_reference_value(context->env, context->callbackRef, &callback);
            napi_value retArg;
            napi_create_int32(context->env, context->retData, &retArg);
            napi_value ret;
            napi_call_function(context->env, nullptr, callback, 1, &retArg, &ret);
            napi_delete_reference(context->env, context->callbackRef);
            napi_close_handle_scope(context->env, scope);
            if (work != nullptr) {
                delete work;
            }
            delete context;
        }
    );
}
对象绑定

【规则】 使用napi_wrap接口，如果最后一个参数result传递不为nullptr，需要开发者在合适的时机调用napi_remove_wrap函数主动删除创建的napi_ref。

napi_wrap接口定义如下：

napi_wrap(napi_env env, napi_value js_object, void* native_object, napi_finalize finalize_cb, void* finalize_hint, napi_ref* result)

当最后一个参数result不为空时，框架会创建一个napi_ref对象，指向js_object。此时开发者需要自己管理js_object的生命周期，即需要在合适的时机调用napi_remove_wrap删除napi_ref，这样GC才能正常释放js_object，从而触发绑定C++对象native_object的析构函数finalize_cb。

一般情况下，根据业务情况最后一个参数result可以直接传递为nullptr。

正确示例：

// 用法1：napi_wrap不需要接收创建的napi_ref，最后一个参数传递nullptr，创建的napi_ref是弱引用，由系统管理，不需要用户手动释放
napi_wrap(env, jsobject, nativeObject, cb, nullptr, nullptr);


// 用法2：napi_wrap需要接收创建的napi_ref，最后一个参数不为nullptr，返回的napi_ref是强引用，需要用户手动释放，否则会内存泄漏
napi_ref result;
napi_wrap(env, jsobject, nativeObject, cb, nullptr, &result);
// 当js_object和result后续不再使用时，及时调用napi_remove_wrap释放result
void* nativeObjectResult = nullptr;
napi_remove_wrap(env, jsobject, &nativeObjectResult);
高性能数组

【建议】 存储值类型数据时，使用ArrayBuffer代替JSArray来提高应用性能。

使用JSArray作为容器储存数据，支持几乎所有的JS数据类型。

使用napi_set_element方法对JSArray存储值类型数据（如int32）时，同样会涉及到与运行时的交互，造成不必要的开销。

ArrayBuffer进行增改是直接对缓冲区进行更改，具有远优于使用napi_set_element操作JSArray的性能表现。

因此此种场景下，更推荐使用napi_create_arraybuffer接口创建的ArrayBuffer对象。

示例：

// 以下代码使用常规JSArray作为容器，但其仅存储int32类型数据。
// 但因为是JS对象，因此只能使用napi方法对其进行增改，性能较低。
static napi_value ArrayDemo(napi_env env, napi_callback_info info)
{
    constexpr size_t arrSize = 1000;
    napi_value jsArr = nullptr;
    napi_create_array(env, &jsArr);
    for (int i = 0; i < arrSize; i++) {
        napi_value arrValue = nullptr;
        napi_create_int32(env, i, &arrValue);
        // 常规JSArray使用napi方法对array进行读写，性能较差。
        napi_set_element(env, jsArr, i, arrValue);
    }
    return jsArr;
}


// 推荐写法：
// 同样以int32类型数据为例，但以下代码使用ArrayBuffer作为容器。
// 因此可以使用C/C++的方法直接对缓冲区进行增改。
static napi_value ArrayBufferDemo(napi_env env, napi_callback_info info)
{
    constexpr size_t arrSize = 1000;
    napi_value arrBuffer = nullptr;
    void* data = nullptr;


    napi_create_arraybuffer(env, arrSize * sizeof(int32_t), &data, &arrBuffer);
    // data为空指针，取消对data进行写入
    if (data == nullptr) {
        return arrBuffer;
    }
    int32_t* i32Buffer = reinterpret_cast<int32_t*>(data);
    for (int i = 0; i < arrSize; i++) {
        // arrayBuffer直接对缓冲区进行修改，跳过运行时，
        // 与操作原生C/C++对象性能相当
        i32Buffer[i] = i;
    }


    return arrBuffer;
}

napi_create_arraybuffer等同于JS代码中的new ArrayBuffer(size)，其生成的对象不可直接在TS/JS中进行读取，需要将其包装为TypedArray或DataView后方可进行读写。

基准性能测试结果如下：

说明

以下数据为千次循环写入累计数据，为更好的体现出差异，已对设备核心频率进行限制。

容器类型	Benchmark数据（us）
JSArray	1566.174
ArrayBuffer	3.609
数据转换

【建议】 尽可能的减少数据转换次数，避免不必要的复制。

减少数据转换次数： 频繁的数据转换可能会导致性能下降，可以通过批量处理数据或者使用更高效的数据结构来优化性能。
避免不必要的数据复制： 在进行数据转换时，可以使用Node-API提供的接口来直接访问原始数据，而不是创建新的副本。
使用缓存： 如果某些数据在多次转换中都会被使用到，可以考虑使用缓存来避免重复的数据转换。缓存可以减少不必要的计算，提高性能。
模块注册与模块命名

【规则】

nm_register_func对应的函数需要加上修饰符static，防止与其他二进制so文件里的符号冲突。

模块注册的入口，即使用__attribute__((constructor))修饰函数的函数名需要确保与其他模块不同。

模块实现中.nm_modname字段需要与二进制so文件的名字完全匹配，区分大小写。

错误示例

以下代码为二进制so文件的名为nativerender时的错误示例

EXTERN_C_START
napi_value Init(napi_env env, napi_value exports)
{
    // ...
    return exports;
}
EXTERN_C_END


static napi_module nativeModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    // 没有在nm_register_func对应的函数加上static
    .nm_register_func = Init,
    // 模块实现中.nm_modname字段没有与模块名完全匹配，会导致多线程场景模块加载失败
    .nm_modname = "entry",
    .nm_priv = nullptr,
    .reserved = { 0 },
};


// 模块注册的入口函数名为RegisterModule，容易与其他模块重复
extern "C" __attribute__((constructor)) void RegisterModule()
{
    napi_module_register(&nativeModule);
}

图一

图二

正确示例：

以下代码为模块名为nativerender时的正确示例

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // ...
    return exports;
}
EXTERN_C_END


static napi_module nativeModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "nativerender",
    .nm_priv = nullptr,
    .reserved = { 0 },
};


extern "C" __attribute__((constructor)) void RegisterNativeRenderModule()
{
    napi_module_register(&nativeModule);
}
dlopen与模块注册

【规则】

如果注册的模块事先有被dlopen，需使用以下方式注册模块。

模块需对外导出固定名称为napi_onLoad的函数，在该函数内调用注册函数。napi_onLoad函数只会在ArkTS代码的import语句中被主动调用，从而避免dlopen时提前触发模块的注册。

示例

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // ...
    return exports;
}
EXTERN_C_END


static napi_module nativeModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "nativerender",
    .nm_priv = nullptr,
    .reserved = { 0 },
};


extern "C" void napi_onLoad()
{
    napi_module_register(&nativeModule);
}
正确的使用napi_create_external系列接口创建的JS Object

【规则】 napi_create_external系列接口创建出来的JS对象仅允许在当前线程传递和使用，跨线程传递（如使用worker的post_message）将会导致应用crash。若需跨线程传递绑定有Native对象的JS对象，请使用napi_coerce_to_native_binding_object接口绑定JS对象和Native对象。具体API说明详见API参考。

错误示例

static void MyFinalizeCB(napi_env env, void *finalize_data, void *finalize_hint) { return; }


static napi_value CreateMyExternal(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;
    napi_create_external(env, nullptr, MyFinalizeCB, nullptr, &result);
    return result;
}


// 此处已省略模块注册的代码，你可能需要自行注册 CreateMyExternal 方法
// index.d.ts
export const createMyExternal: () => Object;


// 应用代码
import testNapi from 'libentry.so';
import { worker } from '@kit.ArkTS';


const mWorker = new worker.ThreadWorker('../workers/Worker');


{
    const mExternalObj = testNapi.createMyExternal();


    mWorker.postMessage(mExternalObj);


}


// 关闭worker线程
// 应用可能在此步骤崩溃，或在后续引擎进行GC的时候崩溃
mWorker.terminate();
// Worker的实现为默认模板，此处省略
防止重复释放获取的buffer

【规则】 使用napi_get_arraybuffer_info等接口，参数data资源开发者不允许释放，data的生命周期受引擎管理。

这里以napi_get_arraybuffer_info为例，该接口定义如下：

napi_get_arraybuffer_info(napi_env env, napi_value arraybuffer, void** data, size_t* byte_length)

data获取的是ArrayBuffer的Buffer头指针，开发者只可以在范围内读写该Buffer区域，不可以进行释放操作。该段内存由引擎内部的ArrayBuffer Allocator管理，随JS对象ArrayBuffer的生命周期释放。

错误示例：

void* arrayBufferPtr = nullptr;
napi_value arrayBuffer = nullptr;
size_t createBufferSize = ARRAY_BUFFER_SIZE;
napi_status verification = napi_create_arraybuffer(env, createBufferSize, &arrayBufferPtr, &arrayBuffer);
size_t arrayBufferSize;
napi_status result = napi_get_arraybuffer_info(env, arrayBuffer, &arrayBufferPtr, &arrayBufferSize);
delete arrayBufferPtr; // 这一步是禁止的，创建的arrayBufferPtr生命周期由引擎管理，不允许用户自己delete，否则会double free
Node-API中受当前规则约束的接口有：
napi_create_arraybuffer
napi_create_sendable_arraybuffer
napi_get_arraybuffer_info
napi_create_buffer
napi_get_buffer_info
napi_get_typedarray_info
napi_get_dataview_info
其他

【建议】 合理使用napi_object_freeze和napi_object_seal来控制对象以及对象属性的可变性。

napi_object_freeze等同于Object.freeze语义，freeze后对象的所有属性都不可能以任何方式被修改；napi_object_seal等同于Object.seal语义，对象不可增删属性。两者的主要区别是，freeze不能改属性的值，seal还可以改属性的值。

开发者使用以上语义时，需确保约束条件是自己需要的，一旦违背以上语义严格模式下就会抛出Error（默认严格模式）。

参考文档

Native侧子线程与UI主线程通信开发;

如何在Native侧C++子线程直接调用ArkTS接口，不用通过ArkTS侧触发回调;

napi_env、napi_value实例是否可以跨worker线程共享;

Native如何创建子线程，有什么约束，与主线程如何通信.

---

## Node-API扩展能力接口

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/use-napi-about-extension

简介

扩展能力接口进一步扩展了Node-API的功能，提供了一些额外的接口，用于在Node-API模块中与ArkTS进行更灵活的交互和定制，这些接口可以用于创建自定义ArkTS对象等场景。

Node-API接口开发流程参考使用Node-API实现跨语言交互开发流程，本文仅对接口对应C++及ArkTS相关代码进行展示。

本文cpp部分代码所需引用的头文件如下：

#include "napi/native_api.h"
#include <bits/alltypes.h>
#include <mutex>
#include <unordered_set>
#include <uv.h>
#include "hilog/log.h"

本文ArkTS侧示例代码所需的模块导入如下：

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import { taskpool } from '@kit.ArkTS';
模块加载
接口描述
接口	描述
napi_load_module	用于在Node-API模块中将abc文件作为模块加载，返回模块的命名空间，适用于需要在运行时动态加载模块或资源的应用程序，从而实现灵活的扩展和定制。
napi_load_module_with_info	用于在Node-API中进行模块的加载，当模块加载出来之后，可以使用函数napi_get_property获取模块导出的变量，也可以使用napi_get_named_property获取模块导出的函数，该函数可以在新创建的ArkTS基础运行时环境中使用。
napi_module_register	有些功能可能需要通过Node-API模块来实现以获得更好的性能，通过将这些功能实现为自定义模块并注册到ArkTS环境中，可以在一定程度上提高整体的性能。
使用示例

napi_load_module

使用Node-API接口在主线程中进行模块加载

napi_load_module_with_info

使用Node-API接口进行模块加载

napi_module_register

在ArkTS代码环境中使用Node-API模块编写的代码来实现特定的功能，可以将这部分功能封装成自定义模块，然后通过napi_module_register将其注册到ArkTS代码环境中，以实现功能的扩展和复用。

cpp部分代码

#include "napi/native_api.h"


// 此模块是一个Node-API的回调函数
static napi_value Add(napi_env env, napi_callback_info info)
{
    // 接受传入两个参数
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);


    // 将传入的napi_value类型的参数转化为double类型
    double valueLeft;
    double valueRight;
    napi_get_value_double(env, args[0], &valueLeft);
    napi_get_value_double(env, args[1], &valueRight);


    // 将转化后的double值相加并转成napi_value返回给ArkTS代码使用
    napi_value sum;
    napi_create_double(env, valueLeft + valueRight, &sum);


    return sum;
}


// C++函数Init用于初始化插件，用于将ArkTS层的函数或属性与C++层的函数进行关联
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // 通过napi_property_descriptor结构体，可以定义需要导出的属性，并在Node-API模块中使用。napi_define_properties将属性与实际的C++函数进行关联，使其可以被ArkTS层访问和调用
    napi_property_descriptor desc[] = {
        { "add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END


// 插件的初始化被定义在一个名为demoModule的结构体中，其中包含了模块的基本信息，比如模块的版本号、注册函数等
static napi_module demoModule = {
    .nm_version =1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};


// 在RegisterEntryModule函数中，使用napi_module_register函数注册并导出了这个插件
extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}

接口声明

export const add: (a: number, b: number) => number; // 模块加载

ArkTS侧示例代码

hilog.info(0x0000, 'testTag', 'Test Node-API 2 + 3 = %{public}d', testNapi.add(2, 3));

---

## Node-API常见问题

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/use-napi-faqs

稳定性
应用运行过程中出现高概率闪退，出现cppcrash栈，栈顶为系统库libark_jsruntime.so，崩溃栈前几帧也有libace_napi.z.so，怎么进行定位解决
c++线程池中并发调用ArkTS方法（c++多线程调用ArkTS方法），如何处理线程安全问题？
napi_value非预期，napi_value创建时类型是napi_function，保存一段时间后napi_value类型发生变化
是否存在获取最新napi_env的方法？
napi_add_env_cleanup_hook/napi_remove_env_cleanup_hook调用报错，该如何处理？
内存泄漏
napi_create_reference可以创建对js对象的引用，保持js对象不释放，正常来说使用完需要使用napi_delete_reference进行释放，但怕漏delete导致js对象内存泄漏，当前是否有机制来检查/测试是否有泄漏的napi_reference？
Node-API开发过程中，遇见内存泄漏问题，要怎么定位解决？
参数泄漏问题参考napi_open_handle_scope、napi_close_handle_scope
napi_threadsafe_function内存泄漏，应该如何处理？
常见基本功能问题
模块加载失败，Error message: is not callable NativeModule调用报错？
是否有保序的线程通信推荐写法？
是否存在便捷的NAPI回调ArkTS的方式？
如何在C++调用从ArkTS传递过来的function？
如何在遵循 Node-API 单一返回值约束的前提下，安全、高效地将多个返回值（包括结构化数据和指针信息）传递给 ArkTS 运行时环境，并确保数据类型的正确映射与内存管理的安全性？
Node-API调用三方so
napi_get_uv_event_loop接口错误码说明
Node-API中，native层调用ArkTS层对象方法，必须传入一个function给native层吗？
在c++通过pthread或std::thread创建的线程，是否能调用ArkTS的方法并获取到结果？
当前napi的napi_get_value_string_utf8每次调用的时候都要进行拷贝，是否有nocopy、不拷贝的napi_get_value_string_utf8接口或者能力？
多线程下napi_env的使用注意事项是什么？是否存在napi_env切换导致的异常问题？是否必须在主线程?
napi_call_threadsafe_function执行顺序是怎样的？
ArkTS侧import xxx from libxxx.so后，使用xxx报错显示undefined/not callable或明确的Error message
接口执行结果非预期，日志显示occur exception need return
napi_value和napi_ref的生命周期有何区别
Node-API接口返回值不是napi_ok时，如何排查定位
napi_wrap如何保证被wrap的对象按期望顺序析构？
napi_call_threadsafe_function回调任务不执行

