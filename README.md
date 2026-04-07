# Math Curve Loaders

[Live Preview](https://paidax01.github.io/math-curve-loaders/)

Originally this project was a JavaScript/Web implementation of mathematical curve-based loading animations.
This repository now also contains the Swift port of that implementation: `MathCurveKit` (SPM package) and
`MathCurveLoadersApp` (SwiftUI iOS example app).

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

1. Generate/update the Xcode project:
   - `xcodegen generate`
2. Open `MathCurveLoaders.xcodeproj` in Xcode and run `MathCurveLoadersApp`.

CLI test run:
- `xcodebuild test -project MathCurveLoaders.xcodeproj -scheme MathCurveLoadersApp -destination 'platform=iOS Simulator,name=iPhone 17'`

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

## Why

This project explores how mathematical parameterizations can become expressive UI loading states while staying lightweight and dependency-free.
