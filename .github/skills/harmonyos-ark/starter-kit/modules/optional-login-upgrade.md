# 可选登录升级模块（从免登录到账号同步）

> 覆盖：游客模式升级登录 / 本地数据迁移 / 冲突合并策略 / 回滚安全

## 目标
- 保持“默认可离线免登录”体验
- 在用户需要跨设备同步时，再引导登录
- 登录后把本地数据迁移到云端，不丢数据

## 典型触发点
- 用户点击“云同步”“多端同步”“备份恢复”
- 用户更换设备，需要恢复历史记录

## 推荐流程

```text
游客模式（本地）
  -> 用户主动点“登录同步”
  -> LoginPage 完成授权
  -> 执行 MigrationService
      1) 读取本地数据
      2) 拉取云端数据
      3) 冲突合并
      4) 上传最终数据
      5) 标记迁移完成
  -> 进入“已登录 + 可同步”状态
```

## 数据状态模型

```typescript
// model/SessionMode.ets
export enum SessionMode {
  GUEST = 'guest',
  AUTH = 'auth'
}

export interface SessionState {
  mode: SessionMode
  userId?: string
  migratedAt?: number
}
```

## 迁移服务示例

```typescript
// service/MigrationService.ets
import { LocalRepository } from '../repository/LocalRepository'
import { CloudRepository } from '../repository/CloudRepository'

export class MigrationService {
  private localRepo = new LocalRepository()
  private cloudRepo = new CloudRepository()

  async migrateAfterLogin(userId: string): Promise<void> {
    const localItems = await this.localRepo.listAll()
    const cloudItems = await this.cloudRepo.listAll(userId)

    const merged = this.mergeByUpdatedAt(localItems, cloudItems)

    await this.cloudRepo.replaceAll(userId, merged)
    await this.localRepo.markMigrated(Date.now())
  }

  private mergeByUpdatedAt(localItems: Item[], cloudItems: Item[]): Item[] {
    const map = new Map<string, Item>()

    for (const item of cloudItems) {
      map.set(item.id, item)
    }

    for (const item of localItems) {
      const old = map.get(item.id)
      if (!old || item.updatedAt > old.updatedAt) {
        map.set(item.id, item)
      }
    }

    return Array.from(map.values())
  }
}
```

## UI 文案建议

- 游客状态按钮：`登录后多端同步（可选）`
- 登录确认弹窗：
  - 标题：`启用云同步`
  - 文案：`登录后将把当前本地数据同步到云端，可在其他设备恢复。`
  - 次按钮：`暂不登录`
  - 主按钮：`继续登录`

## 冲突策略（建议默认）

1. 同 id 冲突：取 `updatedAt` 更新的一条
2. 本地新增、云端不存在：直接上传
3. 云端新增、本地不存在：直接拉取
4. 删除冲突：优先尊重最近操作（需要 tombstone 或 deleteAt）

## 安全与回滚

- 迁移前先做本地快照（JSON）
- 迁移失败可回滚到快照
- 迁移过程显示进度并可重试
- 不在日志打印 token、手机号等敏感信息

## 与现有模块关系

- 前置：modules/offline-no-login.md
- 账号能力：modules/auth-login.md
- 数据层：snippets/state-management.md
