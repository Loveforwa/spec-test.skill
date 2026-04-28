# spec-driven-test

> A Claude skill that helps small teams and individual developers run rigorous end-to-end tests on web applications, using a specification-based testing methodology.
>
> 一个 Claude skill,帮助小团队和个人开发者用规约驱动测试(specification-based testing)的方法对 web 应用做严谨的端到端(E2E)测试。

---

## English

### What this skill does

`spec-driven-test` turns "write some E2E tests" into a disciplined three-stage workflow run by three cooperating Claude agents, with two human review gates in the middle:

1. **Cartographer** reads your code and produces a written **spec** of the feature under test, then translates that spec into concrete **test cases**.
2. **Inspector** reviews those test cases against established testing methodologies (boundary value analysis, equivalence partitioning, decision tables, state transition, use case testing, Right-BICEP) and a checklist of common scenario patterns, returning P0 / P1 / P2 graded feedback.
3. **Operator** drives a real browser (Playwright or Claude in Chrome) to execute every test case and produce an evidence-backed execution report with screenshots.

Two human review checkpoints (one after the spec, one after the test cases) keep a person in the loop on the things that matter — *is the spec actually right?* and *are these the tests we want to run?* — without making humans do the busywork.

### Why it exists

E2E testing is the layer most often skipped by small teams and individual developers because writing good tests by hand is slow, and "vibe-coded" tests miss the unhappy paths. This skill is designed to give a single developer the rigor of a dedicated QA process: structured specs, methodology-driven test design, real-browser execution, and a reproducible report — without needing a separate QA team.

### How it works

You point the skill at a feature ("test the login flow", "test the chat message rendering"). From there, the skill drives a 7-step workflow with **two human review checkpoints** built in:

```
   You: "test feature X"
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 1. Cartographer · Phase 0                  │  Confirm scope, gather optional info
   │    Confirm test scope                      │  (ground truth, UI screenshots,
   │                                            │   Operator's tool capabilities)
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 2. Cartographer · Phase 1                  │  Reads code → writes a structured
   │    Code → Spec                             │  spec doc; tags matching scenario
   │                                            │  patterns
   └────────────────────────────────────────────┘
        │
        ▼
   ╔════════════════════════════════════════════╗
   ║  HUMAN REVIEW #1 — Is the spec correct?    ║  You read the spec, fix anything
   ╚════════════════════════════════════════════╝  the agent misread
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 3. Cartographer · Phase 2 (+ 2.5)          │  Spec → concrete test cases with
   │    Spec → Test Cases                       │  steps, expected results, screenshot
   │                                            │  checkpoints; fills self-check tables
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 4. Inspector                               │  Reviews test cases against testing
   │    Methodology-based review                │  methodologies and scenario patterns;
   │                                            │  returns P0 / P1 / P2 graded feedback
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 5. Cartographer · Phase 3                  │  Decides per-feedback: accept &
   │    Respond to feedback                     │  modify, or reject with rationale
   └────────────────────────────────────────────┘
        │
        ▼
   ╔════════════════════════════════════════════╗
   ║  HUMAN REVIEW #2 — Are these the tests     ║  You read the final test cases,
   ║  we want to run?                           ║  greenlight execution
   ╚════════════════════════════════════════════╝
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 6. Operator                                │  Drives a real browser (Playwright
   │    Execute in a real browser               │  / Claude in Chrome) — runs every
   │                                            │  test case, captures screenshots
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 7. Execution report                        │  Pass / fail per case, with
   │                                            │  screenshot evidence and root-cause
   │                                            │  notes for any failures
   └────────────────────────────────────────────┘
```

**The three agents and their boundaries:**

| Agent | Role | Sees | Does NOT see |
|---|---|---|---|
| **Cartographer** | Map maker | Code + spec + test cases + Inspector feedback | (no restriction) |
| **Inspector** | Reviewer | Spec + test cases + methodologies | **Code** — keeps review honest |
| **Operator** | Real user simulator | Test cases + actual browser state | **Spec design intent** — and may not take API/SQL shortcuts for the trigger action; must drive the UI like a real user |

