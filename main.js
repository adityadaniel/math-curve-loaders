const SVG_NS = "http://www.w3.org/2000/svg";
const gallery = document.querySelector("#gallery");
const viewerModal = document.querySelector("#viewer-modal");
const viewerBackdrop = document.querySelector("#viewer-backdrop");
const viewer = document.querySelector("#viewer");
const viewerGroup = document.querySelector("#viewer-group");
const viewerPath = document.querySelector("#viewer-path");
const viewerTitle = document.querySelector("#viewer-title");
const viewerTag = document.querySelector("#viewer-tag");
const viewerDesc = document.querySelector("#viewer-desc");
const viewerControls = document.querySelector("#viewer-controls");
const viewerFormula = document.querySelector("#viewer-formula");
const viewerCode = document.querySelector("#viewer-code code");
const viewerCopy = document.querySelector("#viewer-copy");
const viewerClose = document.querySelector("#viewer-close");
const viewerReset = document.querySelector("#viewer-reset");
const langEnButton = document.querySelector("#lang-en");
const langZhButton = document.querySelector("#lang-zh");
const heroEyebrow = document.querySelector("#hero-eyebrow");
const heroTitle = document.querySelector("#hero-title");
const viewerControlsLabel = document.querySelector("#viewer-controls-label");
const viewerFormulaLabel = document.querySelector("#viewer-formula-label");
const viewerCodeLabel = document.querySelector("#viewer-code-label");
let openAnimationFrame = 0;
let currentLanguage = "en";

const UI_TEXT = {
  en: {
    heroEyebrow: "Mathematical Curve Motion",
    heroTitle: "A Gallery of Mathematical Loading Animations",
    galleryLabel: "Mathematical curve animation gallery",
    controls: "Controls",
    formula: "Formula",
    code: "Code",
    reset: "Reset",
    copy: "Copy",
    copied: "Copied",
    copyFailed: "Failed",
    close: "Close",
    ariaOpen: "Open enlarged preview and code for",
  },
  zh: {
    heroEyebrow: "Mathematical Curve Motion",
    heroTitle: "基于数学曲线的加载动画集",
    galleryLabel: "数学曲线动画画廊",
    controls: "配置项",
    formula: "公式",
    code: "代码",
    reset: "重置",
    copy: "复制",
    copied: "已复制",
    copyFailed: "复制失败",
    close: "关闭",
    ariaOpen: "查看放大预览与代码：",
  },
};

const CONTROL_DEFS = [
  { key: "particleCount", labelEn: "Particles", labelZh: "粒子数", min: 24, max: 140, step: 1 },
  { key: "trailSpan", labelEn: "Trail", labelZh: "尾迹长度", min: 0.12, max: 0.68, step: 0.01 },
  { key: "durationMs", labelEn: "Loop", labelZh: "循环时长", min: 2400, max: 12000, step: 100 },
  { key: "pulseDurationMs", labelEn: "Pulse", labelZh: "呼吸时长", min: 1800, max: 10000, step: 100 },
  { key: "rotationDurationMs", labelEn: "Rotate", labelZh: "旋转时长", min: 6000, max: 60000, step: 500 },
  { key: "strokeWidth", labelEn: "Stroke", labelZh: "轨迹粗细", min: 2.5, max: 7.5, step: 0.1 },
];

