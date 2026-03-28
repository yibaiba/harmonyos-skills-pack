# ArkTS基础类库（离线参考）

> 来源：华为 HarmonyOS 开发者文档

---

## ArkTS基础类库概述

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-utils-overview

ArkTS基础类库是一个功能齐全的API集合，设计了一系列关键且实用的功能模块。

ArkTS基础类库主要提供了XML生成解析转换、二进制Buffer、多种容器类库、URL字符串解析和高精度浮点计算等能力，简化开发工作，提升开发效率。

---

## 二进制Buffer

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/buffer

场景介绍

Buffer和FastBuffer模块将内存区域抽象为可读写、修改的逻辑对象，提供高效的二进制数据处理接口。每个Buffer实例是连续的字节序列，支持创建自定义大小的内存块，用于存储和操作序列化后的数据。

Buffer和FastBuffer模块的主要应用场景包括：

大数据传输：传输大量数据，如二进制文件、数据库记录或网络报文时，使用Buffer作为数据的存储和处理容器，可减少拷贝和内存消耗，提升效率。

图像和音频处理：在图像编码、解码和音频数据流处理中，Buffer帮助开发者操作像素或采样数据，确保数据的完整性。

二进制数据操作：Buffer提供接口解析和操作二进制数据。

Buffer

Buffer模块的核心功能包括：

创建和分配内存：允许指定大小初始化Buffer，创建后内存容量固定。

读写和复制数据：支持按索引访问Buffer内的字节，按字节块读取和写入，复制Buffer的某部分到其他Buffer或数组。

转换操作：提供Buffer与基本类型（如Uint8Array、string）之间的转换方法，满足不同的数据处理需求。

内存操作：支持截取部分Buffer、切片和合并多个Buffer，便于数据流的处理和管理。

Buffer模块各接口使用详见：@ohos.buffer。

FastBuffer

FastBuffer是一种高性能二进制数据容器，专为固定长度字节序列的存储与处理设计，相比Buffer，它在效率和读写速度上具有显著优势。

当构造FastBuffer的入参为number | FastBuffer | Uint8Array | ArrayBuffer | Array<number> | string时，推荐使用FastBuffer处理大量二进制数据，如图片处理和文件接收上传等。

FastBuffer模块的核心功能包括：

创建和分配内存：允许基于uint32指定大小初始化FastBuffer，创建后内存容量固定。

读写和复制数据：支持按索引访问Buffer内的字节，按字节块读取和写入，复制FastBuffer的某部分到其他FastBuffer或数组。

转换操作：提供FastBuffer与基本类型（如Uint8Array、string）之间的转换方法，满足不同的数据处理需求。

内存操作：支持截取部分FastBuffer、切片和合并多个FastBuffer，便于数据流的处理和管理。

FastBuffer模块各接口使用详见：@ohos.fastbuffer。

---

## XML生成解析转换

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/xml-overview

XML（可扩展标记语言）是一种用于描述数据的标记语言，提供通用的数据传输和存储方式。XML不预定义标记，因此更加灵活，适用于广泛的应用领域。

XML文档由元素（element）、属性（attribute）和内容（content）组成。

元素指的是标记对，包含文本、属性或其他元素。

属性提供了有关元素的其他信息。

内容则是元素包含的数据或子元素。

XML使用XML Schema或DTD（文档类型定义）定义文档结构，开发人员可以利用这些机制创建自定义规则，以验证XML文档的格式是否符合预期规范。

XML支持命名空间、实体引用、注释和处理指令，灵活适应各种数据需求。

语言基础类库提供了XML相关的基础能力，包括：XML的生成、XML的解析和XML的转换。

以下是一个简单的XML样例及对应说明，更多XML的接口和具体使用，请见@ohos.xml。

<!-- 声明 -->
<?xml version="1.0" encoding="utf-8"?>
<!-- 处理指令 -->
<?xml-stylesheet type="text/css" href="style.css"?>
<!-- 元素、属性及属性值 -->
<note importance="high">
    <title>Happy</title>
    <!-- 实体引用 -->
    <todo>&amp;</todo>
    <!-- 命名空间的声明及统一资源标识符 -->
    <h:table xmlns:h="http://www.w3.org/TR/html4/">
        <h:tr>
            <h:td>Apples</h:td>
            <h:td>Bananas</h:td>
        </h:tr>
    </h:table>
