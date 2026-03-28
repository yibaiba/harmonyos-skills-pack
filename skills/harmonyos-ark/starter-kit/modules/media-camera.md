# 相机与媒体模块

> 覆盖：系统相机拍照 / 相册选取 / 图片裁剪压缩 / 沙箱文件保存 / 视频缩略图

> 来源：HarmonyOS V5 (API 12) CameraPicker / PhotoAccessHelper / Image Kit 官方文档

## 一、CameraPicker 系统相机拍照

```typescript
// utils/CameraUtil.ets
import { cameraPicker } from '@kit.CameraKit'
import { camera } from '@kit.CameraKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'Camera'

export class CameraUtil {
  /**
   * 调用系统相机拍照
   * @returns 照片 URI 或 null（用户取消）
   */
  static async takePhoto(context: Context): Promise<string | null> {
    try {
      const pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      }
      const result = await cameraPicker.pick(
        context,
        [cameraPicker.PickerMediaType.PHOTO],
        pickerProfile
      )
      if (result?.resultUri) {
        hilog.info(0x0000, TAG, '拍照成功: %{public}s', result.resultUri)
        return result.resultUri
      }
      return null
    } catch (e) {
      hilog.error(0x0000, TAG, '拍照失败: %{public}s', JSON.stringify(e))
      return null
    }
  }

  /**
   * 调用系统相机录像
   * @returns 视频 URI 或 null
   */
  static async recordVideo(context: Context): Promise<string | null> {
    try {
      const pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
        videoDuration: 60 // 最长 60 秒
      }
      const result = await cameraPicker.pick(
        context,
        [cameraPicker.PickerMediaType.VIDEO],
        pickerProfile
      )
      return result?.resultUri ?? null
    } catch (e) {
      hilog.error(0x0000, TAG, '录像失败: %{public}s', JSON.stringify(e))
      return null
    }
  }
}
```

## 二、PhotoAccessHelper 相册选取

```typescript
// utils/AlbumPicker.ets
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'AlbumPicker'

export class AlbumPicker {
  /**
   * 从相册选取图片
   * @param maxSelect 最大选择数量
   * @returns 选中图片的 URI 数组
   */
  static async pickImages(maxSelect: number = 9): Promise<string[]> {
    try {
      const option = new photoAccessHelper.PhotoSelectOptions()
      option.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
      option.maxSelectNumber = maxSelect
      option.isPhotoTakingSupported = false // 不允许在选择器内拍照

      const picker = new photoAccessHelper.PhotoViewPicker()
      const result = await picker.select(option)

      if (result?.photoUris?.length > 0) {
        hilog.info(0x0000, TAG, '选取了 %{public}d 张图片', result.photoUris.length)
        return result.photoUris
      }
      return []
    } catch (e) {
      hilog.error(0x0000, TAG, '相册选取失败: %{public}s', JSON.stringify(e))
      return []
    }
  }

  /**
   * 从相册选取视频
   * @returns 选中视频的 URI 数组
   */
  static async pickVideos(maxSelect: number = 1): Promise<string[]> {
    try {
      const option = new photoAccessHelper.PhotoSelectOptions()
      option.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE
      option.maxSelectNumber = maxSelect

      const picker = new photoAccessHelper.PhotoViewPicker()
      const result = await picker.select(option)
      return result?.photoUris ?? []
    } catch (e) {
      hilog.error(0x0000, TAG, '视频选取失败: %{public}s', JSON.stringify(e))
      return []
    }
  }
}
```

## 三、图片裁剪与压缩

```typescript
// utils/ImageProcessor.ets
import { image } from '@kit.ImageKit'
import { fileIo } from '@kit.CoreFileKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'ImageProcessor'

export class ImageProcessor {
  /**
   * 压缩图片到指定大小
   * @param sourceUri  原始图片 URI
   * @param outputPath 输出路径（沙箱目录）
   * @param maxWidth   最大宽度
   * @param quality    JPEG 质量 0-100
   */
  static async compressImage(
    sourceUri: string,
    outputPath: string,
    maxWidth: number = 1080,
    quality: number = 80
  ): Promise<string> {
    // 读取源文件
    const fd = fileIo.openSync(sourceUri, fileIo.OpenMode.READ_ONLY)
    const imageSource = image.createImageSource(fd.fd)
    const imageInfo = await imageSource.getImageInfo()

    // 计算缩放比例
    let targetWidth = imageInfo.size.width
    let targetHeight = imageInfo.size.height
    if (targetWidth > maxWidth) {
      const ratio = maxWidth / targetWidth
      targetWidth = maxWidth
      targetHeight = Math.floor(targetHeight * ratio)
    }

    // 解码为 PixelMap
    const decodingOptions: image.DecodingOptions = {
      desiredSize: { width: targetWidth, height: targetHeight }
    }
    const pixelMap = await imageSource.createPixelMap(decodingOptions)

    // 编码压缩
    const packer = image.createImagePacker()
    const packOptions: image.PackingOption = {
      format: 'image/jpeg',
      quality: quality
    }
    const buffer = await packer.packing(pixelMap, packOptions)

    // 写入目标文件
    const outFd = fileIo.openSync(outputPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY)
    fileIo.writeSync(outFd.fd, buffer)
    fileIo.closeSync(outFd.fd)

    // 释放资源
    pixelMap.release()
    imageSource.release()
    packer.release()
    fileIo.closeSync(fd.fd)

    hilog.info(0x0000, TAG, '压缩完成: %{public}d x %{public}d, 路径: %{public}s',
      targetWidth, targetHeight, outputPath)
    return outputPath
  }
}
```

