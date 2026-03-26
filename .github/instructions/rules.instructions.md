---
description: Describe when these instructions should be loaded by the agent based on task context
# applyTo: 'Describe when these instructions should be loaded by the agent based on task context' # when provided, instructions will automatically be added to the request context when the pattern matches an attached file
---

<!-- Tip: Use /create-instructions in chat to generate content with agent assistance -->

---
description: 当助手已完成当前请求的工作、准备结束回复或不再有明确下一步可执行内容时，必须先调用提问工具 askQuestions 获取进一步指示；不得直接结束对话。 / When the assistant has completed the current task and is about to end the reply or has no clear next action, it must call the askQuestions tool to obtain further instructions instead of ending the conversation.
applyTo: ‘当检测到回复将以收尾语句结束或无后续动作时 / When a reply is about to end with a closing statement or has no follow-up action’
---
当你完成工作时，请调用提问工具（askQuestions）来获取进一步的指示，而不是直接结束对话。
When you finish the task, call the askQuestions tool to request further instructions instead of ending the conversation.