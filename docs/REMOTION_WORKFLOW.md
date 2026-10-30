# Remotion 编程动画演示创建指南

## 📋 标准工作流程

### 快速开始模板

```bash
# 1. 创建项目
cd your/workspace
mkdir my-animation && cd my-animation

# 2. 创建基础文件结构
mkdir -p src/components src/utils

# 3. 创建 package.json
cat > package.json << 'EOF'
{
  "name": "my-animation",
  "version": "1.0.0",
  "scripts": {
    "start": "remotion studio",
    "build": "remotion render MyAnimation out/video.mp4",
    "render": "remotion render MyAnimation out/video.mp4 --codec h264"
  },
  "dependencies": {
    "@remotion/cli": "^4.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "remotion": "^4.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "typescript": "^5.0.0"
  }
}
EOF

# 4. 安装依赖
npm install
```

---

## 📁 标准项目结构

```
my-animation/
├── src/
│   ├── index.ts                    # Remotion 入口
│   ├── Root.tsx                    # Composition 配置
│   ├── MyAnimation.tsx             # 主动画组件
│   ├── components/                 # 可复用组件
│   │   ├── Title.tsx
│   │   ├── CodeBlock.tsx
│   │   └── AnimatedBox.tsx
│   └── utils/                      # 工具函数
│       ├── animations.ts           # 动画预设
│       └── colors.ts                # 颜色主题
├── package.json
├── tsconfig.json
├── remotion.config.ts
└── README.md
```

---

## 🎨 核心文件模板

### 1. index.ts - Remotion 入口
```typescript
import { registerRoot } from "remotion";
import { RemotionRoot } from "./Root";

registerRoot(RemotionRoot);
```

### 2. Root.tsx - Composition 配置
```typescript
import { Composition } from "remotion";
import { MyAnimation } from "./MyAnimation";

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="MyAnimation"
        component={MyAnimation}
        durationInFrames={180}    // 6秒 @ 30fps
        fps={30}
        width={1920}
        height={1080}
      />
    </>
  );
};
```

### 3. MyAnimation.tsx - 主动画组件
```typescript
import React from "react";
import {
  AbsoluteFill,
  Sequence,
  useCurrentFrame,
  interpolate,
  spring,
} from "remotion";

export const MyAnimation: React.FC = () => {
  const frame = useCurrentFrame();

  return (
    <AbsoluteFill style={{ backgroundColor: "#1E1E1E" }}>
      {/* 你的动画内容 */}
    </AbsoluteFill>
  );
};
```

---

## 🎬 常用动画模式

### 模式 1: 元素淡入淡出
```typescript
const FadeIn: React.FC<{ children: React.ReactNode; startFrame: number }> = ({
  children,
  startFrame
}) => {
  const frame = useCurrentFrame();
  const opacity = interpolate(
    frame,
    [startFrame, startFrame + 30],
    [0, 1],
    { extrapolateRight: "clamp" }
  );

  return (
    <div style={{ opacity }}>
      {children}
    </div>
  );
};
```

### 模式 2: 弹簧动画（掉落效果）
```typescript
const SpringDrop: React.FC<{ startFrame: number; y: number }> = ({
  startFrame,
  y
}) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const progress = spring({
    frame: frame - startFrame,
    fps,
    config: {
      damping: 15,
      stiffness: 100,
      mass: 0.8,
    },
  });

  const animatedY = interpolate(progress, [0, 1], [-400, 0]);

  return (
    <div style={{
      position: "absolute",
      top: y + animatedY,
    }}>
      {/* 内容 */}
    </div>
  );
};
```

### 模式 3: 滑动效果
```typescript
const SlideIn: React.FC<{
  children: React.ReactNode;
  startFrame: number;
  direction: "left" | "right" | "up" | "down";
}> = ({ children, startFrame, direction }) => {
  const frame = useCurrentFrame();

  const translateValue = interpolate(
    frame,
    [startFrame, startFrame + 30],
    [500, 0],
    { extrapolateRight: "clamp" }
  );

  const transform = {
    left: `translateX(-${translateValue}px)`,
    right: `translateX(${translateValue}px)`,
    up: `translateY(${translateValue}px)`,
    down: `translateY(-${translateValue}px)`,
  }[direction];

  return (
    <div style={{ transform }}>
      {children}
    </div>
  );
};
```

### 模式 4: 序列动画（依次出现）
```typescript
const SequenceAnimation: React.FC = () => {
  return (
    <AbsoluteFill>
      {/* 元素 1: 0-30 帧 */}
      <Sequence from={0} durationInFrames={30}>
        <FadeIn startFrame={0}>First Element</FadeIn>
      </Sequence>

      {/* 元素 2: 30-60 帧 */}
      <Sequence from={30} durationInFrames={30}>
        <FadeIn startFrame={30}>Second Element</FadeIn>
      </Sequence>

      {/* 元素 3: 60-90 帧 */}
      <Sequence from={60} durationInFrames={30}>
        <FadeIn startFrame={60}>Third Element</FadeIn>
      </Sequence>
    </AbsoluteFill>
  );
};
```

