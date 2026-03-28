# 表单提交模块

> 覆盖：字段校验 / 提交加载 / 成功跳转 / 失败重试 / 图片选择上传

## 通用表单 ViewModel

```typescript
// viewmodel/FormViewModel.ets
import { FormRepository } from '../repository/FormRepository'

/** 替换为实际业务表单字段 */
@ObservedV2
export class FormViewModel {
  // ── 表单字段 ─────────────────────────────────────
  @Trace title: string = ''
  @Trace content: string = ''
  @Trace imageUris: string[] = []   // 本地 uri 列表

  // ── UI 状态 ──────────────────────────────────────
  @Trace isSubmitting: boolean = false
  @Trace submitSuccess: boolean = false
  @Trace errorMsg: string = ''

  // ── 字段错误（逐字段） ──────────────────────────
  @Trace titleError: string = ''
  @Trace contentError: string = ''

  private repo = new FormRepository()

  // ── 实时校验（onChange 调用） ───────────────────
  validateTitle(v: string): void {
    this.title = v
    this.titleError = v.trim().length === 0 ? '标题不能为空'
      : v.length > 50 ? '标题最多 50 个字符' : ''
  }

  validateContent(v: string): void {
    this.content = v
    this.contentError = v.trim().length < 10 ? '内容至少 10 个字符' : ''
  }

  get canSubmit(): boolean {
    return !this.isSubmitting
      && this.titleError === ''
      && this.contentError === ''
      && this.title.trim() !== ''
      && this.content.trim().length >= 10
  }

  // ── 提交 ─────────────────────────────────────────
  async submit(): Promise<boolean> {
    this.errorMsg = ''
    if (!this.canSubmit) {
      // 触发全量校验（未动过的字段不显示错误）
      this.validateTitle(this.title)
      this.validateContent(this.content)
      return false
    }
    this.isSubmitting = true
    try {
      await this.repo.submit({
        title: this.title.trim(),
        content: this.content.trim(),
        imageUris: this.imageUris
      })
      this.submitSuccess = true
      return true
    } catch (e) {
      this.errorMsg = e?.message ?? '提交失败，请稍后重试'
      return false
    } finally {
      this.isSubmitting = false
    }
  }
}
```

## FormPage.ets — 完整表单页

