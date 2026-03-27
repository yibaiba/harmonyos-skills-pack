# 测试、签名与发布主题

## Scope
- 编译构建、应用签名（自动/手动）、真机运行、模拟器运行、调试、测试框架、应用发布上架、HAP 包

## 来源
- DevEco Studio 工具指南

## Official Entrypoints
- [编译构建](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-build-V5)
- [应用签名](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-signing-V5)
- [本地真机运行](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-device-V5)
- [模拟器运行](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-emulator-V5)
- [调试概述](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-debug-device-V5)
- [应用测试](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-app-test-V5)
- [测试框架](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-test-V5)
- [应用发布](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-publish-app-V5)
- [HAP包](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/hap-package-V5)

---

## 编译构建

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-build-V5

简体中文
下载 App
探索
设计
开发
分发
推广与变现
生态合作
支持
更多
探索
设计
开发
分发
推广与变现
生态合作
支持
文档
管理中心

HarmonyOS 5.0.0(12)

版本说明
指南
API参考
最佳实践
FAQ
变更预告
更多
入门
基础入门
Archived
开发
应用开发准备
Archived
应用框架
Archived
系统
Archived
媒体
Archived
图形
Archived
应用服务
Archived
AI
Archived
一次开发，多端部署
Archived
自由流转
Archived
NDK开发
Archived
工具
DevEco Studio
Archived
工具简介
快速开始
工程管理
代码编辑
界面预览
应用/元服务开发
编译构建
应用/元服务签名
应用/元服务运行
应用/元服务调试
性能分析
应用/元服务测试
HarmonyOS应用/元服务发布
AI智能辅助编程工具
附录
Command Line Tools
Archived
DevEco Service
Archived
测试
应用测试
Archived
体验建议
应用体验建议
Archived
您当前浏览的HarmonyOS 5.0.0(API 12)文档归档不再维护，推荐您使用最新版本。详细请参考文档维护策略变更。
指南
DevEco Studio
编译构建
编译构建
更新时间: 2024-11-21 10:44
概述

配置构建

定制构建

优化构建

扩展构建

加固构建

问题排查

通用云开发模板
概述
简体中文
华为开发者联盟 版权所有 ©2026
使用条款
华为开发者联盟用户协议
关于华为开发者联盟与隐私的声明
cookies
开源软件声明

---

## 应用签名

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-signing-V5

针对应用/元服务的签名，DevEco Studio为开发者提供了自动签名方案，帮助开发者高效进行调试。也可选择手动签名对应用/元服务进行签名。

自动签名
说明

使用自动签名前，请确保本地系统时间与北京时间（UTC/GMT +8.00）保持一致。如果不一致，将导致签名失败。

操作步骤
连接真机设备或模拟器，具体请参考使用本地真机运行应用/元服务或使用模拟器运行应用/元服务，真机连接成功后如下图所示：

说明
如果同时连接多个设备，则使用自动化签名时，会同时将这多个设备的信息写到证书文件中。
大部分场景下，模拟器无需签名就可以调试应用/元服务，但是当应用/元服务需要获取ODID或使用Push Kit时，需要配置签名，可在模拟器上自动签名。

进入File > Project Structure... > Project > Signing Configs界面，勾选“Automatically generate signature”（如果是HarmonyOS工程，需同时勾选“Support HarmonyOS”），即可完成签名。如果未登录，请先单击Sign In进行登录，然后自动完成签名。

签名完成后，如下图所示，并在本地生成密钥（.p12）、证书请求文件（.csr）、数字证书（.cer）及Profile文件（.p7b），数字证书在AppGallery Connect网站的“证书、APP ID和Profile”页签中可以查看。

支持ACL权限

从DevEco Studio 4.0 Release版本起，若您的应用需要使用受限开放权限，可以在调测阶段通过自动签名快速申请。

注意
在申请前，请审视是否符合受限权限的使用场景。当前仅少量符合特殊场景的应用可在通过审批后，使用受限权限。申请方式请见申请使用受限权限。
涉及受限权限的应用，在上架时，应用市场（AGC）将根据应用的使用场景审核是否可以使用对应的受限权限。如不符合，应用的上架申请将被驳回，审核方式请见发布HarmonyOS应用。

