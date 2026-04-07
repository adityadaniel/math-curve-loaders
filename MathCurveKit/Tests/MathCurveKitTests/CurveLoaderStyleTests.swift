import XCTest
@testable import MathCurveKit

final class CurveLoaderStyleTests: XCTestCase {
  func testAllStylesMapToValidSpecs() {
    XCTAssertEqual(CurveLoaderStyle.allCases.count, 21)

    for style in CurveLoaderStyle.allCases {
      let spec = CurveCatalog.spec(for: style)
      XCTAssertFalse(spec.id.isEmpty)
    }
  }

  func testRoseAliasMapsToRoseCurveSpec() {
    XCTAssertEqual(CurveCatalog.spec(for: .rose).id, "rose-curve")
  }

  func testStyleInitUsesDefaultParameters() {
    let spec = CurveCatalog.spec(for: .rose)
    let view = CurveLoaderView(style: .rose)
    let resolved = view.resolvedParameters()

    for (key, defaultValue) in spec.defaults {
      XCTAssertEqual(
        resolved[key],
        defaultValue,
        accuracy: 0.000001,
        "default mismatch for key '\(key)'"
      )
    }
  }

  func testConfigureValuesAreClampedAndQuantized() {
    let view = CurveLoaderView(style: .rose) { params in
      params["particleCount"] = 999
      params["strokeWidth"] = 0.1
      params["trailSpan"] = 0.124
    }

    let resolved = view.resolvedParameters()
    XCTAssertEqual(resolved["particleCount"], 140)
    XCTAssertEqual(resolved["strokeWidth"], 2.5, accuracy: 0.000001)
    XCTAssertEqual(resolved["trailSpan"], 0.12, accuracy: 0.000001)
  }

  func testModifiersOverrideConfiguredValuesWithLastWins() {
    let view = CurveLoaderView(style: .rose) { params in
      params["particleCount"] = 30
    }
    .curveParticleCount(60)
    .curveParticleCount(84)
    .curveStrokeWidth(6.06)

    let resolved = view.resolvedParameters()
    XCTAssertEqual(resolved["particleCount"], 84)
    XCTAssertEqual(resolved["strokeWidth"], 6.1, accuracy: 0.000001)
  }

  func testUnknownGenericControlOverrideIsIgnored() {
    let spec = CurveCatalog.spec(for: .rose)
    let defaultParticleCount = try! XCTUnwrap(spec.defaults["particleCount"])
    let defaultStrokeWidth = try! XCTUnwrap(spec.defaults["strokeWidth"])

    let view = CurveLoaderView(style: .rose)
      .curveControl("unknownKey", value: 999)

    let resolved = view.resolvedParameters()
    XCTAssertEqual(
      resolved["particleCount"],
      defaultParticleCount,
      accuracy: 0.000001
    )
    XCTAssertEqual(
      resolved["strokeWidth"],
      defaultStrokeWidth,
      accuracy: 0.000001
    )
  }
}