const curves = [
  {
    name: "Original Thinking",
    tag: "Custom Rose Trail",
    descriptionEn: "The base circle is carved by a sevenfold cosine term, so the trail blooms into a rotating seven-petal ring.",
    descriptionZh: "基础圆周叠加了 7 倍频余弦项，所以轨迹会长成一个旋转中的七瓣花环。",
    formula: [
      "x(t) = 50 + (7 cos t - 3s cos 7t) * 3.9",
      "y(t) = 50 + (7 sin t - 3s sin 7t) * 3.9",
      "s = detailScale(time)",
    ].join("\n"),
    rotate: true,
    particleCount: 64,
    trailSpan: 0.38,
    durationMs: 4600,
    rotationDurationMs: 28000,
    pulseDurationMs: 4200,
    strokeWidth: 5.5,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const x = 7 * Math.cos(t) - 3 * detailScale * Math.cos(7 * t);
      const y = 7 * Math.sin(t) - 3 * detailScale * Math.sin(7 * t);
      return {
        x: 50 + x * 3.9,
        y: 50 + y * 3.9,
      };
    },
  },
  {
    name: "Thinking Five",
    tag: "Custom Rose Trail",
    descriptionEn: "Replacing the sevenfold term with a fivefold term reduces the inner loops, giving the curve a cleaner five-petal rhythm.",
    descriptionZh: "把 7 倍频项换成 5 倍频后，内部环绕圈减少，整条轨迹会呈现更简洁的五瓣节奏。",
    formula: [
      "x(t) = 50 + (7 cos t - 3s cos 5t) * 3.9",
      "y(t) = 50 + (7 sin t - 3s sin 5t) * 3.9",
      "s = detailScale(time)",
    ].join("\n"),
    rotate: true,
    particleCount: 62,
    trailSpan: 0.38,
    durationMs: 4600,
    rotationDurationMs: 28000,
    pulseDurationMs: 4200,
    strokeWidth: 5.5,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const x = 7 * Math.cos(t) - 3 * detailScale * Math.cos(5 * t);
      const y = 7 * Math.sin(t) - 3 * detailScale * Math.sin(5 * t);
      return {
        x: 50 + x * 3.9,
        y: 50 + y * 3.9,
      };
    },
  },
  {
    name: "Thinking Nine",
    tag: "Custom Rose Trail",
    descriptionEn: "A ninefold term packs more inner turns into the same orbit, so the floral ring feels denser and more finely braided.",
    descriptionZh: "9 倍频项会把更多小回环压进同一圈轨道里，所以花环会更密、更细。",
    formula: [
      "x(t) = 50 + (7 cos t - 3s cos 9t) * 3.9",
      "y(t) = 50 + (7 sin t - 3s sin 9t) * 3.9",
      "s = detailScale(time)",
    ].join("\n"),
    rotate: true,
    particleCount: 68,
    trailSpan: 0.39,
    durationMs: 4700,
    rotationDurationMs: 30000,
    pulseDurationMs: 4200,
    strokeWidth: 5.5,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const x = 7 * Math.cos(t) - 3 * detailScale * Math.cos(9 * t);
      const y = 7 * Math.sin(t) - 3 * detailScale * Math.sin(9 * t);
      return {
        x: 50 + x * 3.9,
        y: 50 + y * 3.9,
      };
    },
  },
  {
    name: "Rose Orbit",
    tag: "r = cos(kθ)",
    descriptionEn: "The radius expands and contracts with cos(7t), so the orbit breathes into repeated petals while staying anchored to a circle.",
    descriptionZh: "半径随 cos(7t) 起伏，所以整条轨迹会在圆周上反复鼓起花瓣，同时保持绕圈感。",
    formula: [
      "r(t) = 7 - 2.7s cos(7t)",
      "x(t) = 50 + cos t · r(t) · 3.9",
      "y(t) = 50 + sin t · r(t) · 3.9",
    ].join("\n"),
    rotate: true,
    particleCount: 72,
    trailSpan: 0.42,
    durationMs: 5200,
    rotationDurationMs: 28000,
    pulseDurationMs: 4600,
    strokeWidth: 5.2,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const r = 7 - 2.7 * detailScale * Math.cos(7 * t);
      return {
        x: 50 + Math.cos(t) * r * 3.9,
        y: 50 + Math.sin(t) * r * 3.9,
      };
    },
  },
  {
    name: "Rose Curve",
    tag: "r = a cos(kθ)",
    descriptionEn: "Using r = a cos(5t) creates five evenly spaced lobes, and the breathing multiplier gently swells each petal in and out.",
    descriptionZh: "使用 r = a cos(5t) 会得到五个均匀分布的花瓣，再叠加呼吸倍率后，每片花瓣都会轻微胀缩。",
    formula: [
      "r(t) = a(0.72 + 0.28s) cos(5t)",
      "a = 9.2 + 0.6s",
      "x(t) = 50 + cos t · r(t) · 3.25",
      "y(t) = 50 + sin t · r(t) · 3.25",
    ].join("\n"),
    rotate: true,
    particleCount: 78,
    trailSpan: 0.32,
    durationMs: 5400,
    rotationDurationMs: 28000,
    pulseDurationMs: 4600,
    strokeWidth: 4.5,
    point(progress, detailScale, config) {
      const t = progress * Math.PI * 2;
      const a = 9.2 + detailScale * 0.6;
      const r = a * (0.72 + detailScale * 0.28) * Math.cos(5 * t);
      return {
        x: 50 + Math.cos(t) * r * 3.25,
        y: 50 + Math.sin(t) * r * 3.25,
      };
    },
  },
  {
    name: "Rose Two",
    tag: "r = a cos(2θ)",
    descriptionEn: "With k = 2, the cosine radius forms broad opposing petals, and the breathing factor makes the center pulse like the original.",
    descriptionZh: "当 k = 2 时，余弦半径会生成一组宽阔的对称花瓣，呼吸倍率则让中心像原版一样鼓动。",
    formula: [
      "r(t) = a(0.72 + 0.28s) cos(2t)",
      "a = 9.2 + 0.6s",
      "x(t) = 50 + cos t · r(t) · 3.25",
      "y(t) = 50 + sin t · r(t) · 3.25",
    ].join("\n"),
    rotate: true,
    particleCount: 74,
    trailSpan: 0.3,
    durationMs: 5200,
    rotationDurationMs: 28000,
    pulseDurationMs: 4300,
    strokeWidth: 4.6,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const a = 9.2 + detailScale * 0.6;
      const r = a * (0.72 + detailScale * 0.28) * Math.cos(2 * t);
      return {
        x: 50 + Math.cos(t) * r * 3.25,
        y: 50 + Math.sin(t) * r * 3.25,
      };
    },
  },
  {
    name: "Rose Three",
    tag: "r = a cos(3θ)",
    descriptionEn: "With k = 3, the curve resolves into three rotating petals, and the inner breathing keeps the motion from feeling mathematically rigid.",
    descriptionZh: "当 k = 3 时，曲线会落成三瓣旋转结构，而内层呼吸感会让它不只是静态的数学图形。",
    formula: [
      "r(t) = a(0.72 + 0.28s) cos(3t)",
      "a = 9.2 + 0.6s",
      "x(t) = 50 + cos t · r(t) · 3.25",
      "y(t) = 50 + sin t · r(t) · 3.25",
    ].join("\n"),
    rotate: true,
    particleCount: 76,
    trailSpan: 0.31,
    durationMs: 5300,
    rotationDurationMs: 28000,
    pulseDurationMs: 4400,
    strokeWidth: 4.6,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const a = 9.2 + detailScale * 0.6;
      const r = a * (0.72 + detailScale * 0.28) * Math.cos(3 * t);
      return {
        x: 50 + Math.cos(t) * r * 3.25,
        y: 50 + Math.sin(t) * r * 3.25,
      };
    },
  },
  {
    name: "Rose Four",
    tag: "r = a cos(4θ)",
    descriptionEn: "With k = 4, the petals settle into a balanced cross-like rose, and the breathing core adds the same soft pulse as the original loader.",
    descriptionZh: "当 k = 4 时，花瓣会落成更均衡的十字型玫瑰，而内圆呼吸让它保留原版那种轻微脉动。",
    formula: [
      "r(t) = a(0.72 + 0.28s) cos(4t)",
      "a = 9.2 + 0.6s",
      "x(t) = 50 + cos t · r(t) · 3.25",
      "y(t) = 50 + sin t · r(t) · 3.25",
    ].join("\n"),
    rotate: true,
    particleCount: 78,
    trailSpan: 0.32,
    durationMs: 5400,
    rotationDurationMs: 28000,
    pulseDurationMs: 4500,
    strokeWidth: 4.6,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const a = 9.2 + detailScale * 0.6;
      const r = a * (0.72 + detailScale * 0.28) * Math.cos(4 * t);
      return {
        x: 50 + Math.cos(t) * r * 3.25,
        y: 50 + Math.sin(t) * r * 3.25,
      };
    },
  },
  {
    name: "Lissajous Drift",
    tag: "x = sin(at), y = sin(bt)",
    descriptionEn: "Different sine frequencies on x and y make the path cross itself repeatedly, producing the woven feel of an oscilloscope trace.",
    descriptionZh: "x 和 y 使用不同频率的正弦后，路径会不断交叉回绕，所以会呈现示波器一样的编织感。",
    formula: [
      "A = 24 + 6s",
      "x(t) = 50 + sin(3t + π/2) · A",
      "y(t) = 50 + sin(4t) · 0.92A",
    ].join("\n"),
    rotate: false,
    particleCount: 68,
    trailSpan: 0.34,
    durationMs: 6000,
    rotationDurationMs: 36000,
    pulseDurationMs: 5400,
    strokeWidth: 4.7,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const amp = 24 + detailScale * 6;
      return {
        x: 50 + Math.sin(3 * t + Math.PI / 2) * amp,
        y: 50 + Math.sin(4 * t) * (amp * 0.92),
      };
    },
  },
  {
    name: "Lemniscate Bloom",
    tag: "Bernoulli Lemniscate",
    descriptionEn: "The 1 + sin²t denominator pinches the center while preserving two lobes, so the curve naturally reads as a breathing infinity sign.",
    descriptionZh: "分母里的 1 + sin²t 会把中间收紧、两侧保留双环，因此它天然像一个会呼吸的无限符号。",
    formula: [
      "a = 20 + 7s",
      "x(t) = 50 + a cos t / (1 + sin² t)",
      "y(t) = 50 + a sin t cos t / (1 + sin² t)",
    ].join("\n"),
    rotate: false,
    particleCount: 70,
    trailSpan: 0.4,
    durationMs: 5600,
    rotationDurationMs: 34000,
    pulseDurationMs: 5000,
    strokeWidth: 4.8,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const scale = 20 + detailScale * 7;
      const denom = 1 + Math.sin(t) ** 2;
      return {
        x: 50 + (scale * Math.cos(t)) / denom,
        y: 50 + (scale * Math.sin(t) * Math.cos(t)) / denom,
      };
    },
  },
  {
    name: "Hypotrochoid Loop",
    tag: "Inner Spirograph",
    descriptionEn: "The rolling-circle terms create nested turns and offsets, so the path feels like a compact spirograph traced by a machine.",
    descriptionZh: "滚动圆项会叠出嵌套回环和偏移卷曲，因此整条路径会像机械画出来的紧凑内旋轮线。",
    formula: [
      "x(t) = 50 + ((R-r) cos t + d cos((R-r)t/r)) · 3.05",
      "y(t) = 50 + ((R-r) sin t - d sin((R-r)t/r)) · 3.05",
      "R = 8.2, r = 2.7 + 0.45s, d = 4.8 + 1.2s",
    ].join("\n"),
    rotate: false,
    particleCount: 82,
    trailSpan: 0.46,
    durationMs: 7600,
    rotationDurationMs: 42000,
    pulseDurationMs: 6200,
    strokeWidth: 4.6,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const R = 8.2;
      const r = 2.7 + detailScale * 0.45;
      const d = 4.8 + detailScale * 1.2;
      const x = (R - r) * Math.cos(t) + d * Math.cos(((R - r) / r) * t);
      const y = (R - r) * Math.sin(t) - d * Math.sin(((R - r) / r) * t);
      return {
        x: 50 + x * 3.05,
        y: 50 + y * 3.05,
      };
    },
  },
  {
    name: "Butterfly Phase",
    tag: "Butterfly Curve",
    descriptionEn: "Exponential and high-frequency cosine terms stretch the wings unevenly, giving the path its unmistakably fluttering butterfly shape.",
    descriptionZh: "指数项和高频余弦会把两侧翅膀不均匀地拉开，所以整条轨迹会像蝴蝶一样拍动。",
    formula: [
      "u = 12t",
      "B(u) = e^{cos u} - 2 cos 4u - sin^5(u/12)",
      "x(t) = 50 + sin u · B(u) · (4.6 + 0.45s)",
      "y(t) = 50 + cos u · B(u) · (4.6 + 0.45s)",
    ].join("\n"),
    rotate: false,
    particleCount: 88,
    trailSpan: 0.32,
    durationMs: 9000,
    rotationDurationMs: 50000,
    pulseDurationMs: 7000,
    strokeWidth: 4.4,
    point(progress, detailScale) {
      const t = progress * Math.PI * 12;
      const s =
        Math.exp(Math.cos(t)) -
        2 * Math.cos(4 * t) -
        Math.sin(t / 12) ** 5;
      const scale = 4.6 + detailScale * 0.45;
      return {
        x: 50 + Math.sin(t) * s * scale,
        y: 50 + Math.cos(t) * s * scale,
      };
    },
  },
  {
    name: "Cardioid Glow",
    tag: "Cardioid",
    descriptionEn: "Because r = a(1 - cos t) collapses to zero at one side and swells on the other, the curve reads like a soft pulsing heart wave.",
    descriptionZh: "由于 r = a(1 - cos t) 会在一侧收成尖点、另一侧鼓起，所以这条曲线会像温和起伏的心形脉冲。",
    formula: [
      "a = 8.4 + 0.8s",
      "r(t) = a(1 - cos t)",
      "x(t) = 50 + cos t · r(t) · 2.15",
      "y(t) = 50 + sin t · r(t) · 2.15",
    ].join("\n"),
    rotate: false,
    particleCount: 72,
    trailSpan: 0.36,
    durationMs: 6200,
    rotationDurationMs: 36000,
    pulseDurationMs: 5200,
    strokeWidth: 4.9,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const a = 8.4 + detailScale * 0.8;
      const r = a * (1 - Math.cos(t));
      return {
        x: 50 + Math.cos(t) * r * 2.15,
        y: 50 + Math.sin(t) * r * 2.15,
      };
    },
  },
  {
    name: "Cardioid Heart",
    tag: "r = a(1 + cosθ)",
    descriptionEn: "Starting from r = a(1 + cos t) and rotating the coordinates turns the textbook cardioid into a more legible upright heart.",
    descriptionZh: "从 r = a(1 + cos t) 出发，再把坐标整体旋转后，标准心形线就会变成更直观的竖向爱心。",
    formula: [
      "r(t) = a(1 + cos t)",
      "a = 8.8 + 0.8s",
      "x'(t) = -sin t · r(t)",
      "y'(t) = -cos t · r(t)",
    ].join("\n"),
    rotate: false,
    particleCount: 74,
    trailSpan: 0.36,
    durationMs: 6200,
    rotationDurationMs: 36000,
    pulseDurationMs: 5200,
    strokeWidth: 4.9,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const a = 8.8 + detailScale * 0.8;
      const r = a * (1 + Math.cos(t));
      const baseX = Math.cos(t) * r;
      const baseY = Math.sin(t) * r;
      return {
        x: 50 - baseY * 2.15,
        y: 50 - baseX * 2.15,
      };
    },
  },
  {
    name: "Heart Wave",
    tag: "f(x) Heart Wave",
    descriptionEn: "The x^(2/3) envelope supplies the heart outline, while sin(bπx) fills its interior with adjustable horizontal ripples.",
    descriptionZh: "x^(2/3) 负责给出爱心外轮廓，sin(bπx) 则把可调密度的横向波纹填进心形内部。",
    formula: [
      "f(x) = x^(2/3) + 0.9√(3.3 - x²) sin(bπx)",
      "screenY ∝ 1.75 - f(x)",
      "b controls the ripple density inside the heart",
    ].join("\n"),
    rotate: false,
    particleCount: 104,
    trailSpan: 0.18,
    durationMs: 8400,
    rotationDurationMs: 22000,
    pulseDurationMs: 5600,
    strokeWidth: 3.9,
    heartWaveB: 6.4,
    controls: [
      { key: "heartWaveB", labelEn: "b", labelZh: "b", min: 2, max: 12, step: 0.1 },
    ],
    point(progress, detailScale, config) {
      const xLimit = Math.sqrt(3.3);
      const x = -xLimit + progress * xLimit * 2;
      const safeRoot = Math.max(0, 3.3 - x * x);
      const b = config.heartWaveB;
      const wave = 0.9 * Math.sqrt(safeRoot) * Math.sin(b * Math.PI * x);
      const curve = Math.pow(Math.abs(x), 2 / 3);
      const y = curve + wave;
      const scaleX = 23.2;
      const scaleY = 24.5 + detailScale * 1.5;

      return {
        x: 50 + x * scaleX,
        y: 18 + (1.75 - y) * scaleY,
      };
    },
  },
  {
    name: "Spiral Search",
    tag: "Archimedean Spiral",
    descriptionEn: "A fast-growing angle combined with a cosine-modulated radius creates a spiral that opens out and closes cleanly back into itself.",
    descriptionZh: "快速增长的角度配合被余弦调制的半径，会形成向外展开又能平顺闭合的螺旋轨迹。",
    formula: [
      "θ(t) = 4t",
      "r(t) = 8 + (1 - cos t)(8.5 + 2.4s)",
      "x(t) = 50 + cos θ · r(t)",
      "y(t) = 50 + sin θ · r(t)",
    ].join("\n"),
    rotate: false,
    particleCount: 86,
    trailSpan: 0.28,
    durationMs: 7800,
    rotationDurationMs: 44000,
    pulseDurationMs: 6800,
    strokeWidth: 4.3,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const angle = t * 4;
      const radius = 8 + (1 - Math.cos(t)) * (8.5 + detailScale * 2.4);
      return {
        x: 50 + Math.cos(angle) * radius,
        y: 50 + Math.sin(angle) * radius,
      };
    },
  },
  {
    name: "Fourier Flow",
    tag: "Fourier Curve",
    descriptionEn: "Several sine and cosine components interfere with one another, so the shape keeps mutating like a living waveform.",
    descriptionZh: "多组正弦和余弦彼此干涉后，轮廓会持续变形，看起来像一条有生命的信号波。",
    formula: [
      "x(t) = 50 + 17 cos t + 7.5 cos(3t + 0.6m) + 3.2 sin(5t - 0.4)",
      "y(t) = 50 + 15 sin t + 8.2 sin(2t + 0.25) - 4.2 cos(4t - 0.5m)",
      "m = 1 + 0.16s",
    ].join("\n"),
    rotate: false,
    particleCount: 92,
    trailSpan: 0.31,
    durationMs: 8400,
    rotationDurationMs: 44000,
    pulseDurationMs: 6800,
    strokeWidth: 4.2,
    point(progress, detailScale) {
      const t = progress * Math.PI * 2;
      const mix = 1 + detailScale * 0.16;
      const x =
        17 * Math.cos(t) +
        7.5 * Math.cos(3 * t + 0.6 * mix) +
        3.2 * Math.sin(5 * t - 0.4);
      const y =
        15 * Math.sin(t) +
        8.2 * Math.sin(2 * t + 0.25) -
        4.2 * Math.cos(4 * t - 0.5 * mix);
      return {
        x: 50 + x,
        y: 50 + y,
      };
    },
  },
];

