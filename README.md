# Math Curve Loaders - SwiftUI Port

[Live Preview](https://paidax01.github.io/math-curve-loaders/)

This project began as a JavaScript/Web implementation of mathematical curve-based loading animations.
This repository now also contains the Swift port of that implementation: `MathCurveKit` (SPM package) and
`MathCurveLoadersApp` (SwiftUI iOS example app).

## Swift Demo

| Demo 1 | Demo 2 |
| --- | --- |
| <video src="https://raw.githubusercontent.com/adityadaniel/math-curve-loaders/main/assets/demo-1.mp4" controls muted playsinline width="360"></video> | <video src="https://raw.githubusercontent.com/adityadaniel/math-curve-loaders/main/assets/demo-2.mp4" controls muted playsinline width="360"></video> |

## Why

This project explores how mathematical parameterizations can become expressive UI loading states while staying lightweight and dependency-free.

## Swift Port

The Swift port is a native reimplementation of the original JavaScript curve engine and interaction model.

- `MathCurveKit` exposes reusable APIs for curve specs, runtime parameters, and `CurveLoaderView`
- `MathCurveLoadersApp` is the sample iOS app that showcases all loaders with live configuration controls
- the goal is behavioral parity with the web implementation, while giving iOS-first SwiftUI integration

It includes:

- the original particle trail loader
- a collection of curve variants such as rose curves, Lissajous curves, hypotrochoids, cardioids, Cassini ovals, and Fourier-style paths
- the original JavaScript/web preview implementation
- click-to-open modal previews
- per-curve formula notes and code snippets
- copy support for formula and code
- a SwiftUI port with reusable `MathCurveKit` module and iOS demo app

## Files

- `index.html`: gallery entry
- `style.css`: layout, modal, and visual styles
- `main.js`: original JS animation engine, curve definitions, modal interactions
- `original.html`: standalone original loader demo
- `original.css`
- `original.js`
- `project.yml`: XcodeGen spec for SwiftUI app/module targets
- `MathCurveLoaders.xcodeproj`: generated iOS project (via `xcodegen generate`)
- `MathCurveKit/`: reusable curve engine, catalog, and tests
- `MathCurveLoadersApp/`: SwiftUI demo app and app smoke tests

## Run

Open `index.html` directly in a browser.

## SwiftUI Run

Use the provided `Makefile` for all CLI workflows:

- `make generate`: generate/update `MathCurveLoaders.xcodeproj`
- `make build`: build `MathCurveLoadersApp` for simulator
- `make run`: install and launch on the configured simulator
- `make test`: run app + package tests
- `make lint`: lint Swift sources with `swift-format`

If you prefer Xcode UI, run `make generate` first, then open `MathCurveLoaders.xcodeproj`.

## Swift Package Manager

`MathCurveKit` is also importable as an SPM library product.

Add dependency:

```swift
dependencies: [
  .package(url: "https://github.com/Paidax01/math-curve-loaders.git", from: "0.1.0")
]
```

Use in your target:

```swift
targets: [
  .target(
    name: "YourApp",
    dependencies: [
      .product(name: "MathCurveKit", package: "math-curve-loaders")
    ]
  )
]
```

Then in SwiftUI:

```swift
import MathCurveKit

CurveLoaderView(style: .rose)
```

## Style API

### Basic

```swift
CurveLoaderView(style: .rose)
```

### Typed core modifiers

```swift
CurveLoaderView(style: .rose)
  .curveParticleCount(84)
  .curveStrokeWidth(5.2)
  .curveDuration(milliseconds: 5400)
```

### Advanced configure hook

```swift
CurveLoaderView(style: .rose) { parameters in
  parameters["roseK"] = 7
  parameters["roseScale"] = 3.4
}
```

### Generic per-key override

```swift
CurveLoaderView(style: .rose)
  .curveControl("roseK", value: 9)
```

`CurveLoaderView(spec:parameters:)` remains available for full low-level control.
