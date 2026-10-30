# Remotion动画设计标准 v1.0

基于 `for-loop-animation` demo 提取的运动、渐变和平滑变动标准。

## 🎯 核心原则

1. **一致性** - 所有课程动画使用统一的缓动和时序模式
2. **可预测性** - 运动规律清晰，观众能预期动画走向
3. **平滑性** - 使用物理模拟(spring)而非线性插值
4. **视觉层级** - 重要元素先动，次要元素跟随

---

## 🌊 运动方式标准

### Spring 动画配置

#### 标准入场动画
```typescript
const scale = spring({
  frame: frame - startFrame,
  fps,
  config: {
    damping: 15,      // 阻尼: 控制震荡次数 (15 = 轻微回弹)
    stiffness: 100,   // 刚度: 控制速度 (100 = 中速)
    mass: 1,          // 质量: 控制惯性 (1 = 标准)
  }
});
```

**使用场景**: 元素初始出现、标题入场

#### 快速响应动画
```typescript
const progress = spring({
  frame: frame - startFrame,
  fps,
  config: {
    damping: 200,      // 高阻尼 = 无震荡，平滑到位
    stiffness: 180,    // 高刚度 = 快速响应
    mass: 0.6,        // 低质量 = 轻快
  }
});
```

**使用场景**: 交互反馈、状态变化、位置重排

#### 缓动下落动画
```typescript
const dropProgress = spring({
  frame: frame - startFrame,
  fps,
  config: {
    damping: 15,
    stiffness: 100,
    mass: 0.8,         // 略高质量 = 重力感
  }
});
```

**使用场景**: 堆栈元素下落、物体掉落效果

### 插值动画标准

#### 线性淡入/淡出
```typescript
const opacity = interpolate(
  frame,
  [startFrame, endFrame],
  [0, 1],
  { extrapolateRight: 'clamp' }  // 防止超出范围
);
```

#### 位移插值
```typescript
const y = interpolate(progress, [0, 1], [-400, 0]);
const x = interpolate(progress, [0, 1], [startX, targetX]);
```

#### 缩放弹性
```typescript
const scale = interpolate(
  animationProgress,
  [0, 0.6, 1],
  [0.8, 1.05, 1]  // 先放大再回弹 = 吸引注意力
);
```

---

## 🎨 颜色渐变标准

### 官方背景渐变 (锁定)
```typescript
background: `linear-gradient(
  to bottom,
  '#000000' 0%,        // 纯黑顶部
  '#1a1a1a' 40%,       // 深灰过渡
  '#2d2d30' 100%       // 深灰底部
)`;
```

**强制要求**: 所有 EasyC++ 课程动画必须使用此背景，确保视觉一致性。

### 状态颜色渐变

#### 扫描中 → 已处理
```typescript
// 动态切换颜色
let boxColor = '#2d2d30';  // 默认
if (isScanning) boxColor = '#4ec9b0';  // 青色扫描
if (isProcessed) boxColor = '#f1c40f';  // 黄色完成
```

#### 警告状态渐变
```typescript
// 条件不满足时变红
const isHighlighted = line.highlight?.includes(keyword);
const finalColor = isHighlighted ? '#e74c3c' : originalColor;
```

#### 透明度渐变
```typescript
// 淡出不需要的元素
const opacity = interpolate(
  frame,
  [fadeOutStart, fadeOutEnd],
  [1, 0],
  { extrapolateRight: 'clamp' }
);
```

---

## ⚡ 时序标准

### 标准时间单位 (以 30fps 为基准)

```typescript
// 快速交互
const frameDelay = 12;  // 12帧 = 0.4秒 (用于快速搜索/迭代)

// 标准展示
const pauseDuration = 30;  // 30帧 = 1秒 (让观众看清)

// 慢速过渡
const longPause = 45;  // 45帧 = 1.5秒 (重要信息展示)

// 淡入淡出
const fadeDuration = 20;  // 20帧 = 0.67秒 (平滑过渡)
```

### 阶段时间轴示例

```typescript
// 1. 初始展示 (30帧 = 1秒)
const initialShowFrame = 30;

// 2. 开始主动作 (60帧 = 2秒时开始)
const searchStartFrame = 60;

// 3. 动作执行 (每次迭代12帧)
const frameDelay = 12;
const searchEndIndex = 10;
const finalSearchFrame = searchStartFrame + (searchEndIndex * frameDelay);

// 4. 关键时刻强调 (20帧)
const conditionRejectFrame = finalSearchFrame + 20;
const conditionRejectDuration = 30;

// 5. 过渡到下一阶段 (20帧淡出)
const fadeOutStartFrame = conditionRejectFrame + conditionRejectDuration;
const fadeOutDuration = 20;

// 6. 最终结果展示 (45帧动画 + 30帧暂停)
const gatherStartFrame = fadeOutStartFrame + fadeOutDuration;
const gatherDuration = 45;
const pauseAfterGather = 30;
```

---

## 🎬 复合运动模式

### 模式1: 搜索-筛选-收集 (Search-Filter-Gather)

**适用场景**: 循环、查找、遍历算法