function normalizeProgress(progress) {
  return ((progress % 1) + 1) % 1;
}

function createCard(config) {
  const article = document.createElement("article");
  article.className = "curve-card";
  article.tabIndex = 0;
  article.setAttribute("role", "button");

  article.innerHTML = `
    <div class="curve-frame"></div>
    <div class="curve-meta">
      <h2 class="curve-title">${config.name}</h2>
      <span class="curve-tag">${config.tag}</span>
    </div>
    <p class="curve-desc"></p>
  `;

  const frame = article.querySelector(".curve-frame");
  const svg = document.createElementNS(SVG_NS, "svg");
  svg.setAttribute("class", "curve-svg");
  svg.setAttribute("viewBox", "0 0 100 100");
  svg.setAttribute("fill", "none");
  svg.setAttribute("aria-hidden", "true");

  const group = document.createElementNS(SVG_NS, "g");
  const path = document.createElementNS(SVG_NS, "path");
  path.setAttribute("stroke", "currentColor");
  path.setAttribute("stroke-width", String(config.strokeWidth));
  path.setAttribute("stroke-linecap", "round");
  path.setAttribute("stroke-linejoin", "round");
  path.setAttribute("opacity", "0.1");

  group.appendChild(path);
  svg.appendChild(group);
  frame.appendChild(svg);

  const particles = Array.from({ length: config.particleCount }, () => {
    const circle = document.createElementNS(SVG_NS, "circle");
    circle.setAttribute("fill", "currentColor");
    group.appendChild(circle);
    return circle;
  });

  return {
    article,
    config,
    group,
    path,
    particles,
    startTime: performance.now(),
    phaseOffset: Math.random(),
  };
}