## 四、媒体文件保存到沙箱

```typescript
// utils/FileSaveUtil.ets
import { fileIo } from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit'

export class FileSaveUtil {
  /**
   * 将 URI 指向的文件复制到应用沙箱
   * @param context   UIAbility 上下文
   * @param sourceUri 源文件 URI（相机/相册返回的 URI）
   * @param fileName  目标文件名（如 "avatar.jpg"）
   * @returns 沙箱内的完整路径
   */
  static async copyToSandbox(
    context: common.UIAbilityContext,
    sourceUri: string,
    fileName: string
  ): Promise<string> {
    const cacheDir = context.cacheDir
    const targetPath = `${cacheDir}/${fileName}`

    // 读源文件
    const srcFd = fileIo.openSync(sourceUri, fileIo.OpenMode.READ_ONLY)
    const stat = fileIo.statSync(srcFd.fd)
    const buffer = new ArrayBuffer(stat.size)
    fileIo.readSync(srcFd.fd, buffer)
    fileIo.closeSync(srcFd.fd)

    // 写目标文件
    const dstFd = fileIo.openSync(targetPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY)
    fileIo.writeSync(dstFd.fd, buffer)
    fileIo.closeSync(dstFd.fd)

    return targetPath
  }

  /** 清理缓存目录 */
  static cleanCache(context: common.UIAbilityContext): void {
    const cacheDir = context.cacheDir
    const files = fileIo.listFileSync(cacheDir)
    for (const file of files) {
      fileIo.unlinkSync(`${cacheDir}/${file}`)
    }
  }
}
```

## 五、视频缩略图生成

```typescript
// utils/VideoThumbnail.ets
import { media } from '@kit.MediaKit'
import { image } from '@kit.ImageKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'VideoThumb'

export class VideoThumbnail {
  /**
   * 获取视频第一帧作为缩略图
   * @param videoUri 视频文件 URI
   * @returns PixelMap 缩略图对象，可直接用于 Image 组件
   */
  static async generate(videoUri: string): Promise<image.PixelMap | null> {
    let avImageGenerator: media.AVImageGenerator | null = null
    try {
      avImageGenerator = await media.createAVImageGenerator()
      const fdObj = fileIo.openSync(videoUri, fileIo.OpenMode.READ_ONLY)
      avImageGenerator.fdSrc = { fd: fdObj.fd }

      const param: media.PixelMapParams = {
        width: 320,
        height: 240
      }
      // 取第 0 微秒帧
      const pixelMap = await avImageGenerator.fetchFrameByTime(
        0, media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC, param
      )
      fileIo.closeSync(fdObj.fd)
      return pixelMap
    } catch (e) {
      hilog.error(0x0000, TAG, '缩略图生成失败: %{public}s', JSON.stringify(e))
      return null
    } finally {
      avImageGenerator?.release()
    }
  }
}

// 在页面中使用
// @State thumbnail: image.PixelMap | null = null
// this.thumbnail = await VideoThumbnail.generate(videoUri)
// Image(this.thumbnail).width(160).height(120).objectFit(ImageFit.Cover)
```

## 常见陷阱

| 陷阱 | 说明 | 正确做法 |
|------|------|---------|
| PixelMap 忘记 release | 大图占用大量内存，快速泄漏导致 OOM | 使用完毕立即 release() |
| 相册 URI 直接用于上传 | URI 可能是临时权限，跨进程失效 | 先 copyToSandbox 再上传 |
| 主线程压缩大图 | 阻塞 UI，用户感知卡顿 | 使用 TaskPool 异步处理 |
| 忘记声明权限 | 无权限时 Picker 不弹窗或闪退 | ohos.permission.CAMERA（拍照）、ohos.permission.READ_IMAGEVIDEO（相册） |
| fileIo.openSync 忘记 close | 文件句柄泄漏 | 用 try/finally 保证 closeSync |
| 压缩后文件比原图大 | quality 过高 + 原图已压缩 | 先判断原图大小，小于阈值直接跳过压缩 |

## 官方参考
- CameraPicker: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-camerapicker
- PhotoAccessHelper: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-photoaccesshelper
- Image Kit: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/image-overview
- AVImageGenerator: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-media

---

## See Also

- [Image Kit](../../topics/image-kit.md)
- [媒体设备](../../topics/media-device.md)
- [数据持久化](data-persistence.md)
