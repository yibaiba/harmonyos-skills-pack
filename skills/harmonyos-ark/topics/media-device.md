# 媒体与设备能力主题

## Scope
- Camera Kit（相机服务）、Image Kit（图片处理）、Media Kit（音视频播放/录制）、Media Library Kit（媒体文件管理）

## 来源
- 媒体 Kit 系列

## Official Entrypoints
- [Camera Kit简介](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/camera-overview-V5)
- [相机开发准备](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/camera-preparation-V5)
- [相机开发指导(ArkTS)](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/camera-dev-arkts-V5)
- [Image Kit简介](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-overview-V5)
- [图片开发指导(ArkTS)](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-arkts-dev-V5)
- [Media Kit简介](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/media-kit-intro-V5)
- [媒体开发指导(ArkTS)](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/media-kit-dev--arkts-V5)
- [Media Library Kit](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/medialibrary-kit-V5)

---

## Camera Kit简介

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/camera-overview-V5

开发者通过调用Camera Kit(相机服务)提供的接口可以开发相机应用，应用通过访问和操作相机硬件，实现基础操作，如预览、拍照和录像；还可以通过接口组合完成更多操作，如控制闪光灯和曝光时间、对焦或调焦等。

开发场景

当开发者需要开发一个相机应用（或是在应用内开发相机模块）时，可参考以下开发模型了解相机的工作流程，进而开发相机应用，具体可参考相机开发指导。

如果开发者仅是需要拉起系统相机拍摄一张照片、录制一段视频，可直接使用CameraPicker，无需申请相机权限，直接拉起系统相机完成拍摄，具体可参考Camera Picker。

开发模型

相机调用摄像头采集、加工图像视频数据，精确控制对应的硬件，灵活输出图像、视频内容，满足多镜头硬件适配（如广角、长焦、TOF）、多业务场景适配（如不同分辨率、不同格式、不同效果）的要求。

相机的工作流程如图所示，可概括为相机输入设备管理、会话管理和相机输出管理三部分。

相机设备调用摄像头采集数据，作为相机输入流。

会话管理可配置输入流，即选择哪些镜头进行拍摄。另外还可以配置闪光灯、曝光时间、对焦和调焦等参数，实现不同效果的拍摄，从而适配不同的业务场景。应用可以通过切换会话满足不同场景的拍摄需求。

配置相机的输出流，即将内容以预览流、拍照流或视频流输出。

图1 相机工作流程

了解相机工作流程后，建议开发者了解相机的开发模型，便于更好地开发相机应用。

图2 相机开发模型

相机应用通过控制相机，实现图像显示（预览）、照片保存（拍照）、视频录制（录像）等基础操作。在实现基本操作过程中，相机服务会控制相机设备采集和输出数据，采集的图像数据在相机底层的设备硬件接口（HDI，Hardware Device Interfaces），直接通过BufferQueue传递到具体的功能模块进行处理。BufferQueue在应用开发中无需关注，用于将底层处理的数据及时送到上层进行图像显示。

以视频录制为例进行说明，相机应用在录制视频过程中，媒体录制服务先创建一个视频Surface用于传递数据，并提供给相机服务，相机服务可控制相机设备采集视频数据，生成视频流。采集的数据通过底层相机HDI处理后，通过Surface将视频流传递给媒体录制服务，媒体录制服务对视频数据进行处理后，保存为视频文件，完成视频录制。

---

## 相机开发准备

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/camera-preparation-V5

相机应用开发的主要流程包含开发准备、设备输入、会话管理、预览、拍照和录像等。

申请权限

在开发相机应用时，需要先申请相机相关权限，确保应用拥有访问相机硬件及其他功能的权限，需要的权限如下表。在申请权限前，请保证符合权限使用的基本原则。

