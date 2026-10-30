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

## 缺陷修复记录（2026-10-31）

四项静态缺陷已全部修复，来源 `DEMO_REUSE_ASSESSMENT_v001_20261030.md`：

| # | 缺陷 | 修复方式 | 状态 |
|---|---|---|---|
| 1 | Composition 540 帧 vs 配置 750 帧 | `Root.tsx` 改为 `const TOTAL_DURATION = STAGES[STAGES.length-1].end`，帧数从配置推导，不再两处手写 | ✅ |
| 2 | `int&` 分支注释 `{1,999,3}` 与实际不符 | 循环内 `item = 999` 会赋值**每个**元素，注释改为 `{999, 999, 999}` | ✅ |
| 3 | 脚手架脚本硬编码同步盘路径、JSX 闭合问题 | `create-new-animation.bat` 与 `clean-and-reset.bat` 全部重写：参数化、运行时解析 `TOOLS_ROOT`、不删锁文件、二次确认 | ✅ |
| 4 | `allowBuilds` 占位 + Node 版本 + 子包旧 npm 锁 | 旧 Demo 根已删除（占位随之消失）；Framecraft 与 demos 的 `engines.node` 均 `>=18`；7 个子包的 `package-lock.json` 已清除，统一用 pnpm | ✅ |

**旧脚本备份**：`E:\_sync-quarantine\20261030\framecraft-scripts-before\`

### 现在可以用了

```powershell
# 新建演示包（参数化，不再依赖脚本内的固定路径）
.\scripts\create-new-animation.bat "<工程目录>" <包名>

# 重置依赖（删 node_modules 后重装，保留 pnpm-lock.yaml）
.\scripts\clean-and-reset.bat "<工程>/demos" -y
```
