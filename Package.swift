// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "MathCurveLoaders",
  platforms: [
    .iOS(.v17),
    .macOS(.v12),
  ],
  products: [
    .library(
      name: "MathCurveKit",
      targets: ["MathCurveKit"]
    ),
  ],
  targets: [
    .target(
      name: "MathCurveKit",
      path: "MathCurveKit/Sources/MathCurveKit"
    ),
    .testTarget(
      name: "MathCurveKitTests",
      dependencies: ["MathCurveKit"],
      path: "MathCurveKit/Tests/MathCurveKitTests"
    ),
  ]
)
