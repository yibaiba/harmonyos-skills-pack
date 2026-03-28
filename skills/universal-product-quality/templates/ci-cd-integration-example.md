# CI/CD 集成示例

> 将质量门禁嵌入自动化流水线，适用于 GitHub Actions / GitLab CI / Jenkins。

---

## 一、Lighthouse 性能门禁（Web 项目）

```yaml
# .github/workflows/quality-gate.yml
name: Quality Gate
on: [pull_request]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: treosh/lighthouse-ci-action@v11
        with:
          urls: |
            http://localhost:3000/
            http://localhost:3000/login
          budgetPath: ./lighthouse-budget.json
          uploadArtifacts: true
```

```json
// lighthouse-budget.json — 性能预算
[{
  "path": "/*",
  "timings": [
    { "metric": "first-contentful-paint", "budget": 2500 },
    { "metric": "interactive", "budget": 3000 },
    { "metric": "speed-index", "budget": 3000 }
  ],
  "resourceSizes": [
    { "resourceType": "script", "budget": 300 },
    { "resourceType": "total", "budget": 1000 }
  ]
}]
```

---

## 二、axe 无障碍自动检测

```yaml
# 在已有 CI job 中追加
- name: Accessibility audit
  run: |
    npx @axe-core/cli http://localhost:3000 \
      --tags wcag2a,wcag2aa \
      --exit  # 发现违规时退出码非零
```

---

## 三、截图回归检测

```yaml
# BackstopJS 视觉回归
- name: Visual regression
  run: |
    npx backstop test --config=backstop.config.js
  continue-on-error: false
```

```javascript
// backstop.config.js 最小配置
module.exports = {
  id: "app",
  viewports: [
    { label: "phone", width: 375, height: 812 },
    { label: "tablet", width: 768, height: 1024 },
    { label: "desktop", width: 1440, height: 900 },
  ],
  scenarios: [
    { label: "Homepage", url: "http://localhost:3000", delay: 2000 },
    { label: "Homepage Dark", url: "http://localhost:3000",
      onReadyScript: "puppet/dark-mode.js", delay: 2000 },
  ],
  paths: { bitmaps_reference: "backstop_data/bitmaps_reference" },
  engine: "puppeteer",
};
```

---

## 四、HarmonyOS 项目构建门禁

```yaml
# HarmonyOS 项目 CI（DevEco CLI）
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup DevEco CLI
        run: |
          # 安装 ohpm 和 hvigor
          npm install -g @ohos/hvigor-cli
      - name: Install dependencies
        run: ohpm install
      - name: Build HAP
        run: hvigorw assembleHap --no-daemon
      - name: Run unit tests
        run: hvigorw test --no-daemon
```

---

## 五、质量门禁集成策略

| 风险等级 | 必选门禁 | 推荐门禁 |
|---------|---------|---------|
| Low | 构建通过 + 单元测试 | — |
| Medium | + 无障碍检测 + 性能预算 | 截图回归 |
| High | + 截图回归 + 安全扫描 | 端到端测试 |

### 失败策略

- 🔴 构建/测试失败 → 阻断合并
- 🟡 无障碍/性能超标 → 标记 Warning，由评审人决定
- 🟢 截图差异 → 自动更新 baseline 或人工确认

---

## See Also

- [pre-release-universal.md](../checklists/pre-release-universal.md) — 发布前检查清单
- [team-review-scorecard.md](../templates/team-review-scorecard.md) — 团队评审打分表