function getDescription(config) {
  return currentLanguage === "zh" ? config.descriptionZh : config.descriptionEn;
}

function applyLanguage() {
  const ui = UI_TEXT[currentLanguage];
  document.documentElement.lang = currentLanguage === "zh" ? "zh-CN" : "en";
  heroEyebrow.textContent = ui.heroEyebrow;
  heroTitle.textContent = ui.heroTitle;
  gallery.setAttribute("aria-label", ui.galleryLabel);
  viewerControlsLabel.textContent = ui.controls;
  viewerFormulaLabel.textContent = ui.formula;
  viewerCodeLabel.textContent = ui.code;
  viewerReset.textContent = ui.reset;
  viewerCopy.textContent = ui.copy;
  viewerClose.textContent = ui.close;
  langEnButton.classList.toggle("is-active", currentLanguage === "en");
  langZhButton.classList.toggle("is-active", currentLanguage === "zh");

  instances.forEach((instance) => {
    const desc = instance.article.querySelector(".curve-desc");
    if (desc) {
      desc.textContent = getDescription(instance.config);
    }
    instance.article.setAttribute(
      "aria-label",
      currentLanguage === "zh"
        ? `${ui.ariaOpen}${instance.config.name}`
        : `${ui.ariaOpen} ${instance.config.name}`
    );
  });

  if (activeInstance) {
    viewerDesc.textContent = getDescription(activeInstance.config);
  }
}