```typescript
// pages/FormPage.ets
import { router } from '@kit.ArkUI'
import { picker } from '@kit.CoreFileKit'
import { FormViewModel } from '../viewmodel/FormViewModel'

@Entry
@Component
struct FormPage {
  @State private vm: FormViewModel = new FormViewModel()

  build() {
    Column() {
      // ── 导航栏 ─────────────────────────────────────
      Row() {
        Image($r('app.media.ic_back')).width(24).height(24).onClick(() => router.back())
        Text('发布内容').fontSize(18).fontWeight(FontWeight.Medium).layoutWeight(1).textAlign(TextAlign.Center)
        Button('提交')
          .fontSize(14)
          .enabled(this.vm.canSubmit)
          .backgroundColor(this.vm.canSubmit ? $r('app.color.primary') : $r('app.color.disabled'))
          .onClick(async () => {
            const ok = await this.vm.submit()
            if (ok) {
              promptAction.showToast({ message: '发布成功' })
              router.back()
            }
          })
      }
      .width('100%').height(56).padding({ left: 16, right: 16 })

      Divider()

      // ── 表单内容 ───────────────────────────────────
      Scroll() {
        Column({ space: 20 }) {
          // 标题
          this.buildField('标题', () => this.buildTitleInput())

          // 正文
          this.buildField('内容', () => this.buildContentInput())

          // 图片
          this.buildField('图片（最多 9 张）', () => this.buildImagePicker())

          // 全局错误
          if (this.vm.errorMsg) {
            Text(this.vm.errorMsg)
              .fontColor($r('app.color.error'))
              .padding({ left: 16, right: 16 })
          }
        }
        .padding({ bottom: 32 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%').height('100%')
    .backgroundColor($r('app.color.background'))
  }

  @Builder
  buildField(label: string, content: () => void) {
    Column({ space: 6 }) {
      Text(label).fontSize(14).fontColor($r('app.color.text_secondary')).padding({ left: 16 })
      content()
    }
  }

  @Builder
  buildTitleInput() {
    Column({ space: 4 }) {
      TextInput({ placeholder: '请输入标题', text: this.vm.title })
        .maxLength(50)
        .onChange(v => this.vm.validateTitle(v))
        .padding({ left: 16, right: 16 })
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(8)
        .margin({ left: 16, right: 16 })

      if (this.vm.titleError) {
        Text(this.vm.titleError)
          .fontSize(12).fontColor($r('app.color.error'))
          .padding({ left: 16 })
      }
    }
  }

  @Builder
  buildContentInput() {
    Column({ space: 4 }) {
      TextArea({ placeholder: '请输入内容（至少 10 个字）', text: this.vm.content })
        .maxLength(2000)
        .height(160)
        .onChange(v => this.vm.validateContent(v))
        .padding(12)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(8)
        .margin({ left: 16, right: 16 })

      Row() {
        if (this.vm.contentError) {
          Text(this.vm.contentError).fontSize(12).fontColor($r('app.color.error'))
        }
        Blank()
        Text(`${this.vm.content.length}/2000`)
          .fontSize(12).fontColor($r('app.color.text_secondary'))
      }
      .width('100%').padding({ left: 16, right: 16 })
    }
  }

  @Builder
  buildImagePicker() {
    Flex({ wrap: FlexWrap.Wrap, space: { main: { value: 8, unit: LengthUnit.VP } } }) {
      ForEach(this.vm.imageUris, (uri: string, index: number) => {
        Stack({ alignContent: Alignment.TopEnd }) {
          Image(uri).width(80).height(80).borderRadius(8).objectFit(ImageFit.Cover)
          Image($r('app.media.ic_close'))
            .width(20).height(20)
            .onClick(() => {
              this.vm.imageUris.splice(index, 1)
            })
        }
      })

      if (this.vm.imageUris.length < 9) {
        Column() {
          Image($r('app.media.ic_add')).width(32).height(32)
          Text('添加图片').fontSize(12).fontColor($r('app.color.text_secondary'))
        }
        .width(80).height(80).borderRadius(8)
        .backgroundColor($r('app.color.card_background'))
        .justifyContent(FlexAlign.Center)
        .onClick(() => this.pickImage())
      }
    }
    .padding({ left: 16, right: 16 })
  }

  /** 调用系统图片选择器 */
  private async pickImage(): Promise<void> {
    const photoPicker = new picker.PhotoViewPicker()
    const result = await photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 9 - this.vm.imageUris.length
    })
    if (result.photoUris) {
      this.vm.imageUris = [...this.vm.imageUris, ...result.photoUris]
    }
  }
}
```

## FormRepository.ets — 表单提交含图片上传

```typescript
// repository/FormRepository.ets
import { HttpUtil } from '../utils/HttpUtil'

interface SubmitPayload {
  title: string
  content: string
  imageUris: string[]
}

export class FormRepository {
  async submit(payload: SubmitPayload): Promise<void> {
    // 1. 先上传图片，获取 CDN URL
    const uploadedUrls: string[] = []
    for (const uri of payload.imageUris) {
      const url = await HttpUtil.uploadFile('/api/upload', uri)
      uploadedUrls.push(url)
    }
    // 2. 提交表单
    await HttpUtil.post('/api/content/create', {
      title: payload.title,
      content: payload.content,
      images: uploadedUrls
    })
  }
}
```

## 官方参考
- TextInput / TextArea: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-textinput
- PhotoViewPicker: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/photoviewpicker
- 文件上传: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/upload-and-download-guidelines

---

## See Also

- [../../topics/network-data.md](../../topics/network-data.md) — 网络请求与数据持久化
- [./media-camera.md](./media-camera.md) — 相机与媒体（图片上传）
- [../snippets/common-patterns.md](../snippets/common-patterns.md) — 表单校验模式