使用相机拍摄前，需要申请ohos.permission.CAMERA相机权限。
当需要使用麦克风同时录制音频时，需要申请ohos.permission.MICROPHONE麦克风权限。
当需要拍摄的图片/视频显示地理位置信息时，需要申请ohos.permission.MEDIA_LOCATION，来访问用户媒体文件中的地理位置信息。

以上权限均需要通过弹窗向用户申请授权，具体申请方式及校验方式，请参考向用户申请授权。

当需要读取图片或视频文件时，请优先使用媒体库Picker选择媒体资源。
当需要保存图片或视频文件时，请优先使用安全控件保存媒体资源。
说明

仅应用需要克隆、备份或同步用户公共目录的图片、视频类文件时，可申请ohos.permission.READ_IMAGEVIDEO、ohos.permission.WRITE_IMAGEVIDEO权限来读写音频文件，申请方式请参考申请受控权限，通过AGC审核后才能使用。为避免应用的上架申请被驳回，开发者应优先使用Picker/控件等替代方案，仅少量符合特殊场景的应用被允许申请受限权限。

开发指导

当前相机提供了ArkTS和C++两种开发语言的开发指导，如下表所示。

开发流程	ArkTS开发指导	C++开发指导
设备输入	设备输入(ArkTS)	设备输入(C/C++)
会话管理	会话管理(ArkTS)	会话管理(C/C++)
预览	预览(ArkTS)	预览(C/C++)
预览流二次处理	-	预览流二次处理(C/C++)
拍照	拍照(ArkTS)	拍照(C/C++)
分段式拍照	分段式拍照(ArkTS)	-
动态照片	动态照片(ArkTS)	-
录像	录像(ArkTS)	录像(C/C++)
元数据	元数据(ArkTS)	元数据(C/C++)

---

## 相机开发指导(ArkTS)

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/camera-dev-arkts-V5

相机管理(ArkTS)

设备输入(ArkTS)

会话管理(ArkTS)

预览(ArkTS)

拍照(ArkTS)

录像(ArkTS)

元数据(ArkTS)

对焦(ArkTS)

手电筒使用(ArkTS)

适配不同折叠状态的摄像头变更(ArkTS)

分段式拍照(ArkTS)

动态照片(ArkTS)

相机基础动效(ArkTS)

在Worker线程中使用相机(ArkTS)

相机旋转

安全相机(ArkTS)

动态调整预览帧率(ArkTS)

使用相机预配置(ArkTS)

---

## Image Kit简介

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-overview-V5

应用开发中的图片开发是对图片像素数据进行解析、处理、构造的过程，达到目标图片效果，主要涉及图片解码、图片处理、图片编码等。

在学习图片开发前，需要熟悉以下基本概念：

图片解码

指将所支持格式的存档图片解码成统一的PixelMap，以便在应用或系统中进行图片显示或图片处理。

PixelMap

指图片解码后无压缩的位图，用于图片显示或图片处理。

图片处理

指对PixelMap进行相关的操作，如旋转、缩放、设置透明度、获取图片信息、读写像素数据等。

图片编码

指将PixelMap编码成不同格式的存档图片，用于后续处理，如保存、传输等。

图片开发的主要流程如下图所示。

图1 图片开发流程示意图

获取图片：通过应用沙箱等方式获取原始图片。

创建ImageSource实例：ImageSource是图片解码出来的图片源类，用于获取或修改图片相关信息。

图片解码：通过ImageSource解码生成PixelMap。

图片处理：对PixelMap进行处理，更改图片属性实现图片的旋转、缩放、裁剪等效果。然后通过Image组件显示图片。

图片编码：使用图片打包器类ImagePacker，将PixelMap或ImageSource进行压缩编码，生成一张新的图片。

除上述基本图片开发能力外，HarmonyOS还提供常用图片工具，供开发者选择使用。

亮点/特征

Image Kit编解码支持多种图片格式，并采用了高效的算法和优化策略，提高了图片处理的速度和效率。

约束与限制

