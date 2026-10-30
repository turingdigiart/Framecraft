# Remotion 快速参考指南

## 🎯 常用 Spring 配置速查

```typescript
// 🌟 入场动画 (默认推荐)
spring({
  frame: frame - startFrame,
  fps,
  config: { damping: 15, stiffness: 100, mass: 1 }
})

// ⚡ 快速响应 (交互/重排)
config: { damping: 200, stiffness: 180, mass: 0.6 }

// 📦 下落堆叠 (重力感)
config: { damping: 15, stiffness: 100, mass: 0.8 }

// 🎢 强弹跳 (强调效果)
config: { damping: 8, stiffness: 80, mass: 1.2 }
```

---

## ⏱️ 时序参数速查 (30fps)

```typescript
12帧  = 0.4秒  // 快速迭代/搜索
20帧  = 0.67秒 // 淡入淡出
30帧  = 1秒    // 标准暂停
45帧  = 1.5秒  // 重要展示
60帧  = 2秒    // 长暂停/阶段过渡
```

---

## 🎨 颜色速查

```typescript
// 官方背景 (强制)
background: `linear-gradient(
  to bottom, '#000000' 0%, '#1a1a1a' 40%, '#2d2d30' 100%
)`;

// 状态颜色
#4ec9b0  // 青色 - 扫描中/进行中
#f1c40f  // 黄色 - 已匹配/完成
#e74c3c  // 红色 - 警告/错误
#569cd6  // 蓝色 - 信息/默认
#2d2d30  // 深灰 - 未处理/背景
```

---

## 📐 标准组件模板

### 1. 可视化盒子 (带状态)
```typescript
<div style={{
  position: 'absolute',
  left: `${xPos}px`,
  width: '100px',
  height: '100px',
  borderRadius: '12px',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: '42px',
  fontWeight: 'bold',
  backgroundColor: boxColor,
  color: textColor,
  border: '3px solid #569cd6',
  transform: `scale(${scale})`,
  opacity: opacity,
  boxShadow: hasGlow ? '0 0 25px rgba(78, 201, 176, 0.9)' : 'none',
}}>{content}</div>
```

### 2. 代码窗口 (CodeFrameV2)
```typescript
<CodeFrameV2
  filename="demo.cpp"
  lines={[
    {
      text: 'for (int idx = 0; idx < 10; idx++) {',
      keywords: ['for', 'int', 'idx'],
      highlight: isWarning ? ['idx'] : []
    }
  ]}
/>
```

### 3. 渐变背景容器
```typescript
<AbsoluteFill style={{
  background: `linear-gradient(
    to bottom,
    '#000000' 0%,
    '#1a1a1a' 40%,
    '#2d2d30' 100%
  )`,
  padding: '60px',
  display: 'flex',
  flexDirection: 'column',
  position: 'relative',
  overflow: 'hidden',
}}>
  {/* 内容 */}
</AbsoluteFill>
```

---

## 🔄 标准动画模式

### 模式A: 搜索-处理
```typescript
// 1. 搜索过程 (frameDelay = 12)
const currentIndex = Math.floor((frame - startFrame) / frameDelay);

// 2. 状态切换
if (isScanning) color = '#4ec9b0';
if (isProcessed) color = '#f1c40f';

// 3. 高亮效果
if (current === active) hasGlow = true;
```

### 模式B: 淡出-重排
```typescript
// 1. 淡出不需要的元素
if (isFadingOut && !shouldKeep) {
  opacity = interpolate(frame, [start, end], [1, 0]);
}

// 2. 平滑重排
const progress = spring({
  frame: frame - gatherStartFrame,
  fps,
  config: { damping: 200, stiffness: 180, mass: 0.6 }
});
x = interpolate(progress, [0, 1], [startX, targetX]);
```

