# HarmonyOS 6.0 版本概览与新特性

> 来源：developer.huawei.com/consumer/cn/doc/harmonyos-releases/
> 版本范围：6.0.0(API 20) → 6.0.1(API 21) → 6.0.2(API 22)
> 提取时间：2025-07

<!-- Agent 摘要：本文件 1493 行，HarmonyOS 6.0 全版本新特性概览。
     内容：各版本 Release Notes 摘要 + 新增能力 + breaking changes 汇总。
     是 6.0 系列的总入口，建议先读本文件再按需查阅具体 API changelog。
     API changelog → harmonyos-6-api-core.md / harmonyos-6-api-arkui.md 等。 -->

## 版本映射

| 版本 | API Level | DevEco Studio | 发布时间 |
|------|-----------|---------------|----------|
| 6.0.0 | API 20 | 6.0.0 Release | 2025/06/20 |
| 6.0.1 | API 21 | 6.0.1 Release | 2025/09 |
| 6.0.2 | API 22 | 6.0.2 Release | 2026/01/21 |

## 6.0.0 (API 20)

### 版本概览

HarmonyOS开发者版本6.0.0(20) Release于2025年9月25日正式发布。

6.0.0(20)在5.1.1(19)的基础上，进一步增强ArkUI组件能力，新增多个系统组件并优化多个组件调用细节等；ArkWeb的Chromium内核升级至132版本，ArkWeb能力增强；新增端侧问答模型，支持端侧的智能问答，新增智慧化数据检索C API，支持向量化、知识检索和知识问答的能力；地图能力新增矢量图层、流场图层、海量点图层、热力图层，支持通过自定义组件生成marker图标等等，更多详情可参见OS平台新增和增强特性。

DevEco Studio新增AI智能辅助编程，进一步提升编译构建效率和优化内存占用，ArkUI Inspector新增支持按照组件粒度3D展开应用，方便查看组件之间的嵌套、遮挡关系，智慧调优能力新增支持对Allocation内存分配问题和Snapshot内存堆快照问题进行分析，更多详情可参见DevEco Studio新增和增强特性。

版本信息
说明

使用正确的配套关系进行应用开发可以获得更流畅的开发体验。

请在阅读版本更新和变更内容前，务必确认版本的配套关系是否与当前您所使用的开发套件是一致的。

6.0.0(20) Release开发者套件配套信息

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Release

	

6.0.0(20)

*注意：设备系统支持的API能力范围请以API版本为准。

	

2025/09/25




DevEco Studio

	

Release

	

DevEco Studio 6.0.0 Release（6.0.0.878）

（Patch版本）

	

2025/12/24




DevEco Studio 6.0.0 Release (6.0.0.868)

（Patch版本）

	

2025/10/23




DevEco Studio 6.0.0 Release (6.0.0.858)

	

2025/09/25




SDK

	

Release

	

HarmonyOS 6.0.0 Release SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.0.47 (API 20 Release)

	

2025/09/25

说明
API版本请在设备的“设置”中点击设备名称，进入“关于本机”进行查询。
DevEco Studio版本请从DevEco Studio界面菜单选择“Help > About DevEco Studio”进行查询。
SDK内置在DevEco Studio，安装DevEco Studio时自动安装配套版本SDK。具体版本请从DevEco Studio界面菜单选择“Help > About HarmonyOS SDK”进行查询。
应用工程版本信息配置建议

应用工程中应当正确配置应用运行所依赖的SDK版本信息，以确保应用在不同系统版本的设备上运行时的兼容性。

使用该版本开发的应用，其build-profile.json5配置项中关于版本的配置项建议如下：

build-profile.json5配置项

	

已开发应用

	

新启动开发应用




配置建议

	

配置示例




compileSdkVersion

	

无需显性配置，编译时默认使用配套的SDK版本，即默认为：

“compileSdkVersion”: “6.0.0(20)”

	

NA

	

推荐使用6.0.0(20)进行新应用的开发。




compatibleSdkVersion

	

建议与工程升级前的compatibleSdkVersion保持一致

	

和升级前保持一致，如：

“compatibleSdkVersion”: “5.0.5(17)”




targetSdkVersion

	

推荐您适配新版本的最新变更，然后配置为：“targetSdkVersion”: “6.0.0(20)”。

如果您期望延迟适配变更，可配置targetSdkVersion与工程升级前的targetSdkVersion一致。

	

1、应用适配变更，变更适配完成后配置为：

“targetSdkVersion”: “6.0.0(20)”

2、应用暂不适配变更，需配置为工程升级前的值，如：

“targetSdkVersion”: “5.0.5(17)”

历史Beta版本
6.0.0(20) Beta5

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Beta

	

6.0.0(20) Beta5

*注意：设备系统支持的API能力范围请以API版本为准。

	

2025/09/15




DevEco Studio

	

Beta

	

DevEco Studio 6.0.0 Beta5 (6.0.0.848)

	

2025/09/15




SDK

	

Beta

	

HarmonyOS 6.0.0 Beta5 SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.0.47 (API 20 Beta5)

	

2025/09/15

6.0.0(20) Beta3

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Beta

	

6.0.0(20) Beta3

*注意：设备系统支持的API能力范围请以API版本为准。

	

