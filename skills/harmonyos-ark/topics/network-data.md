# 网络请求与数据持久化主题

<!-- Agent 摘要：895 行。ArkData（Preferences/RDB/KV Store）+ 文件管理。
     HTTP/WebSocket/图片缓存 → network-data-network.md。
     代码模板 → starter-kit/modules/data-persistence.md。 -->


## 目录

- [Scope](#scope)
- [来源](#来源)
- [Official Entrypoints](#official-entrypoints)
- [ArkData简介](#arkdata简介)
- [应用数据持久化概述](#应用数据持久化概述)
- [用户首选项持久化](#用户首选项持久化)
- [键值型数据库持久化](#键值型数据库持久化)
- [关系型数据库持久化](#关系型数据库持久化)
- [Network Kit简介](#network-kit简介)
- [HTTP数据请求](#http数据请求)
- [WebSocket连接](#websocket连接)
- [Socket连接](#socket连接)

---

## Scope
- ArkData 数据管理（首选项/键值型/关系型数据库）、Network Kit（HTTP/WebSocket/Socket）

## 来源
- ArkData（方舟数据管理）+ Network Kit（网络服务）

## Official Entrypoints
- [ArkData简介](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-mgmt-overview-V5)
- [应用数据持久化概述](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/app-data-persistence-overview-V5)
- [用户首选项持久化](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-persistence-by-preferences-V5)
- [键值型数据库持久化](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-persistence-by-kv-store-V5)
- [关系型数据库持久化](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-persistence-by-rdb-store-V5)
- [Network Kit简介](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/net-mgmt-overview-V5)
- [HTTP数据请求](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/http-request-V5)
- [WebSocket连接](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/websocket-connection-V5)
- [Socket连接](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/socket-connection-V5)

---

## ArkData简介

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-mgmt-overview-V5

功能介绍

ArkData （方舟数据管理）为开发者提供数据存储、数据管理和数据同步能力，比如联系人应用数据可以保存到数据库中，提供数据库的安全、可靠以及共享访问等管理机制，也支持与手表同步联系人信息。

标准化数据定义：提供HarmonyOS跨应用、跨设备的统一数据类型标准，包含标准化数据类型和标准化数据结构。

数据存储：提供通用数据持久化能力，根据数据特点，分为用户首选项、键值型数据库和关系型数据库。

数据管理：提供高效的数据管理能力，包括权限管理、数据备份恢复、数据共享框架等。

数据同步：提供跨设备数据同步能力，比如分布式对象支持内存对象跨设备共享能力，分布式数据库支持跨设备数据库访问能力。

应用创建的数据库，都保存到应用沙盒，当应用卸载时，数据库也会自动删除。

运作机制

数据管理模块包括用户首选项、键值型数据管理、关系型数据管理、分布式数据对象、跨应用数据管理和统一数据管理框架。Interface接口层提供标准JS API接口，定义这些部件接口描述，供开发者参考。Frameworks&System service层负责实现部件数据存储、同步功能，还有一些SQLite和其他子系统的依赖。

图1 数据管理架构图

用户首选项（Preferences）：提供了轻量级配置数据的持久化能力，并支持订阅数据变化的通知能力。不支持分布式同步，常用于保存应用配置信息、用户偏好设置等。

键值型数据管理（KV-Store）：提供了键值型数据库的读写、加密、手动备份以及订阅通知能力。应用需要使用键值型数据库的分布式能力时，KV-Store会将同步请求发送给DatamgrService由其完成跨设备数据同步。

关系型数据管理（RelationalStore）：提供了关系型数据库的增删改查、加密、手动备份以及订阅通知能力。应用需要使用关系型数据库的分布式能力时，RelationalStore部件会将同步请求发送给DatamgrService由其完成跨设备数据同步。

分布式数据对象（DataObject）：独立提供对象型结构数据的分布式能力。如果应用需要重启后仍获取之前的对象数据（包含跨设备应用和本设备应用），则使用数据管理服务（DatamgrService）的对象持久化能力，做暂时保存。

跨应用数据管理（DataShare）：提供了数据提供者provider、数据消费者consumer以及同设备跨应用数据交互的增、删、改、查以及订阅通知等能力。DataShare不与任何数据库绑定，可以对接关系型数据库、键值型数据库。如果开发C/C++应用甚至可以自行封装数据库。在提供标准的provider-consumer模式基础上，同时提供了静默数据访问能力，即不再拉起provider而是直接通过DatamgrService代理访问provider的数据（目前仅关系型数据库支持静默数据访问方式）。

统一数据管理框架（UDMF）：提供了数据跨应用、跨设备交互标准，定义了跨应用、跨设备数据交互过程中的数据语言，提升数据交互效率。提供安全、标准化数据流通通路，支持不同级别的数据访问权限与生命周期管理策略，实现高效的数据跨应用、跨设备共享。

数据管理服务（DatamgrService）：提供其它部件的同步及跨应用共享能力，包括RelationalStore和KV-Store跨设备同步，DataShare静默访问provider数据，暂存DataObject同步对象数据等。

---

## 应用数据持久化概述

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/app-data-persistence-overview-V5

应用数据持久化，是指应用将内存中的数据通过文件或数据库的形式保存到设备上。内存中的数据形态通常是任意的数据结构或数据对象，存储介质上的数据形态可能是文本、数据库、二进制文件等。

HarmonyOS标准系统支持典型的存储数据形态，包括用户首选项、键值型数据库、关系型数据库。

开发者可以根据如下功能介绍，选择合适的数据形态以满足自己应用数据的持久化需要。

用户首选项（Preferences）：通常用于保存应用的配置信息。数据通过文本的形式保存在设备中，应用使用过程中会将文本中的数据全量加载到内存中，所以访问速度快、效率高，但不适合需要存储大量数据的场景。

键值型数据库（KV-Store）：一种非关系型数据库，其数据以“键值”对的形式进行组织、索引和存储，其中“键”作为唯一标识符。适合很少数据关系和业务关系的业务数据存储，同时因其在分布式场景中降低了解决数据库版本兼容问题的复杂度，和数据同步过程中冲突解决的复杂度而被广泛使用。相比于关系型数据库，更容易做到跨设备跨版本兼容。

关系型数据库（RelationalStore）：一种关系型数据库，以行和列的形式存储数据，广泛用于应用中的关系型数据的处理，包括一系列的增、删、改、查等接口，开发者也可以运行自己定义的SQL语句来满足复杂业务场景的需要。

---

## 用户首选项持久化

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-persistence-by-preferences-V5

场景介绍

用户首选项为应用提供Key-Value键值型的数据处理能力，支持应用持久化轻量级数据，并对其修改和查询。当用户希望有一个全局唯一存储的地方，可以采用用户首选项来进行存储。Preferences会将该数据缓存在内存中，当用户读取的时候，能够快速从内存中获取数据，当需要持久化时可以使用flush接口将内存中的数据写入持久化文件中。Preferences会随着存放的数据量越多而导致应用占用的内存越大，因此，Preferences不适合存放过多的数据，也不支持通过配置加密，适用的场景一般为应用保存用户的个性化设置（字体大小，是否开启夜间模式）等。

运作机制

如图所示，用户程序通过ArkTS接口调用用户首选项读写对应的数据文件。开发者可以将用户首选项持久化文件的内容加载到Preferences实例，每个文件唯一对应到一个Preferences实例，系统会通过静态容器将该实例存储在内存中，直到主动从内存中移除该实例或者删除该文件。

应用首选项的持久化文件保存在应用沙箱内部，可以通过context获取其路径。具体可见获取应用文件路径。

图1 用户首选项运作机制

约束限制

首选项无法保证进程并发安全，会有文件损坏和数据丢失的风险，不支持在多进程场景下使用。

Key键为string类型，要求非空且长度不超过1024个字节。

如果Value值为string类型，请使用UTF-8编码格式，可以为空，不为空时长度不超过16MB。

当存储的数据中包含非UTF-8格式的字符串时，请使用Uint8Array类型存储，否则会造成持久化文件出现格式错误造成文件损坏。

当调用removePreferencesFromCache或者deletePreferences后，订阅的数据变更会主动取消订阅，重新getPreferences后需要重新订阅数据变更。

不允许deletePreferences与其他接口多线程、多进程并发调用，否则会发生不可预期行为。

内存会随着存储数据量的增大而增大，所以存储的数据量应该是轻量级的，建议存储的数据不超过一万条，否则会在内存方面产生较大的开销。

接口说明

以下是用户首选项持久化功能的相关接口，更多接口及使用方式请见用户首选项。

接口名称	描述
getPreferencesSync(context: Context, options: Options): Preferences	获取Preferences实例。该接口存在异步接口。
putSync(key: string, value: ValueType): void	将数据写入Preferences实例，可通过flush将Preferences实例持久化。该接口存在异步接口。
hasSync(key: string): boolean	检查Preferences实例是否包含名为给定Key的存储键值对。给定的Key值不能为空。该接口存在异步接口。
getSync(key: string, defValue: ValueType): ValueType	获取键对应的值，如果值为null或者非默认值类型，返回默认数据defValue。该接口存在异步接口。
deleteSync(key: string): void	从Preferences实例中删除名为给定Key的存储键值对。该接口存在异步接口。
flush(callback: AsyncCallback<void>): void	将当前Preferences实例的数据异步存储到用户首选项持久化文件中。
on(type: 'change', callback: Callback<string>): void	订阅数据变更，订阅的数据发生变更后，在执行flush方法后，触发callback回调。
off(type: 'change', callback?: Callback<string>): void	取消订阅数据变更。
deletePreferences(context: Context, options: Options, callback: AsyncCallback<void>): void	从内存中移除指定的Preferences实例。若Preferences实例有对应的持久化文件，则同时删除其持久化文件。
开发步骤

导入@kit.ArkData模块。

import { preferences } from '@kit.ArkData';

获取Preferences实例。

import { UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';


let dataPreferences: preferences.Preferences | null = null;


class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    let options: preferences.Options = { name: 'myStore' };
    dataPreferences = preferences.getPreferencesSync(this.context, options);
  }
}

写入数据。

使用putSync()方法保存数据到缓存的Preferences实例中。在写入数据后，如有需要，可使用flush()方法将Preferences实例的数据存储到持久化文件。

说明

当对应的键已经存在时，putSync()方法会覆盖其值。可以使用hasSync()方法检查是否存在对应键值对。

示例代码如下所示：

import { util } from '@kit.ArkTS';
if (dataPreferences.hasSync('startup')) {
  console.info("The key 'startup' is contained.");
} else {
  console.info("The key 'startup' does not contain.");
  // 此处以此键值对不存在时写入数据为例
  dataPreferences.putSync('startup', 'auto');
  // 当字符串有特殊字符时，需要将字符串转为Uint8Array类型再存储
  let uInt8Array1 = new util.TextEncoder().encodeInto("~！@#￥%……&*（）——+？");
  dataPreferences.putSync('uInt8', uInt8Array1);
}

读取数据。

使用getSync()方法获取数据，即指定键对应的值。如果值为null或者非默认值类型，则返回默认数据。

示例代码如下所示：

let val = dataPreferences.getSync('startup', 'default');
console.info("The 'startup' value is " + val);
// 当获取的值为带有特殊字符的字符串时，需要将获取到的Uint8Array转换为字符串
let uInt8Array2 : preferences.ValueType = dataPreferences.getSync('uInt8', new Uint8Array(0));
let textDecoder = util.TextDecoder.create('utf-8');
val = textDecoder.decodeToString(uInt8Array2 as Uint8Array);
console.info("The 'uInt8' value is " + val);

删除数据。

使用deleteSync()方法删除指定键值对，示例代码如下所示：

dataPreferences.deleteSync('startup');

数据持久化。

应用存入数据到Preferences实例后，可以使用flush()方法实现数据持久化。示例代码如下所示：

dataPreferences.flush((err: BusinessError) => {
  if (err) {
    console.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
    return;
  }
  console.info('Succeeded in flushing.');
})

订阅数据变更。

应用订阅数据变更需要指定observer作为回调方法。订阅的Key值发生变更后，当执行flush()方法时，observer被触发回调。示例代码如下所示：

let observer = (key: string) => {
  console.info('The key' + key + 'changed.');
}
dataPreferences.on('change', observer);
// 数据产生变更，由'auto'变为'manual'
dataPreferences.put('startup', 'manual', (err: BusinessError) => {
  if (err) {
    console.error(`Failed to put the value of 'startup'. Code:${err.code},message:${err.message}`);
    return;
  }
  console.info("Succeeded in putting the value of 'startup'.");
  if (dataPreferences !== null) {
    dataPreferences.flush((err: BusinessError) => {
      if (err) {
        console.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in flushing.');
    })
  }
})

删除指定文件。

使用deletePreferences()方法从内存中移除指定文件对应的Preferences实例，包括内存中的数据。若该Preference存在对应的持久化文件，则同时删除该持久化文件，包括指定文件及其备份文件、损坏文件。

说明

调用该接口后，应用不允许再使用该Preferences实例进行数据操作，否则会出现数据一致性问题。

成功删除后，数据及文件将不可恢复。

示例代码如下所示：

preferences.deletePreferences(this.context, options, (err: BusinessError) => {
  if (err) {
    console.error(`Failed to delete preferences. Code:${err.code}, message:${err.message}`);
      return;
  }
  console.info('Succeeded in deleting preferences.');
})
示例代码
首选项

---

## 键值型数据库持久化

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-persistence-by-kv-store-V5

场景介绍

键值型数据库存储键值对形式的数据，当需要存储的数据没有复杂的关系模型，比如存储商品名称及对应价格、员工工号及今日是否已出勤等，由于数据复杂度低，更容易兼容不同数据库版本和设备类型，因此推荐使用键值型数据库持久化此类数据。

约束限制

设备协同数据库，针对每条记录，Key的长度≤896 Byte，Value的长度<4 MB。

单版本数据库，针对每条记录，Key的长度≤1 KB，Value的长度<4 MB。

每个应用程序最多支持同时打开16个键值型分布式数据库。

键值型数据库事件回调方法中不允许进行阻塞操作，例如修改UI组件。

接口说明

以下是键值型数据库持久化功能的相关接口，大部分为异步接口。异步接口均有callback和Promise两种返回形式，下表均以callback形式为例，更多接口及使用方式请见分布式键值数据库。

接口名称	描述
createKVManager(config: KVManagerConfig): KVManager	创建一个KVManager对象实例，用于管理数据库对象。
getKVStore<T>(storeId: string, options: Options, callback: AsyncCallback<T>): void	指定options和storeId，创建并得到指定类型的KVStore数据库。
put(key: string, value: Uint8Array | string | number | boolean, callback: AsyncCallback<void>): void	添加指定类型的键值对到数据库。
get(key: string, callback: AsyncCallback<boolean | string | number | Uint8Array>): void	获取指定键的值。
delete(key: string, callback: AsyncCallback<void>): void	从数据库中删除指定键值的数据。
closeKVStore(appId: string, storeId: string, callback: AsyncCallback<void>): void	通过storeId的值关闭指定的分布式键值数据库。
deleteKVStore(appId: string, storeId: string, callback: AsyncCallback<void>): void	通过storeId的值删除指定的分布式键值数据库。
开发步骤

若要使用键值型数据库，首先要获取一个KVManager实例，用于管理数据库对象。示例代码如下所示：

Stage模型示例：

// 导入模块
import { distributedKVStore } from '@kit.ArkData';


// Stage模型
import { window } from '@kit.ArkUI';
import { UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';


let kvManager: distributedKVStore.KVManager | undefined = undefined;


export default class EntryAbility extends UIAbility {
  onCreate() {
    let context = this.context;
    const kvManagerConfig: distributedKVStore.KVManagerConfig = {
      context: context,
      bundleName: 'com.example.datamanagertest'
    };
    try {
      // 创建KVManager实例
      kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      console.info('Succeeded in creating KVManager.');
      // 继续创建获取数据库
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
    }
  }
}
if (kvManager !== undefined) {
   kvManager = kvManager as distributedKVStore.KVManager;
  //进行后续操作
  //...
}

FA模型示例：

// 导入模块
import { distributedKVStore } from '@kit.ArkData';


// FA模型
import { featureAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';


let kvManager: distributedKVStore.KVManager | undefined = undefined;
let context = featureAbility.getContext(); // 获取context
const kvManagerConfig: distributedKVStore.KVManagerConfig = {
  context: context,
  bundleName: 'com.example.datamanagertest'
};
try {
  kvManager = distributedKVStore.createKVManager(kvManagerConfig);
  console.info('Succeeded in creating KVManager.');
  // 继续创建获取数据库
} catch (e) {
   let error = e as BusinessError;
   console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
}
if (kvManager !== undefined) {
  kvManager = kvManager as distributedKVStore.KVManager;
  //进行后续操作
  //...
}

创建并获取键值数据库。示例代码如下所示：

let kvStore: distributedKVStore.SingleKVStore | undefined = undefined;
try {
  const options: distributedKVStore.Options = {
    createIfMissing: true,
    encrypt: false,
    backup: false,
    autoSync: false,
    // kvStoreType不填时，默认创建多设备协同数据库
    kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
    // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
    securityLevel: distributedKVStore.SecurityLevel.S1
  };
  kvManager.getKVStore<distributedKVStore.SingleKVStore>('storeId', options, (err, store: distributedKVStore.SingleKVStore) => {
    if (err) {
      console.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
      return;
    }
    console.info('Succeeded in getting KVStore.');
    kvStore = store;
    // 请确保获取到键值数据库实例后，再进行相关数据操作
  });
} catch (e) {
  let error = e as BusinessError;
  console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
}
if (kvStore !== undefined) {
  kvStore = kvStore as distributedKVStore.SingleKVStore;
    //进行后续操作
    //...
}

调用put()方法向键值数据库中插入数据。示例代码如下所示：

const KEY_TEST_STRING_ELEMENT = 'key_test_string';
const VALUE_TEST_STRING_ELEMENT = 'value_test_string';
try {
  kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
    if (err !== undefined) {
      console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
      return;
    }
    console.info('Succeeded in putting data.');
  });
} catch (e) {
  let error = e as BusinessError;
  console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
}
说明

当Key值存在时，put()方法会修改其值，否则新增一条数据。

调用get()方法获取指定键的值。示例代码如下所示：

try {
  kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
    if (err !== undefined) {
      console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
      return;
    }
    console.info('Succeeded in putting data.');
    kvStore = kvStore as distributedKVStore.SingleKVStore;
    kvStore.get(KEY_TEST_STRING_ELEMENT, (err, data) => {
      if (err != undefined) {
        console.error(`Failed to get data. Code:${err.code},message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting data. Data:${data}`);
    });
  });
} catch (e) {
  let error = e as BusinessError;
  console.error(`Failed to get data. Code:${error.code},message:${error.message}`);
}

调用delete()方法删除指定键值的数据。示例代码如下所示：

try {
  kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
    if (err !== undefined) {
      console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
      return;
    }
    console.info('Succeeded in putting data.');
    kvStore = kvStore as distributedKVStore.SingleKVStore;
    kvStore.delete(KEY_TEST_STRING_ELEMENT, (err) => {
      if (err !== undefined) {
        console.error(`Failed to delete data. Code:${err.code},message:${err.message}`);
        return;
      }
      console.info('Succeeded in deleting data.');
    });
  });
} catch (e) {
  let error = e as BusinessError;
  console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
}

通过storeId的值关闭指定的分布式键值数据库。示例代码如下所示：

try {
  kvStore = undefined;
  kvManager.closeKVStore('appId', 'storeId', (err: BusinessError)=> {
    if (err) {
      console.error(`Failed to close KVStore.code is ${err.code},message is ${err.message}`);
      return;
    }
    console.info('Succeeded in closing KVStore');
  });
} catch (e) {
  let error = e as BusinessError;
  console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
}

通过storeId的值删除指定的分布式键值数据库。示例代码如下所示：

try {
  kvStore = undefined;
  kvManager.deleteKVStore('appId', 'storeId', (err: BusinessError)=> {
    if (err) {
      console.error(`Failed to close KVStore.code is ${err.code},message is ${err.message}`);
      return;
    }
    console.info('Succeeded in closing KVStore');
  });
} catch (e) {
  let error = e as BusinessError;
  console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
}

---

## 关系型数据库持久化

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-persistence-by-rdb-store-V5

场景介绍

关系型数据库基于SQLite组件，适用于存储包含复杂关系数据的场景，比如一个班级的学生信息，需要包括姓名、学号、各科成绩等，又或者公司的雇员信息，需要包括姓名、工号、职位等，由于数据之间有较强的对应关系，复杂程度比键值型数据更高，此时需要使用关系型数据库来持久化保存数据。

大数据量场景下查询数据可能会导致耗时长甚至应用卡死，如有相关操作可参考文档批量数据写数据库场景，且有建议如下：

单次查询数据量不超过5000条。
在TaskPool中查询。
拼接SQL语句尽量简洁。
合理地分批次查询。
基本概念

谓词：数据库中用来代表数据实体的性质、特征或者数据实体之间关系的词项，主要用来定义数据库的操作条件。

结果集：指用户查询之后的结果集合，可以对数据进行访问。结果集提供了灵活的数据访问方式，可以更方便地拿到用户想要的数据。

运作机制

关系型数据库对应用提供通用的操作接口，底层使用SQLite作为持久化存储引擎，支持SQLite具有的数据库特性，包括但不限于事务、索引、视图、触发器、外键、参数化查询和预编译SQL语句。

图1 关系型数据库运作机制

约束限制

系统默认日志方式是WAL（Write Ahead Log）模式，系统默认落盘方式是FULL模式。

数据库中有4个读连接和1个写连接，线程获取到空闲读连接时，即可进行读取操作。当没有空闲读连接且有空闲写连接时，会将写连接当做读连接来使用。

为保证数据的准确性，数据库同一时间只能支持一个写操作。

当应用被卸载完成后，设备上的相关数据库文件及临时文件会被自动清除。

ArkTS侧支持的基本数据类型：number、string、二进制类型数据、boolean。

为保证插入并读取数据成功，建议一条数据不要超过2M。超出该大小，插入成功，读取失败。

接口说明

以下是关系型数据库持久化功能的相关接口，大部分为异步接口。异步接口均有callback和Promise两种返回形式，下表均以callback形式为例，更多接口及使用方式请见关系型数据库。

接口名称	描述
getRdbStore(context: Context, config: StoreConfig, callback: AsyncCallback<RdbStore>): void	获得一个RdbStore，操作关系型数据库，用户可以根据自己的需求配置RdbStore的参数，然后通过RdbStore调用相关接口可以执行相关的数据操作。
executeSql(sql: string, bindArgs: Array<ValueType>, callback: AsyncCallback<void>):void	执行包含指定参数但不返回值的SQL语句。
insert(table: string, values: ValuesBucket, callback: AsyncCallback<number>):void	向目标表中插入一行数据。
update(values: ValuesBucket, predicates: RdbPredicates, callback: AsyncCallback<number>):void	根据predicates的指定实例对象更新数据库中的数据。
delete(predicates: RdbPredicates, callback: AsyncCallback<number>):void	根据predicates的指定实例对象从数据库中删除数据。
query(predicates: RdbPredicates, columns: Array<string>, callback: AsyncCallback<ResultSet>):void	根据指定条件查询数据库中的数据。
deleteRdbStore(context: Context, name: string, callback: AsyncCallback<void>): void	删除数据库。
开发步骤

因Stage模型、FA模型的差异，个别示例代码提供了在两种模型下的对应示例；示例代码未区分模型或没有对应注释说明时默认在两种模型下均适用。

关系库数据库操作或者存储过程中，有可能会因为各种原因发生非预期的数据库异常情况（抛出14800011），此时需要对数据库进行重建并恢复数据，以保障正常的应用开发，具体可见关系型数据库异常重建。

使用关系型数据库实现数据持久化，需要获取一个RdbStore，其中包括建库、建表、升降级等操作。示例代码如下所示：

Stage模型示例：

import { relationalStore } from '@kit.ArkData'; // 导入模块
import { UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';


// 此处示例在Ability中实现，使用者也可以在其他合理场景中使用
class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    const STORE_CONFIG :relationalStore.StoreConfig= {
      name: 'RdbTest.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
      encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
      isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
    };


    // 判断数据库版本，如果不匹配则需进行升降级操作
    // 假设当前数据库版本为3，表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, IDENTITY)
    const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB, IDENTITY UNLIMITED INT)'; // 建表Sql语句, IDENTITY为bigint类型，sql中指定类型为UNLIMITED INT


    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');


      // 当数据库创建时，数据库默认版本为0
      if (store.version === 0) {
        store.executeSql(SQL_CREATE_TABLE); // 创建数据表
        // 设置数据库的版本，入参为大于0的整数
        store.version = 3;
      }


      // 如果数据库版本不为0且和当前数据库版本不匹配，需要进行升降级操作
      // 当数据库存在并假定版本为1时，例应用从某一版本升级到当前版本，数据库需要从1版本升级到2版本
      if (store.version === 1) {
        // version = 1：表结构：EMPLOYEE (NAME, SALARY, CODES, ADDRESS) => version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS)
        (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE ADD COLUMN AGE INTEGER');
        store.version = 2;
      }


      // 当数据库存在并假定版本为2时，例应用从某一版本升级到当前版本，数据库需要从2版本升级到3版本
      if (store.version === 2) {
        // version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS) => version = 3：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES)
        (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE DROP COLUMN ADDRESS TEXT');
        store.version = 3;
      }
    });


    // 请确保获取到RdbStore实例后，再进行数据库的增、删、改、查等操作
  }
}

FA模型示例：

import { relationalStore } from '@kit.ArkData'; // 导入模块
import { featureAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';


let context = featureAbility.getContext();


const STORE_CONFIG :relationalStore.StoreConfig = {
  name: 'RdbTest.db', // 数据库文件名
  securityLevel: relationalStore.SecurityLevel.S3 // 数据库安全级别
};


// 假设当前数据库版本为3，表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, IDENTITY)
const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB, IDENTITY UNLIMITED INT)'; // 建表Sql语句，IDENTITY为bigint类型，sql中指定类型为UNLIMITED INT


relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
  if (err) {
    console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
    return;
  }
  console.info('Succeeded in getting RdbStore.');


  // 当数据库创建时，数据库默认版本为0
  if (store.version === 0) {
    store.executeSql(SQL_CREATE_TABLE); // 创建数据表
    // 设置数据库的版本，入参为大于0的整数
    store.version = 3;
  }


  // 如果数据库版本不为0且和当前数据库版本不匹配，需要进行升降级操作
  // 当数据库存在并假定版本为1时，例应用从某一版本升级到当前版本，数据库需要从1版本升级到2版本
  if (store.version === 1) {
    // version = 1：表结构：EMPLOYEE (NAME, SALARY, CODES, ADDRESS) => version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS)
    store.executeSql('ALTER TABLE EMPLOYEE ADD COLUMN AGE INTEGER');
    store.version = 2;
  }


  // 当数据库存在并假定版本为2时，例应用从某一版本升级到当前版本，数据库需要从2版本升级到3版本
  if (store.version === 2) {
    // version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS) => version = 3：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES)
    store.executeSql('ALTER TABLE EMPLOYEE DROP COLUMN ADDRESS TEXT');
    store.version = 3;
  }
});


// 请确保获取到RdbStore实例后，再进行数据库的增、删、改、查等操作
说明

应用创建的数据库与其上下文（Context）有关，即使使用同样的数据库名称，但不同的应用上下文，会产生多个数据库，例如每个UIAbility都有各自的上下文。

当应用首次获取数据库（调用getRdbStore）后，在应用沙箱内会产生对应的数据库文件。使用数据库的过程中，在与数据库文件相同的目录下可能会产生以-wal和-shm结尾的临时文件。此时若开发者希望移动数据库文件到其它地方使用查看，则需要同时移动这些临时文件，当应用被卸载完成后，其在设备上产生的数据库文件及临时文件也会被移除。

错误码的详细介绍请参见通用错误码和关系型数据库错误码。

获取到RdbStore后，调用insert()接口插入数据。示例代码如下所示：

let store: relationalStore.RdbStore | undefined = undefined;


let value1 = 'Lisa';
let value2 = 18;
let value3 = 100.5;
let value4 = new Uint8Array([1, 2, 3, 4, 5]);
let value5 = BigInt('15822401018187971961171');
// 以下三种方式可用
const valueBucket1: relationalStore.ValuesBucket = {
  'NAME': value1,
  'AGE': value2,
  'SALARY': value3,
  'CODES': value4,
  'IDENTITY': value5,
};
const valueBucket2: relationalStore.ValuesBucket = {
  NAME: value1,
  AGE: value2,
  SALARY: value3,
  CODES: value4,
  IDENTITY: value5,
};
const valueBucket3: relationalStore.ValuesBucket = {
  "NAME": value1,
  "AGE": value2,
  "SALARY": value3,
  "CODES": value4,
  "IDENTITY": value5,
};


if (store !== undefined) {
  (store as relationalStore.RdbStore).insert('EMPLOYEE', valueBucket1, (err: BusinessError, rowId: number) => {
    if (err) {
      console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
      return;
    }
    console.info(`Succeeded in inserting data. rowId:${rowId}`);
  })
}
说明

关系型数据库没有显式的flush操作实现持久化，数据插入即保存在持久化文件。

根据谓词指定的实例对象，对数据进行修改或删除。

调用update()方法修改数据，调用delete()方法删除数据。示例代码如下所示：

let value6 = 'Rose';
let value7 = 22;
let value8 = 200.5;
let value9 = new Uint8Array([1, 2, 3, 4, 5]);
let value10 = BigInt('15822401018187971967863');
// 以下三种方式可用
const valueBucket4: relationalStore.ValuesBucket = {
  'NAME': value6,
  'AGE': value7,
  'SALARY': value8,
  'CODES': value9,
  'IDENTITY': value10,
};
const valueBucket5: relationalStore.ValuesBucket = {
  NAME: value6,
  AGE: value7,
  SALARY: value8,
  CODES: value9,
  IDENTITY: value10,
};
const valueBucket6: relationalStore.ValuesBucket = {
  "NAME": value6,
  "AGE": value7,
  "SALARY": value8,
  "CODES": value9,
  "IDENTITY": value10,
};


// 修改数据
let predicates1 = new relationalStore.RdbPredicates('EMPLOYEE'); // 创建表'EMPLOYEE'的predicates
predicates1.equalTo('NAME', 'Lisa'); // 匹配表'EMPLOYEE'中'NAME'为'Lisa'的字段
if (store !== undefined) {
  (store as relationalStore.RdbStore).update(valueBucket4, predicates1, (err: BusinessError, rows: number) => {
    if (err) {
      console.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
     return;
   }
   console.info(`Succeeded in updating data. row count: ${rows}`);
  })
}


// 删除数据
predicates1 = new relationalStore.RdbPredicates('EMPLOYEE');
predicates1.equalTo('NAME', 'Lisa');
if (store !== undefined) {
  (store as relationalStore.RdbStore).delete(predicates1, (err: BusinessError, rows: number) => {
    if (err) {
      console.error(`Failed to delete data. Code:${err.code}, message:${err.message}`);
      return;
    }
    console.info(`Delete rows: ${rows}`);
  })
}

根据谓词指定的查询条件查找数据。

调用query()方法查找数据，返回一个ResultSet结果集。示例代码如下所示：

let predicates2 = new relationalStore.RdbPredicates('EMPLOYEE');
predicates2.equalTo('NAME', 'Rose');
if (store !== undefined) {
  (store as relationalStore.RdbStore).query(predicates2, ['ID', 'NAME', 'AGE', 'SALARY', 'IDENTITY'], (err: BusinessError, resultSet) => {
    if (err) {
      console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
      return;
    }
    console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
    // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
    while (resultSet.goToNextRow()) {
      const id = resultSet.getLong(resultSet.getColumnIndex('ID'));
      const name = resultSet.getString(resultSet.getColumnIndex('NAME'));
      const age = resultSet.getLong(resultSet.getColumnIndex('AGE'));
      const salary = resultSet.getDouble(resultSet.getColumnIndex('SALARY'));
      const identity = resultSet.getValue(resultSet.getColumnIndex('IDENTITY'));
      console.info(`id=${id}, name=${name}, age=${age}, salary=${salary}, identity=${identity}`);
    }
    // 释放数据集的内存
    resultSet.close();
  })
}
说明

当应用完成查询数据操作，不再使用结果集（ResultSet）时，请及时调用close方法关闭结果集，释放系统为其分配的内存。

在同路径下备份数据库。关系型数据库支持两种手动备份和自动备份（仅系统应用可用）两种方式，具体可见关系型数据库备份。

此处以手动备份为例：

if (store !== undefined) {
  // "Backup.db"为备份数据库文件名，默认在RdbStore同路径下备份。也可指定路径：customDir + "backup.db"
  (store as relationalStore.RdbStore).backup("Backup.db", (err: BusinessError) => {
    if (err) {
      console.error(`Failed to backup RdbStore. Code:${err.code}, message:${err.message}`);
      return;
    }
    console.info(`Succeeded in backing up RdbStore.`);
  })
}

从备份数据库中恢复数据。关系型数据库支持两种方式：恢复手动备份数据和恢复自动备份数据（仅系统应用可用），具体可见关系型数据库数据恢复。

此处以调用restore接口恢复手动备份数据为例：

if (store !== undefined) {
  (store as relationalStore.RdbStore).restore("Backup.db", (err: BusinessError) => {
    if (err) {
      console.error(`Failed to restore RdbStore. Code:${err.code}, message:${err.message}`);
      return;
    }
    console.info(`Succeeded in restoring RdbStore.`);
  })
}

删除数据库。

调用deleteRdbStore()方法，删除数据库及数据库相关文件。示例代码如下：

Stage模型示例：

relationalStore.deleteRdbStore(this.context, 'RdbTest.db', (err: BusinessError) => {
 if (err) {
    console.error(`Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
    return;
  }
  console.info('Succeeded in deleting RdbStore.');
});

FA模型示例：

relationalStore.deleteRdbStore(context, 'RdbTest.db', (err: BusinessError) => {
  if (err) {
    console.error(`Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
    return;
  }
  console.info('Succeeded in deleting RdbStore.');
});

---


---

> 📎 网络请求（HTTP/WebSocket/Socket）见 [network-data-network.md](./network-data-network.md)

## See Also

- [network-data-network.md](./network-data-network.md) — HTTP/WebSocket/Socket 网络请求
- [state-management.md](./state-management.md) — 状态管理
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) — HttpUtil 等代码模式
