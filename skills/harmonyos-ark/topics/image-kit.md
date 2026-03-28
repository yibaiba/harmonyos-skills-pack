# Image Kit 图片处理服务（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V5/API 12）
> 覆盖：图片解码、图像变换、图片编码、EXIF 信息读写


## 目录

- [Image Kit 简介](#image-kit-简介)
- [图片解码](#图片解码)
- [图像变换](#图像变换)
- [图片编码](#图片编码)
- [EXIF 信息读写](#exif-信息读写)
- [常见陷阱与最佳实践](#常见陷阱与最佳实践)

---

## Image Kit 简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-overview-V5

Image Kit（图片处理服务）提供图片解码、图像变换、图片编码等能力。主要概念：

| 概念 | 说明 |
|------|------|
| **PixelMap** | 图片解码后的无压缩位图，用于显示或处理 |
| **ImageSource** | 图片解码出来的图片源类，用于获取/修改图片信息 |
| **ImagePacker** | 图片打包器，将 PixelMap/ImageSource 编码为存档图片 |

**支持格式**：JPEG、PNG、GIF、WebP、BMP、SVG、ICO、DNG、HEIF

**核心流程**：获取图片 → 创建 ImageSource → 解码为 PixelMap → 图片处理 → 编码保存

### 与相关 Kit 的关系

- Image 组件直接使用 PixelMap 进行显示
- CoreFileKit 提供文件读写能力
- LocalizationKit 的 ResourceManager 提供资源文件访问

---

## 图片解码

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-decoding-V5

### 导入模块

```typescript
import { image } from '@kit.ImageKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
```

### 图片加载方式选择

| 来源 | 方式 | 适用场景 | 性能 |
|------|------|---------|------|
| 沙箱文件 | 路径 / fd | 本地拍照、下载后的文件 | ⭐⭐⭐ 最快 |
| 资源文件 | ArrayBuffer | rawfile 中的固定图片资源 | ⭐⭐ 需拷贝内存 |
| 资源文件 | RawFileDescriptor | rawfile 中的大图（避免内存拷贝） | ⭐⭐⭐ 零拷贝 |
| 网络图片 | 先下载再 createImageSource | 远程 URL 图片处理 | ⭐ 取决于网络 |

> 💡 **选择建议**：只需显示 → 用 `Image` 组件直接加载；需要裁剪/变换/编码 → 用 Image Kit 的 PixelMap 流程。

### 获取图片的四种方式

**方式一：沙箱路径**

```typescript
const context: Context = getContext(this);
const filePath: string = context.cacheDir + '/test.jpg';
```

**方式二：文件描述符**

```typescript
const file: fs.File = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
const fd: number = file?.fd;
```

**方式三：资源文件 ArrayBuffer**

```typescript
import { resourceManager } from '@kit.LocalizationKit';

const resourceMgr = getContext(this).resourceManager;
const fileData = await resourceMgr.getRawFileContent('test.jpg');
const buffer = fileData.buffer.slice(0);
```

**方式四：资源文件 RawFileDescriptor**

```typescript
const rawFd = await resourceMgr.getRawFd('test.jpg');
```

### 创建 ImageSource

```typescript
// 从沙箱路径
const imageSource = image.createImageSource(filePath);
// 从文件描述符
const imageSource = image.createImageSource(fd);
// 从 ArrayBuffer
const imageSource = image.createImageSource(buffer);
// 从 RawFileDescriptor
const imageSource = image.createImageSource(rawFd);
```

### 解码为 PixelMap

```typescript
const decodingOptions: image.DecodingOptions = {
  editable: true,
  desiredPixelFormat: 3,  // RGBA_8888
};

const pixelMap = await imageSource.createPixelMap(decodingOptions);
```

### HDR 图片解码

```typescript
const decodingOptions: image.DecodingOptions = {
  desiredDynamicRange: image.DecodingDynamicRange.AUTO,
};
const pixelMap = await imageSource.createPixelMap(decodingOptions);
// 判断是否为 HDR
const info = pixelMap.getImageInfoSync();
console.log('isHdr: ' + info.isHdr);
```

### 释放资源（必须）

```typescript
pixelMap.release();
imageSource.release();
```

> ⚠️ **易错点**：必须在异步操作完成后才能释放，否则会导致崩溃。

---

## 图像变换

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-transformation-V5

对 PixelMap 进行裁剪、缩放、偏移、旋转、翻转、透明度等操作。

### 获取图片信息

```typescript
const info = await pixelMap.getImageInfo();
console.info('width = ' + info.size.width);
console.info('height = ' + info.size.height);
```

### 变换操作

```typescript
// 裁剪：从 (0,0) 裁剪 400x400 区域
pixelMap.crop({ x: 0, y: 0, size: { height: 400, width: 400 } });

// 缩放：宽高各缩小一半
pixelMap.scale(0.5, 0.5);

// 偏移：向右下各移动 100
pixelMap.translate(100, 100);

// 旋转：顺时针 90°
pixelMap.rotate(90);

// 翻转：垂直翻转
pixelMap.flip(false, true);
// 水平翻转
pixelMap.flip(true, false);

// 透明度
pixelMap.opacity(0.5);
```

> ⚠️ **注意**：所有变换操作直接修改原始 PixelMap，不会创建新对象。

---

## 图片编码

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-encoding-V5

将 PixelMap 编码为 JPEG/WebP/PNG/HEIF 格式。

### 编码到 ArrayBuffer

```typescript
const imagePackerApi = image.createImagePacker();
const packOpts: image.PackingOption = {
  format: 'image/jpeg',
  quality: 98,
};

// 从 PixelMap 编码
const data: ArrayBuffer = await imagePackerApi.packing(pixelMap, packOpts);

// 从 ImageSource 编码
const data: ArrayBuffer = await imagePackerApi.packing(imageSource, packOpts);
```

### 编码直接写入文件

```typescript
const path = getContext(this).cacheDir + '/output.jpg';
const file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
await imagePackerApi.packToFile(pixelMap, file.fd, packOpts);
```

### HDR 编码

```typescript
packOpts.desiredDynamicRange = image.PackingDynamicRange.AUTO;
```

> ⚠️ **MIME 标准**：`format` 应设为 `"image/jpeg"` 而非 `"jpeg"`，文件扩展名为 `.jpg` 或 `.jpeg`。

---

## EXIF 信息读写

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/image-tool-V5

EXIF（Exchangeable image file format）记录数码照片属性和拍摄数据。**仅支持 JPEG 格式**。

### 读取 EXIF

```typescript
const options: image.ImagePropertyOptions = {
  index: 0,
  defaultValue: '9999'
};
const bitsPerSample = await imageSourceApi.getImageProperty(
  image.PropertyKey.BITS_PER_SAMPLE, options
);
```

### 编辑 EXIF

```typescript
await imageSourceApi.modifyImageProperty(
  image.PropertyKey.IMAGE_WIDTH, '120'
);
const width = await imageSourceApi.getImageProperty(
  image.PropertyKey.IMAGE_WIDTH
);
```

---

## 常见陷阱与最佳实践

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| PixelMap 显示空白 | 未等待异步解码完成 | 使用 `await` 或 `.then()` 确保解码完成 |
| 内存泄漏 | 未释放 PixelMap/ImageSource | 使用完毕后调用 `.release()` |
| HEIF 解码失败 | 设备不支持 | 检查设备能力，降级为 JPEG |
| 编码质量差 | quality 值过低 | 建议 quality ≥ 90 |
| EXIF 修改不生效 | 非 JPEG 格式 | EXIF 仅支持 JPEG |

### 性能建议

1. **大图缩略解码**：设置 `desiredSize` 避免全尺寸解码消耗内存
2. **及时释放**：在页面 `aboutToDisappear` 中释放 PixelMap
3. **编码到文件**：优先使用 `packToFile` 而非先编码到内存再写文件

---

## See Also

- [network-data.md](./network-data.md) — 图片加载与缓存策略
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) — 常用代码模式
- [arkui-advanced.md](./arkui-advanced.md) — Image 组件高级用法