---

## 🎨 编程教学专用组件

### 1. CodeBlock - 代码展示组件
```typescript
import React from "react";
import { useCurrentFrame, interpolate } from "remotion";

interface CodeBlockProps {
  code: string;
  language: string;
  startFrame: number;
}

export const CodeBlock: React.FC<CodeBlockProps> = ({
  code,
  language,
  startFrame
}) => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [startFrame, startFrame + 20], [0, 1]);

  return (
    <div
      style={{
        backgroundColor: "#1E1E1E",
        border: "2px solid #4EC9B0",
        borderRadius: 10,
        padding: 30,
        fontFamily: "'Consolas', monospace",
        fontSize: 24,
        opacity,
      }}
    >
      <pre style={{ color: "#D4D4D4", margin: 0 }}>
        {code}
      </pre>
    </div>
  );
};
```

### 2. ConceptCard - 概念卡片组件
```typescript
import React from "react";
import { spring, useCurrentFrame, useVideoConfig } from "remotion";

export const ConceptCard: React.FC<{
  title: string;
  description: string;
  icon: string;
  startFrame: number;
}> = ({ title, description, icon, startFrame }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const scale = spring({
    frame: frame - startFrame,
    fps,
    config: { damping: 12, stiffness: 200 },
  });

  return (
    <div
      style={{
        backgroundColor: "#252526",
        borderRadius: 15,
        padding: 40,
        transform: `scale(${scale})`,
      }}
    >
      <div style={{ fontSize: 48 }}>{icon}</div>
      <h3 style={{ color: "#4EC9B0", fontSize: 32 }}>{title}</h3>
      <p style={{ color: "#808080", fontSize: 20 }}>{description}</p>
    </div>
  );
};
```

---

## 🎯 编程教学动画模板

### 模板 1: 概念解释动画
```typescript
// 适用于: 解释编程概念
// 结构: 标题 -> 概念卡片 -> 代码示例 -> 总结

export const ConceptExplainer: React.FC = () => {
  return (
    <AbsoluteFill style={{ backgroundColor: "#1E1E1E" }}>
      {/* 标题 */}
      <Sequence from={0} durationInFrames={60}>
        <Title text="Concept Name" />
      </Sequence>

      {/* 概念卡片 */}
      <Sequence from={30} durationInFrames={90}>
        <ConceptCard
          title="What is it?"
          description="Brief explanation"
          icon="💡"
          startFrame={30}
        />
      </Sequence>

      {/* 代码示例 */}
      <Sequence from={90} durationInFrames={90}>
        <CodeBlock
          code="int x = 10;"
          language="cpp"
          startFrame={90}
        />
      </Sequence>
    </AbsoluteFill>
  );
};
```

### 模板 2: 对比演示动画
```typescript
// 适用于: 对比两个概念 (如 Stack vs Heap)
// 结构: 标题 -> 左侧演示 -> 右侧演示 -> 对比总结

export const ComparisonAnimation: React.FC = () => {
  return (
    <AbsoluteFill style={{ backgroundColor: "#1E1E1E" }}>
      {/* 左侧 */}
      <div style={{ position: "absolute", left: 100, top: 200 }}>
        <Sequence from={0} durationInFrames={180}>
          <Concept1Animation />
        </Sequence>
      </div>

      {/* 右侧 */}
      <div style={{ position: "absolute", right: 100, top: 200 }}>
        <Sequence from={60} durationInFrames={120}>
          <Concept2Animation />
        </Sequence>
      </div>

      {/* 中间 VS */}
      <Sequence from={30} durationInFrames={150}>
        <div style={{
          position: "absolute",
          left: "50%",
          top: 300,
          transform: "translateX(-50%)",
          fontSize: 60,
          color: "#808080",
        }}>
          VS
        </div>
      </Sequence>
    </AbsoluteFill>
  );
};
```

---

## 🛠️ 常用工具函数

### animations.ts - 动画预设
```typescript
import { spring, useCurrentFrame, useVideoConfig } from "remotion";

// 弹簧预设配置
export const SPRING_CONFIGS = {
  gentle: { damping: 20, stiffness: 100, mass: 1 },
  snappy: { damping: 15, stiffness: 200, mass: 0.8 },
  bouncy: { damping: 10, stiffness: 150, mass: 0.6 },
};

// 获取弹簧动画值
export const useSpringValue = (
  startFrame: number,
  config: keyof typeof SPRING_CONFIGS = "gentle"
) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return spring({
    frame: frame - startFrame,
    fps,
    config: SPRING_CONFIGS[config],
  });
};
```

