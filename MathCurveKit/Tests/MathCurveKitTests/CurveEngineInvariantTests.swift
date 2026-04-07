import XCTest

@testable import MathCurveKit

final class CurveEngineInvariantTests: XCTestCase {
  func testNormalizeProgressWraps() {
    XCTAssertEqual(CurveEngine.normalizeProgress(-0.2), 0.8, accuracy: 0.0000001)
    XCTAssertEqual(CurveEngine.normalizeProgress(1.2), 0.2, accuracy: 0.0000001)
  }

  func testDetailScaleRange() {
    for time in stride(from: 0.0, through: 20_000.0, by: 137.0) {
      let value = CurveEngine.detailScale(timeMs: time, pulseDurationMs: 4200, phaseOffset: 0.33)
      XCTAssertGreaterThanOrEqual(value, 0.52 - 0.000001)
      XCTAssertLessThanOrEqual(value, 1.0 + 0.000001)
    }
  }

  func testRotationHonorsRotateFlag() {
    let rotating = CurveEngine.rotation(
      timeMs: 1200,
      rotationDurationMs: 28_000,
      phaseOffset: 0.2,
      rotate: true
    )
    let staticRotation = CurveEngine.rotation(
      timeMs: 1200,
      rotationDurationMs: 28_000,
      phaseOffset: 0.2,
      rotate: false
    )
    XCTAssertNotEqual(rotating, 0)
    XCTAssertEqual(staticRotation, 0)
  }

  func testParticleTailMonotonicFade() {
    let spec = CurveCatalog.specs[0]
    let params = CurveParameters(defaults: spec.defaults)
    let detailScale = 0.75
    let progress = 0.4

    let first = CurveEngine.particle(
      spec: spec,
      parameters: params,
      index: 0,
      progress: progress,
      detailScale: detailScale
    )
    let middle = CurveEngine.particle(
      spec: spec,
      parameters: params,
      index: 20,
      progress: progress,
      detailScale: detailScale
    )
    let last = CurveEngine.particle(
      spec: spec,
      parameters: params,
      index: Int(params["particleCount"]) - 1,
      progress: progress,
      detailScale: detailScale
    )

    XCTAssertGreaterThan(first.opacity, middle.opacity)
    XCTAssertGreaterThan(middle.opacity, last.opacity)
    XCTAssertGreaterThan(first.radius, middle.radius)
    XCTAssertGreaterThan(middle.radius, last.radius)
  }
}