2025/08/20




DevEco Studio

	

Beta

	

DevEco Studio 6.0.0 Beta3 (6.0.0.828)

	

2025/08/20




SDK

	

Beta

	

HarmonyOS 6.0.0 Beta3 SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.0.45(API 20 Beta3)

	

2025/08/20

6.0.0(20) Beta2

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Beta

	

6.0.0(20) Beta2

*注意：设备系统支持的API能力范围请以API版本为准。

	

2025/07/23




DevEco Studio

	

Beta

	

DevEco Studio 6.0.0 Beta2 (6.0.0.456)

	

2025/07/23




SDK

	

Beta

	

HarmonyOS 6.0.0 Beta2 SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.0.39(API 20 Beta2)

	

2025/07/23

6.0.0(20) Beta1

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Beta

	

6.0.0(20) Beta1

*注意：设备系统支持的API能力范围请以API版本为准。

	

2025/06/20




DevEco Studio

	

Beta

	

DevEco Studio 6.0.0 Beta1 (6.0.0.418SP)

	

2025/06/25




DevEco Studio 6.0.0 Beta1 (6.0.0.418)

	

2025/06/20




SDK

	

Beta

	

HarmonyOS 6.0.0 Beta1 SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.0.35(API 20 Beta1)

	

2025/06/20

### 新增和增强特性

6.0.0(20) Release

6.0.0(20) Release不涉及新增特性。

6.0.0(20) Beta5关键特性
AppGallery Kit

应用市场更新功能新增支持Wearable设备。（指南）

App Linking Kit

新增支持通过聚合链接按指定方式跳转至应用，例如跳转至HarmonyOS平台预览页、应用市场详情页、自定义网址、深度链接地址等。（指南）

ArkUI

C API新增提供渲染节点的能力。（指南、API参考）

Camera Kit

新增支持对微距状态变化事件的监听。（API参考-PhotoSession、API参考-VideoSession）

Media Kit

新增支持通过C API设置捕获图像在目标区域的填充模式。（API参考）

Network Kit
新增支持设置当前PAC脚本的URL地址。通过解析脚本地址可以获取代理信息。(API参考)
新增TLS认证支持国密证书。(API参考)
Telephony Kit

新增支持查看卡槽ID和SIM卡的对应关系。(API参考)

6.0.0(20) Beta3关键特性
Ability Kit

新增支持应用预加载机制。该机制会根据用户的使用习惯，在系统资源充足时提前加载应用至特定阶段。（指南）

Ads Kit

开放匿名设备标识服务新增支持TV设备。（指南、API参考）

Agent Framework Kit

【新增Kit】新增Agent Framework Kit（智能体框架服务）提供了拉起指定智能体的能力。（指南、API参考）

ArkData
新增支持监听附件传输的进度，支持接续传输。（API参考）
新增支持应用间配置信息的共享。（指南、API参考）
ArkUI
新增闪控球功能，提供控制闪控球的相关API。（API参考）
@Consume装饰的变量支持设置默认值。（指南）
新增支持将属性字符串根据文本布局选项转换成对应的Paragraph数组。（API参考）
SymbolGlyph新增支持快速替换动效（API参考）、阴影效果（API参考）、禁用动效（API参考）、渐变效果（API参考）。
Text组件新增支持设置为数字翻牌动效。（API参考）
Scroll组件新增支持设置手势缩放的大小比例控制。（API参考）
Swiper组件新增支持滑动状态变化事件回调，在跟手滑动、离手动画、停止三种滑动状态变化时触发，返回值为当前滑动状态。（API参考）
Navigation新增支持绑定路由栈到Navigation组件，并且指定一个NavDestination作为Navigation的导航栏（主页）。（API参考）
弹出菜单新增属性anchorPosition，用于支持通过设定水平与垂直偏移量，控制菜单相对于绑定组件左上角的弹出位置。（API参考）
PC/2in1设备或自由多窗模式的平板设备的窗口能力增强：
新增支持设置一级子窗是否支持与主窗保持相对位置不变。（API参考）
新增支持设置主窗口是否显示阴影。（API参考）
新增支持设置主窗口容器在焦点态和非焦点态时的背景色。（API参考）
屏幕管理新增支持将指定屏幕左上角为原点的相对坐标转换成主屏左上角为原点的全局坐标。（API参考）

## 6.0.1 (API 21)

### 版本概览

6.0.1(21)在6.0.0(20)的基础上，进一步增强ArkUI组件能力，新增一批属性样式的C API，增强了Image组件的SVG解析能力；Ability Kit增强了拉起应用的结果处理；ArkWeb增强了WebView相关能力；后台任务新增支持并行创建多个同样的长时任务；地图服务进一步丰富了可直接调用的场景，等等。更多详情可参见OS平台新增和增强特性。

DevEco Studio进一步增强AI智能辅助编程的能力和Code Linter静态检测能力，工程级配置文件新增多个可选配置字段，等等。更多详情可参见DevEco Studio新增和增强特性。

版本信息
说明

使用正确的配套关系进行应用开发可以获得更流畅的开发体验。

请在阅读版本更新和变更内容前，务必确认版本的配套关系是否与当前您所使用的开发套件是一致的。

