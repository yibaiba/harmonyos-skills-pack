# 数据持久化模块

> 覆盖：Preferences 用户偏好 / KV Store 键值数据库 / RDB 关系型数据库 / 选型决策 / 事务处理 / 数据迁移

> 来源：HarmonyOS V5 (API 12) 数据管理能力文档

## 存储方案选择决策表

| 场景 | 推荐方案 | 理由 |
|------|---------|------|
| 用户设置、Token、开关 | Preferences | 轻量 KV，无需建表，启动即用 |
| 跨设备数据同步 | KV Store | 内置分布式同步能力 |
| 复杂查询（JOIN/聚合/分页） | RDB | 完整 SQL 支持 |
| 结构化列表（待办、订单） | RDB | 需要索引与条件查询 |
| 单设备缓存（< 1MB） | Preferences | 最低开销 |
| 大量结构化记录（> 1000 条） | RDB | Preferences 不适合大数据量 |

## 一、Preferences 用户偏好存储

```typescript
// utils/PreferencesUtil.ets
import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'

const STORE_NAME = 'app_preferences'

export class PreferencesUtil {
  private static store: preferences.Preferences | null = null

  /** 初始化 — 在 EntryAbility.onCreate 调用 */
  static async init(context: common.UIAbilityContext): Promise<void> {
    PreferencesUtil.store = await preferences.getPreferences(context, STORE_NAME)
  }

  /** 写入 */
  static async put<T extends preferences.ValueType>(key: string, value: T): Promise<void> {
    await PreferencesUtil.store?.put(key, value)
    await PreferencesUtil.store?.flush()
  }

  /** 读取 */
  static async get<T extends preferences.ValueType>(key: string, defaultValue: T): Promise<T> {
    const val = await PreferencesUtil.store?.get(key, defaultValue)
    return val as T
  }

  /** 删除单个键 */
  static async remove(key: string): Promise<void> {
    await PreferencesUtil.store?.delete(key)
    await PreferencesUtil.store?.flush()
  }

  /** 检查键是否存在 */
  static async has(key: string): Promise<boolean> {
    return (await PreferencesUtil.store?.has(key)) ?? false
  }

  /** 清空全部数据 */
  static async clear(): Promise<void> {
    await PreferencesUtil.store?.clear()
    await PreferencesUtil.store?.flush()
  }
}
```

## 二、KV Store 键值数据库（跨设备同步场景）

```typescript
// utils/KVStoreUtil.ets
import { distributedKVStore } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'

const STORE_ID = 'app_kv_store'

export class KVStoreUtil {
  private static kvManager: distributedKVStore.KVManager | null = null
  private static kvStore: distributedKVStore.SingleKVStore | null = null

  /** 初始化 KV 管理器与数据库 */
  static async init(context: common.UIAbilityContext): Promise<void> {
    const config: distributedKVStore.KVManagerConfig = {
      bundleName: context.abilityInfo.bundleName,
      context: context
    }
    KVStoreUtil.kvManager = distributedKVStore.createKVManager(config)

    const options: distributedKVStore.Options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: true, // 跨设备自动同步
      kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
      securityLevel: distributedKVStore.SecurityLevel.S1
    }
    KVStoreUtil.kvStore = await KVStoreUtil.kvManager.getKVStore<distributedKVStore.SingleKVStore>(
      STORE_ID, options
    )
  }

  /** 写入键值 */
  static async put(key: string, value: string): Promise<void> {
    await KVStoreUtil.kvStore?.put(key, value)
  }

  /** 读取键值 */
  static async get(key: string): Promise<string | null> {
    try {
      const entry = await KVStoreUtil.kvStore?.get(key)
      return entry as string
    } catch {
      return null // 键不存在
    }
  }

  /** 删除键值 */
  static async delete(key: string): Promise<void> {
    await KVStoreUtil.kvStore?.delete(key)
  }

  /** 监听数据变更（含远端同步） */
  static onDataChange(callback: (entries: distributedKVStore.ChangeNotification) => void): void {
    KVStoreUtil.kvStore?.on('dataChange', distributedKVStore.SubscribeType.SUBSCRIBE_TYPE_ALL,
      callback)
  }
}
```

## 三、RDB 关系型数据库（复杂查询场景）