在图片处理中，可能需要使用用户图片，应用需要向用户申请对应的读写操作权限才能保证功能的正常运行。

与相关Kit的关系

图片框架提供图片编解码能力，为Image组件及图库等应用提供支撑，其解码结果可以传给Image组件显示。

---

## 图片开发指导(ArkTS)

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-arkts-dev-V5

使用ImageSource完成图片解码

使用PixelMap完成图像变换

使用PixelMap完成位图操作

使用ImagePacker完成图片编码

编辑图片EXIF信息

---

## Media Kit简介

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/media-kit-intro-V5

Media Kit（媒体服务）用于开发音视频播放或录制的各类功能。在Media Kit的开发指导中，将详细介绍音视频多个模块的开发方式，指导开发者如何使用系统提供的音视频API实现对应功能。比如使用SoundPool实现简单的提示音，当设备接收到新消息时，会发出短促的“滴滴”声；使用AVPlayer实现音乐播放器，循环播放一首音乐。

Media Kit提供的模块有：

AVPlayer：播放音视频
SoundPool：播放短音频
AVRecorder：录制音视频
AVScreenCapture：录制屏幕
AVMetadataExtractor：获取音视频元数据
AVImageGenerator：获取视频缩略图
AVTranscoder：视频转码
亮点/特征

使用轻量媒体引擎

使用较少的系统资源（线程、内存），可支持音视频播放/录制，支持pipeline灵活拼装，支持插件化扩展source/demuxer/codec。

支持HDR视频

系统原生数据结构与接口支持hdr vivid的采集与播放，方便三方应用在业务中使用系统的HDR能力，为用户带来更炫彩的体验。

支持音频池

针对开发中常用的短促音效播放场景，如相机快门音效、系统通知音效等，应用可调用SoundPool，实现一次加载，多次低时延播放。

开发说明

本开发指导仅针对音视频播放或录制本身，由media模块提供相关能力，不涉及UI界面、图形处理、媒体存储或其他相关领域功能。

在开发音乐、视频播放功能之前，建议了解流媒体播放的相关概念包括但不限于：

播放过程：网络协议 > 容器格式 > 音视频编解码 > 图形/音频渲染

网络协议：比如HLS、HTTP-FLV、HTTP/HTTPS

容器格式：比如mp4、mkv、mpeg-ts

编码格式：比如h264/h265

详细流媒体开发流程请参考流媒体播放开发指导。

AVPlayer

AVPlayer主要工作是将Audio/Video媒体资源（比如mp4/mp3/mkv/mpeg-ts等）转码为可供渲染的图像和可听见的音频模拟信号，并通过输出设备进行播放。

AVPlayer提供功能完善一体化播放能力，应用只需要提供流媒体来源，不负责数据解析和解码就可达成播放效果。

音频播放

当使用AVPlayer开发音乐应用播放音频时，AVPlayer与外部模块的交互关系如图所示。

音乐类应用通过调用JS接口层提供的AVPlayer接口实现相应功能时，框架层会通过播放服务（Player Framework）将资源解析成音频数据流（PCM），音频数据流经过软件解码后输出至音频服务（Audio Framework），由音频服务输出至音频驱动渲染，实现音频播放功能。完整的音频播放需要应用、Player Framework、Audio Framework、音频HDI共同实现。

上图中，数字标注表示需要数据与外部模块的传递。

音乐应用将媒体资源传递给AVPlayer接口。

Player Framework将音频PCM数据流输出给Audio Framework，再由Audio Framework输出给音频HDI。

视频播放

当使用AVPlayer开发视频应用播放视频时，AVPlayer与外部模块的交互关系如图所示。

应用通过调用JS接口层提供的AVPlayer接口实现相应功能时，框架层会通过播放服务（Player Framework）解析成单独的音频数据流和视频数据流，音频数据流经过软件解码后输出至音频服务（Audio Framework），再至硬件接口层的音频HDI，实现音频播放功能。视频数据流经过硬件（推荐）/软件解码后输出至图形渲染服务（Graphic Framework），再输出至硬件接口层的显示HDI，完成图形渲染。