当前支持通过自动签名申请需要ACL权限的清单如表1所示。

表1 支持的ACL权限列表

API版本

	

支持的ACL权限




API Version ＝ 10

	
ohos.permission.READ_CONTACTS
ohos.permission.WRITE_CONTACTS
ohos.permission.READ_AUDIO
ohos.permission.WRITE_AUDIO
ohos.permission.READ_IMAGEVIDEO
ohos.permission.WRITE_IMAGEVIDEO
ohos.permission.SYSTEM_FLOAT_WINDOW



API Version = 11

	
ohos.permission.READ_CONTACTS
ohos.permission.WRITE_CONTACTS
ohos.permission.READ_AUDIO
ohos.permission.WRITE_AUDIO
ohos.permission.READ_IMAGEVIDEO
ohos.permission.WRITE_IMAGEVIDEO
ohos.permission.SYSTEM_FLOAT_WINDOW
ohos.permission.READ_PASTEBOARD
ohos.permission.ACCESS_DDK_USB
ohos.permission.ACCESS_DDK_HID
ohos.permission.FILE_ACCESS_PERSIST



API Version = 12

	
ohos.permission.READ_CONTACTS
ohos.permission.WRITE_CONTACTS
ohos.permission.READ_AUDIO
ohos.permission.WRITE_AUDIO
ohos.permission.READ_IMAGEVIDEO
ohos.permission.WRITE_IMAGEVIDEO
ohos.permission.SYSTEM_FLOAT_WINDOW
ohos.permission.READ_PASTEBOARD
ohos.permission.ACCESS_DDK_USB
ohos.permission.ACCESS_DDK_HID
ohos.permission.FILE_ACCESS_PERSIST
ohos.permission.SHORT_TERM_WRITE_IMAGEVIDEO
ohos.permission.INPUT_MONITORING
ohos.permission.INTERCEPT_INPUT_EVENT

执行操作步骤后，DevEco Studio将校验当前配置的ACL权限是否在上述列表内，然后通过应用市场（AGC）申请对应的Profile文件，用于签名打包，从而避免繁琐的手动签名步骤。

如果使用的DevEco Studio版本低于4.0 Release，在开发过程中使用了需要ACL的权限，则仍需要采用手动签名。

手动签名

HarmonyOS应用/元服务通过数字证书（.cer文件）和Profile文件（.p7b文件）来保证应用/元服务的完整性。在申请数字证书和Profile文件前，首先需要通过DevEco Studio来生成密钥（存储在格式为.p12的密钥库文件中）和证书请求文件（.csr文件）。然后，申请调试数字证书和调试Profile文件。最后，将密钥（.p12）文件、数字证书（.cer）文件和Profile（.p7b）文件配置到工程中。

基本概念
密钥：格式为.p12，包含非对称加密中使用的公钥和私钥，存储在密钥库文件中，公钥和私钥对用于数字签名和验证。
证书请求文件：格式为.csr，全称为Certificate Signing Request，包含密钥对中的公钥和公共名称、组织名称、组织单位等信息，用于向AppGallery Connect申请数字证书。
数字证书：格式为.cer，由华为AppGallery Connect颁发。
Profile文件：格式为.p7b，包含HarmonyOS应用/元服务的包名、数字证书信息、描述应用/元服务允许申请的证书权限列表，以及允许应用/元服务调试的设备列表（如果应用/元服务类型为Release类型，则设备列表为空）等内容，每个应用/元服务包中均必须包含一个Profile文件。
生成密钥和证书请求文件
在主菜单栏单击Build > Generate Key and CSR。

说明

如果本地已有对应的密钥，无需新生成密钥，可以在Generate Key界面中单击下方的Skip跳过密钥生成过程，直接使用已有密钥生成证书请求文件。

在Key Store File中，可以单击Choose Existing选择已有的密钥库文件（存储有密钥的.p12文件）；如果没有密钥库文件，单击New进行创建。下面以新创建密钥库文件为例进行说明。