### colors.ts - 颜色主题
```typescript
// VS Code Dark+ 主题
export const COLORS_VSCODE = {
  background: "#1E1E1E",
  text: "#D4D4D4",
  textMuted: "#808080",
  keyword: "#569CD6",
  string: "#CE9178",
  number: "#B5CEA8",
  comment: "#6A9955",
  function: "#DCDCAA",
  variable: "#9CDCFE",
  type: "#4EC9B0",
};

// 常用编程教学颜色
export const TEACHING_COLORS = {
  stack: "#4EC9B0",     // 青色 - Stack
  heap: "#DCDCAA",      // 黄色 - Heap
  pointer: "#C586C0",   // 紫色 - 指针
  memory: "#569CD6",    // 蓝色 - 内存
};
```

---

## 📊 标准时间轴规划

### 6秒动画 (180 frames @ 30fps)
```
帧 0-30   (0-1秒)   : 标题淡入
帧 30-60  (1-2秒)   : 概念卡片出现
帧 60-120 (2-4秒)   : 核心动画演示
帧 120-150 (4-5秒)  : 代码示例
帧 150-180 (5-6秒)  : 总结/说明
```

### 10秒动画 (300 frames @ 30fps)
```
帧 0-40   (0-1.3秒) : 标题淡入
帧 40-80  (1.3-2.6秒): 概念介绍
帧 80-200 (2.6-6.6秒): 详细动画演示
帧 200-260 (6.6-8.6秒): 代码示例
帧 260-300 (8.6-10秒): 总结
```

---

## 🚀 开发工作流程

### 1. 本地开发
```bash
# 启动 Remotion Studio
npm start

# 浏览器打开 http://localhost:3001
# 实时预览，修改代码自动更新
```

### 2. 测试渲染
```bash
# 渲染预览版本（低分辨率）
npx remotion render MyAnimation preview.mp4 --quality low

# 渲染特定帧范围
npx remotion render MyAnimation test.mp4 --frames 0-60
```

### 3. 最终渲染
```bash
# 渲染完整视频
npm run build

# 或自定义参数
npx remotion render MyAnimation output.mp4 \
  --codec h264 \
  --quality high \
  --frames 0-300
```

---

## 📦 导出选项

### MP4 (推荐)
```bash
npm run build
# 输出: out/video.mp4
```

### WebM (透明背景)
```bash
npx remotion render MyAnimation output.webm --transparent
```

### GIF
```bash
npx remotion render MyAnimation output.gif --codec gif
```

### 图片序列
```bash
npx remotion render MyAnimation frames/ --frames 0-180
```

---

## ✅ 最佳实践清单

### 设计原则
- ✅ 单一概念一个视频（聚焦）
- ✅ 动画节奏清晰（不要太快）
- ✅ 文字说明简洁（不超过 20 字）
- ✅ 代码示例真实可运行
- ✅ 视觉风格统一（使用主题色）

### 技术规范
- ✅ 使用 TypeScript 类型安全
- ✅ 组件复用（创建 components/）
- ✅ 使用 Sequence 管理时间轴
- ✅ 使用 spring 创建自然动画
- ✅ 使用 interpolate 控制数值变化

### 性能优化
- ✅ 避免过度复杂的动画
- ✅ 使用 Sequence 而非条件渲染
- ✅ 预渲染静态元素
- ✅ 测试渲染使用低质量

---

## 🎯 常见用例

### 1. 数据结构动画
- 数组操作可视化
- 链表遍历过程
- 树结构递归演示
- 图的 BFS/DFS

### 2. 算法演示
- 排序算法动画
- 搜索过程可视化
- 递归调用栈
- 动态规划过程

### 3. 内存管理
- Stack vs Heap
- 指针操作
- 内存分配/释放
- 值类型 vs 引用类型

### 4. 并发概念
- 线程同步
- 死锁演示
- 生产者消费者
- 异步流程

---

## 🔗 快速启动命令

### 创建新项目
```bash
# 一键创建
mkdir my-animation && cd my-animation && \
echo '{"name":"my-animation","scripts":{"start":"remotion studio","build":"remotion render MyAnimation out/video.mp4"},"dependencies":{"@remotion/cli":"^4.0.0","react":"^18.2.0","remotion":"^4.0.0"}}' > package.json && \
npm install
```

### 快速复制模板
```bash
# 复制现有项目作为模板
cp -r existing-animation new-animation
cd new-animation
# 修改 package.json 中的 name
# 修改动画组件
npm install
npm start
```

---

## 📚 参考资源

- [Remotion 官方文档](https://remotion.dev/docs)
- [动画示例库](https://remotion.dev/showcase)
- [Spring 动画参数](https://remotion.dev/docs/spring)
- [Interpolate 函数](https://remotion.dev/docs/interpolate)
- [Sequence 组件](https://remotion.dev/docs/sequence)

---

**最后更新**: 2026-07-19  
**版本**: 1.0  
**作者**: EasyC++ 项目组