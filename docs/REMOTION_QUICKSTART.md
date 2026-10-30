# Remotion 动画快速开始指南

## 🚀 5分钟创建新的课程动画

### 步骤 1: 复制标准模板

```bash
# 复制 for-loop-animation 作为起点
cp -r Template/Demo/for-loop-animation Template/Demo/your-new-animation

# 进入新目录
cd Template/Demo/your-new-animation
```

### 步骤 2: 修改项目配置

```typescript
// 编辑 src/Root.tsx
import { Composition } from "remotion";
import { YourNewDemo } from "./YourNewDemo";

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="YourNewDemo"
        component={YourNewDemo}
        durationInFrames={300}  // 根据需要调整
        fps={30}
        width={1920}
        height={1080}
        defaultProps={{}}
      />
    </>
  );
};
```

### 步骤 3: 创建动画组件

```typescript
// 创建 src/YourNewDemo.tsx
import { AbsoluteFill, useCurrentFrame, useVideoConfig, interpolate, spring } from 'remotion';
import { COLORS_V2 } from './styles-v2';

export const YourNewDemo: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // 📐 设置时间轴
  const startFrame = 30;
  const actionStartFrame = 60;
  const endFrame = 240;

  return (
    <AbsoluteFill style={{
      background: `linear-gradient(
        to bottom,
        ${COLORS_V2.background.top} 0%,
        ${COLORS_V2.background.middle} 40%,
        ${COLORS_V2.background.bottom} 100%
      )`,
      padding: '60px',
      display: 'flex',
      flexDirection: 'column',
    }}>
      {/* 你的动画内容 */}
      <div style={{
        color: COLORS_V2.text.primary,
        fontSize: '48px',
        textAlign: 'center',
      }}>
        你的课程动画内容
      </div>
    </AbsoluteFill>
  );
};
```

### 步骤 4: 选择动画模式

根据你的教学内容选择模式:

#### 模式 A: 线性遍历 (搜索-处理-收集)
```typescript
// 参考 ForLoopDemo.tsx
const currentSearchIndex = Math.floor((frame - searchStartFrame) / frameDelay);
const isSearching = frame >= searchStartFrame && frame < searchEndFrame;
const isGathering = frame >= gatherStartFrame && frame < gatherEndFrame;
```

#### 模式 B: 下落-堆叠
```typescript
// 参考 StackHeapAnimation.tsx
const dropProgress = spring({
  frame: frame - startFrame,
  fps,
  config: { damping: 15, stiffness: 100, mass: 0.8 }
});
const y = interpolate(dropProgress, [0, 1], [-400, 0]);
```

#### 模式 C: 递归可视化
```typescript
// 调用栈 + 缩进
const callStack = [
  { function: 'fib', params: [5], depth: 0, status: 'calling' },
  { function: 'fib', params: [4], depth: 1, status: 'calling' },
  // ...
];
```

### 步骤 5: 应用标准颜色和时序

```typescript
// 使用官方颜色
COLORS_V2.status.scanning  // '#4ec9b0' - 进行中
COLORS_V2.status.matched   // '#f1c40f' - 已完成
COLORS_V2.status.warning   // '#e74c3c' - 警告

// 标准时序
const frameDelay = 12;      // 0.4秒 - 快速迭代
const pauseDuration = 30;  // 1秒 - 标准暂停
const fadeDuration = 20;   // 0.67秒 - 淡入淡出
```

### 步骤 6: 测试和调整

```bash
# 启动开发服务器
npm start

# 在浏览器中查看
# http://localhost:3000
```

### 步骤 7: 渲染最终视频

```bash
# 渲染视频
npm run build

# 视频输出位置
# out/your-new-animation.mp4
```

---

## 📋 快速检查清单

创建新动画前，确保:

- [ ] 已复制 `for-loop-animation` 或 `stack-heap-animation` 作为模板
- [ ] `styles-v2.ts` 文件存在且导入 `COLORS_V2`
- [ ] 使用官方背景渐变: `#000000` → `#1a1a1a` → `#2d2d30`
- [ ] Spring 配置使用标准参数
- [ ] 时序使用标准值: 12帧(快速), 30帧(标准), 45帧(重要)
- [ ] 颜色使用标准色板: 青色(#4ec9b0), 黄色(#f1c40f), 红色(#e74c3c)
- [ ] 已测试动画在 Remotion Preview 中的效果
- [ ] 已调整 fps=30 和分辨率 1920x1080

---

## 🎯 常见问题快速解决

### Q: 动画太慢怎么办?
```typescript
// 减少帧延迟
const frameDelay = 12;  // 改为 8 或 6

// 使用更快的 spring 配置
config: { damping: 200, stiffness: 180, mass: 0.6 }
```

### Q: 动画太生硬怎么办?
```typescript
// 使用 spring 而不是 interpolate
const smooth = spring({...});
const value = interpolate(smooth, [0, 1], [start, end]);

// 添加弹性效果
const scale = interpolate(progress, [0, 0.6, 1], [0.8, 1.05, 1]);
```

### Q: 如何添加代码高亮?
```typescript
// 使用 CodeFrameV2
import { CodeFrameV2 } from './CodeFrameV2';

<CodeFrameV2
  filename="demo.cpp"
  lines={[
    {
      text: 'for (int idx = 0; idx < 10; idx++) {',
      keywords: ['for', 'int', 'idx'],
      highlight: isWarning ? ['idx'] : []  // 条件高亮
    }
  ]}
/>
```

### Q: 如何添加多个阶段?
```typescript
// 阶段时间轴
const phase1Start = 30;
const phase2Start = 90;
const phase3Start = 180;

const isPhase1 = frame >= phase1Start && frame < phase2Start;
const isPhase2 = frame >= phase2Start && frame < phase3Start;
const isPhase3 = frame >= phase3Start;

// 在渲染中使用
if (isPhase1) {
  // 阶段1逻辑
} else if (isPhase2) {
  // 阶段2逻辑
} else if (isPhase3) {
  // 阶段3逻辑
}
```

---

## 🔧 自定义配置

### 修改视频规格
```typescript
// src/Root.tsx
<Composition
  id="YourDemo"
  component={YourDemo}
  durationInFrames={300}  // 总时长
  fps={30}               // 帧率 (建议保持 30)
  width={1920}            // 分辨率宽度 (建议保持 1920)
  height={1080}           // 分辨率高度 (建议保持 1080)
/>
```

### 修改输出格式
```typescript
// remotion.config.ts
import { Config } from "@remotion/cli/config";

Config.setVideoImageFormat("jpeg");
Config.setOverwriteOutput(true);
```

---

## 📚 进阶技巧

### 技巧 1: 复用动画组件
```typescript
// 创建可复用的组件
const AnimatedBox: React.FC<{
  value: number;
  delay: number;
  status: 'default' | 'active' | 'done';
}> = ({ value, delay, status }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  
  const progress = spring({
    frame: frame - delay,
    fps,
    config: { damping: 15, stiffness: 100, mass: 1 }
  });
  
  const scale = interpolate(progress, [0, 0.6, 1], [0, 1.05, 1]);
  const opacity = interpolate(progress, [0, 0.3], [0, 1]);
  
  return (
    <div style={{
      transform: `scale(${scale})`,
      opacity,
      backgroundColor: status === 'active' ? '#4ec9b0' : '#2d2d30',
      // ...
    }}>
      {value}
    </div>
  );
};
```

### 技巧 2: 条件渲染优化
```typescript
// 只在需要时渲染复杂组件
{frame > threshold && (
  <ExpensiveComponent />
)}

// 而不是
<div style={{ opacity: frame > threshold ? 1 : 0 }}>
  <ExpensiveComponent />
</div>
```

### 技巧 3: 使用 Sequence 组织复杂动画
```typescript
import { Sequence } from 'remotion';

<Sequence from={0} durationInFrames={90}>
  <Phase1Component />
</Sequence>

<Sequence from={90} durationInFrames={90}>
  <Phase2Component />
</Sequence>

<Sequence from={180} durationInFrames={120}>
  <Phase3Component />
</Sequence>
```

---

## 🎓 学习资源

### 项目内资源
- `REMOTION_ANIMATION_STANDARDS.md` - 完整动画标准
- `REMOTION_QUICK_REFERENCE.md` - 快速参考手册
- `REMOTION_ALGORITHM_SPECIALIZATION.md` - 算法特化指南
- `for-loop-animation/src/ForLoopDemo.tsx` - 标准实现参考
- `stack-heap-animation/src/StackHeapAnimation.tsx` - 堆栈动画参考

### 官方文档
- [Remotion 官方文档](https://www.remotion.dev/docs)
- [Spring 动画原理](https://www.remotion.dev/docs/spring)
- [Interpolate 参考](https://www.remotion.dev/docs/interpolate)
- [Composition 指南](https://www.remotion.dev/docs/composition)

---

## 🤝 贡献指南

当你创建了新的动画后:

1. **记录特殊参数**: 如果使用了非标准的 spring 配置或时序，请记录原因
2. **更新文档**: 如果发现了新的动画模式，考虑更新 `REMOTION_ALGORITHM_SPECIALIZATION.md`
3. **分享经验**: 将你遇到的问题和解决方案添加到项目的 FAQ 中

---

**最后更新**: 2026年7月19日  
**维护**: TuringTech Lab - EasyC++ 项目组

---

## 📞 获取帮助

如果遇到问题:
1. 查看项目中的示例实现
2. 参考 Remotion 官方文档
3. 检查 `REMOTION_QUICK_REFERENCE.md` 中的常见陷阱
4. 在项目 Issues 中提问

祝动画制作顺利! 🎬