在Create Key Store窗口中，填写密钥库信息后，单击OK。

Key store file：设置密钥库文件存储路径，并填写p12文件名。
Password：设置密钥库密码，必须由大写字母、小写字母、数字和特殊符号中的两种以上字符的组合，长度至少为8位。请记住该密码，后续签名配置需要使用。
Confirm password：再次输入密钥库密码。

在Generate Key and CSR界面中，继续填写密钥信息后，单击Next。

Alias：密钥的别名信息，用于标识密钥名称。请记住该别名，后续签名配置需要使用。
Password：密钥对应的密码，与密钥库密码保持一致，无需手动输入。

在Generate Key and CSR界面，设置CSR文件存储路径和CSR文件名。

单击Finish，创建CSR文件成功，可以在存储路径下获取生成的密钥库文件（.p12）、证书请求文件（.csr）和material文件夹（存放签名方案相关材料，如密码、证书等）。

申请调试证书和调试Profile文件
通过生成的证书请求文件，向AppGallery Connect申请调试证书和Profile文件，操作如下：
创建HarmonyOS应用/元服务：在AppGallery Connect项目中，创建一个HarmonyOS应用/元服务，用于调试证书和Profile文件申请，具体请参考创建HarmonyOS应用/元服务。
申请调试证书和Profile文件：在AppGallery Connect中申请、下载调试证书和Profile文件，具体请参考申请调试证书和申请调试Profile。
手动配置签名信息

在DevEco Studio中配置密钥（.p12）文件、申请的调试证书（.cer）文件和调试Profile（.p7b）文件。

在File > Project Structure > Project > Signing Configs窗口中，取消勾选“Automatically generate signature”（如果是HarmonyOS应用，请勾选“Support HarmonyOS”），然后配置工程的签名信息。
Store file：选择密钥库文件，文件后缀为.p12，该文件为生成密钥和证书请求文件中生成的.p12文件。
Store password：输入密钥库密码，该密码与生成密钥和证书请求文件中填写的密钥库密码保持一致。
Key alias：输入密钥的别名信息，与生成密钥和证书请求文件中填写的别名保持一致。
Key password：输入密钥的密码，与生成密钥和证书请求文件中填写的Store Password保持一致。
Sign alg：签名算法，固定为SHA256withECDSA。
Profile file：选择申请调试证书和调试Profile文件中生成的Profile文件，文件后缀为.p7b。
Certpath file：选择申请调试证书和调试Profile文件中生成的数字证书文件，文件后缀为.cer。
说明

Store file，Profile file，Certpath file三个字段支持配置相对路径，以项目根目录为起点，配置文件所在位置的路径名称。

配置完成后，进入工程级build-profile.json5文件，在“signingConfigs”下可查看到配置成功的签名信息。

使用ACL的签名配置指导

如果应用需要使用受限权限，请先审视是否符合受限开放权限的使用场景，并根据以下流程申请。

申请进入白名单。

请将APP ID、申请使用的受限开放权限、使用该权限的场景和功能信息，发送到agconnect@huawei.com。AGC运营将审核相关材料，通过后将为您配置受限开放权限使用的名单，审核周期一个工作日，请耐心等待。

注意
若应用因特殊场景要求使用受限开放权限，请务必在此步骤进行申请，否则应用将在审核时被驳回。受限开放权限可申请的特殊场景请参考受限开放权限。
同时，请确保应用申请受限开放权限时提供的场景和功能信息准确。
如果应用内使用的受限开放权限超出您申请的范围，或申请权限后使用的功能和场景超出可使用的范围，将影响您的应用上架。
获取密钥和证书请求文件，请参见生成密钥和证书请求文件。
申请调试证书，请参见申请调试证书。
申请调试Profile，请参见申请调试Profile。
在配置文件中添加权限信息。
在需要使用权限的模块的module.json5/config.json文件中添加“requestPermissions”/“reqPermissions”字段，并在字段下添加对应的权限名等信息，以在Stage模型工程中增加权限“ohos.permission.ACCESS_IDS”为例。
{
  "module": {
    ...
    "requestPermissions": [{
      "name": "ohos.permission.ACCESS_IDS",
    }],
    ...
  }
}