**Hybrid execution (Operator):** for each test case, Cartographer marks one of three modes — **Playwright** (data flow / regression), **LLM-driven browser** (visual / UX), or **Hybrid** (Playwright runs the flow + saves screenshots at key checkpoints, LLM judges the screenshots). Most chatbot / CRUD / dashboard tests end up Hybrid.

**What you (the human) actually do:** trigger the workflow, then review the spec at gate #1 and the test cases at gate #2. The agents handle code reading, spec writing, methodology selection, test design, browser driving, and report generation.

**What you get out:** a spec document, a test case document, and an execution report (with screenshots) — all in markdown, all version-controllable, all rerunnable.

### Two language editions

This repository ships the skill in two editions. They are content-equivalent — pick whichever language your team works in.

| Edition | Path | Use when |
|---|---|---|
| **Chinese (中文)** | [`zh/`](./zh) | Your team writes specs and reviews in Chinese, or your codebase comments are mostly Chinese. |
| **English** | [`en/`](./en) | Your team works in English, or you want to share the skill with international collaborators. |

Each edition contains the full skill: `SKILL.md`, `references/` (the agent rulebooks, methodology references, and scenario patterns), `templates/`, and `examples/`.

### How to install

**Option 1 — Download the prebuilt `.skill` bundle (easiest):**

Grab the latest release and drag the `.skill` file into Cowork's skill installer (or unzip into your `~/.claude/skills/` directory):