function buildPath(config, detailScale, steps = 480) {
  return Array.from({ length: steps + 1 }, (_, index) => {
    const point = config.point(index / steps, detailScale, config);
    return `${index === 0 ? "M" : "L"} ${point.x.toFixed(2)} ${point.y.toFixed(2)}`;
  }).join(" ");
}

function getParticle(config, index, progress, detailScale) {
  const tailOffset = index / (config.particleCount - 1);
  const point = config.point(
    normalizeProgress(progress - tailOffset * config.trailSpan),
    detailScale,
    config
  );
  const fade = Math.pow(1 - tailOffset, 0.56);

  return {
    x: point.x,
    y: point.y,
    radius: 0.9 + fade * 2.7,
    opacity: 0.04 + fade * 0.96,
  };
}

function getDetailScale(time, config, phaseOffset) {
  const pulseProgress =
    ((time + phaseOffset * config.pulseDurationMs) % config.pulseDurationMs) /
    config.pulseDurationMs;
  const pulseAngle = pulseProgress * Math.PI * 2;
  return 0.52 + ((Math.sin(pulseAngle + 0.55) + 1) / 2) * 0.48;
}

function getRotation(time, config, phaseOffset) {
  if (!config.rotate) {
    return 0;
  }

  return -(
    ((time + phaseOffset * config.rotationDurationMs) % config.rotationDurationMs) /
    config.rotationDurationMs
  ) * 360;
}