手动配置签名信息。
连接真机设备，确保DevEco Studio与真机设备已连接。

点击DevEco Studio右上角的按钮打开“Project Structure”窗口，进入“Signing Config”页签，取消勾选“Automatically generate signature”。

在“Signing”下分别配置密钥(.p12文件)、Profile(.p7b文件)和数字证书(.cer文件)的路径等信息。

勾选“Show restricted permissions”，即可看到配置成功的权限。

配置完毕后，点击“Apply”。

进入工程级build-profile.json5文件，在“signingConfigs”下可查看到配置成功的签名信息，点击右上角的“Run”按钮运行应用/元服务。

常见问题
元服务签名时，提示"Invalid AppId in the bundle name."

问题原因

元服务的包名采用固定前缀和APP ID组合方式（com.atomicservice.[appid]）命名。开发者需先在AppGallery Connect中新建元服务并获取其包名，并将包名填写至工程的bundleName字段中。若上传的元服务包的包名和AGC中的包名不一致，则会导致元服务上架失败。

不合法包名包括：

包名在AGC中不存在；
非当前DevEco Studio登录账号下的元服务应用的包名。

解决措施

在AGC中新建元服务并获取相应的包名。

在工程AppScope > app.json5文件中填写相应的bundleName，并重新进行签名。

---

## 本地真机运行

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-device-V5

在Phone和Tablet中运行HarmonyOS应用/元服务的操作方法一致，可以采用USB连接方式或者无线调试的连接方式。

前提条件
在Phone或Tablet上查看设置 > 系统中开发者选项是否存在，如果不存在，可在设置 > 设备名称中，连续七次单击“版本号”，直到提示“开启开发者选项”，点击确认开启后输入PIN码（如果已设置），设备将自动重启，请等待设备完成重启。
在设备运行应用/元服务需要根据为应用/元服务进行签名章节，提前对应用/服务进行签名。
使用USB连接方式
使用USB方式，将Phone或Tablet与PC端进行连接。
在设置 > 系统 > 开发者选项中，打开“USB调试”开关（确保设备已连接USB）。
在Phone或Tablet中会弹出“允许USB调试”的弹框，单击允许。

在菜单栏中，单击Run>Run'模块名称'或，或使用默认快捷键Shift+F10（macOS为Control+R）运行应用/元服务。

DevEco Studio启动HAP的编译构建和安装。安装成功后，设备会自动运行安装的HarmonyOS应用/元服务。
说明

设备连接后，如果DevEco Studio无法识别到设备，显示“No device”，请参考设备连接后，无法识别设备的处理指导。

使用无线调试连接方式
将Phone/Tablet和PC连接到同一WLAN网络。
在设置 > 系统 > 开发者选项中，打开“无线调试”开关，并获取Phone/Tablet端的IP地址和端口号。

在PC中执行如下命令连接设备，关于hdc工具的使用指导请参考hdc。

hdc tconn 设备IP地址:端口号

在菜单栏中，单击Run>Run'模块名称'或，或使用默认快捷键Shift+F10（macOS为Control+R）运行应用/元服务。

DevEco Studio启动HAP的编译构建和安装。安装成功后，Phone/Tablet会自动运行安装的HarmonyOS应用/元服务。

---

## 模拟器运行

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-emulator-V5

简体中文
下载 App
探索
设计
开发
分发
推广与变现
生态合作
支持
更多
探索
设计
开发
分发
推广与变现
生态合作
支持
文档
管理中心

HarmonyOS 5.0.0(12)