6.0.1(21)开发者套件配套信息

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Release

	

6.0.1(21)

*注意：设备系统支持的API能力范围请以API版本为准。

	

2025/11/20




DevEco Studio

	

Release

	

DevEco Studio 6.0.1 Release (6.0.1.268)

（Patch版本）

	

2026/02/13




DevEco Studio 6.0.1 Release (6.0.1.260)

（Patch版本）

	

2025/12/17




DevEco Studio 6.0.1 Release (6.0.1.251)

（Patch版本）

	

2025/11/24




DevEco Studio 6.0.1 Release (6.0.1.249)

	

2025/11/20




SDK

	

Release

	

HarmonyOS 6.0.1 Release SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.1.112 (API 21 Release)

	

2025/11/20

说明
API版本请在设备的“设置”中点击设备名称，进入“关于本机”进行查询。
DevEco Studio版本请从DevEco Studio界面菜单选择“Help > About DevEco Studio”进行查询。
SDK内置在DevEco Studio，安装DevEco Studio时自动安装配套版本SDK。具体版本请从DevEco Studio界面菜单选择“Help > About HarmonyOS SDK”进行查询。
应用工程版本信息配置建议

应用工程中应当正确配置应用运行所依赖的SDK版本信息，以确保应用在不同系统版本的设备上运行时的兼容性。

使用该版本开发的应用，其build-profile.json5配置项中关于版本的配置项建议如下：

build-profile.json5配置项

	

已开发应用

	

新启动开发应用




配置建议

	

配置示例




compileSdkVersion

	

无需显性配置，编译时默认使用配套的SDK版本，即默认为：

“compileSdkVersion”: “6.0.1(21)”

	

NA

	

推荐使用6.0.0(20)进行新应用的开发。




compatibleSdkVersion

	

建议与工程升级前的compatibleSdkVersion保持一致

	

和升级前保持一致，如：

“compatibleSdkVersion”: “5.0.5(17)”




targetSdkVersion

	

推荐您适配新版本的最新变更，然后配置为：“targetSdkVersion”: “6.0.1(21)”。

如果您期望延迟适配变更，可配置targetSdkVersion与工程升级前的targetSdkVersion一致。

	

1、应用适配变更，变更适配完成后配置为：

“targetSdkVersion”: “6.0.1(21)”

2、应用暂不适配变更，需配置为工程升级前的值，如：

“targetSdkVersion”: “5.0.5(17)”

历史Beta版本
6.0.1(21) Beta1

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Beta

	

6.0.1(21) Beta1

*注意：设备系统支持的API能力范围请以API版本为准。

	

2025/11/06




DevEco Studio

	

Beta

	

DevEco Studio 6.0.1 Beta1 (6.0.1.246)

	

2025/11/06




SDK

	

Beta

	

HarmonyOS 6.0.1 Beta1 SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.1.111 (API 21 Beta1)

	

2025/11/06

### 新增和增强特性

6.0.1(21) Release关键特性
Ability Kit

C API新增支持设置子进程配置信息对象的uid是否隔离。（API参考）

ArkUI

图像类型定义新增对内容切换时的过渡效果的定义。（API参考）

ArkWeb
WebView的prefetchPage新增同名接口，可自定义预取行为的相关选项。（API参考）
Web组件事件新增支持网站安全风险检查结束时触发的回调。（API参考）
Media Library Kit

新增PhotoPicker退出界面的上下文信息，可以用于下次使用PhotoPicker时恢复上次退出时的现场。（API参考）

6.0.1(21) Beta1关键特性
Ability Kit
新增支持通过C API获取应用版本号的能力。（API参考）
拉起UIExtensionAbility的回调新增属性completionHandler，用于返回拉起指定类型的Ability组件的回调结果。（API参考）
应用启动框架新增支持设置启动任务的调度阶段。（指南）
openLink的可选参数OpenLinkOptions新增支持传递拉起应用结果的操作类（completionHandler），用于处理拉起应用的结果。（API参考）
包管理新增支持清理应用自身的缓存。（API参考）
C API新增支持获取可打开特定文件类型的组件资源信息列表。（API参考）
Agent Framework Kit

新增支持图标与标题呈现上下结构的胶囊按钮。（API参考）

ArkGraphics 2D

新增行高缩放基数枚举，支持设置以字号大小或字形高度作为缩放基数进行行高设置。（API参考）

