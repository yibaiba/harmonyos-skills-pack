# Location Kit 位置服务（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V5/API 12）
> 覆盖：位置服务简介、权限申请、设备定位、地理编码/逆编码、地理围栏


## 目录

- [Location Kit简介](#location-kit简介)
- [申请位置权限开发指导](#申请位置权限开发指导)
- [获取设备的位置信息开发指导](#获取设备的位置信息开发指导)
- [地理编码转化与逆地理编码转化开发指导](#地理编码转化与逆地理编码转化开发指导)
- [地理围栏开发指导](#地理围栏开发指导)

---

## Location Kit简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/location-kit-intro-V5

Location Kit开发概述

移动终端设备已经深入人们日常生活的方方面面，如查看所在城市的天气、新闻轶事、出行打车、旅行导航、运动记录。这些习以为常的活动，都离不开定位用户终端设备的位置。

当用户处于这些丰富的使用场景中时，系统的位置能力可以提供实时准确的位置数据。对于开发者，设计基于位置体验的服务，也可以使应用的使用体验更贴近每个用户。

当应用在实现基于设备位置的功能时，如：驾车导航，记录运动轨迹等，可以调用该模块的API接口，完成位置信息的获取。

Location Kit简介

位置子系统使用多种定位技术提供服务，如GNSS定位、基站定位、WLAN/蓝牙定位（基站定位、WLAN/蓝牙定位后续统称“网络定位技术”）；通过这些定位技术，无论用户设备在室内或是户外，都可以准确地确定设备位置。

Location Kit除了提供基础的定位服务之外，还提供了地理围栏、地理编码、逆地理编码、国家码等功能和接口。

坐标

系统以1984年世界大地坐标系统为参考，使用经度、纬度数据描述地球上的一个位置。

GNSS定位

基于全球导航卫星系统，包含：GPS、GLONASS、北斗、Galileo等，通过导航卫星、设备芯片提供的定位算法，来确定设备准确位置。定位过程具体使用哪些定位系统，取决于用户设备的硬件能力。

基站定位

根据设备当前驻网基站和相邻基站的位置，估算设备当前位置。此定位方式的定位结果精度相对较低，并且需要设备可以访问蜂窝网络。

WLAN、蓝牙定位

根据设备可搜索到的周围WLAN、蓝牙设备位置，估算设备当前位置。此定位方式的定位结果精度依赖设备周围可见的固定WLAN、蓝牙设备的分布，密度较高时，精度也相较于基站定位方式更高，同时也需要设备可以访问网络。

约束与限制

位置能力作为系统为应用提供的一种基础服务，需要应用在所使用的业务场景，向系统主动发起请求，并在业务场景结束时，主动结束此请求，在此过程中系统会将实时的定位结果上报给应用。

使用设备的位置能力，需要用户进行确认并主动开启位置开关。如果位置开关没有开启，系统不会向任何应用提供定位服务。

设备位置信息属于用户敏感数据，所以即使用户已经开启位置开关，应用在获取设备位置前仍需向用户申请位置访问权限。在用户确认允许后，系统才会向应用提供定位服务。

---

## 申请位置权限开发指导

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/location-permission-guidelines-V5

场景概述

应用在使用Location Kit系统能力前，需要检查是否已经获取用户授权访问设备位置信息。如未获得授权，可以向用户申请需要的位置权限。

系统提供的定位权限有：

ohos.permission.LOCATION：用于获取精准位置，精准度在米级别。

ohos.permission.APPROXIMATELY_LOCATION：用于获取模糊位置，精确度为5公里。

ohos.permission.LOCATION_IN_BACKGROUND：用于应用切换到后台仍然需要获取定位信息的场景。

Location Kit接口对权限的要求参见：Location Kit。

开发步骤

开发者可以在应用配置文件中声明所需要的权限并向用户申请授权，具体可参考向用户申请授权。

当APP运行在前台，且访问设备位置信息时，申请位置权限的方式如下：

申请位置权限的方式	是否允许申请	申请成功后获取的位置的精确度
申请ohos.permission.APPROXIMATELY_LOCATION	是	获取到模糊位置，精确度为5公里。
同时申请ohos.permission.APPROXIMATELY_LOCATION和ohos.permission.LOCATION	是	获取到精准位置，精准度在米级别。
当APP运行在后台时，申请位置权限的方式如下：

如果应用在后台运行时也需要访问设备位置，除了按照步骤2申请权限外，还需要申请LOCATION类型的长时任务。

长时任务申请可参考：长时任务介绍。

示例代码
位置信息

---

## 获取设备的位置信息开发指导

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/location-guidelines-V5

场景概述

开发者可以调用HarmonyOS位置相关接口，获取设备实时位置，或者最近的历史位置，以及监听设备的位置变化。

对于位置敏感的应用业务，建议获取设备实时位置信息。如果不需要设备实时位置信息，并且希望尽可能的节省耗电，开发者可以考虑获取最近的历史位置。

接口说明

获取设备的位置信息所使用的接口如下，详细说明参见：Location Kit。

本模块能力仅支持WGS-84坐标系。

接口名	功能描述
on(type: 'locationChange', request: LocationRequest | ContinuousLocationRequest, callback: Callback<Location>): void	开启位置变化订阅，并发起定位请求。
off(type: 'locationChange', callback?: Callback<Location>): void	关闭位置变化订阅，并删除对应的定位请求。
getCurrentLocation(request: CurrentLocationRequest | SingleLocationRequest, callback: AsyncCallback<Location>): void	获取当前位置，使用callback回调异步返回结果。
getCurrentLocation(request?: CurrentLocationRequest | SingleLocationRequest): Promise<Location>	获取当前位置，使用Promise方式异步返回结果。
getLastLocation(): Location	获取最近一次定位结果。
isLocationEnabled(): boolean	判断位置服务是否已经开启。
开发步骤

获取设备的位置信息，需要有位置权限，位置权限申请的方法和步骤见申请位置权限开发指导。

导入geoLocationManager模块，所有与基础定位能力相关的功能API，都是通过该模块提供的。

import { geoLocationManager } from '@kit.LocationKit';

调用获取位置接口之前需要先判断位置开关是否打开。

查询当前位置开关状态，返回结果为布尔值，true代表位置开关开启，false代表位置开关关闭，示例代码如下：

import { geoLocationManager } from '@kit.LocationKit';
try {
    let locationEnabled = geoLocationManager.isLocationEnabled();
} catch (err) {
    console.error("errCode:" + err.code + ", message:"  + err.message);
}

如果位置开关未开启，可以拉起全局开关设置弹框，引导用户打开位置开关，具体可参考拉起全局开关设置弹框

单次获取当前设备位置。多用于查看当前位置、签到打卡、服务推荐等场景。

方式一：获取系统缓存的最新位置。

如果系统当前没有缓存位置会返回错误码。

推荐优先使用该接口获取位置，可以减少系统功耗。

如果对位置的新鲜度比较敏感，可以先获取缓存位置，将位置中的时间戳与当前时间对比，若新鲜度不满足预期可以使用方式二获取位置。

import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit'
try {
    let location = geoLocationManager.getLastLocation();
} catch (err) {
    console.error("errCode:" + JSON.stringify(err));
}

方式二：获取当前位置。

首先要实例化SingleLocationRequest对象，用于告知系统该向应用提供何种类型的位置服务，以及单次定位超时时间。

设置LocatingPriority：

如果对位置的返回精度要求较高，建议LocatingPriority参数优先选择PRIORITY_ACCURACY，会将一段时间内精度较好的结果返回给应用。

如果对定位速度要求较高，建议LocatingPriority参数选择PRIORITY_LOCATING_SPEED，会将最先拿到的定位结果返回给应用。

两种定位策略均会同时使用GNSS定位和网络定位技术，以便在室内和户外场景下均可以获取到位置结果，对设备的硬件资源消耗较大，功耗也较大。

设置locatingTimeoutMs：

因为设备环境、设备所处状态、系统功耗管控策略等的影响，定位返回的时延会有较大波动，建议把单次定位超时时间设置为10秒。

以快速定位策略(PRIORITY_LOCATING_SPEED)为例，调用方式如下：

import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit'
let request: geoLocationManager.SingleLocationRequest = {
   'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
   'locatingTimeoutMs': 10000
}
try {
   geoLocationManager.getCurrentLocation(request).then((result) => { // 调用getCurrentLocation获取当前设备位置，通过promise接收上报的位置
      console.log('current location: ' + JSON.stringify(result));
   })
   .catch((error:BusinessError) => { // 接收上报的错误码
      console.error('promise, getCurrentLocation: error=' + JSON.stringify(error));
   });
 } catch (err) {
   console.error("errCode:" + JSON.stringify(err));
 }

通过本模块获取到的坐标均为WGS-84坐标系坐标点，如需使用其它坐标系类型的坐标点，请进行坐标系转换后再使用。

可参考Map Kit提供的地图计算工具进行坐标转换。

持续定位。多用于导航、运动轨迹、出行等场景。

首先要实例化ContinuousLocationRequest对象，用于告知系统该向应用提供何种类型的位置服务，以及位置结果上报的频率。

设置locationScenario：

建议locationScenario参数优先根据应用的使用场景进行设置，该参数枚举值定义参见UserActivityScenario，例如地图在导航时使用NAVIGATION参数，可以持续在室内和室外场景获取位置用于导航。

设置interval：

表示上报位置信息的时间间隔，单位是秒，默认值为1秒。如果对位置上报时间间隔无特殊要求，可以不填写该字段。

以地图导航场景为例，调用方式如下：

import { geoLocationManager } from '@kit.LocationKit';
let request: geoLocationManager.ContinuousLocationRequest= {
   'interval': 1,
   'locationScenario': geoLocationManager.UserActivityScenario.NAVIGATION
}
let locationCallback = (location:geoLocationManager.Location):void => {
   console.log('locationCallback: data: ' + JSON.stringify(location));
};
try {
   geoLocationManager.on('locationChange', request, locationCallback);
} catch (err) {
   console.error("errCode:" + JSON.stringify(err));
}

如果不主动结束定位可能导致设备功耗高，耗电快；建议在不需要获取定位信息时及时结束定位。

geoLocationManager.off('locationChange', locationCallback);

---

## 地理编码转化与逆地理编码转化开发指导

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/geocode-guidelines-V5

场景概述

使用坐标描述一个位置，非常准确，但是并不直观，面向用户表达并不友好。系统向开发者提供了以下两种转化能力。

地理编码转化：将地理描述转化为具体坐标。

逆地理编码转化能力：将坐标转化为地理描述。

其中地理编码包含多个属性来描述位置，包括国家、行政区划、街道、门牌号、地址描述等等，这样的信息更便于用户理解。

接口说明

进行坐标和地理编码信息的相互转化，所使用的接口说明如下，详细信息参见：Location Kit。

接口名	功能描述
isGeocoderAvailable(): boolean;	判断地理编码与逆地理编码服务是否可用。
getAddressesFromLocation(request: ReverseGeoCodeRequest, callback: AsyncCallback<Array<GeoAddress>>): void	调用逆地理编码服务，将坐标转换为地理描述，使用callback回调异步返回结果。
getAddressesFromLocationName(request: GeoCodeRequest, callback: AsyncCallback<Array<GeoAddress>>): void	调用地理编码服务，将地理描述转换为具体坐标，使用callback回调异步返回结果。
开发步骤
说明

地理编码与逆地理编码功能需要访问后端服务，请确保设备联网，以进行信息获取。

导入geoLocationManager模块，所有与地理编码转化&逆地理编码转化能力相关的功能API，都是通过该模块提供的。

import { geoLocationManager } from '@kit.LocationKit';

查询地理编码与逆地理编码服务是否可用。

调用isGeoServiceAvailable查询地理编码与逆地理编码服务是否可用，如果服务可用再继续进行步骤3。如果服务不可用，说明该设备不具备地理编码与逆地理编码能力，请勿使用相关接口。

import { geoLocationManager } from '@kit.LocationKit';
try {
    let isAvailable = geoLocationManager.isGeocoderAvailable();
} catch (err) {
    console.error("errCode:" + JSON.stringify(err));
}

获取转化结果。

调用getAddressesFromLocation，把坐标转化为地理位置信息。应用可以获得与此坐标匹配的GeoAddress（地理编码地址信息）列表，应用可以根据实际使用需求，读取相应的参数数据。

let reverseGeocodeRequest:geoLocationManager.ReverseGeoCodeRequest = {"latitude": 31.12, "longitude": 121.11, "maxItems": 1};
try {
    geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest, (err, data) => {
        if (err) {
            console.log('getAddressesFromLocation err: ' + JSON.stringify(err));
        } else {
            console.log('getAddressesFromLocation data: ' + JSON.stringify(data));
        }
    });
} catch (err) {
    console.error("errCode:" + JSON.stringify(err));
}

调用getAddressesFromLocationName把位置描述转化为坐标。

let geocodeRequest:geoLocationManager.GeoCodeRequest = {"description": "上海市浦东新区xx路xx号", "maxItems": 1};
try {
    geoLocationManager.getAddressesFromLocationName(geocodeRequest, (err, data) => {
        if (err) {
            console.log('getAddressesFromLocationName err: ' + JSON.stringify(err));
        } else {
            console.log('getAddressesFromLocationName data: ' + JSON.stringify(data));
        }
    });
} catch (err) {
    console.error("errCode:" + JSON.stringify(err));
}

应用可以获得与位置描述相匹配的GeoAddress（地理编码地址信息）列表，其中包含对应的坐标数据。

如果需要查询的位置描述可能出现多地重名的请求，可以设置GeoCodeRequest，通过设置一个经纬度范围，以高效地获取期望的准确结果。

---

## 地理围栏开发指导

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/geofence-guidelines-V5

场景概述

地理围栏就是虚拟地理边界，当设备进入、离开某个特定地理区域时，可以接收自动通知和警告。

目前仅支持圆形围栏，并且依赖GNSS芯片的地理围栏功能，仅在室外开阔区域才能准确识别用户进出围栏事件。

应用场景举例：开发者可以使用地理围栏，在企业周围创建一个区域进行广告定位，在不同的地点，在移动设备上进行有针对性的促销优惠。

接口说明

地理围栏所使用的接口如下，详细说明参见：Location Kit。

接口名	功能描述
on(type: 'gnssFenceStatusChange', request: GeofenceRequest, want: WantAgent): void;	添加一个围栏，并订阅地理围栏事件。
off(type: 'gnssFenceStatusChange', request: GeofenceRequest, want: WantAgent): void;	删除一个围栏，并取消订阅该围栏事件。
开发步骤

使用地理围栏功能，需要有权限ohos.permission.APPROXIMATELY_LOCATION，位置权限申请的方法和步骤见申请位置权限开发指导。

导入geoLocationManager模块、wantAgent模块和BusinessError模块。

import { geoLocationManager } from '@kit.LocationKit';
import { wantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit'

创建WantAgentInfo信息。

场景一：创建拉起Ability的WantAgentInfo信息。

// 通过WantAgentInfo的operationType设置动作类型
let wantAgentInfo:wantAgent.WantAgentInfo = {
    wants: [
        {
            deviceId: '',
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
            action: '',
            entities: [],
            uri: '',
            parameters: {}
        }
    ],
    operationType: wantAgent.OperationType.START_ABILITY,
    requestCode: 0,
    wantAgentFlags:[wantAgent.WantAgentFlags.CONSTANT_FLAG]
};

场景二：创建发布公共事件的WantAgentInfo信息。

// 通过WantAgentInfo的operationType设置动作类型
let wantAgentInfo:wantAgent.WantAgentInfo = {
    wants: [
        {
            action: 'event_name', // 设置事件名
            parameters: {},
        }
    ],
    operationType: wantAgent.OperationType.SEND_COMMON_EVENT,
    requestCode: 0,
    wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
}

调用getWantAgent()方法进行创建WantAgent。

并且在获取到WantAgent对象之后调用地理围栏接口添加围栏，当设备进入或者退出该围栏时，系统会自动触发WantAgent的动作。

let wantAgentObj : object | undefined = undefined;
// 创建WantAgent
wantAgent.getWantAgent(wantAgentInfo, (err, data) => {
    if (err) {
      console.error('getWantAgent err=' + JSON.stringify(err));
      return;
    }
    console.info('getWantAgent success');
    wantAgentObj = data;
    let requestInfo:geoLocationManager.GeofenceRequest = {'scenario': 0x301, "geofence": {"latitude": 31.12, "longitude": 121.11, "radius": 100, "expiration": 10000}};
    try {
        geoLocationManager.on('gnssFenceStatusChange', requestInfo, wantAgentObj);
    } catch (err) {
        console.error("errCode:" + JSON.stringify(err));
    }
});

---


## See Also

- [Notification Kit 通知服务](notification-kit.md)
- [网络请求与数据持久化](network-data.md)