版本说明
指南
API参考
最佳实践
FAQ
变更预告
更多
入门
基础入门
Archived
开发
应用开发准备
Archived
应用框架
Archived
系统
Archived
媒体
Archived
图形
Archived
应用服务
Archived
AI
Archived
一次开发，多端部署
Archived
自由流转
Archived
NDK开发
Archived
工具
DevEco Studio
Archived
工具简介
快速开始
工程管理
代码编辑
界面预览
应用/元服务开发
编译构建
应用/元服务签名
应用/元服务运行
使用本地真机运行应用/元服务
使用模拟器运行应用/元服务
应用/元服务调试
性能分析
应用/元服务测试
HarmonyOS应用/元服务发布
AI智能辅助编程工具
附录
Command Line Tools
Archived
DevEco Service
Archived
测试
应用测试
Archived
体验建议
应用体验建议
Archived
您当前浏览的HarmonyOS 5.0.0(API 12)文档归档不再维护，推荐您使用最新版本。详细请参考文档维护策略变更。
指南
DevEco Studio
应用/元服务运行
使用模拟器运行应用/元服务
使用模拟器运行应用/元服务
更新时间: 2024-11-21 10:44
概述

管理模拟器

使用模拟器

模拟器常见问题

使用本地真机运行应用/元服务
概述
简体中文
华为开发者联盟 版权所有 ©2026
使用条款
华为开发者联盟用户协议
关于华为开发者联盟与隐私的声明
cookies
开源软件声明

---

## 调试概述

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-debug-device-V5

DevEco Studio提供了丰富的HarmonyOS应用/元服务调试能力，支持JS、ArkTS、C/C++单语言调试和ArkTS/JS+C/C++跨语言调试能力，并且支持三方库源码调试，帮助开发者更方便、高效地调试应用/元服务。

HarmonyOS应用/元服务调试支持使用真机设备、模拟器、预览器调试。接下来以使用真机设备为例进行说明，详细的调试流程如下图所示：

配置签名信息：使用真机设备进行调试前需要对HAP进行签名；使用模拟器和预览器调试无需签名。
设置调试代码类型：调试类型默认为Detect Automatically。
设置HAP安装方式：选择先卸载应用/元服务后再重新安装或覆盖安装。
启动调试：启动debug调试或attach调试。

使用预览器调试的特别说明

使用真机或模拟器进行调试时，修改后的代码需要经过较长时间的编译和安装过程，才能刷新至调试环境。使用预览器进行调试，可快速地修改代码和运行应用，在DevEco Studio中直接查看修改后的界面显示效果。

开发者可以使用预览器运行调试Ability生命周期代码和界面代码，预览器调试支持基础Debug能力，包括断点、调试执行、变量查看等。

预览器调试使用约束：

一个工程内不支持启动多个预览调试任务。
一个Previewer只能支持普通预览或预览调试模式，不可同时支持两种模式。
使用预览器进行调试不支持以下场景：
不支持Attach。
不支持跨Ability调试。
不支持C++调试。
不支持极速预览。
不支持Hot Reload。
不支持多进程和worker/taskpool调试。

---

## 应用测试

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-app-test-V5

简体中文
下载 App
探索
设计
开发
分发
推广与变现
生态合作
支持
更多
探索
设计
开发
分发
推广与变现
生态合作
支持
文档
管理中心

HarmonyOS 5.0.0(12)

版本说明
指南
API参考
最佳实践
FAQ
变更预告
更多
入门
基础入门
Archived
开发
应用开发准备
Archived
应用框架
Archived
系统
Archived
媒体
Archived
图形
Archived
应用服务
Archived
AI
Archived
一次开发，多端部署
Archived
自由流转
Archived
NDK开发
Archived
工具
DevEco Studio
Archived
工具简介
快速开始
工程管理
代码编辑
界面预览
应用/元服务开发
编译构建
应用/元服务签名
应用/元服务运行
应用/元服务调试
性能分析
应用/元服务测试
HarmonyOS应用/元服务发布
AI智能辅助编程工具
附录
Command Line Tools
Archived
DevEco Service
Archived
测试
应用测试
Archived
体验建议
应用体验建议
Archived
您当前浏览的HarmonyOS 5.0.0(API 12)文档归档不再维护，推荐您使用最新版本。详细请参考文档维护策略变更。
指南
DevEco Studio
应用/元服务测试
应用/元服务测试
更新时间: 2024-11-21 10:44
测试框架

应用与元服务体检

