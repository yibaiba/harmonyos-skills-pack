# 后端 / API 项目质量基线

> 将 universal-product-quality 通用规则映射到后端/API 场景。

---

## 概念映射

| 通用概念 | 后端映射 | 检查方式 |
|---------|---------|---------|
| 功能完整性 | API 端点覆盖率 | 所有 CRUD 端点可调用并返回预期结构 |
| 业务链路 | 端到端请求链 | 从入口 API 到数据库到响应，无断链 |
| 异常处理 | 错误响应规范 | 4xx/5xx 返回统一错误格式 + 错误码 |
| 深色模式 | N/A（API 无 UI） | 跳过 |
| 多端适配 | 多客户端版本兼容 | 向后兼容策略（版本号/Feature Flag） |
| 状态反馈 | HTTP 状态码正确性 | 200/201/204/400/401/403/404/500 |
| 无障碍 | API 文档可访问性 | OpenAPI/Swagger 文档完整且可在线测试 |

---

## 后端专属检查项

### A. 接口规范

1. 🔴 所有接口有 OpenAPI / Swagger 文档
2. 🔴 请求/响应结构有类型定义（Schema）
3. 🔴 错误响应统一格式：`{ code, message, details? }`
4. 🟡 分页接口使用一致的分页参数（page/pageSize 或 cursor）
5. 🟡 时间字段统一使用 ISO 8601 格式

### B. 安全基线

1. 🔴 认证 Token 验证（JWT / OAuth2）
2. 🔴 输入参数校验与清理（防 SQL 注入/XSS）
3. 🔴 敏感接口限流（Rate Limiting）
4. 🟡 日志脱敏（不记录密码/Token/身份证号）
5. 🟡 CORS 配置精确（不使用 `*`）

### C. 性能基线

| 指标 | Low 风险 | Medium | High |
|------|---------|--------|------|
| P95 响应时间 | ≤ 500ms | ≤ 300ms | ≤ 200ms |
| 错误率 | < 1% | < 0.5% | < 0.1% |
| 可用性 | 99% | 99.9% | 99.99% |

### D. 可观测性

1. 🟡 结构化日志（JSON 格式，含 traceId）
2. 🟡 健康检查端点 `/health` 或 `/readyz`
3. 🟢 关键指标暴露（Prometheus / OpenTelemetry）
4. 🟢 慢查询告警阈值配置

---

## 后端评审简化打分表

| 维度 | 权重 | 评审要点 |
|------|------|---------|
| 接口完整性 | 30% | 端点覆盖 + 文档 + 错误格式 |
| 安全合规 | 30% | 认证 + 输入校验 + 限流 |
| 性能稳定性 | 25% | 响应时间 + 错误率 + 压测 |
| 可观测性 | 15% | 日志 + 监控 + 健康检查 |

---

## See Also

- [pre-release-universal.md](../checklists/pre-release-universal.md) — 通用发布前检查清单
- [team-review-scorecard.md](../templates/team-review-scorecard.md) — 团队评审打分表
- [risk-auto-classification.md](../rules/risk-auto-classification.md) — 风险自动分级