const instances = curves.map((config) => {
  const instance = createCard(config);
  gallery.appendChild(instance.article);
  return instance;
});

const viewerParticles = Array.from({ length: 120 }, () => {
  const circle = document.createElementNS(SVG_NS, "circle");
  circle.setAttribute("fill", "currentColor");
  viewerGroup.appendChild(circle);
  return circle;
});

let activeInstance = null;
let activeViewerConfig = null;

function formatControlValue(key, value) {
  if (key.endsWith("Ms")) {
    return `${(value / 1000).toFixed(1)}s`;
  }

  if (key === "trailSpan" || key === "strokeWidth") {
    return Number(value).toFixed(2);
  }

  return `${Math.round(value)}`;
}

function createViewerConfig(config) {
  return {
    ...config,
    point: config.point,
    formula: config.formula,
  };
}

function renderControls(config) {
  viewerControls.innerHTML = "";

  const controls = [...CONTROL_DEFS, ...(config.controls ?? [])];

  controls.forEach((control) => {
    const wrap = document.createElement("label");
    wrap.className = "viewer-control";
    wrap.innerHTML = `
      <div class="viewer-control-head">
        <span class="viewer-control-label">${currentLanguage === "zh" ? control.labelZh : control.labelEn}</span>
        <span class="viewer-control-value" data-value-key="${control.key}">
          ${formatControlValue(control.key, config[control.key])}
        </span>
      </div>
      <input
        type="range"
        min="${control.min}"
        max="${control.max}"
        step="${control.step}"
        value="${config[control.key]}"
        data-key="${control.key}"
      />
    `;
    viewerControls.appendChild(wrap);
  });
}