快捷键
测试框架
简体中文
华为开发者联盟 版权所有 ©2026
使用条款
华为开发者联盟用户协议
关于华为开发者联盟与隐私的声明
cookies
开源软件声明

---

## 测试框架

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-test-V5

简体中文
下载 App
探索
设计
开发
分发
推广与变现
生态合作
支持
更多
探索
设计
开发
分发
推广与变现
生态合作
支持
文档
管理中心

HarmonyOS 5.0.0(12)

版本说明
指南
API参考
最佳实践
FAQ
变更预告
更多
入门
基础入门
Archived
开发
应用开发准备
Archived
应用框架
Archived
系统
Archived
媒体
Archived
图形
Archived
应用服务
Archived
AI
Archived
一次开发，多端部署
Archived
自由流转
Archived
NDK开发
Archived
工具
DevEco Studio
Archived
工具简介
快速开始
工程管理
代码编辑
界面预览
应用/元服务开发
编译构建
应用/元服务签名
应用/元服务运行
应用/元服务调试
性能分析
应用/元服务测试
测试框架
应用与元服务体检
HarmonyOS应用/元服务发布
AI智能辅助编程工具
附录
Command Line Tools
Archived
DevEco Service
Archived
测试
应用测试
Archived
体验建议
应用体验建议
Archived
您当前浏览的HarmonyOS 5.0.0(API 12)文档归档不再维护，推荐您使用最新版本。详细请参考文档维护策略变更。
指南
DevEco Studio
应用/元服务测试
测试框架
测试框架
更新时间: 2024-11-21 10:44
代码测试

Mock能力

黑盒覆盖率测试

应用/元服务测试
代码测试
简体中文
华为开发者联盟 版权所有 ©2026
使用条款
华为开发者联盟用户协议
关于华为开发者联盟与隐私的声明
cookies
开源软件声明

---

## 应用发布

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-publish-app-V5

HarmonyOS通过数字证书与Profile文件等签名信息来保证应用/元服务的完整性，应用/元服务上架到AppGallery Connect必须通过签名校验。因此，您需要使用发布证书和Profile文件对应用/元服务进行签名后才能发布。

发布流程

开发者完成HarmonyOS应用/元服务开发后，需要将应用/元服务打包成App Pack（.app文件），用于上架到AppGallery Connect。发布应用/元服务的流程如下图所示：

关于以上流程的详细介绍，请继续查阅本章节内容。

准备签名文件

HarmonyOS应用/元服务通过数字证书（.cer文件）和Profile文件（.p7b文件）来保证应用/元服务的完整性。在申请数字证书和Profile文件前，首先需要通过DevEco Studio来生成密钥（存储在格式为.p12的密钥库文件中）和证书请求文件（.csr文件）。

基本概念
密钥：包含非对称加密中使用的公钥和私钥，存储在密钥库文件中，格式为.p12，公钥和私钥对用于数字签名和验证。
证书请求文件：格式为.csr，全称为Certificate Signing Request，包含密钥对中的公钥和公共名称、组织名称、组织单位等信息，用于向AppGallery Connect申请数字证书。
数字证书：格式为.cer，由华为AppGallery Connect颁发。
Profile文件：格式为.p7b，包含HarmonyOS应用/元服务的包名、数字证书信息、描述应用/元服务允许申请的证书权限列表，以及允许应用/元服务调试的设备列表（如果应用/元服务类型为Release类型，则设备列表为空）等内容，每个应用/元服务包中均必须包含一个Profile文件。
生成密钥和证书请求文件
在主菜单栏单击Build > Generate Key and CSR。

说明

如果本地已有对应的密钥，无需新生成密钥，可以在Generate Key界面中单击下方的Skip跳过密钥生成过程，直接使用已有密钥生成证书请求文件。

在Key Store File中，可以单击Choose Existing选择已有的密钥库文件（存储有密钥的.p12文件）；如果没有密钥库文件，单击New进行创建。下面以新创建密钥库文件为例进行说明。

在Create Key Store窗口中，填写密钥库信息后，单击OK。