ArkUI
新增支持通过图片对象说明获取属性字符串中的图片的尺寸。（API参考）
RichEditor新增支持设置组件滚动条的颜色。（API参考）
FrameNode新增支持在当前帧触发节点属性更新。（ArkTS API参考、C API参考、C API指南）
新增支持通过C API注册目标节点的基础事件回调。（API参考）
Image组件SVG新增多个解析处理能力，包括SVG易用性提升、仿射变换能力扩展、解析能力扩展、显示效果扩展。（API参考）
新增动画控制器的相关能力。（API参考）
新增支持发起图片资源的同步加载和异步加载，并返回加载结果。（API参考）
Text组件新增支持设置文本内容区在组件内的垂直对齐方式，以便在文本内容区高度大于组件高度时确保文本内容区的对齐方式正确显示。（API参考）
C API的属性样式集合ArkUI_NodeAttributeType的枚举项增强：（API参考）
背景图位置属性NODE_BACKGROUND_IMAGE_POSITION新增属性值.value[2].?i32，表示对齐模式；新增属性值.value[3].?i32，表示布局方向。
遮罩属性NODE_OVERLAY新增属性值.value[3]?.i32，表示浮层的布局方向；新增属性值.object，表示overlay的节点树。
新增属性NODE_WIDTH_LAYOUTPOLICY = 105，用于设置组件宽度布局策略。
新增属性NODE_HEIGHT_LAYOUTPOLICY = 106，用于设置组件高度布局策略。
新增属性NODE_POSITION_EDGES = 107，用于设置组件相对容器内容区边界的位置。
新增属性NODE_PIXEL_ROUND = 109，用于设置组件的像素取整策略。
新增属性NODE_TEXT_CONTENT_ALIGN = 1036，用于设置文本内容区垂直对齐方式。
新增属性NODE_IMAGE_SOURCE_SIZE = 4013，用于设置图片解码尺寸。
新增属性NODE_IMAGE_IMAGE_MATRIX = 4014，用于设置图片的变换矩阵属性。
新增属性NODE_IMAGE_MATCH_TEXT_DIRECTION = 4015，用于设置图片是否跟随系统语言方向。
新增属性NODE_IMAGE_COPY_OPTION = 4016，用于设置图片的拷贝方式。
新增属性NODE_IMAGE_ENABLE_ANALYZER = 4017，用于设置组件支持AI分析。
新增属性NODE_IMAGE_DYNAMIC_RANGE_MODE = 4018，用于定义图片显示动态范围属性。
新增属性NODE_IMAGE_HDR_BRIGHTNESS = 4019，用于定义图片HDR模式下的亮度属性。
新增属性NODE_IMAGE_ORIENTATION = 4020，用于设置图像内容的显示方向。
新增属性NODE_IMAGE_SUPPORT_SVG2 = 4021，用于通过启用SVG新解析能力开关设置SVG解析功能支持的范围。
新增属性NODE_IMAGE_CONTENT_TRANSITION = 4022，用于设置图像变化时的转场动效。
新增属性NODE_SLIDER_BLOCK_LINEAR_GRADIENT_COLOR，用于定义Slider滑块的颜色。
新增属性NODE_SLIDER_TRACK_LINEAR_GRADIENT_COLOR，用于定义Slider滑轨的背景颜色。
新增属性NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR，用于定义Slider滑轨的已滑动部分颜色。
新增ListItem划出菜单管理器，支持展开和收起指定ListItem的划出菜单。（ArkTS API参考、C API参考）
滚动组件通用接口增强生命周期回调事件，新增：
滚动组件开始拖动时触发onWillStartDragging（API参考）；
滚动组件结束拖拽时触发onDidStopDragging（API参考）；
滚动组件将要开始Fling动效时触发onWillStartFling（API参考）；
滚动组件结束Fling动效后触发onDidStopFling（API参考）；
滚动组件在结束拖拽时触发OnDidStopDraggingCallback（API参考）。
NavDestination的页面显示事件onShown能力增强，新增支持通过VisibilityChangeReason说明onShown触发的原因。（API参考）
新增支持定制CheckboxGroup内容区的方法。（API参考）
UIContext新增支持设置HSP资源管理对象缓存个数的上限。（API参考）
窗口管理新增支持设置窗口内容布局（不含边框和标题栏等装饰）的比例。（API参考）
窗口管理新增支持设置本应用进程下窗口的水印图片。（API参考）
ArkWeb
新增支持设置Web组件是否启用强制缩放功能。（API参考）
WebView能力增强：
customizeSchemes新增同名接口，可设置接口内部是否跳过初始化WebEngine。（API参考）
新增支持设置（API参考）和查询（API参考）Web内核的自动预连接状态。
新增支持设置（API参考）和查询（API参考）站点隔离模式。
新增支持设置ArkWeb中已使用过的空闲socket的超时时间。（API参考）
Web组件的自定义菜单扩展项新增onMenuShow和onMenuHide事件回调。（API参考）
Web组件的枚举属性增强：
网页元素信息WebElementType新增枚举TEXT，表示网页元素为文本或可编辑区域类型。（API参考）
菜单响应类型WebResponseType新增枚举RIGHT_CLICK，表示通过鼠标右键触发菜单弹出。（API参考）
Asset Store Kit

关键资产删除时机的规则优化。从API 21开始，应用卸载时清除存储在ASSET中的非群组数据，群组数据调整为仅在群组内所有应用卸载时清除。（指南）