完整的视频播放需要：应用、XComponent、Player Framework、Graphic Framework、Audio Framework、显示HDI和音频HDI共同实现。

图中的数字标注表示需要数据与外部模块的传递。

应用从XComponent组件获取窗口SurfaceID，获取方式参考XComponent。

应用把媒体资源、SurfaceID传递给AVPlayer接口。

Player Framework把视频ES数据流输出给解码HDI，解码获得视频帧（NV12/NV21/RGBA）。

Player Framework把音频PCM数据流输出给Audio Framework，Audio Framework输出给音频HDI。

Player Framework把视频帧（NV12/NV21/RGBA）输出给Graphic Framework，Graphic Framework输出给显示HDI。

支持的格式与协议

推荐使用以下主流的播放格式，音视频容器、音视频编码属于内容创作者所掌握的专业领域，不建议应用开发者自制码流进行测试，以免产生无法播放、卡顿、花屏等兼容性问题。若发生此类问题不会影响系统，退出播放即可。

支持的协议如下：

协议类型	协议描述
本地点播	协议格式：支持file descriptor，禁止file path
网络点播	协议格式：支持http/https/hls/dash
网络直播	协议格式：支持hls/http-flv

支持的音频播放格式如下：

音频容器规格	规格描述
m4a	音频格式：AAC
aac	音频格式：AAC
mp3	音频格式：MP3
ogg	音频格式：VORBIS
wav	音频格式：PCM
amr	音频格式：AMR

支持的视频播放格式和主流分辨率如下：

视频容器规格	规格描述	分辨率
mp4	

视频格式：H26510+/H264

音频格式：AAC/MP3

	主流分辨率，如4K/1080P/720P/480P/270P
mkv	

视频格式：H26510+/H264

音频格式：AAC/MP3

	主流分辨率，如4K/1080P/720P/480P/270P
ts	

视频格式：H26510+/H264

音频格式：AAC/MP3

	主流分辨率，如4K/1080P/720P/480P/270P

支持的字幕格式如下：

字幕容器规格	支持的协议	支持的加载方式
srt	本地点播(fd)/网络点播(http/https/hls/dash)	外挂字幕
vtt	本地点播(fd)/网络点播(http/https/hls/dash)	外挂字幕
webvtt	网络点播(dash协议)	内置字幕
说明

当dash协议存在内置字幕时，不支持添加外挂字幕。

SoundPool

SoundPool主要工作是将音频媒体资源（比如mp3/m4a/wav等）转码为音频模拟信号，并通过输出设备进行播放。

SoundPool提供短音频的播放能力，应用只需要提供音频资源来源，不负责数据解析和解码就可达成播放效果。

当使用SoundPool开发应用播放音频时，SoundPool与外部模块的交互关系如图所示。

音乐类应用通过调用JS接口层提供的SoundPool接口实现相应功能时，框架层会通过播放服务（Player Framework）将资源解析成音频数据流（PCM），音频数据流经过软件解码后输出至音频服务（Audio Framework），由音频服务输出至音频驱动渲染，实现音频播放功能。完整的音频播放需要应用、Player Framework、Audio Framework、音频HDI共同实现。

图中的数字标注表示需要数据与外部模块的传递。

音乐应用将媒体资源传递给SoundPool接口。

Player Framework将音频PCM数据流输出给Audio Framework，再由Audio Framework输出给音频HDI。

支持的格式与协议

推荐使用以下主流的播放格式，音视容器、音频编码属于内容创作者所掌握的专业领域，不建议应用开发者自制码流进行测试，以免产生无法播放、卡顿等兼容性问题。若发生此类问题不会影响系统，退出播放即可。

支持的协议如下：

协议类型	协议描述
本地点播	协议格式：支持file descriptor，禁止file path