Key Store File：设置密钥库文件存储路径，并填写p12文件名。
Password：设置密钥库密码，必须由大写字母、小写字母、数字和特殊符号中的两种以上字符的组合，长度至少为8位。请记住该密码，后续签名配置需要使用。
Confirm Password：再次输入密钥库密码。

在Generate Key and CSR界面中，继续填写密钥信息后，单击Next。

Alias：密钥的别名信息，用于标识密钥名称。请记住该别名，后续签名配置需要使用。
Password：密钥对应的密码，与密钥库密码保持一致，无需手动输入。

在Generate Key and CSR界面，设置CSR文件存储路径和CSR文件名。

单击OK按钮，创建CSR文件成功，可以在存储路径下获取生成的密钥库文件（.p12）和证书请求文件（.csr）。

申请发布证书和Profile文件
通过生成的证书请求文件，向AppGallery Connect申请发布证书和Profile文件，操作如下。
创建HarmonyOS应用/元服务：在AppGallery Connect项目中，创建一个HarmonyOS应用/元服务，用于发布证书和Profile文件申请，具体请参考创建HarmonyOS应用/元服务。
说明

如果申请元服务的签名证书，在“创建应用”操作时，“是否元服务”选项请选择“是”。

申请发布证书和Profile文件：在AppGallery Connect中申请、下载发布证书和Profile文件，具体请参考申请发布证书和申请发布Profile。

用于发布的证书和Profile文件申请完成后，请在DevEco Studio中进行签名，请参考配置签名信息。

说明

使用发布证书和发布Profile文件进行手动签名，只能用来打包应用上架，不能用来运行调试工程。

配置签名信息

使用制作的私钥（.p12）文件、在AppGallery Connect中申请的证书（.cer）文件和Profile（.p7b）文件，在DevEco Studio配置工程的签名信息，构建携带发布签名信息的APP。

在File > Project Structure > Project > Signing Configs > default界面中，取消“Automatically generate signature”勾选项，然后配置工程的签名信息。
Store File：选择密钥库文件，文件后缀为.p12。
Store Password：输入密钥库密码。
Key Alias：输入密钥的别名信息。
Key Password：输入密钥的密码。
Sign Alg：签名算法，固定为SHA256withECDSA。
Profile File：选择申请的发布Profile文件，文件后缀为.p7b。
Certpath File：选择申请的发布数字证书文件，文件后缀为.cer。

设置完签名信息后，单击OK进行保存，然后使用DevEco Studio生成APP，请参考编译构建.app文件。

（条件必选）更新公钥指纹

当应用需要使用以下开放能力的一种或多种时，发布应用前，需在AppGallery Connect中将调试应用的指纹更新为发布证书指纹。具体操作请参见配置应用签名证书指纹。

Account Kit（华为账号服务）
Game Service Kit（游戏服务）
Health Service Kit（运动健康服务）
IAP Kit（应用内支付服务）
Map Kit（地图服务）
Payment Kit（华为支付服务）
Wallet Kit（钱包服务）
编译构建.app文件
注意

应用上架时，要求应用包类型为Release类型。

打包APP时，DevEco Studio会将工程目录下的所有HAP/HSP模块打包到APP中，因此，如果工程目录中存在不需要打包到APP的HAP/HSP模块，请手动删除后再进行编译构建生成APP。

单击Build > Build Hap(s)/APP(s) > Build APP(s)，等待编译构建完成已签名的应用包。

说明

当未指定构建模式时，构建APP包，默认Release模式；构建HAP/HSP/HAR包，默认Debug模式。

即Build APP(s)时，默认构建的APP包为Release类型，符合上架要求，开发者无需进行另外设置。

编译构建完成后，可以在工程目录build > outputs > default下，获取带签名的应用包。

上架.app文件到AGC

将HarmonyOS应用/元服务打包成.app文件后上架到AppGallery Connect，上架详细操作指导请参考上架HarmonyOS应用或上架元服务。

---

## HAP包

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/hap-package-V5

HAP（Harmony Ability Package）是应用安装和运行的基本单元。HAP包是由代码、资源、第三方库、配置文件等打包生成的模块包，其主要分为两种类型：entry和feature。