Audio Kit
音频返听能力增强，新增支持设置音频返听器的混响模式（API参考）、获取当前音频返听器的混响模式（API参考）、设置音频返听器的均衡器类型（API参考）、获取当前音频返听器的均衡器类型（API参考）。
新增支持查询指定录音流类型的智能降噪开关是否已开启。（ArkTS API参考、C API参考）
Background Tasks Kit
新增支持申请长时任务的同名接口，新接口支持同一时间申请多个长时任务。（指南、API参考）
针对上述接口申请的长时任务，配套新增更新长时任务的接口。（API参考）
新增支持取消指定ID的长时任务。（API参考）
Basic Services Kit
系统时间：新增支持获取自动设置时间的开关的状态。（API参考）
设备信息：常量定义中新增设备CPU芯片型号（chipType）和设备重启次数（bootCount）。（API参考）
上传下载：通知栏的自定义信息新增支持设置任务的显示方式（visibility）。（API参考）
剪贴板：当使用延迟复制功能的应用退出时，支持应用主动通知剪贴板获取所有延迟数据。（指南、API参考）
Camera Kit
新增支持设置拍照画质优先策略。（API参考）
Cloud Foundation Kit
新增支持调试本地云函数。（指南、API参考）
云数据库模块新增支持以随机顺序展示查询结果集中的对象。（指南、API参考）
Connectivity Kit

新增支持通过C API获取设备真实Mac地址。（API参考）

Crypto Architecture Kit

新增支持开启硬件熵源的能力。（API参考）

Device Security Kit

新增支持拉起系统级防窥蒙层对窗口敏感内容进行覆盖。（指南、API参考）

Enterprise Space Kit

空间管理服务场景下，新增支持设置系统服务进程不可访问后台用户数据、获取系统服务进程不可访问的后台用户数据状态、获取不可访问后台用户数据的系统服务进程列表、新增不可访问后台用户数据的系统服务进程列表、删除不可访问后台用户数据的系统服务进程列表功能。（指南、API参考）

Game Controller Kit

【新增Kit】Game Controller Kit（游戏控制器服务）支持游戏类应用适配控制器外设（如游戏手柄），解决玩家操控性问题，保障用户体验。游戏开发者可通过接入该服务实现游戏外设的上下线和按键及轴事件监听等功能。（指南、API参考）

Game Service Kit

新增支持小游戏相关能力，包括小游戏登录和小游戏支付。（指南、API参考）

IME Kit

新增支持获取指定屏幕当前状态（例如：折叠或展开）下输入法软键盘相对系统面板的偏移区域。（指南-详见步骤2、API参考）

Input Kit
全局快捷键模块的按键事件消费设置新增支持识别媒体播放的播放/暂停（KEYCODE_MEDIA_PLAY_PAUSE）、下一首（KEYCODE_MEDIA_NEXT）、上一首（KEYCODE_MEDIA_PREVIOUS）的快捷键。（API参考）
C API新增如下能力的相关接口：
获取按键事件的Id。（API参考）
添加（API参考）和移除（API参考）按键事件拦截钩子函数。
重新分发按键事件。（API参考）
Localization Kit

新增支持在开发者模式下通过param工具的“param get persist.global.language”命令获取系统语言。（指南）

Location Kit

新增支持判断指定的BSSID是否存在于最新的WLAN扫描结果里。（API参考）

Map Kit
新增支持更改我的位置图层相对于覆盖物的压盖顺序。（指南、API参考）
新增支持拉起地图应用的打车页面。（指南、API参考）
地图应用的POI详情页面，新增设置地图缩放级别和地图坐标系类型。（API参考）
路线规划场景下，新增支持设置地图坐标系类型。（API参考）
导航场景下，新增支持设置起点信息和地图坐标系类型。（API参考）
打开地图应用规划路线或导航，新增支持公交类型。（API参考）
MDM Kit
企业应用的应用管理（API参考）和包管理（API参考）的相关接口在需要传入appIds参数时均新增支持使用appIdentifier参数作为入参，代替原先使用appId的方式。可在对应模块的API参考中搜索“appIds”了解详情。
可设置禁用/启用的特性新增如下（API参考）：
应用分身能力（appClone）
外置存储能力（externalStorageCard）
Wi-Fi链接时使用随机MAC（randomMac）
新增支持应用运行允许名单，添加至允许名单的应用允许在指定用户下运行，不在允许名单的应用不允许在指定用户下运行。（API参考）

同时调整了应用运行禁止名单的策略，如果应用运行允许名单addallowedRunningBundles非空，就不能再通过接口添加应用到应用运行禁止名单。（API参考）

Media Kit
媒体信息描述的枚举新增视频原始宽度（MD_KEY_ORIGINAL_WIDTH）和视频原始高度（MD_KEY_ORIGINAL_HEIGHT）两个信息。（API参考）
新增支持通过C API设置播放器的媒体源。（API参考）
NearLink Kit

新增支持获取已配对设备列表。（API参考）

Online Authentication Kit

FIDO新增支持业务切换自定义认证方式。（API参考）

PDF Kit

新增搜索关键词API，开发者可以对PDF文档进行搜索，并获取上下文、关键词位置等信息。（API参考）

Remote Communication Kit
发送简单的HTTP表单数据场景下，新增支持按照键列表的先后顺序发送。（指南、API参考）
发送HTTP多部分表格数据时，新增支持按照键列表的先后顺序发送。（指南、API参考）
新增C API，支持监听响应状态码的功能。（API参考）
Scenario Fusion Kit

新增支持关注组件API，开发者可在应用页面展示服务号关注组件，实现用户点击关注按钮可关注对应服务号。（指南、API 参考）

Share Kit

新增支持宿主应用配置目标应用名单。（指南）

Spatial Recon Kit

