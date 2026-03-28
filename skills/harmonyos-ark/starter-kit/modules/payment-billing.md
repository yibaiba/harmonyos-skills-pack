# 应用内支付模块

> 覆盖：IAP Kit 概述 / 购买流程框架 / 订单验证 / 掉单补偿策略

> 来源：HarmonyOS V5 (API 12) IAP Kit 官方文档

> ⚠️ **注意：** 本模块需要 AGC（AppGallery Connect）服务端配合，仅提供客户端框架与架构指引。完整接入需在 AGC 控制台配置商品并部署服务端验证接口。

## 商品类型决策表

| 类型 | IAP 类型标识 | 典型场景 | 特点 |
|------|------------|---------|------|
| 消耗型 | consumable | 金币、钻石、体力 | 购买后消耗，可重复购买 |
| 非消耗型 | non_consumable | 去广告、关卡解锁、皮肤 | 一次购买永久生效 |
| 订阅型 | auto_subscription | 会员、月度服务 | 自动续期，可取消 |

## 一、IAP Kit 初始化与环境检查

```typescript
// iap/IAPManager.ets
import { iap } from '@kit.IAPKit'
import { common } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'IAP'

export class IAPManager {
  private context: common.UIAbilityContext

  constructor(context: common.UIAbilityContext) {
    this.context = context
  }

  /** 检查 IAP 环境是否可用 */
  async isAvailable(): Promise<boolean> {
    try {
      await iap.queryEnvironmentStatus(this.context)
      hilog.info(0x0000, TAG, 'IAP 环境可用')
      return true
    } catch (e) {
      hilog.error(0x0000, TAG, 'IAP 环境不可用: %{public}s', JSON.stringify(e))
      return false
    }
  }
}
```

## 二、查询商品信息

```typescript
// iap/IAPManager.ets — 追加方法

/** 查询商品列表 */
async queryProducts(productIds: string[], type: number): Promise<iap.Product[]> {
  try {
    const request: iap.QueryProductsParameter = {
      productType: type,
      productList: productIds.map(id => ({ productId: id }))
    }
    const result = await iap.queryProducts(this.context, request)
    return result?.productList ?? []
  } catch (e) {
    hilog.error(0x0000, TAG, '查询商品失败: %{public}s', JSON.stringify(e))
    return []
  }
}

// 使用示例
// const products = await iapManager.queryProducts(
//   ['coin_100', 'coin_500', 'vip_monthly'],
//   0 // 0=消耗型, 1=非消耗型, 2=订阅型
// )
```

## 三、发起购买

```typescript
// iap/IAPManager.ets — 追加方法

/**
 * 发起购买 — 客户端框架
 * 完整流程：客户端购买 → 获取 purchaseToken → 服务端验证 → 确认发货
 */
async purchase(productId: string, type: number): Promise<PurchaseResult> {
  try {
    const request: iap.CreatePurchaseParameter = {
      productId: productId,
      productType: type
    }
    const result = await iap.createPurchase(this.context, request)

    if (result?.purchaseData) {
      const purchaseData = JSON.parse(result.purchaseData) as PurchaseData
      hilog.info(0x0000, TAG, '购买成功，orderId: %{public}s', purchaseData.orderId)

      return {
        success: true,
        orderId: purchaseData.orderId,
        purchaseToken: purchaseData.purchaseToken,
        productId: purchaseData.productId
      }
    }
    return { success: false, orderId: '', purchaseToken: '', productId: productId }
  } catch (e) {
    hilog.error(0x0000, TAG, '购买失败: %{public}s', JSON.stringify(e))
    return { success: false, orderId: '', purchaseToken: '', productId: productId }
  }
}

/** 购买结果数据 */
interface PurchaseResult {
  success: boolean
  orderId: string
  purchaseToken: string
  productId: string
}

/** IAP 返回的购买数据结构 */
interface PurchaseData {
  orderId: string
  purchaseToken: string
  productId: string
  purchaseTime: number
}
```

## 四、服务端订单验证（架构说明）

```
购买流程时序图：

  客户端                     服务端                   华为 IAP 服务器
    │                         │                          │
    │── createPurchase() ────▶│                          │
    │◀── purchaseToken ───────│                          │
    │                         │                          │
    │── POST /verify ────────▶│                          │
    │   {purchaseToken}       │── verifyPurchase() ─────▶│
    │                         │◀── 验证结果 ─────────────│
    │                         │                          │
    │                         │── 发放道具/权益          │
    │◀── 发货确认 ────────────│                          │
    │                         │                          │
    │── finishPurchase() ────▶│  （消耗型商品必须确认）   │
```