</note>

---

## XML生成、解析与转换

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/xml-generation-parsing-conversion

XML概述

XML生成

XML解析

XML转换


---

## JSON扩展库

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-json

场景介绍

该库扩展了原生JSON功能，提供了额外的错误处理、循环引用检测、BigInt处理以及对不同输入类型的严格检查。代码中底层依赖于原生JSON.parse和JSON.stringify，但在此基础上加入了多种自定义逻辑并提供额外的has和remove接口，具体可见@arkts.json。

JSON扩展库主要适用于以下场景：

需要处理BigInt的JSON解析或序列化。

需要更严格的参数校验和错误处理。

需要在序列化对象时检测循环引用。

需要安全的对象操作（has/remove）。

该库适用于需要增强JSON功能的场景，特别是在处理BigInt和严格的参数校验时。

JSON扩展说明
parse

parse(text: string, reviver?: Transformer, options?: ParseOptions): Object | null

解析JSON字符串，支持BigInt模式。

与原生的区别：

特性	原生parse	本库parse
BigInt支持	不支持（抛出TypeError）	支持（通过parseBigInt扩展）
参数校验	弱校验	强校验（抛出BusinessError）
错误信息	原生错误（如SyntaxError）	自定义BusinessError
reviver参数	支持	支持，但强制类型检查
stringify

stringify(value: Object, replacer?: (number | string)[] | null, space?: string | number): string

将对象转换为JSON字符串，支持BigInt模式。

与原生的区别：

特性	原生stringify	本库stringify
BigInt支持	不支持（抛出TypeError）	支持（通过stringifyBigInt扩展）
循环引用检测	抛出TypeError	检测并抛出BusinessError
参数校验	弱校验	强校验（replacer必须是函数或数组）
错误信息	原生错误	自定义BusinessError
has

has(obj: object, property: string): boolean

检查对象是否包含指定的属性，确保传入的值是一个对象，并且属性键是有效的字符串。

与原生的区别：

特性	原生方式（obj.hasOwnProperty）	本库has
参数校验	无校验（可能误用）	强制检查obj是普通对象，property是非空字符串
错误处理	可能静默失败	抛出BusinessError
remove

remove(obj: object, property: string): void

从对象中删除指定的属性。

特性	原生方式（delete obj.key）	本库remove
参数校验	无校验（可能误删）	强制检查obj是普通对象，property是非空字符串
错误处理	可能静默失败	抛出BusinessError
总结
功能	原生JSON	本库
严格参数校验	不支持	支持
循环引用检测	不支持	支持
BigInt处理	不支持	支持
增强的错误处理（BusinessError）	不支持	支持
额外方法（has/remove）	不支持	支持
开发场景
解析包含嵌套引号的JSON字符串场景

JSON字符串中的嵌套引号会破坏其结构，将导致解析失败。

// 比如以下JSON字符串，由于嵌套引号导致结构破坏，执行JSON.parse将会抛异常。
// let jsonStr = `{"info": "{"name": "zhangsan", "age": 18}"}`;

以下提供两种方式解决该场景问题：

方式1：避免出现嵌套引号的操作。

import { JSON } from '@kit.ArkTS';


interface Info {
  name: string;
  age: number;
}


interface TestObj {
  info: Info;
}


interface TestStr {
  info: string;
}


/*
 * 将原始JSON字符串`{"info": "{"name": "zhangsan", "age": 18}"}`
 * 修改为`{"info": {"name": "zhangsan", "age": 18}}`。
 * */
let jsonStr = `{"info": {"name": "zhangsan", "age": 18}}`;
let obj1  = JSON.parse(jsonStr) as TestObj;
console.info(JSON.stringify(obj1));    //{"info":{"name":"zhangsan","age":18}}
// 获取JSON字符串中的name信息
console.info(obj1.info.name); // zhangsan

方式2：将JSON字符串中嵌套的引号进行双重转义，恢复JSON的正常结构。

import { JSON } from '@kit.ArkTS';


interface Info {
  name: string;
  age: number;
}


