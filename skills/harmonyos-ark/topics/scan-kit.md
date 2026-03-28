# Scan Kit 统一扫码服务（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V13/API 13）
> 覆盖：扫码直达、默认界面扫码、自定义界面扫码、图像识码、码图生成


## 目录

- [Scan Kit 简介](#scan-kit-简介)
- [默认界面扫码](#默认界面扫码)
- [自定义界面扫码](#自定义界面扫码)
- [图像识码](#图像识码)
- [码图生成](#码图生成)
- [常见陷阱与最佳实践](#常见陷阱与最佳实践)

---

## Scan Kit 简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V13/scan-introduction-V13

Scan Kit（统一扫码服务）是软硬协同的系统级扫码服务，支持码图识别和生成。

### 场景选择

| 场景 | 说明 | 是否需要相机权限 |
|------|------|----------------|
| **扫码直达**（推荐） | 通过系统入口扫码跳转到应用 | ❌ |
| **默认界面扫码** | 系统统一扫码 UI | ❌（预授权） |
| **自定义界面扫码** | 开发者自定义扫码界面 | ✅ |
| **图像识码** | 对图片/图像数据识别 | ❌ |
| **码图生成** | 生成二维码/条形码图片 | ❌ |

### 支持码制式（13 种）

QR Code、Data Matrix、PDF417、Aztec、EAN-8、EAN-13、UPC-A、UPC-E、Codabar、Code 39、Code 93、Code 128、ITF-14

> 支持 MULTIFUNCTIONAL CODE 识别。

### 约束限制

- 支持手机和平板
- 默认界面扫码：不支持悬浮屏/分屏，相册扫码仅支持单码
- 自定义界面扫码：需申请 `ohos.permission.CAMERA`
- 扫码直达：仅支持 HTTPS 链接

---

## 默认界面扫码

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V13/scan-scanbarcode-V13

使用系统提供的统一扫码界面，无需申请相机权限。

### 导入模块

```typescript
import { scanCore, scanBarcode } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
```

### Callback 方式

```typescript
let options: scanBarcode.ScanOptions = {
  scanTypes: [scanCore.ScanType.ALL],
  enableMultiMode: true,
  enableAlbum: true,
};

scanBarcode.startScanForResult(getContext(this), options,
  (error: BusinessError, result: scanBarcode.ScanResult) => {
    if (error) {
      console.error('Scan failed: ' + error.message);
      return;
    }
    console.info('Scan result: ' + result.originalValue);
  }
);
```

### Promise 方式

```typescript
try {
  const result = await scanBarcode.startScanForResult(getContext(this), options);
  console.info('Scan result: ' + result.originalValue);
  console.info('Scan type: ' + result.scanType);
} catch (error) {
  console.error('Scan failed: ' + (error as BusinessError).message);
}
```

### ScanResult 关键字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `originalValue` | string | 扫码原始内容 |
| `scanType` | ScanType | 码制式类型 |
| `inputType` | number | 输入来源（相机/相册） |

---

## 自定义界面扫码

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V13/scan-customscan-V13

自定义扫码界面需要开发者自行实现 UI 和权限申请。

### 权限声明

```json
// module.json5
{
  "requestPermissions": [
    { "name": "ohos.permission.CAMERA" }
  ]
}
```

### 自定义扫码组件

```typescript
import { customScan, scanBarcode, scanCore } from '@kit.ScanKit';

@Entry
@Component
struct CustomScanPage {
  private surfaceId: string = '';
  private customScanController: customScan.ViewControl = new customScan.ViewControl();

  build() {
    Stack() {
      // 相机预览
      XComponent({
        id: 'scanSurface',
        type: XComponentType.SURFACE,
        controller: new XComponentController()
      })
        .onLoad(() => {
          this.surfaceId = (arguments[0] as Record<string, string>).surfaceId;
          this.startScan();
        })
        .width('100%')
        .height('100%')

      // 自定义 UI 覆盖层
      Column() {
        // 扫码框、提示文字等
        Text('将二维码放入框内')
          .fontColor(Color.White)
      }
    }
  }

  async startScan() {
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.QR_CODE],
      enableMultiMode: false,
      enableAlbum: false,
    };
    try {
      await customScan.init(options);
      await customScan.start(this.surfaceId, this.customScanController);

      customScan.on('lightingFlash', (state: boolean) => {
        // 暗光环境提示开启闪光灯
        console.info('Flash needed: ' + state);
      });

      const result = await customScan.getResult();
      console.info('Scan result: ' + result[0].originalValue);
    } catch (error) {
      console.error('Custom scan error: ' + (error as BusinessError).message);
    }
  }

  aboutToDisappear() {
    customScan.stop();
    customScan.release();
  }
}
```

### 闪光灯控制

```typescript
// 开启闪光灯
customScan.openFlashLight();
// 关闭闪光灯
customScan.closeFlashLight();
// 获取闪光灯状态
const isOn = customScan.getFlashLightStatus();
```

### 缩放控制

```typescript
customScan.setZoom(2.0);  // 2 倍缩放
```

---

## 图像识码

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V13/scan-detectbarcode-V13

识别本地图片或图像数据中的码图，无需相机权限。

### 识别本地图片

```typescript
import { detectBarcode, scanCore } from '@kit.ScanKit';
import { image } from '@kit.ImageKit';

// 从 PixelMap 识别
const pixelMap: image.PixelMap = /* 获取图片 PixelMap */;
let options: scanCore.ScanOptions = {
  scanTypes: [scanCore.ScanType.ALL],
};

// Callback 方式
detectBarcode.decode(pixelMap, options,
  (error: BusinessError, result: Array<scanCore.ScanResult>) => {
    if (error) {
      console.error('Decode failed');
      return;
    }
    for (const item of result) {
      console.info('Detected: ' + item.originalValue);
    }
  }
);

// Promise 方式
try {
  const results = await detectBarcode.decode(pixelMap, options);
  results.forEach((item) => {
    console.info('Detected: ' + item.originalValue);
  });
} catch (error) {
  console.error('Decode failed');
}
```

### 从相册选择图片识码

```typescript
import { photoAccessHelper } from '@kit.MediaLibraryKit';

// 使用 PhotoViewPicker 选择图片
const picker = new photoAccessHelper.PhotoViewPicker();
const result = await picker.select({ MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE });
const uri = result.photoUris[0];

// 创建 ImageSource → PixelMap → 识码
const imageSource = image.createImageSource(uri);
const pixelMap = await imageSource.createPixelMap();
const scanResults = await detectBarcode.decode(pixelMap, options);
```

---

## 码图生成

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V13/scan-barcodegenerate-V13

### 通过文本生成码图

```typescript
import { generateBarcode } from '@kit.ScanKit';

let options: generateBarcode.CreateOptions = {
  scanType: scanCore.ScanType.QR_CODE,
  height: 400,
  width: 400,
};

try {
  const pixelMap = await generateBarcode.createBarcode(
    '扫码内容文本', options
  );
  // pixelMap 可直接用于 Image 组件显示
  // this.qrCodeImage = pixelMap;
} catch (error) {
  console.error('Generate failed: ' + (error as BusinessError).message);
}
```

### 在页面中显示生成的码图

```typescript
@Entry
@Component
struct QRCodePage {
  @State qrImage: PixelMap | undefined = undefined;

  async aboutToAppear() {
    let options: generateBarcode.CreateOptions = {
      scanType: scanCore.ScanType.QR_CODE,
      height: 400,
      width: 400,
    };
    this.qrImage = await generateBarcode.createBarcode(
      'https://example.com', options
    );
  }

  build() {
    Column() {
      if (this.qrImage) {
        Image(this.qrImage)
          .width(200)
          .height(200)
      }
    }
  }
}
```

### 支持生成的码制式

| 码制式 | 说明 |
|--------|------|
| QR_CODE | 二维码（最常用） |
| AZTEC | Aztec 码 |
| DATA_MATRIX | Data Matrix 码 |
| PDF_417 | PDF417 码 |
| EAN_8 / EAN_13 | 商品条码 |
| UPC_A / UPC_E | 美国商品码 |
| CODE_39 / CODE_93 / CODE_128 | 工业条码 |
| CODABAR | Codabar 码 |
| ITF_14 | ITF-14 码 |

---

## 常见陷阱与最佳实践

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 默认界面扫码无结果 | scanTypes 设置过窄 | 使用 `ScanType.ALL` |
| 自定义扫码崩溃 | 未申请 CAMERA 权限 | 在 module.json5 声明并动态申请 |
| 暗光环境识别率低 | 未启用闪光灯提示 | 监听 `lightingFlash` 事件 |
| 码图生成模糊 | 尺寸设置过小 | width/height 建议 ≥ 400 |
| 相册识码慢 | 图片过大 | 先缩小 PixelMap 再识别 |

### 场景选择决策

```
需要扫码？
├── 不需要自定义 UI → 默认界面扫码（最简单）
├── 需要自定义 UI → 自定义界面扫码
├── 识别已有图片 → 图像识码
└── 生成码图 → 码图生成
```

---

## See Also

- [image-kit.md](./image-kit.md) — PixelMap 处理（识码输入/码图输出）
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) §九 — 权限申请模式
- [testing-release.md](./testing-release.md) — 应用测试与发布
