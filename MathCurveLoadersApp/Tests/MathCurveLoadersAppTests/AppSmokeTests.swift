import MathCurveKit
import XCTest

@testable import MathCurveLoadersApp

final class AppSmokeTests: XCTestCase {
  func testRootViewCanBeConstructed() {
    _ = RootView()
  }

  func testDetailScreenCanBeConstructedForEveryCurve() {
    XCTAssertEqual(CurveCatalog.specs.count, 21)

    for spec in CurveCatalog.specs {
      _ = CurveDetailScreen(spec: spec)
    }
  }
}