```typescript
// database/AppDatabase.ets
import { relationalStore } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'

const DB_NAME = 'app.db'
const TABLE_TODO = 'todo'

// 建表 SQL
const SQL_CREATE_TODO = `
  CREATE TABLE IF NOT EXISTS ${TABLE_TODO} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT DEFAULT '',
    is_done INTEGER DEFAULT 0,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
  )`

export class AppDatabase {
  private static rdbStore: relationalStore.RdbStore | null = null

  /** 初始化数据库 — 在 EntryAbility.onCreate 调用 */
  static async init(context: common.UIAbilityContext): Promise<void> {
    const config: relationalStore.StoreConfig = {
      name: DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    AppDatabase.rdbStore = await relationalStore.getRdbStore(context, config)
    await AppDatabase.rdbStore.executeSql(SQL_CREATE_TODO)
  }

  /** 插入待办 */
  static async insertTodo(title: string, content: string): Promise<number> {
    const now = Date.now()
    const bucket: relationalStore.ValuesBucket = {
      title: title,
      content: content,
      is_done: 0,
      created_at: now,
      updated_at: now
    }
    return await AppDatabase.rdbStore!.insert(TABLE_TODO, bucket)
  }

  /** 分页查询待办 */
  static async queryTodos(page: number, pageSize: number): Promise<relationalStore.ResultSet> {
    const predicates = new relationalStore.RdbPredicates(TABLE_TODO)
    predicates.orderByDesc('created_at')
    predicates.limitAs(pageSize)
    predicates.offsetAs((page - 1) * pageSize)
    return await AppDatabase.rdbStore!.query(predicates, [
      'id', 'title', 'content', 'is_done', 'created_at'
    ])
  }

  /** 标记完成 */
  static async toggleDone(id: number, isDone: boolean): Promise<void> {
    const bucket: relationalStore.ValuesBucket = {
      is_done: isDone ? 1 : 0,
      updated_at: Date.now()
    }
    const predicates = new relationalStore.RdbPredicates(TABLE_TODO)
    predicates.equalTo('id', id)
    await AppDatabase.rdbStore!.update(bucket, predicates)
  }

  /** 删除待办 */
  static async deleteTodo(id: number): Promise<void> {
    const predicates = new relationalStore.RdbPredicates(TABLE_TODO)
    predicates.equalTo('id', id)
    await AppDatabase.rdbStore!.delete(predicates)
  }
}
```

## 四、事务处理模式

```typescript
// 在 AppDatabase 中添加批量操作事务
static async batchInsert(items: Array<{ title: string; content: string }>): Promise<void> {
  const store = AppDatabase.rdbStore!
  try {
    await store.beginTransaction()
    const now = Date.now()
    for (const item of items) {
      const bucket: relationalStore.ValuesBucket = {
        title: item.title,
        content: item.content,
        is_done: 0,
        created_at: now,
        updated_at: now
      }
      await store.insert(TABLE_TODO, bucket)
    }
    await store.commit()
  } catch (e) {
    await store.rollBack()
    throw e
  }
}
```

## 五、数据迁移策略

```typescript
// database/Migration.ets
// 版本升级时执行迁移 SQL
const MIGRATIONS: Record<number, string[]> = {
  2: [
    `ALTER TABLE ${TABLE_TODO} ADD COLUMN priority INTEGER DEFAULT 0`,
    `CREATE INDEX idx_todo_priority ON ${TABLE_TODO}(priority)`
  ],
  3: [
    `ALTER TABLE ${TABLE_TODO} ADD COLUMN category TEXT DEFAULT ''`
  ]
}

export async function runMigrations(
  store: relationalStore.RdbStore,
  fromVersion: number,
  toVersion: number
): Promise<void> {
  for (let v = fromVersion + 1; v <= toVersion; v++) {
    const sqls = MIGRATIONS[v]
    if (sqls) {
      for (const sql of sqls) {
        await store.executeSql(sql)
      }
    }
  }
}
```

## 常见陷阱

| 陷阱 | 说明 | 正确做法 |
|------|------|---------|
| Preferences 存大量数据 | 整体加载到内存，超过 1MB 明显卡顿 | 超过百条记录改用 RDB |
| 忘记 flush | put 后数据仅在内存，进程被杀数据丢失 | 每次 put 后调用 flush() |
| RDB 主线程查询 | 大表查询阻塞 UI | 使用 TaskPool 异步查询 |
| KV Store 未声明权限 | 跨设备同步失败无提示 | 声明 ohos.permission.DISTRIBUTED_DATASYNC |
| ResultSet 忘记关闭 | 内存泄漏，句柄耗尽 | 使用后调用 resultSet.close() |
| 事务未 rollBack | 异常路径未回滚导致数据不一致 | try/catch 中 catch 必须 rollBack |

## 官方参考
- Preferences: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/preferences-guidelines
- KV Store: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/kvstore-guidelines
- RDB: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/rdb-guidelines

---

## See Also

- [网络数据](../../topics/network-data.md)
- [状态管理](../../topics/state-management.md)
- [通用模式](../snippets/common-patterns.md)
