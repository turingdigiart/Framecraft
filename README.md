# Framecraft｜逐帧工坊

> 把代码与概念编排成**可渲染的教学演示动画**。基于 Remotion（React → 逐帧视频）。
> `TOOL-ORG-FRAMECRAFT-001` · 逻辑根 `${TOOLS_ROOT}/framecraft`
> 远端：`github.com/turingdigiart/Framecraft`

## 它解决什么问题

讲"这段代码怎么执行"很难用录屏说清：光标乱跳、观众跟不上。Framecraft 用**代码驱动画面**——每一步写成带时间轴的 React 场景，帧与帧之间状态完全确定，可复现、可微调、可重渲。

典型产物：`for` 循环三要素、数组遍历对比、`switch` 贯穿、`enum` 结构可视化。

## 边界（重要）

| 负责 | **不**负责 |
|---|---|
| 公共演示组件（代码框、时间轴、步骤、箭头、缓动） | 具体学科的讲解内容 |
| 新演示包脚手架与样板 | 视频剪辑与成片（Premiere 工程在课程目录） |
| 渲染与预览脚本 | 课程大纲、讲稿 |
| 演示动画的视觉标准（字体/配色/HUD） | 任意网页录屏 |

**不做任意网页录屏**——Remotion 是按帧计算画面，不是抓屏。这是机制决定的，不是没做。

## 快速开始

```powershell
# 1. 新建演示包（在目标工程的 demos/ 下）
.\scripts\create-new-animation.bat "<工程目录>" <包名>

# 2. 链接依赖（在工程的 demos/ 下）
powershell -File .\link-framecraft.ps1

# 3. 装依赖并预览
pnpm install
pnpm --dir "<包名>" start

# 4. 渲染
pnpm --dir "<包名>" build

# 重置某个工程的全部演示依赖
.\scripts\clean-and-reset.bat "<工程>/demos" -y
```

## 目录

```
framecraft/
├─ docs/                    演示动画标准与工作流
│   ├─ ANIMATION_STANDARDS.md
│   ├─ REMOTION_ANIMATION_STANDARDS.md
│   ├─ REMOTION_QUICKSTART.md / _QUICK_REFERENCE.md / REMOTION_WORKFLOW.md
│   ├─ SCIFI_HUD_DESIGN_SYSTEM.md
│   └─ TECH_STACK_COMPARISON.md
├─ templates/package/       新演示包样板（tsconfig / remotion.config / styles / 预览.bat）
├─ src/components/          公共组件（当前：CodeFrame）
├─ scripts/                 脚手架与维护脚本
└─ package.json             包名 @framecraft/components
```

## 与工程的关系：软引用（方案 A）

演示包通过 `file:` 依赖引用本工具的公共组件，**不复制**：

```json
{ "dependencies": { "@framecraft/components": "file:../../../../AITools/framecraft" } }
```

该路径由各工程 `demos/link-framecraft.ps1` 在安装前**按本机位置生成**，`package.json` 不含盘符。

- **好处**：公共组件只有一份，升级改一处
- **代价**：Framecraft 升级后需回归所有演示包
- **取舍**：升级频率极低，回归成本可接受

## 当前用户

| 工程 | 演示目录 | 数量 |
|---|---|---:|
| `TECH-EASYCPP-RESTARTPROJECTA-001` | `<工程>/demos/` | 7 |

## 校验状态（2026-10-31）

| 项 | 结果 |
|---|---|
| `pnpm install` | 通过（10,896 文件，remotion/react/typescript 就位） |
| `tsc --noEmit`（7 个包） | **7/7 通过** |
| 实际渲染 | 未验证（待 `pnpm approve-builds` 放行 esbuild 后跑 `remotion compositions`） |

已修的四项历史缺陷（来源 `DEMO_REUSE_ASSESSMENT_v001_20261030.md`）：

| # | 缺陷 | 修法 |
|---|---|---|
| 1 | Composition 帧数与配置不一致 | `durationInFrames` 从 `STAGES` 推导 |
| 2 | `int&` 注释与代码语义不符 | 注释改为 `{999, 999, 999}` |
| 3 | 脚本硬编码同步盘路径 | 重写为参数化 + 运行时解析 `TOOLS_ROOT` |
| 4 | Node/锁策略不一致 | `engines >= 18`；清掉 7 个子包的 npm 锁；`onlyBuiltDependencies: esbuild` |

另修 9 处类型错误（经典 JSX 运行时 → `react-jsx`、`COL.default` → `textDefault`、颜色字面量收窄、`extrapolateRight: "loop"` 非法等）。

## 相关

- 技能：`remotion-demo-director`（`CAP-ORG-DEMO-ANIM-001`）
- 首个用户工程：`TECH-EASYCPP-RESTARTPROJECTA-001`
- 工程总览：`RestArtEducation/项目管理/TURING_ENGINEERING_OVERVIEW_v003_20261030.md`