function syncViewerMeta(config) {
  viewerFormula.textContent = config.formula;
  viewerCode.textContent = formatCurveCode(config);
  viewerPath.setAttribute("stroke-width", String(config.strokeWidth));
  renderControls(config);
}

function formatCurveCode(config) {
  const pointSource = config.point.toString().replace(/^point/, "function point");
  const controls = config.controls ?? [];
  const customLines = controls.map((control) => `  ${control.key}: ${config[control.key]},`);
  return [
    `const curve = {`,
    `  name: "${config.name}",`,
    `  tag: "${config.tag}",`,
    `  rotate: ${config.rotate},`,
    `  particleCount: ${config.particleCount},`,
    `  trailSpan: ${config.trailSpan},`,
    `  durationMs: ${config.durationMs},`,
    `  rotationDurationMs: ${config.rotationDurationMs},`,
    `  pulseDurationMs: ${config.pulseDurationMs},`,
    `  strokeWidth: ${config.strokeWidth},`,
    ...customLines,
    `};`,
    ``,
    pointSource,
  ].join("\n");
}

function setActiveInstance(instance) {
  activeInstance = instance;
  if (openAnimationFrame) {
    cancelAnimationFrame(openAnimationFrame);
    openAnimationFrame = 0;
  }
  const rect = instance.article.getBoundingClientRect();
  const vw = window.innerWidth;
  const vh = window.innerHeight;
  const modalWidth = Math.min(1200, vw - 32);
  const modalHeight = Math.min(vh - 32, vw <= 640 ? vh - 24 : vh - 32);
  const targetLeft = (vw - modalWidth) / 2;
  const targetTop = (vh - modalHeight) / 2;
  const scaleX = Math.max(0.18, rect.width / modalWidth);
  const scaleY = Math.max(0.18, rect.height / modalHeight);
  viewer.style.setProperty("--viewer-translate-x", `${rect.left - targetLeft}px`);
  viewer.style.setProperty("--viewer-translate-y", `${rect.top - targetTop}px`);
  viewer.style.setProperty("--viewer-scale", `${Math.min(scaleX, scaleY)}`);
  viewerModal.classList.remove("is-open");
  viewerModal.classList.add("is-entering");
  viewerModal.setAttribute("aria-hidden", "false");
  viewerTitle.textContent = instance.config.name;
  viewerTag.textContent = instance.config.tag;
  viewerDesc.textContent = getDescription(instance.config);
  activeViewerConfig = createViewerConfig(instance.config);
  syncViewerMeta(activeViewerConfig);

  instances.forEach((item) => {
    item.article.classList.toggle("is-active", item === instance);
    item.article.setAttribute("aria-pressed", item === instance ? "true" : "false");
  });

  openAnimationFrame = requestAnimationFrame(() => {
    openAnimationFrame = requestAnimationFrame(() => {
      viewerModal.classList.add("is-open");
      viewerModal.classList.remove("is-entering");
      openAnimationFrame = 0;
    });
  });
}

function clearActiveInstance() {
  activeInstance = null;
  if (openAnimationFrame) {
    cancelAnimationFrame(openAnimationFrame);
    openAnimationFrame = 0;
  }
  viewerModal.classList.remove("is-open");
  viewerModal.classList.remove("is-entering");
  viewerModal.setAttribute("aria-hidden", "true");
  instances.forEach((item) => {
    item.article.classList.remove("is-active");
    item.article.setAttribute("aria-pressed", "false");
  });
  viewerTitle.textContent = "";
  viewerTag.textContent = "";
  viewerDesc.textContent = "";
  viewerControls.innerHTML = "";
  viewerFormula.textContent = "";
  viewerCode.textContent = "";
  viewerPath.setAttribute("d", "");
  activeViewerConfig = null;
}

instances.forEach((instance) => {
  const open = () => setActiveInstance(instance);
  instance.article.addEventListener("click", open);
  instance.article.addEventListener("keydown", (event) => {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      open();
    }
  });
});