```typescript
// 服务端验证请求封装（客户端侧）
import { http } from '@kit.NetworkKit'

const VERIFY_URL = 'https://your-server.com/api/iap/verify'

export async function verifyPurchaseOnServer(
  purchaseToken: string,
  productId: string,
  orderId: string
): Promise<boolean> {
  const httpRequest = http.createHttp()
  try {
    const response = await httpRequest.request(VERIFY_URL, {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify({
        purchaseToken: purchaseToken,
        productId: productId,
        orderId: orderId
      })
    })
    if (response.responseCode === 200) {
      const body = JSON.parse(response.result as string)
      return body.verified === true
    }
    return false
  } catch {
    return false
  } finally {
    httpRequest.destroy()
  }
}
```

## 五、消耗型商品确认（finishPurchase）

```typescript
// iap/IAPManager.ets — 追加方法

/**
 * 确认消耗 — 消耗型商品购买成功并发货后必须调用
 * 不调用会导致用户无法再次购买同一商品
 */
async finishPurchase(purchaseToken: string, productId: string): Promise<void> {
  try {
    const request: iap.FinishPurchaseParameter = {
      productType: 0, // 消耗型
      purchaseToken: purchaseToken,
      productId: productId
    }
    await iap.finishPurchase(this.context, request)
    hilog.info(0x0000, TAG, '消耗确认完成: %{public}s', productId)
  } catch (e) {
    hilog.error(0x0000, TAG, '消耗确认失败: %{public}s', JSON.stringify(e))
    // 失败时应存入本地队列，下次启动时重试
  }
}
```

## 六、掉单补偿策略

```typescript
// iap/PurchaseRecovery.ets
import { iap } from '@kit.IAPKit'
import { common } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'PurchaseRecovery'

export class PurchaseRecovery {
  /**
   * 查询未完成的购买 — 应用启动时调用
   * 覆盖场景：网络中断、进程被杀、验证超时
   */
  static async checkUnfinished(context: common.UIAbilityContext): Promise<void> {
    try {
      const request: iap.QueryPurchasesParameter = {
        productType: 0 // 检查消耗型
      }
      const result = await iap.queryPurchases(context, request)

      if (result?.purchaseList && result.purchaseList.length > 0) {
        hilog.warn(0x0000, TAG, '发现 %{public}d 笔未完成订单', result.purchaseList.length)

        for (const purchase of result.purchaseList) {
          const data = JSON.parse(purchase.purchaseData)
          // 重新走服务端验证 → 发货 → finishPurchase
          const verified = await verifyPurchaseOnServer(
            data.purchaseToken, data.productId, data.orderId
          )
          if (verified) {
            // 补发道具
            await deliverProduct(data.productId)
            // 确认消耗
            const req: iap.FinishPurchaseParameter = {
              productType: 0,
              purchaseToken: data.purchaseToken,
              productId: data.productId
            }
            await iap.finishPurchase(context, req)
            hilog.info(0x0000, TAG, '掉单补偿完成: %{public}s', data.orderId)
          }
        }
      }
    } catch (e) {
      hilog.error(0x0000, TAG, '掉单检查失败: %{public}s', JSON.stringify(e))
    }
  }
}

async function deliverProduct(productId: string): Promise<void> {
  // 根据 productId 补发对应道具/权益
  // 具体逻辑取决于业务
}
```

## 常见陷阱

| 陷阱 | 说明 | 正确做法 |
|------|------|---------|
| 客户端信任购买结果 | purchaseData 可伪造 | 必须服务端验证 purchaseToken |
| 消耗型不调 finishPurchase | 用户无法再次购买同一商品 | 发货后立即调用 finishPurchase |
| 未处理掉单 | 用户付了钱没收到道具 | 启动时 queryPurchases 补偿 |
| 沙箱测试遗漏 | 正式环境才发现支付流程问题 | 用 AGC 沙箱账号充分测试 |
| 订阅状态仅客户端缓存 | 订阅到期/续费状态不准 | 定期服务端查询订阅状态 |
| 价格硬编码 | 不同地区价格不同 | 始终从 queryProducts 获取最新价格 |

## 官方参考
- IAP Kit 概述: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/iap-overview
- 购买流程: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/iap-purchase
- 服务端验证: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/iap-server-verify

---

## See Also

- [测试与发布](../../topics/testing-release.md)
- [审核风险清单](../../topics/incentive-review-2025.md)
- [后台任务](background-tasks.md)
