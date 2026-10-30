# Framecraft｜逐帧工坊

> 把代码与概念编排成**可渲染的教学演示动画**。基于 Remotion（React → 逐帧视频）。
> 工具 ID：`TOOL-ORG-FRAMECRAFT-001` · 逻辑根：`${TOOLS_ROOT}/framecraft`

## 它解决什么问题

教学里"解释一段代码怎么执行"很难用录屏讲清楚：光标乱跳、观众跟不上执行顺序。Framecraft 用**代码驱动画面**——把每一步写成带时间轴的 React 场景，Remotion 渲染成视频，帧与帧之间的状态完全确定、可复现、可微调重渲。

典型产物：`for` 循环三要素演示、数组遍历对比、`switch` 贯穿行为演示、`enum` 结构可视化。

## 边界（一定要看）

| Framecraft 负责 | Framecraft **不**负责 |
|---|---|
| 公共演示组件（代码框、时间轴、步骤、箭头、缓动） | 具体某个学科的场景内容 |
| 新演示包脚手架与样板 | 视频剪辑与成片（Premiere 工程在课程目录） |
| 渲染与预览脚本 | 课程大纲、讲稿 |
| 演示动画的视觉标准（字体/配色/HUD 风格） | 录制原始素材 |

**它不做任意网页录屏**——这是 Remotion 的机制决定的：画面由 React 组件按帧计算，不是抓屏。

## 目录

```
framecraft/
├─ docs/                     演示动画标准与工作流
│   ├─ ANIMATION_STANDARDS.md          动效规范
│   ├─ REMOTION_ANIMATION_STANDARDS.md Remotion 具体实现规范
│   ├─ REMOTION_QUICKSTART.md          上手
│   ├─ REMOTION_QUICK_REFERENCE.md     API 速查
│   ├─ REMOTION_WORKFLOW.md            工作流
│   ├─ SCIFI_HUD_DESIGN_SYSTEM.md      HUD 视觉体系（当前主视觉）
│   └─ HOW_TO_VIEW.md / QUICK_REFERENCE.md
├─ templates/package/        新演示包样板（tsconfig / remotion.config / styles / 预览.bat）
├─ scripts/                  脚手架与工具脚本（**待修复**，见下）
├─ src/components/           公共组件（当前只有 CodeFrame）
└─ src/theme/                主题（待建）
```

## 怎么用（目标形态）

```powershell
# 在任意工程里新建一个演示
framecraft new --project "<目标工程>" --name "for-loop-demo"

# 预览（Remotion Studio）
pnpm --dir "<目标工程>/demos/for-loop-demo" start

# 渲染
pnpm --dir "<目标工程>/demos/for-loop-demo" build
```

> 这三条命令是**目标形态**，脚本尚未修好（见「已知缺陷」）。修好前请按各包 `预览.bat` 手动执行。

## 与工程的关系：软引用（方案 A）

演示包通过 `file:` 依赖引用 Framecraft 的公共组件，**不复制**：

```json
{ "dependencies": { "@framecraft/components": "file:../../../../../AITools/framecraft" } }
```

- **好处**：公共组件只有一份，升级改一处
- **代价**：Framecraft 升级后，需要回归它所服务的所有演示包
- **判断依据**：Framecraft 的升级频率极低（一次成型），回归成本可接受

## 当前用户

| 工程 | 演示位置 | 状态 |
|---|---|---|
| `TECH-EASYCPP-RESTARTPROJECTA-001` | `<工程>/demos/` | **待并入**（EasyC++ 的 7 个动画包） |

## 已知缺陷（待修，按"先迁移后修复"顺序排在最后）

评估文档 `DEMO_REUSE_ASSESSMENT_v001_20261030.md` 记录的四项静态缺陷，本工具继承：

| # | 缺陷 | 证据 |
|---|---|---|
| 1 | Composition 只有 540 帧，配置写到 750 帧，后段超出合成时长 | `foreach-int-vs-ref-animation/src/Root.tsx:5`、`config.ts:18` |
| 2 | `int&` 分支给所有元素赋 999，与注释 `{1,999,3}` 不符 | `foreach-int-vs-ref-animation/src/config.ts:55` |
| 3 | 脚手架脚本硬编码同步盘路径；`create-new-animation.bat` 有 JSX 闭合问题 | `clean-and-reset.bat:6`、`create-new-animation.bat:18` |
| 4 | `allowBuilds.esbuild` 是文本占位；`engines.node >=16` 而 esbuild 要求 `>=18` | `pnpm-workspace.yaml:6`、根 `package.json` |

**在修好之前，`scripts/` 里的脚本不能直接运行。**

## 从哪里来

2026-10-30 从 `TuringTechLab/课程/C++/EasyC++/Template/Demo/` 拆分而来：

- **通用部分**（文档、样板、代码框、脚本）→ 本工具
- **EasyC++ 专属部分**（7 个动画包）→ 并入 `TECH-EASYCPP-RESTARTPROJECTA-001/demos/`

拆分依据：`DEMO_REUSE_ASSESSMENT_v001_20261030.md`；决策记录待补。
