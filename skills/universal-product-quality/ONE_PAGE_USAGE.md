# Universal Product Quality Skill - 一页式使用说明

## 目标
用最短时间建立“可发布”的统一质量门槛，避免功能单薄、深色模式缺陷、多端破版和提审阻塞。

## 适用范围
- 任意项目: App / Web / 桌面 / 小程序
- 任意技术栈: 前端框架、原生、跨端方案均可

## 三步接入
1. 识别风险等级
- 先看 rules/risk-auto-classification.md
- 判定为 High/Medium/Low

2. 执行质量检查
- 通用发布检查: checklists/pre-release-universal.md
- 深色与多端检查: checklists/multi-platform-dark-mode.md

3. 团队评审与发布决策
- 用 templates/team-review-scorecard.md 打分
- 分数 >= 85 且无阻断项再发布

## 最小发布门槛
1. 功能
- 至少 3 条完整业务链路，且包含异常分支
2. 深色模式
- 核心页面在深色主题可读可操作
3. 多端
- 手机/平板/桌面核心流程均可完成
4. 可复现
- 审核或测试账号可复现关键路径

## 新项目 5 分钟上手
1. 复制 templates/project-onboarding-template.md
2. 填项目信息和 3 条核心链路
3. 跑两份检查清单并记录问题
4. 评审打分，输出发布结论

## 常见失败信号
- 只有页面展示，没有完整功能闭环
- 深色模式按钮/文本对比度不足
- 平板或桌面出现布局重叠、不可点击
- 文案、截图、实际功能不一致

## 你现在可以直接做
1. 先判风险等级
2. 跑两份清单
3. 打分
4. 决策发布