```typescript
// 阶段1: 搜索过程
if (isSearching) {
  // 当前搜索项高亮 + 光晕
  if (num === searchedIndex) {
    boxColor = '#4ec9b0';
    hasGlow = true;
  }
  // 已处理项变色
  if (num < searchedIndex && isEven) {
    boxColor = '#f1c40f';
  }
}

// 阶段2: 筛选 (淡出不符合条件的)
if (isFadingOut && !shouldKeep) {
  opacity = interpolate(frame, [start, end], [1, 0]);
}

// 阶段3: 收集结果 (平滑重排)
if (isGathering) {
  const progress = spring({
    frame: frame - gatherStartFrame,
    fps,
    config: { damping: 200, stiffness: 180, mass: 0.6 }
  });
  x = interpolate(progress, [0, 1], [startX, targetX]);
}
```

### 模式2: 下落-堆叠 (Drop-Stack)

**适用场景**: 栈操作、内存分配

```typescript
// 从上方下落
const dropProgress = spring({
  frame: frame - startFrame,
  fps,
  config: { damping: 15, stiffness: 100, mass: 0.8 }
});
const y = interpolate(dropProgress, [0, 1], [-400, 0]);

// 弹性缩放吸引注意力
const scale = interpolate(dropProgress, [0, 0.6, 1], [0.8, 1.05, 1]);
```

### 模式3: 高亮-警告 (Highlight-Warn)

**适用场景**: 条件判断、错误检查

```typescript
// 正常语法高亮
let color = COLORS_V2.syntax.keyword;

// 关键时刻变红警告
if (isConditionReject) {
  color = '#e74c3c';
}
```

---

## 🧩 组件复用标准

### CodeFrameV2 标准用法

```typescript
<CodeFrameV2
  filename="example.cpp"
  lines={[
    {
      text: 'for (int idx = 0; idx < 10; idx++) {',
      keywords: ['for', 'int', 'idx'],
      highlight: isRejecting ? ['idx'] : []  // 条件高亮
    },
    // ...
  ]}
/>
```

### 颜色系统引用

```typescript
import { COLORS_V2 } from './styles-v2';

// 背景
COLORS_V2.background.top       // '#000000'
COLORS_V2.background.middle    // '#1a1a1a'
COLORS_V2.background.bottom    // '#2d2d30'

// 状态颜色
COLORS_V2.status.scanning      // '#4ec9b0'
COLORS_V2.status.matched       // '#f1c40f'
COLORS_V2.status.warning       // '#e74c3c'
COLORS_V2.status.info          // '#569cd6'
```

---

## 📐 布局标准

### 代码窗口布局
```typescript
<AbsoluteFill style={{
  background: gradient,
  padding: '60px',
  display: 'flex',
  flexDirection: 'column',
  position: 'relative',
  overflow: 'hidden',
}}>
  {/* 代码区 - 上部 */}
  <Sequence from={0} style={{ transform: 'translateY(300px)' }}>
    <CodeFrameV2 ... />
  </Sequence>

  {/* 可视化区 - 下部 */}
  <Sequence from={initialShowFrame}>
    <div style={{
      position: 'relative',
      width: '1300px',
      height: '100px'
    }}>
      {/* 动画元素 */}
    </div>
  </Sequence>
</AbsoluteFill>
```

### 居中对齐模式
```typescript
style={{
  position: 'absolute',
  left: '50%',
  transform: 'translateX(-50%)',  // 水平居中
  // 或
  transform: 'translate(-50%, ${y}px)',  // 水平居中 + 垂直动画
}}
```

---

## 🚀 性能优化标准

### 避免重复计算
```typescript
// ❌ 每帧都计算
{x: interpolate(frame, [0, 30], [0, 100])}  // 在 map 中重复计算

// ✅ 预计算
const progress = spring({...});  // 计算一次
const xPos = interpolate(progress, [0, 1], [start, end]);  // 计算一次
```

### 条件渲染优化
```typescript
// ✅ 使用条件而非透明度控制渲染
{frame > threshold && <Component />}

// ❌ 不必要的持续渲染
<div style={{ opacity: frame < threshold ? 0 : 1 }} />
```

---

## 🎓 学习路径建议

1. **基础** - 掌握 spring 配置的阻尼/刚度/质量三参数
2. **进阶** - 学习 interpolate 与 spring 结合使用
3. **高级** - 设计复合运动模式 (搜索→筛选→收集)
4. **特化** - 针对特定算法调整时序参数

---

## 📚 参考资源

- **Spring 配置原理**: [remotion.dev/docs/spring](https://www.remotion.dev/docs/spring)
- **Interpolate 文档**: [remotion.dev/docs/interpolate](https://www.remotion.dev/docs/interpolate)
- **时序设计**: 参考本项目的 `ForLoopDemo.tsx` 第9-29行的时间轴设计

---

## 🔄 版本历史

- **v1.0** (2024-07) - 基于 `for-loop-animation` demo 提取初始标准
- 未来将根据新的案例动画 (如 `stack-heap-animation`, `pointer-animation`) 进行扩展

---

**最后更新**: 2026年7月19日  
**维护者**: TuringTech Lab - EasyC++ 项目组