entry：应用的主模块，作为应用的入口，提供了应用的基础功能。
feature：应用的动态特性模块，作为应用能力的扩展，可以根据用户的需求和设备类型进行选择性安装。

应用程序包可以只包含一个基础的entry包，也可以包含一个基础的entry包和多个功能性的feature包。

使用场景

单HAP场景：如果只包含UIAbility组件，无需使用ExtensionAbility组件，优先采用单HAP（即一个entry包）来实现应用开发。虽然一个HAP中可以包含一个或多个UIAbility组件，为了避免不必要的资源加载，推荐采用“一个UIAbility+多个页面”的方式。

多HAP场景：如果应用的功能比较复杂，需要使用ExtensionAbility组件，可以采用多HAP（即一个entry包+多个feature包）来实现应用开发，每个HAP中包含一个UIAbility组件或者一个ExtensionAbility组件。在这种场景下，可能会存在多个HAP引用相同的库文件，导致重复打包的问题。

约束限制

不支持导出接口和ArkUI组件，给其他模块使用。

多HAP场景下，App Pack包中同一设备类型的所有HAP中必须有且只有一个Entry类型的HAP，Feature类型的HAP可以有一个或者多个，也可以没有。

多HAP场景下，同一应用中的所有HAP的配置文件中的bundleName、versionCode、versionName、minCompatibleVersionCode、debug、minAPIVersion、targetAPIVersion、apiReleaseType相同，同一设备类型的所有HAP对应的moduleName标签必须唯一。HAP打包生成App Pack包时，会对上述参数配置进行校验。

多HAP场景下，同一应用的所有HAP、HSP的签名证书要保持一致。上架应用市场是以App Pack形式上架，应用市场分发时会将所有HAP从App Pack中拆分出来，同时对其中的所有HAP进行重签名，这样保证了所有HAP签名证书的一致性。在调试阶段，开发者通过命令行或DevEco Studio将HAP安装到设备上时，要保证所有HAP签名证书一致，否则会出现安装失败的问题。

创建

下面简要介绍如何通过DevEco Studio新建一个HAP模块。

创建工程，构建第一个ArkTS应用。

在工程目录上单击右键，选择New > Module。

在弹出的对话框中选择Empty Ability模板，单击Next。

在Module配置界面，配置Module name，选择Module Type和Device Type，然后单击Next。

在Ability配置界面，配置Ability name，然后单击Finish完成创建。

开发

HAP中支持添加UIAbility组件或ExtensionAbility组件，添加pages页面。具体操作可参考应用/服务开发。

HAP中支持引用HAR或HSP共享包，详见HAR的使用、HSP的使用。

调试

通过DevEco Studio编译打包，生成单个或者多个HAP，即可基于HAP进行调试。如需根据不同的部署环境、目标人群、运行环境等，将同一个HAP定制编译为不同版本，请参见定制编译指导。

开发者可以采用DevEco Studio或者hdc工具进行调试：

方法一： 使用DevEco Studio进行调试，详见应用程序包调试方法。

方法二： 使用hdc工具(可通过HarmonyOS SDK获取，在SDK的toolchains目录下)进行调试。

在调试前，需要先安装或更新HAP，此处有两种方式：

直接使用hdc安装、更新HAP。

HAP的路径为开发平台上的文件路径，以Windows开发平台为例，命令参考如下：

// 安装、更新，多HAP可以指定多个文件路径
hdc install entry.hap feature.hap
// 执行结果
install bundle successfully.
// 卸载
hdc uninstall com.example.myapplication
// 执行结果
uninstall bundle successfully.

先执行hdc shell，再使用bm工具安装、更新HAP。

HAP的文件路径为真机上的文件路径，命令参考如下：

// 先执行hdc shell才能使用bm工具
hdc shell
// 安装、更新，多HAP可以指定多个文件路径
bm install -p /data/app/entry.hap /data/app/feature.hap
// 执行结果
install bundle successfully.
// 卸载
bm uninstall -n com.example.myapplication
// 执行结果
uninstall bundle successfully.

完成HAP安装或更新后，即可参考相关调试命令进行调试。

示例代码
多HAP