【新增Kit】Spatial Recon Kit（空间建模套件）集成了3DGS（3D Gaussian Splatting）模型的渲染、运算等能力，支持3DGS模型的加载和渲染功能、3DGS渲染的复古风格、漫画风格和比特风格特效。（指南、API参考）

Speech Kit
朗读控件记录上次播放位置，用于下次继续播放。（API参考、API参考）
朗读控件悬浮框新增支持是否显示倍速播放按钮以及是否显示下一篇按钮。（API参考）
Telephony Kit

新增支持订阅通话状态变化拓展事件。（API参考）

UI Design Kit

HdsNavigation提供标题栏顶部自定义区域。（API参考）

## 6.0.2 (API 22)

### 版本概览

6.0.2(22)在6.0.1(21)的基础上，开发能力得到进一步增强：ArkUI增强了滚动组件相关能力，支持更多可配置和自定义的属性；Ability Kit增强了UIAbilityContext管理应用自身UIAbility的能力；ArkWeb增强了与终端用户交互的能力，提升Web页面的交互体验；Connectivity Kit的蓝牙模块增强了获取套接字链路信息的能力；Test Kit的UITest模块增强了模拟交互操作的能力；新增了FAST Kit（算法加速服务），提供高性能算法和数据结构等加速服务，等等。更多详情可参见OS平台新增和增强特性。

DevEco Studio进一步增强AI智能辅助编程的能力和Code Linter静态检测能力，编译构建脚本（如hvigorfile.ts）支持代码联想、跳转等编辑能力，新增支持数据库可视化调试能力等等。更多详情可参见DevEco Studio新增和增强特性。

版本信息
说明

使用正确的配套关系进行应用开发可以获得更流畅的开发体验。

请在阅读版本更新和变更内容前，务必确认版本的配套关系是否与当前您所使用的开发套件是一致的。

6.0.2(22)开发者套件配套信息

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Release

	

6.0.2(22)

*注意：设备系统支持的API能力范围请以API版本为准。

	

2026/01/21




DevEco Studio

	

Release

	

DevEco Studio 6.0.2 Release（6.0.2.642）

（Patch版本）

	

2026/03/06




DevEco Studio 6.0.2 Release（6.0.2.640）

	

2026/01/21




SDK

	

Release

	

HarmonyOS 6.0.2 Release SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.2.130 (API 22 Release)

	

2026/01/21

说明
该版本需通过开发者招募活动进行申请，申请通过后可获得对应设备的ROM版本推送。
API版本请在设备的“设置”中点击设备名称，进入“关于本机”进行查询。
DevEco Studio版本请从DevEco Studio界面菜单选择“Help > About DevEco Studio”进行查询。
SDK内置在DevEco Studio，安装DevEco Studio时自动安装配套版本SDK。具体版本请从DevEco Studio界面菜单选择“Help > About HarmonyOS SDK”进行查询。
应用工程版本信息配置建议

应用工程中应当正确配置应用运行所依赖的SDK版本信息，以确保应用在不同系统版本的设备上运行时的兼容性。

使用该版本开发的应用，其build-profile.json5配置项中关于版本的配置项建议如下：

build-profile.json5配置项

	

已开发应用

	

新启动开发应用




配置建议

	

配置示例




compileSdkVersion

	

无需显性配置，编译时默认使用配套的SDK版本，即默认为：

“compileSdkVersion”: “6.0.2(22)”

	

NA

	

推荐使用6.0.0(20)进行新应用的开发。




compatibleSdkVersion

	

建议与工程升级前的compatibleSdkVersion保持一致。

	

和升级前保持一致，如：

“compatibleSdkVersion”: “5.0.5(17)”




targetSdkVersion

	

推荐您适配新版本的最新变更，然后配置为：“targetSdkVersion”: “6.0.2(22)”。

如果您期望延迟适配变更，可配置targetSdkVersion与工程升级前的targetSdkVersion一致。

	

1、应用适配变更，变更适配完成后配置为：

“targetSdkVersion”: “6.0.2(22)”

2、应用暂不适配变更，需配置为工程升级前的值，如：

“targetSdkVersion”: “5.0.5(17)”

历史Beta版本
6.0.2(22) Beta1

软件包

	

发布类型

	

版本号

	

发布时间




API版本

	

Beta

	

6.0.2(22) Beta1

*注意：设备系统支持的API能力范围请以API版本为准。

	

2026/01/04




DevEco Studio

	

Beta

	

DevEco Studio 6.0.2 Beta1（6.0.2.636）

	

2026/01/04




SDK

	

Beta

	

HarmonyOS 6.0.2 Beta1 SDK

基于OpenHarmony SDK Ohos_sdk_public 6.0.2.129 (API 22 Beta1)

	

2026/01/04

### 新增和增强特性

6.0.2(22) Release

6.0.2(22) Release在Beta1版本基础上未引入新增特性。