- 🇬🇧 English edition: [`spec-driven-test-en.skill`](https://github.com/Loveforwa/spec-driven-test/releases/latest/download/spec-driven-test-en.skill)
- 🇨🇳 Chinese edition: [`spec-driven-test-zh.skill`](https://github.com/Loveforwa/spec-driven-test/releases/latest/download/spec-driven-test-zh.skill)
- Or browse all releases: [Releases page](https://github.com/Loveforwa/spec-driven-test/releases)

**Option 2 — Clone the repo and copy the folder:**

```sh
git clone https://github.com/Loveforwa/spec-driven-test.git
cp -r spec-driven-test/en /path/to/your/skills/spec-driven-test
```

**Option 3 — Build the `.skill` bundle yourself:**

```sh
git clone https://github.com/Loveforwa/spec-driven-test.git
cd spec-driven-test
./scripts/build-skills.sh        # produces dist/spec-driven-test-{zh,en}.skill
```

### Contributing — feedback and improvements are very welcome

This skill is a living document. **If you have a reasonable suggestion, we will adopt it.** That includes — but is not limited to:

- Bugs you hit while running the workflow on a real project
- Wording that is unclear, ambiguous, or wrong
- Missing scenario patterns (e.g. you tested a feature whose pattern wasn't covered)
- Methodology references that are inaccurate or could be clearer
- Translation issues in either edition (English ↔ Chinese parity)
- New examples drawn from real projects
- Improvements to the templates

**How to contribute:**

- **Report a usage issue or bug**: open a GitHub Issue. Tell us what you were testing, which agent you were running, what happened, and what you expected. Logs or transcript snippets help a lot.
- **Suggest an improvement**: open an Issue with the `enhancement` label, or open a Pull Request directly.
- **Submit a translation fix**: PRs welcome — please update *both* `zh/` and `en/` so the two editions stay in sync.
- **Add a real-world example**: PRs welcome under `zh/examples/` and `en/examples/`.

We're a small project. Reasonable feedback and PRs from anyone are appreciated and will be taken seriously.

### License & questions

If you have a usage question that isn't a bug, please still open an Issue — odds are someone else has the same question.

---

## 中文

### 这个 skill 是做什么的

`spec-driven-test` 把"写点 E2E 测试"这件事拆成一套严谨的三阶段流程,由三个 Claude agent 协作完成,中间还有两道人类 review 把关:

1. **Cartographer(制图师)** 读你的代码,产出被测功能的**规约**(spec),再把规约翻译成具体的**测试用例**。
2. **Inspector(检查员)** 用一套测试方法论(边界值分析、等价类划分、决策表、状态迁移、用例测试、Right-BICEP)和场景模式清单审查测试用例,输出 P0 / P1 / P2 分级反馈。
3. **Operator(执行员)** 在真实浏览器里(Playwright 或 Claude in Chrome)跑每一条测试用例,产出附带截图证据的执行报告。

两道人类 review(一道在规约后,一道在用例后)把"规约是不是对的"和"这些用例是不是我们想要的"这种关键判断留给人,但所有繁琐工作都交给 agent 做。

### 为什么要有这个 skill

E2E 测试是小团队和个人开发者最容易跳过的一层——手写好测试太慢,"凭感觉测一下"又会漏掉异常路径。这个 skill 想让一个独立开发者也能享有一个完整 QA 流程的严谨度:结构化规约、方法论驱动的用例设计、真实浏览器执行、可复现的报告——而不需要专门搭一支 QA 团队。

### 工作流程

你让 skill 测一个功能(比如"测一下登录流程"、"测一下聊天消息渲染"),它就把整个测试流程拆成 7 个阶段,中间嵌入**两道人类 review**:

```
   你: "测一下功能 X"
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 1. Cartographer · 阶段 0                    │  确认测试范围,收集可选信息
   │    确认测试范围                              │  (ground truth、UI 截图、
   │                                            │   Operator 工具能力)
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 2. Cartographer · 阶段 1                    │  读代码 → 写出结构化规约文档,
   │    代码 → 规约                              │  并标注匹配的"场景模式"
   └────────────────────────────────────────────┘
        │
        ▼
   ╔════════════════════════════════════════════╗
   ║  人类 Review #1 —— 规约写得对不对?          ║  你看一眼规约,把 agent 读
   ╚════════════════════════════════════════════╝  错的地方改回来
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 3. Cartographer · 阶段 2(+ 2.5)            │  规约 → 具体测试用例(步骤、
   │    规约 → 测试用例                          │  期望结果、截图节点);填场景
   │                                            │  模式自检表
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 4. Inspector                               │  用测试方法论 + 场景模式审查
   │    方法论审查                               │  用例,输出 P0 / P1 / P2 分级
   │                                            │  反馈
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 5. Cartographer · 阶段 3                    │  对每条反馈:接受 & 修改,
   │    回应反馈                                 │  或拒绝并写明 rationale
   └────────────────────────────────────────────┘
        │
        ▼
   ╔════════════════════════════════════════════╗
   ║  人类 Review #2 —— 这是我们想跑的用例吗?    ║  你看一眼最终用例,确认放
   ╚════════════════════════════════════════════╝  行执行
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 6. Operator                                │  在真实浏览器里(Playwright /
   │    真实浏览器执行                            │  Claude in Chrome)跑每一条
   │                                            │  用例,留截图证据
   └────────────────────────────────────────────┘
        │
        ▼
   ┌────────────────────────────────────────────┐
   │ 7. 执行报告                                 │  每条用例的通过/失败结果,
   │                                            │  附截图证据,失败的附根因分析
   └────────────────────────────────────────────┘
```

**三个 agent 的边界:**

| Agent | 角色 | 看什么 | 不看什么 |
|---|---|---|---|
| **Cartographer** | 制图师 | 代码 + 规约 + 用例 + Inspector 反馈 | (无限制) |
| **Inspector** | 检查员 | 规约 + 用例 + 方法论 | **不看代码**——保持审查独立性 |
| **Operator** | 执行员(模拟真实用户) | 用例 + 浏览器实际状态 | **不看规约设计意图**;trigger(被测功能的触发动作)**必须**走 UI,不允许走 API/SQL 捷径,否则 E2E 测试退化为 API 测试 |

**Operator 混合执行模式**:Cartographer 在阶段 2 给每个用例标一个执行模式——**Playwright**(数据流 / 回归)、**LLM 驱动浏览器**(视觉 / UX)或**混合**(Playwright 跑流程 + 关键节点截图,LLM 后处理判断截图)。多数 chatbot / CRUD / 个人主页类测试都是混合模式。

**你(人类)实际做的事**:发起测试请求,然后在两道 review 阶段看一眼规约和用例。其余的——读代码、写规约、选方法论、设计用例、操作浏览器、出报告——都是 agent 干。

**你拿到的产出**:规约文档、测试用例文档、执行报告(带截图)——全是 markdown,可以提交进 git,可以重跑。

### 两个语言版本

这个仓库提供中英两个内容等价的版本,按你团队的工作语言选一个就行。

| 版本 | 路径 | 适用场景 |
|---|---|---|
| **中文** | [`zh/`](./zh) | 团队用中文写规约和评审,或代码注释多数是中文。 |
| **English** | [`en/`](./en) | 团队用英文工作,或者要把 skill 分享给国际协作者。 |

每个版本都是完整 skill:`SKILL.md`、`references/`(三个 agent 各自的规则手册、方法论、场景模式参考)、`templates/`、`examples/`。

### 怎么安装

**方式 1 —— 下载打包好的 `.skill`(最简单)**

去最新 release 下载,把 `.skill` 文件拖进 Cowork 的 skill 安装界面(或解压到 `~/.claude/skills/`):

- 🇨🇳 中文版: [`spec-driven-test-zh.skill`](https://github.com/Loveforwa/spec-driven-test/releases/latest/download/spec-driven-test-zh.skill)
- 🇬🇧 英文版: [`spec-driven-test-en.skill`](https://github.com/Loveforwa/spec-driven-test/releases/latest/download/spec-driven-test-en.skill)
- 或者看所有版本:[Releases 页面](https://github.com/Loveforwa/spec-driven-test/releases)

**方式 2 —— 克隆仓库后复制目录**

```sh
git clone https://github.com/Loveforwa/spec-driven-test.git
cp -r spec-driven-test/zh /path/to/your/skills/spec-driven-test
```

**方式 3 —— 自己打包 `.skill`**

```sh
git clone https://github.com/Loveforwa/spec-driven-test.git
cd spec-driven-test
./scripts/build-skills.sh        # 生成 dist/spec-driven-test-{zh,en}.skill
```

### 贡献 —— 任何合理意见都会采纳

这个 skill 是活文档。**只要是合理的反馈和建议,我们都会认真考虑并采纳。** 包括但不限于:

- 你在真实项目里跑这套流程时踩到的 bug
- 表述不清楚、有歧义或者直接写错的地方
- 缺失的场景模式(比如你测了某个功能,发现现有模式没覆盖到)
- 方法论参考有不准确或可以更清晰的地方
- 中英两个版本之间的翻译不一致
- 来自真实项目的新示例
- 模板的改进建议

**怎么贡献:**

- **反馈使用问题或 bug**:提 GitHub Issue。告诉我们你在测什么、当时跑的是哪个 agent、发生了什么、你期望发生什么。能附日志或对话片段最好。
- **提改进建议**:开一个 Issue 标 `enhancement`,或者直接发 Pull Request。
- **修翻译**:欢迎 PR——请同时改 `zh/` 和 `en/`,保持两个版本同步。
- **加真实案例**:欢迎 PR 到 `zh/examples/` 和 `en/examples/`。

这是个小项目。来自任何人的合理反馈和 PR 都会被认真对待。

### 用法问题

如果你有使用上的疑问,不是 bug,也请开 Issue——大概率别人也有同样的问题。