支持的音频播放格式如下：

音频容器规格	规格描述
m4a	音频格式：AAC
aac	音频格式：AAC
mp3	音频格式：MP3
ogg	音频格式：VORBIS
wav	音频格式：PCM
AVRecorder

AVRecorder主要工作是捕获音频信号，接收视频信号，完成音视频编码并保存到文件中，帮助开发者轻松实现音视频录制功能，包括开始录制、暂停录制、恢复录制、停止录制、释放资源等功能控制。它允许调用者指定录制的编码格式、封装格式、文件路径等参数。

当使用AVRecorder开发应用录制视频时，AVRecorder与外部模块的交互关系如图所示。

音频录制：应用通过调用JS接口层提供的AVRecorder接口实现音频录制时，框架层会通过录制服务（Player Framework），调用音频服务（Audio Framework）通过音频HDI捕获音频数据，通过软件编码封装后保存至文件中，实现音频录制功能。

视频录制：应用通过调用JS接口层提供的AVRecorder接口实现视频录制时，先通过Camera接口调用相机服务（Camera Framework）通过视频HDI捕获图像数据送至框架层的录制服务，录制服务将图像数据通过视频编码HDI编码，再将编码后的图像数据封装至文件中，实现视频录制功能。

通过音视频录制组合，可分别实现纯音频录制、纯视频录制、音视频录制。

图中的数字标注表示需要数据与外部模块的传递。

应用通过AVRecorder接口从录制服务获取SurfaceID。

应用将SurfaceID设置给相机服务，相机服务可以通过SurfaceID获取到Surface。相机服务通过视频HDI捕获图像数据送至框架层的录制服务。

相机服务通过Surface将视频数据传递给录制服务。

录制服务通过视频编码HDI模块将视频数据编码。

录制服务将音频参数设置给音频服务，并从音频服务获取到音频数据。

支持的格式

支持的音频源如下：

音频源类型	说明
mic	系统麦克风作为音频源输入。

支持的视频源如下：

视频源类型	说明
surface_yuv	输入surface中携带的是raw data。
surface_es	输入surface中携带的是ES data。

支持的音视频编码格式如下：

音视频编码格式	说明
audio/mp4a-latm	音频/mp4a-latm类型
video/hevc	视频/hevc类型
video/avc	视频/avc类型
audio/mpeg	音频/mpeg类型
audio/g711mu	音频/g711-mulaw类型

支持的输出文件格式如下：

输出文件格式	说明
mp4	视频的容器格式，MP4。
m4a	音频的容器格式，M4A。
mp3	音频的容器格式，MP3。
wav	音频的容器格式，wav。
AVScreenCapture

AVScreenCapture主要工作是捕获音频信号、视频信号，并通过音视频编码将屏幕信息保存到文件中，帮助开发者轻松实现屏幕录制功能，主要包括录屏存文件和录屏取码流两套接口，它允许调用者指定屏幕录制的编码格式、封装格式和文件路径等参数。

当使用AVScreenCapture开发应用录制屏幕时，AVScreenCapture与外部模块的交互关系如图所示。

音频录制：应用通过调用JS/Native接口层提供的AVScreenCapture接口实现音频录制时，框架层会通过录屏框架，调用音频服务（Audio Framework）通过音频捕获音频数据，通过软件编码封装后保存至文件中，实现音频录制功能。
屏幕录制：应用通过调用JS/Native接口层提供的AVScreenCapture接口实现屏幕录制时，框架层会通过录屏框架，调用图形图像服务通过视频捕获屏幕数据，通过软件编码封装后保存至文件中，实现屏幕录制功能。
支持的格式

支持的音频源如下：

音频源类型	说明
MIC	系统麦克风作为音频源输入。
ALL_PLAYBACK	系统内录使用作为音频源输入。

支持的视频源如下：

视频源类型	说明
SURFACE_RGBA	输出Buffer是rgba data