### 模式C: 弹性入场
```typescript
const progress = spring({
  frame: frame - startFrame,
  fps,
  config: { damping: 15, stiffness: 100, mass: 1 }
});

// 先放大再回弹
const scale = interpolate(progress, [0, 0.6, 1], [0.8, 1.05, 1]);
const y = interpolate(progress, [0, 1], [-400, 0]);
```

---

## 🚀 新项目启动清单

```bash
# 1. 复制标准文件
cp -r Template/Demo/for-loop-animation Template/Demo/new-animation

# 2. 修改配置文件
cd new-animation
# 编辑 src/Root.tsx 中的 composition 名称

# 3. 应用标准样式
# 确保 styles-v2.ts 存在并导入 COLORS_V2

# 4. 设置时序
# 参考 ForLoopDemo.tsx 第9-29行的时间轴模式

# 5. 选择动画模式
# 根据教学内容选择: 搜索-处理 / 下落-堆叠 / 高亮-警告
```

---

## 💡 扩展指南

### 针对不同算法的特化建议

#### 排序算法
```typescript
// 使用模式A (搜索-处理)
// 添加比较高亮: 比较中的元素变红
// 添加交换动画: 两个元素互换位置
const swapProgress = spring({
  frame: frame - swapStartFrame,
  fps,
  config: { damping: 200, stiffness: 180, mass: 0.6 }
});
```

#### 递归算法
```typescript
// 使用模式B (淡出-重排)
// 添加层级缩进: 每层递归向右缩进
const indent = level * 50;
// 添加调用栈可视化: 显示当前调用路径
```

#### 树结构遍历
```typescript
// 使用模式C (弹性入场)
// 添加节点连接线: SVG 动态绘制
// 添加层级下落: 子节点从父节点位置下落
```

#### 图算法
```typescript
// 使用模式A + 模式B
// 节点搜索高亮 + 边的淡入淡出
// 最短路径可视化: 红色高亮最终路径
```

---

## 📚 常用代码片段

### 状态机模式
```typescript
const isPhase1 = frame >= start1 && frame < end1;
const isPhase2 = frame >= start2 && frame < end2;
const isPhase3 = frame >= start3;

if (isPhase1) {
  // 阶段1逻辑
} else if (isPhase2) {
  // 阶段2逻辑
} else if (isPhase3) {
  // 阶段3逻辑
}
```

### 循环迭代动画
```typescript
const iterations = [0, 1, 2, 3, 4];
const currentIteration = Math.floor(
  (frame - startFrame) / iterationDelay
);

iterations.forEach((item, index) => {
  const isActive = index === currentIteration;
  const isCompleted = index < currentIteration;
  // 设置状态...
});
```

### 平滑数值过渡
```typescript
const from = spring({
  frame: frame - startFrame,
  fps,
  config: { damping: 15, stiffness: 100, mass: 1 }
});

const value = interpolate(from, [0, 1], [startValue, endValue]);
```

---

## ⚠️ 常见陷阱

### ❌ 错误做法
```typescript
// 1. 直接使用线性插值做运动
const x = interpolate(frame, [0, 30], [0, 100]);  // 生硬

// 2. 忘记 extrapolateRight
const opacity = interpolate(frame, [0, 30], [0, 1]);  // 可能超出范围

// 3. 在 map 中重复计算
{items.map(item => {
  const progress = spring({...});  // 每个item都计算
  return <div style={{ transform: `translateX(${progress}px)` }} />;
})}
```

### ✅ 正确做法
```typescript
// 1. 使用 spring
const progress = spring({...});
const x = interpolate(progress, [0, 1], [0, 100]);

// 2. 添加 extrapolateRight
const opacity = interpolate(frame, [0, 30], [0, 1], {
  extrapolateRight: 'clamp'
});

// 3. 预计算 spring
const progress = spring({...});
{items.map(item => {
  const x = interpolate(progress, [0, 1], [item.start, item.end]);
  return <div style={{ transform: `translateX(${x}px)` }} />;
})}
```

---

**最后更新**: 2026年7月19日  
**维护**: TuringTech Lab - EasyC++ 项目组
