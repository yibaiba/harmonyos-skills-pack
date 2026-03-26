# 网络与数据主题

## Scope
- HTTP 网络请求、本地存储、数据库持久化与数据同步基础

## Key Concepts
- 请求封装
- 错误重试
- 缓存策略
- 持久化存储
- 数据库建模
- 离线同步

## Official Entrypoints
- HarmonyOS Network Kit 文档
- ArkData/数据存储相关文档
- 网络与存储样例代码

## Quick Q&A
- 网络层如何做统一错误处理与重试
- 本地存储和数据库怎么选择
- 离线场景下数据同步推荐路径是什么

## Common Pitfalls
- 没有统一请求层导致重复代码
- 缓存策略与业务一致性冲突
- 未处理弱网场景下的超时与幂等

## Boundaries
- 不覆盖后端网关与服务端架构设计
- 不覆盖数据库内核级优化
