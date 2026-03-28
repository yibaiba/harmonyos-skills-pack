# User Authentication Kit 用户认证服务（离线参考）

> 来源：华为 HarmonyOS 开发者文档（V5/API 12）
> 覆盖：认证简介、归一化接口、认证能力查询、发起认证、认证控件、凭据状态感知


## 目录

- [User Auth Kit 简介](#user-auth-kit-简介)
- [查询认证能力](#查询认证能力)
- [发起认证](#发起认证)
- [认证控件](#认证控件)
- [凭据状态感知](#凭据状态感知)
- [常见陷阱与最佳实践](#常见陷阱与最佳实践)

---

## User Auth Kit 简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/user-authentication-overview-V5

User Authentication Kit（用户认证服务）提供基于设备本地注册的**锁屏口令、人脸、指纹**认证用户身份的能力。

### 核心特征

| 特征 | 说明 |
|------|------|
| **归一化接口** | 屏蔽不同认证因子差异，同一套接口支持口令/人脸/指纹 |
| **可信等级感知** | 可指定期望的认证可信等级，防止低安认证用于高风险场景 |
| **自定义认证切换** | 支持导航键切换到业务自定义认证界面 |
| **解锁结果复用** | 设备解锁后 5min 内可复用认证结果 |
| **系统认证控件** | 统一的认证 UI，自适应显示模式 |
| **凭据变化感知** | 可检测用户凭据状态变化 |

### 使用场景

- 应用内账号登录鉴权
- 支付认证
- 敏感操作确认（删除数据、修改密码）
- 文件/信息加密保护

### 运作机制

```
┌─────────────┐     ┌──────────────────┐     ┌────────────────────┐
│   应用        │ →  │  统一用户认证API    │ →  │  统一用户认证框架     │
│             │     │  归一化接口        │     │  调度各认证能力       │
└─────────────┘     └──────────────────┘     └────────┬───────────┘
                                                       │
                           ┌───────────────────────────┼──────────────────┐
                           │                           │                  │
                    ┌──────┴──────┐            ┌──────┴──────┐    ┌─────┴──────┐
                    │  口令认证    │            │  人脸认证    │    │  指纹认证   │
                    └─────────────┘            └─────────────┘    └────────────┘
```

认证通过后签发 **AuthToken**，可传递给通用密钥库服务（HUKS）作为密钥访问控制的鉴权证明。

### 认证可信等级

| 等级 | 英文 | 说明 | 典型场景 |
|------|------|------|---------|
| ATL1 | 低 | 锁屏口令 | 信息查看 |
| ATL2 | 中 | 2D 人脸 | 普通鉴权 |
| ATL3 | 高 | 3D 人脸 / 指纹 | 支付 |
| ATL4 | 极高 | 安全芯片级认证 | 高安全 |

> ⚠️ **支付场景**应要求 ATL3 及以上，避免将 2D 人脸（ATL2）用于支付。

---

## 查询认证能力

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/obtain-supported-authentication-capabilities-V5

在发起认证前，先查询设备支持的认证方式。

```typescript
import { userAuth } from '@kit.UserAuthenticationKit';

// 查询是否支持指纹认证（ATL3 等级）
try {
  userAuth.getAvailableStatus(
    userAuth.UserAuthType.FINGERPRINT,
    userAuth.AuthTrustLevel.ATL3
  );
  console.info('指纹认证可用');
} catch (error) {
  console.error('指纹认证不可用: ' + (error as BusinessError).code);
}
```

### 认证类型枚举

| 类型 | 说明 |
|------|------|
| `UserAuthType.PIN` | 锁屏口令 |
| `UserAuthType.FACE` | 人脸认证 |
| `UserAuthType.FINGERPRINT` | 指纹认证 |

### 错误码

| 错误码 | 说明 |
|--------|------|
| 12500002 | 该认证类型不支持 |
| 12500006 | 该认证类型未注册凭据 |
| 12500010 | 该认证类型不可用（被锁定等） |

---

## 发起认证

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/start-authentication-V5

### 基本认证流程

```typescript
import { userAuth } from '@kit.UserAuthenticationKit';
import { BusinessError } from '@kit.BasicServicesKit';

// 1. 配置认证参数
const authParam: userAuth.AuthParam = {
  challenge: new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8]),  // 业务挑战值
  authType: [userAuth.UserAuthType.FINGERPRINT, userAuth.UserAuthType.FACE],
  authTrustLevel: userAuth.AuthTrustLevel.ATL3,
};

// 2. 配置认证控件参数
const widgetParam: userAuth.WidgetParam = {
  title: '请验证身份',  // 最多 500 字符
};

// 3. 获取认证实例
const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);

// 4. 订阅认证结果
userAuthInstance.on('result', {
  onResult(result: userAuth.UserAuthResult) {
    console.info('认证结果: ' + result.result);
    if (result.result === userAuth.UserAuthResultCode.SUCCESS) {
      // 认证成功
      const token = result.token;  // AuthToken
      console.info('认证成功，token: ' + JSON.stringify(token));
    } else {
      // 认证失败
      console.error('认证失败，错误码: ' + result.result);
    }
  }
});

// 5. 启动认证
userAuthInstance.start();
```

### 带自定义认证的导航键

```typescript
const widgetParam: userAuth.WidgetParam = {
  title: '请验证身份',
  navigationButtonText: '使用密码登录',  // 导航键文字
};

userAuthInstance.on('result', {
  onResult(result: userAuth.UserAuthResult) {
    if (result.result === userAuth.UserAuthResultCode.SUCCESS) {
      // 系统认证成功
    }
  }
});

// 监听导航键点击
userAuthInstance.on('result', {
  onResult(result: userAuth.UserAuthResult) {
    if (result.result === userAuth.UserAuthResultCode.TYPE_NOT_SUPPORT) {
      // 用户点击了导航键，切换到自定义认证
      showCustomLoginPage();
    }
  }
});
```

### 取消认证

```typescript
// 认证过程中取消
userAuthInstance.cancel();
```

### 复用解锁认证结果

```typescript
const authParam: userAuth.AuthParam = {
  challenge: new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8]),
  authType: [userAuth.UserAuthType.FINGERPRINT],
  authTrustLevel: userAuth.AuthTrustLevel.ATL3,
  reuseUnlockResult: {
    reuseMode: userAuth.ReuseMode.AUTH_TYPE_RELEVANT,  // 认证方式匹配
    reuseDuration: 300000,  // 5 分钟内（最大 5min = 300000ms）
  }
};
```

| 复用模式 | 说明 |
|---------|------|
| `AUTH_TYPE_IRRELEVANT` | 任何方式解锁均可复用 |
| `AUTH_TYPE_RELEVANT` | 解锁方式必须与请求的一致 |

---

## 认证控件

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/user-auth-icon-V5

### 嵌入式认证控件

系统提供嵌入式用户身份认证控件 `UserAuthIcon`，可直接放在页面中。

```typescript
import { userAuth } from '@kit.UserAuthenticationKit';

@Entry
@Component
struct AuthPage {
  build() {
    Column() {
      Text('需要验证身份才能继续')
        .fontSize(18)
        .margin({ bottom: 20 })

      UserAuthIcon({
        authParam: {
          challenge: new Uint8Array([1, 2, 3, 4]),
          authType: [userAuth.UserAuthType.FACE, userAuth.UserAuthType.FINGERPRINT],
          authTrustLevel: userAuth.AuthTrustLevel.ATL3,
        },
        widgetParam: {
          title: '请验证身份',
        },
        iconHeight: 64,
        iconColor: Color.Blue,
        onIconClick: () => {
          console.info('用户点击了认证图标');
        },
        onAuthResult: (result: userAuth.UserAuthResult) => {
          if (result.result === 0) {
            console.info('认证成功');
          }
        }
      })
    }
    .padding(24)
  }
}
```

### 控件特性

- 根据设备支持的认证方式自动显示对应图标（指纹/人脸）
- 自适应调整窗口显示模式
- 支持自定义标题和导航键文字
- 支持自定义图标颜色和大小

---

## 凭据状态感知

### 查询凭据注册状态

```typescript
try {
  const state = userAuth.getEnrolledState(
    userAuth.UserAuthType.FINGERPRINT,
    userAuth.AuthTrustLevel.ATL3
  );
  console.info('Credential state: ' + state.credentialDigest);
  // 保存 credentialDigest，后续对比检测变化
} catch (error) {
  console.error('Query failed: ' + (error as BusinessError).code);
}
```

### 感知凭据变化场景

1. **业务开通时**：记录当前 `credentialDigest`
2. **后续认证时**：重新获取 `credentialDigest` 并对比
3. **变化检测**：如果 digest 不同，说明用户注册了新凭据或删除了旧凭据

---

## 常见陷阱与最佳实践

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 认证失败 12500002 | 设备不支持该认证类型 | 先调用 `getAvailableStatus` 检查 |
| 认证失败 12500006 | 用户未注册该凭据 | 提示用户到设置中注册 |
| 支付场景安全隐患 | 使用了 ATL2（2D 人脸） | 支付场景强制要求 ATL3+ |
| 认证控件不显示 | 未正确传入参数 | 检查 authParam 和 widgetParam |
| 复用不生效 | 超过时间限制 | reuseDuration 最大 5 分钟 |

### 安全建议

1. **challenge 唯一性**：每次认证使用不同的 challenge，防止重放攻击
2. **可信等级匹配**：根据业务风险级别选择合适的 ATL
3. **AuthToken 验证**：在服务端验证 token 的合法性
4. **降级处理**：设备不支持生物认证时，优雅降级到口令认证

### 认证方式选择决策

```
业务场景？
├── 支付/高安全操作 → ATL3（指纹/3D人脸）
├── 普通鉴权/信息查看 → ATL2（人脸）+ ATL1 降级
├── 快速解锁（非敏感） → 复用解锁结果
└── 需要自定义 UI → 嵌入式认证控件 + navigationButton
```

---

## See Also

- [common-patterns.md](../starter-kit/snippets/common-patterns.md) §九 — 权限申请模式
- [routing-lifecycle.md](./routing-lifecycle.md) — 页面路由（认证后跳转）
- [testing-release.md](./testing-release.md) — 应用测试与发布
