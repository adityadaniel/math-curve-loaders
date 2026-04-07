import XCTest

@testable import MathCurveKit

final class CurveParityTests: XCTestCase {
  private let progress = 0.3141592653589793
  private let detailScale = 0.777

  private let expectedPoints: [String: (Double, Double)] = [
    "original-thinking": (36.433081, 66.481423),
    "thinking-five": (47.496587, 79.023450),
    "thinking-nine": (35.039824, 83.147630),
    "rose-orbit": (40.299171, 72.746206),
    "rose-curve": (60.430056, 25.543924),
    "rose-two": (57.998127, 31.246237),
    "rose-three": (39.192004, 75.342257),
    "rose-four": (50.481704, 48.870516),
    "lissajous-drift": (76.802204, 76.346115),
    "lemniscate-bloom": (44.594254, 45.027580),
    "hypotrochoid-loop": (26.675172, 67.786192),
    "three-petal-spiral": (42.362061, 60.568188),
    "four-petal-spiral": (54.617420, 59.915648),
    "five-petal-spiral": (45.659616, 51.243939),
    "six-petal-spiral": (37.647266, 65.230815),
    "butterfly-phase": (38.048094, 63.549153),
    "cardioid-glow": (39.405874, 74.840781),
    "cardioid-heart": (38.676816, 54.829125),
    "heart-wave": (34.335524, 76.133244),
    "spiral-search": (49.064862, 72.411351),
    "fourier-flow": (50.322814, 54.570802),
  ]

  func testCatalogCount() {
    XCTAssertEqual(CurveCatalog.specs.count, 21)
  }

  func testDefaultPointParity() {
    for spec in CurveCatalog.specs {
      guard let expected = expectedPoints[spec.id] else {
        XCTFail("Missing baseline point for \(spec.id)")
        continue
      }

      let parameters = CurveParameters(defaults: spec.defaults)
      let point = spec.point(progress, detailScale, parameters)
      XCTAssertEqual(point.x, expected.0, accuracy: 0.000001, "x mismatch for \(spec.id)")
      XCTAssertEqual(point.y, expected.1, accuracy: 0.000001, "y mismatch for \(spec.id)")
    }
  }
}