支持的音频编码格式如下：

音频编码格式	说明
AAC_LC	AAC_LC类型

支持的视频编码格式如下：

视频编码格式	说明
H264	H264类型

支持的输出文件格式如下：

输出文件格式	说明
mp4	视频的容器格式，MP4。
m4a	纯音频的容器格式，M4A。
AVMetadataExtractor

AVMetadataExtractor 主要用于获取音视频元数据。通过使用 AVMetadataExtractor，开发者可以从原始媒体资源中提取出丰富的元数据信息。以音频资源为例，我们可以获取到关于该音频的标题、艺术家、专辑名称、时长等详细信息。视频资源的元数据获取流程与音频类似，由于视频没有专辑封面，所以无法获取视频资源的专辑封面。

获取音频资源的元数据的全流程包含：创建AVMetadataExtractor，设置资源，获取元数据，获取专辑封面（可选），销毁资源。

支持的格式

支持的音视频源参考媒体数据解析。

AVImageGenerator

AVImageGenerator 主要用于获取视频缩略图。通过使用 AVImageGenerator，开发者可以实现从原始媒体资源中获取视频指定时间的视频帧。

支持的格式

支持的视频源参考视频解码。

AVTranscoder

AVTranscoder主要用于将已压缩编码的视频文件按照指定参数转换为另一种格式的视频。

支持的格式

当前版本AVTranscoder提供以下转码服务：

支持修改源视频文件的编码参数（格式、码率）和封装格式。源视频的音视频编码和封装格式为系统AVCodec支持的解码和解封装格式，目标视频的音视频编码和封装格式为系统AVCodec支持的编码和封装格式。

支持将HDR VIVID视频转换为SDR视频，以及SDR视频的转码。

支持转码时降低视频分辨率。

原视频分辨率不高于4K，且目标视频分辨率不低于240p。

目标视频宽、高不能大于源视频宽、高，且不能设置为奇数，详情请参考设置正确的视频宽高。

支持的源视频格式：

解封装格式
音频解码格式
视频解码格式

支持的目标视频格式：

封装格式
音频编码格式
视频编码格式

支持的轨道数：

不支持字幕轨，存在字幕轨时将直接丢弃，不起效。
存在多条视频轨时，只会输出一条。
存在多条音频轨时，只会输出一条。
说明
转码输出视频只支持mp4封装格式。
转码需要同时满足源视频和目标视频的格式。

---

## 媒体开发指导(ArkTS)

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/media-kit-dev--arkts-V5

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
Audio Kit（音频服务）
AVCodec Kit（音视频编解码服务）
AVSession Kit（音视频播控服务）
Camera Kit（相机服务）
DRM Kit（数字版权保护服务）
Image Kit（图片处理服务）
Media Kit（媒体服务）
Media Kit简介
媒体开发指导(ArkTS)
媒体开发指导(C/C++)
Media Library Kit（媒体文件管理服务）
Ringtone Kit（铃声服务）
Scan Kit（统一扫码服务）
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
媒体
Media Kit（媒体服务）
媒体开发指导(ArkTS)
媒体开发指导(ArkTS)
更新时间: 2025-03-17 08:08
播放

录制

媒体信息查询

视频转码

Media Kit简介
播放
简体中文
华为开发者联盟 版权所有 ©2026
使用条款
华为开发者联盟用户协议
关于华为开发者联盟与隐私的声明
cookies
开源软件声明

---

## Media Library Kit

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/medialibrary-kit-V5

Media Library Kit 简介

使用Picker选择媒体库资源

保存媒体库资源

使用PhotoPicker组件访问图片/视频

使用AlbumPicker组件访问相册列表

使用RecentPhoto组件获取最近一张图片

使用PhotoPicker推荐图片

动态照片

受限开放能力


---

## See Also

- [网络请求与数据持久化](network-data.md)
- [Notification Kit 通知服务](notification-kit.md)
