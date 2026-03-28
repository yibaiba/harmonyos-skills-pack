# Universal Product Quality Skill - 一页式使用说明

## 目标
用最短时间建立"可发布"的统一质量门槛，避免功能单薄、深色模式缺陷、多端破版和提审阻塞。

## 适用范围
- 任意项目: App / Web / 桌面 / 小程序
- 任意技术栈: 前端框架、原生、跨端方案均可
- 任意团队规模: 单人开发到多人协作

## 质量门禁流程

```
开始
  |
  +-- 1. 判定风险等级
  |     rules/risk-auto-classification.md
  |     结果: High / Medium / Low
  |
  +-- 2. 执行对应深度的质量检查
  |     High:  全部清单 + 完整回归 + 合规复核
  |     Medium: 核心清单 + 核心回归
  |     Low:   基础清单 + 冒烟测试
  |
  +-- 3. 团队评审打分
  |     templates/team-review-scorecard.md
  |     >= 85 分且无阻断项 -> 可发布
  |
  +-- 4. 发布决策
        通过 -> 发布
        修复后复审 -> 修复 -> 回到步骤 2
        不通过 -> 阻断发布
```

## 三步接入（详细版）

### Step 1: 识别风险等级
- 阅读 rules/risk-auto-classification.md
- 根据触发词判定 High/Medium/Low
- 高频触发词：支付=High, 定位=Medium, 离线工具=Low
- 不确定时默认取较高等级

### Step 2: 执行质量检查
- 通用发布检查: checklists/pre-release-universal.md
  - 功能完整性、体验一致性、稳定性、可验证性
  - High/Medium 风险: 增加性能、无障碍、安全检查
- 深色与多端检查: checklists/multi-platform-dark-mode.md
  - 深色模式可读性、多端布局稳定性、交互一致性

### Step 3: 团队评审与发布决策
- 用 templates/team-review-scorecard.md 打分
- >= 85 且无阻断项: 可发布
- 70-84: 修复后复审
- < 70: 不建议发布

## 最小发布门槛（不可妥协项）
1. 功能: 至少 3 条完整业务链路，且包含异常分支
2. 深色模式: 核心页面在深色主题可读可操作
3. 多端: 手机/平板/桌面核心流程均可完成
4. 可复现: 审核或测试账号可复现关键路径
5. 一致性: 应用描述/截图/视频与实际功能一致

## 新项目 5 分钟上手
1. 复制 templates/project-onboarding-template.md 到项目文档
2. 填写项目信息和 3 条核心链路
3. 运行两份检查清单并记录问题
4. 评审打分，输出发布结论

## 与 CI/CD 集成建议
- PR Review: 将 pre-release-universal.md 的 E 节（勾选表）作为 PR 模板
- Sprint Planning: 每个 Sprint 结束时用 team-review-scorecard.md 评分
- Release Gate: 发布流水线中加入风险等级判定 + 分数阈值检查
- 自动化: 功能链路可编写 E2E 测试自动验证

## 常见失败信号
- 只有页面展示，没有完整功能闭环
- 深色模式按钮/文本对比度不足
- 平板或桌面出现布局重叠、不可点击
- 文案、截图、实际功能不一致
- 审核账号无法登录或无测试数据

## FAQ

Q: 项目只有手机端，需要做多端检查吗？
A: 如果只发布手机端，多端检查可简化为"确认横屏不崩溃"。

Q: 功能链路不足 3 条怎么办？
A: 工具类应用可将"设置->切换主题->确认生效"算作一条链路。

Q: 风险等级判定有争议怎么办？
A: 不确定时取较高等级。多花时间验证比发布后被拒更划算。

Q: 评审打分可以自评吗？
A: 可以，但建议至少一人交叉评审。

## 资产索引

| 用途 | 文件 |
|------|------|
| 风险判定 | rules/risk-auto-classification.md |
| 发布前检查 | checklists/pre-release-universal.md |
| 深色与多端 | checklists/multi-platform-dark-mode.md |
| 评审打分 | templates/team-review-scorecard.md |
| 项目接入 | templates/project-onboarding-template.md |
| 功能丰富度 | topics/feature-richness.md |