6.0.2(22) Beta1关键特性
Ability Kit
新增C API支持获取本应用的应用级的日志文件目录。（API参考）
UIAbilityContext新增支持在当前进程中启动应用程序自己的UIAbility。（API参考）
UIAbilityContext新增支持重启应用的接口，处于获焦状态的UIAbility可以通过该接口重启当前UIAbility所在的进程，并拉起应用内的指定UIAbility。（API参考）
新增支持获取应用启动时预加载阶段的能力。（API参考）
AppGallery Kit
应用市场推荐服务新增支持TV设备。（指南）
应用归因服务，登记归因转化接口新增属性timestamp、serviceTag，支持设置转化事件时间及开发者关注的业务信息功能。（API参考）
AR Engine

新增获取拍照流图片接口，支持配置高清图像。（API参考）

ArkTS
新增支持在Sendable class上叠加使用除@Sendable装饰器之外的其他自定义装饰器。（指南）
Util新增接口类AutoFinalizer，用于在ArkTS对象释放时提供回调。通过实现回调接口，开发者可自定义对象被回收时自动触发的资源清理逻辑。（API参考）
新增支持通过taskId或taskId与taskName获取对应的Task实例。（API参考）
ArkUI
新增Picker容器组件，支持开发者自定义构造Picker选择器。（API参考）
滚动组件相关能力增强：
TextArea控件新增C API支持配置滚动条是否显示。（API参考）
滚动组件新增支持获取内容总大小的能力。（API参考）
滚动组件通用接口支持设置滚动内容区域偏移量，实现内容滚动到边缘时有留白、未滚动到边缘时有内容的效果。（API参考）
Grid组件支持通过C API设置布局选项（例如大小规则的GridItem在Grid中占的行数和列数）（API参考），滚动通用属性和事件（例如，设置滚动条宽度，在API参考Attribute表中搜索“Grid从API version 22开始支持”）
scrollBarColor的入参支持Resource类型，覆盖滚动组件通用接口（API参考）、Scroll组件（API参考）、Grid组件（API参考）。
新增组件可见区域变化事件的回调。（API参考-ArkTS、API参考-C API）
新增C API支持停止指定的Swiper节点正在执行的翻页动画。（API参考）
Tabs组件新增回调，支持监听Tabs组件初始化时显示首个页签的事件。（API参考）
Navigation新增回调，支持监听Navigation页面在跳转前的拦截事件。（API参考）
Tabs组件新增支持自定义indicator，支持图片格式的下划线风格。（API参考）
UIContext新增支持获取后端实例的唯一标识ID。（API参考）
新增ReactiveBuilderNode，支持通过无状态的UI方法@Builder生成组件树，并持有该组件树的根节点。（API参考）
窗口新增支持获取当前应用窗口的避让区域，即使避让区域当前处于不可见状态。（API参考）
窗口新增支持以vp单位获取当前应用窗口的尺寸限制。（API参考）
窗口扩展了maximize接口能力，新增参数acrossDisplay控制折叠屏悬停态下主窗口在最大化时的瀑布流模式行为。（API参考）
ArkWeb
将分词高亮与文本选择后弹出AI菜单的功能进行解耦，允许开发者单独进行功能配置。（指南、API参考）
新增支持监听Web页面白屏事件，并提供事件的回调。（API参考）
新增属性emulateTouchFromMouseEvent，支持Web组件设置mouse事件转touch事件。（API参考）
新增支持设置软键盘自动控制模式，用于控制Web组件在失去焦点或获得焦点、状态切换为inactive或active时是否尝试触发软键盘自动隐藏或拉起。（API参考）
新增支持通过ContextMenuDataMediaType获取触发onContextMenuShow的Web元素类型，类型包含NONE、IMAGE 、VIDEO 、AUDIO 、CANVAS。（API参考）
新增支持快速返回Web页面顶部的能力。当网页处于非顶部状态或向下抛滑时，此时若需返回网页顶部，可以使用backToTop方法，开启后通过点击状态栏，打断抛滑并将网页滚动到网页顶部。（API参考）
新增设置属性，支持设置是否通过组合按键（Ctrl+'-/+'或Ctrl+鼠标滚轮/触摸板）进行缩放。（API参考）
OnRefreshAccessedHistoryEvent新增可选参数isMainFrame，用于标记是否为主文档触发。（API参考）
AVSession Kit

新增支持返回当前进程已创建过的会话对象。（API参考）

Call Service Kit
新增允许运营商通话中发起VoIP主叫。（API参考）
新增用户按键静音VoIP来电铃声。（API参考）
Connectivity Kit
蓝牙新增支持查询指定套接字链路下的最大接收数据大小（API参考）和最大发送数据大小（API参考）。
蓝牙新增支持查询指定套接字链路下的连接状态。（API参考）
蓝牙新增支持获取指定server端服务的能力。（API参考）
蓝牙新增支持将16位、32位UUID转128位UUID的能力。（API参考）
NFC新增支持应用声明off_host_apdu能力，将应用添加到默认付款应用列表中。（指南）
Crypto Architecture Kit
新增支持ChaCha20算法的加解密。（指南-ArkTS，指南-C/C++）
新增支持ChaCha20-Poly1305算法的加解密。（指南-ArkTS，指南-C/C++）
DeskTop Extension Kit
新增支持更新状态栏图标hover的信息。（API参考）
新增应用接入快捷栏服务，可自定义快捷栏图标的右键菜单。（指南、API参考）
Device Security Kit
新增支持模拟点击增强检测。（指南、API参考）
新增支持查询和监听设备的超级隐私模式状态。（指南）
Enterprise Space Kit