viewerClose.addEventListener("click", () => {
  clearActiveInstance();
});

viewerCopy.addEventListener("click", async () => {
  if (!activeInstance || !activeViewerConfig) {
    return;
  }

  const textToCopy = [
    `${activeViewerConfig.name}`,
    "",
    "Formula",
    activeViewerConfig.formula,
    "",
    "Code",
    formatCurveCode(activeViewerConfig),
  ].join("\n");

  try {
    await navigator.clipboard.writeText(textToCopy);
      viewerCopy.textContent = UI_TEXT[currentLanguage].copied;
      window.setTimeout(() => {
      viewerCopy.textContent = UI_TEXT[currentLanguage].copy;
    }, 1400);
  } catch (_error) {
    viewerCopy.textContent = UI_TEXT[currentLanguage].copyFailed;
    window.setTimeout(() => {
      viewerCopy.textContent = UI_TEXT[currentLanguage].copy;
    }, 1400);
  }
});

langEnButton.addEventListener("click", () => {
  currentLanguage = "en";
  applyLanguage();
  if (activeViewerConfig) {
    renderControls(activeViewerConfig);
  }
});

langZhButton.addEventListener("click", () => {
  currentLanguage = "zh";
  applyLanguage();
  if (activeViewerConfig) {
    renderControls(activeViewerConfig);
  }
});

viewerReset.addEventListener("click", () => {
  if (!activeInstance) {
    return;
  }

  activeViewerConfig = createViewerConfig(activeInstance.config);
  syncViewerMeta(activeViewerConfig);
});

viewerControls.addEventListener("input", (event) => {
  const target = event.target;
  if (!(target instanceof HTMLInputElement) || !activeViewerConfig) {
    return;
  }

  const { key } = target.dataset;
  if (!key) {
    return;
  }

  const nextValue = key === "particleCount"
    ? Math.round(Number(target.value))
    : Number(target.value);

  activeViewerConfig[key] = nextValue;

  const valueEl = viewerControls.querySelector(`[data-value-key="${key}"]`);
  if (valueEl) {
    valueEl.textContent = formatControlValue(key, nextValue);
  }

  viewerCode.textContent = formatCurveCode(activeViewerConfig);
  viewerPath.setAttribute("stroke-width", String(activeViewerConfig.strokeWidth));
});

viewerBackdrop.addEventListener("click", () => {
  clearActiveInstance();
});

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && activeInstance) {
    clearActiveInstance();
  }
});

function renderInstance(instance, now) {
  const time = now - instance.startTime;
  const { config, group, path, particles, phaseOffset } = instance;
  const progress =
    ((time + phaseOffset * config.durationMs) % config.durationMs) / config.durationMs;
  const detailScale = getDetailScale(time, config, phaseOffset);
  const rotation = getRotation(time, config, phaseOffset);

  group.setAttribute("transform", `rotate(${rotation} 50 50)`);
  path.setAttribute("d", buildPath(config, detailScale));

  particles.forEach((node, index) => {
    const particle = getParticle(config, index, progress, detailScale);
    node.setAttribute("cx", particle.x.toFixed(2));
    node.setAttribute("cy", particle.y.toFixed(2));
    node.setAttribute("r", particle.radius.toFixed(2));
    node.setAttribute("opacity", particle.opacity.toFixed(3));
  });
}

function renderViewer(now) {
  if (!activeInstance) {
    return;
  }

  const time = now - activeInstance.startTime;
  const { phaseOffset } = activeInstance;
  const config = activeViewerConfig ?? activeInstance.config;
  const progress =
    ((time + phaseOffset * config.durationMs) % config.durationMs) / config.durationMs;
  const detailScale = getDetailScale(time, config, phaseOffset);
  const rotation = getRotation(time, config, phaseOffset);

  viewerGroup.setAttribute("transform", `rotate(${rotation} 50 50)`);
  viewerPath.setAttribute("d", buildPath(config, detailScale));

  viewerParticles.forEach((node, index) => {
    if (index >= config.particleCount) {
      node.setAttribute("opacity", "0");
      return;
    }

    const particle = getParticle(config, index, progress, detailScale);
    node.setAttribute("cx", particle.x.toFixed(2));
    node.setAttribute("cy", particle.y.toFixed(2));
    node.setAttribute("r", (particle.radius * 1.35).toFixed(2));
    node.setAttribute("opacity", Math.min(1, particle.opacity + 0.04).toFixed(3));
  });
}

function tick(now) {
  instances.forEach((instance) => renderInstance(instance, now));
  renderViewer(now);
  window.requestAnimationFrame(tick);
}

instances.forEach((instance) => renderInstance(instance, performance.now()));
applyLanguage();
window.requestAnimationFrame(tick);