interface TestObj {
  info: Info;
}


interface TestStr {
  info: string;
}


/*
 * 将原始JSON字符串`{"info": "{"name": "zhangsan", "age": 18}"}`进行双重转义，
 * 修改为`{"info": "{\\"name\\": \\"zhangsan\\", \\"age\\": 18}"}`。
 * */
let jsonStr = `{"info": "{\\"name\\": \\"zhangsan\\", \\"age\\": 18}"}`;
let obj2 = JSON.parse(jsonStr) as TestStr;
console.info(JSON.stringify(obj2));    // {"info":"{\"name\": \"zhangsan\", \"age\": 18}"}
// 获取JSON字符串中的name信息
let obj3 = JSON.parse(obj2.info) as Info;
console.info(obj3.name); // zhangsan
解析包含大整数的JSON字符串场景

当JSON字符串中存在小于-(2^53-1)或大于(2^53-1)的整数时，解析后数据会出现精度丢失或不正确的情况。该解析场景需要指定BigIntMode，将大整数解析为BigInt。

import { JSON } from '@kit.ArkTS';


let numberText = '{"number": 10, "largeNumber": 112233445566778899}';


let numberObj1 = JSON.parse(numberText) as Object;
console.info((numberObj1 as object)?.["largeNumber"]);    // 112233445566778900


// 使用PARSE_AS_BIGINT的BigInt模式进行解析，避免出现大整数解析错误。
let options: JSON.ParseOptions = {
  bigIntMode: JSON.BigIntMode.PARSE_AS_BIGINT,
}


let numberObj2 = JSON.parse(numberText, null, options) as Object;


console.info(typeof (numberObj2 as object)?.["number"]);   // number
console.info((numberObj2 as object)?.["number"]);    // 10


console.info(typeof (numberObj2 as object)?.["largeNumber"]);    // bigint
console.info((numberObj2 as object)?.["largeNumber"]);    // 112233445566778899
序列化BigInt对象场景

为弥补原生JSON无法序列化BigInt对象的缺陷，本库提供以下两种JSON序列化方式：

方式1：不使用自定义转换函数，直接序列化BigInt对象。

import { JSON } from '@kit.ArkTS';


let bigIntObject = BigInt(112233445566778899n)


console.info(JSON.stringify(bigIntObject)); // 112233445566778899

方式2：使用自定义转换函数，需预处理BigInt对象进行序列化操作。

import { JSON } from '@kit.ArkTS';


let bigIntObject = BigInt(112233445566778899n)


// 错误序列化用法：自定义函数中直接返回BigInt对象
// JSON.stringify(bigIntObject, (key: string, value: Object): Object =>{ return value; });


// 正确序列化用法：自定义函数中将BigInt对象预处理为string对象
let result: string = JSON.stringify(bigIntObject, (key: string, value: Object): Object => {
  if (typeof value === 'bigint') {
    return value.toString();
  }
  return value;
});
console.info("result:", result); // result: "112233445566778899"
序列化浮点数number场景

在JSON序列化中，浮点数处理存在一个特殊行为：当小数部分为零时，为保持数值的简洁表示，序列化结果会自动省略小数部分。这可能导致精度信息丢失，影响需要精确表示浮点数的场景（如金融金额、科学计量）。以下示例提供解决该场景的方法：

import { JSON } from '@kit.ArkTS';


// 序列化小数部分不为零的浮点数，可以正常序列化。
let floatNumber1 = 10.12345;
console.info(JSON.stringify(floatNumber1)); // 10.12345


// 序列化小数部分为零的浮点数，为保持数值的简洁表示，会丢失小数部分的精度。
let floatNumber2 = 10.00;
console.info(JSON.stringify(floatNumber2)); // 10


// 以下是防止浮点数精度丢失的方法：
let result = JSON.stringify(floatNumber2, (key: string, value: Object): Object => {
  if (typeof value === 'number') {
    // 按照业务场景需要，定制所需的固定精度。
    return value.toFixed(2);
  }
  return value;
});
console.info(result); // "10.00"


---

## See Also

- [ArkTS 语言基础](arkts-lang-basics.md)
- [ArkTS 并发](arkts-concurrency.md)