空间管理场景下，新增支持设置工作空间策略、查询工作空间策略、设置深度冻结豁免名单、查询深度冻结豁免名单功能。（指南、API参考）

FAST Kit

【新增Kit】FAST Kit（算法加速服务）提供高性能算法和数据结构等加速服务，用于提升开发者的开发效率和用户的应用使用体验。（指南、API参考）

Game Service Kit
新增支持在游戏账号登录面板上置顶游戏官方账号。（指南、API参考）
游戏场景感知，新增C API，支持返回CPU性能信息及建议工作电流等信息。（指南、API参考）
IME Kit

新增输入法扩展信息模块，提供对输入法扩展信息的管理，支持ArkUI编辑框在拉起输入法时传递扩展信息给输入法应用。（API参考）

Input Kit

新增支持注入修饰键后查询到修饰键状态。（API参考）

Live View Kit

实况窗支持显示本地天气效果，典型场景包括即时配送、出行打车等。（API参考）

Localization Kit

新增国际化能力的C API能力。（API参考）

Map Kit
Marker的icon新增支持设置x、y偏移量。（API参考）
自定义矢量瓦片图层新增支持模糊效果。（API参考）
地图Picker新增支持配置转场动效时间。（API参考）
MDM Kit
新增支持设置应用不可关停策略。（API参考）
新增支持应用后台防冻结策略。（API参考）
网络防火墙接口新增支持IPv6。（API参考）
NDK开发
新增支持使用扩展的Node-API接口创建对ArkTS对象的强引用。（指南）
新增支持使用扩展的Node-API接口创建和销毁临界区作用域及访问字符串内容。（指南）
Network Kit
新增支持保护应用进程不受VPN连接影响的能力。（API参考）
新增支持获取本地设备IP邻居表条目信息，包括IPv4和IPv6，每个条目信息包括IP地址、MAC地址、网卡名。（API参考）
TLS新增支持设置timeout字段，TLSSocket会在timeout后断开连接。（API参考）
新增支持在VPN首次启动时传递want中的parameters字段。（API参考）
新增网络策略的接口，在需要设置当前应用能否使用Wi-Fi/蜂窝联网时，可调用该接口打开当前应用的联网设置界面，以设置应用的联网权限。（API参考）
Network Boost Kit

新增C API，支持连接迁移（多网并发），包括业务场景设置、多网状态监听、多网建议监听、多网配额查询、多网发起和释放。（指南）

Notification Kit

新增支持三方应用获取本机通知，用于协同至三方穿戴设备等场景。（指南，API参考）

PDF Kit

新增PDFView组件嵌套滚动能力。（API参考）

Performance Analysis Kit
AppFreeze采样栈新增支持对libuv异步栈的跟踪。（指南）
HiAppEvent新增支持主线程超时事件配置策略，支持主线程超时结束自动停止采样栈的功能。（指南，API参考）
HiDebug新增接口支持对指定的数个线程进行Perf采样，并在调用结束后返回采样栈内容。（API参考）
JS Crash增加混合栈字段（HybridStack），支持打印CPP和JS之间跨语言的代码调用栈。（指南）
Scan Kit
默认界面扫码能力、自定义界面扫码能力和图像识码能力支持获取码图是否携带GS1（Global Standards 1）数据。（API参考）
默认界面扫码能力支持获取扫码结果来源。（API参考）
Scenario Fusion Kit

获取手机号和风险等级Button。（指南、API参考）

Screen Time Guard Kit
新增支持拉起许可应用跳转页的能力，以便快速跳转到指定应用。（指南、API参考）
新增共享时长的时间管控策略类型，即策略关联的所有应用共享同一可用时长配额。（API参考）
Share Kit

碰一碰分享新增支持当前界面无可分享内容时，引导用户前往可分享场景的能力。（指南、API参考）

Test Kit
单元测试框架新增接口beforeEachIt和afterEachIt，用于支持嵌套场景下生命周期函数的执行。（指南）
UITest新增支持窗口变化和组件操作事件监听能力。（API参考）
UITest新增支持指关节操作模拟能力。（API参考）
UITest新增支持在模拟操作的同时查找目标控件是否存在。（API参考）
UITest新增支持触摸板双指滚动操作模拟能力 。（API参考）
UI Design Kit

HdsVisualComponent组件新增支持卡片能力。（API参考）

标准库

ICU4C新增支持ICU版本、名称本地化、码点处理及CLDR版本。（API参考）

调试命令
uinput命令支持控制注入的修饰键状态。（指南）
bm工具安装命令的-p参数支持指定待安装的APP路径。（指南）

## 应用升级适配指导

应用升级适配简介

开发工具链升级

评估API版本变化的影响并适配

在历史版本设备上进行应用的兼容性验证

发布最新编译的应用到应用市场

问题反馈渠道


---

## See Also

- [HarmonyOS 6.0 核心框架 API 变更](harmonyos-6-api-core.md)
- [HarmonyOS 6.0 ArkUI API 变更](harmonyos-6-api-arkui.md)
- [HarmonyOS 6.0 服务类 Kit API 变更](harmonyos-6-api-services.md)
