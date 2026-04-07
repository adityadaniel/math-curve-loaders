import XCTest

@testable import MathCurveKit

final class CurveDetailStateTests: XCTestCase {
  func testUpdateAndReset() {
    let spec = CurveCatalog.specs[0]
    let state = CurveDetailState(spec: spec, globalControls: CurveCatalog.globalControls)

    let original = state.value(for: "particleCount")
    state.updateValue(for: "particleCount", rawValue: original + 5)

    XCTAssertNotEqual(state.value(for: "particleCount"), original)

    state.reset()
    XCTAssertEqual(state.value(for: "particleCount"), original)
  }

  func testFormulaAndCodeArePopulated() {
    let spec = CurveCatalog.specs[0]
    let state = CurveDetailState(spec: spec, globalControls: CurveCatalog.globalControls)

    XCTAssertFalse(state.formulaText.isEmpty)
    XCTAssertFalse(state.codeText.isEmpty)
    XCTAssertTrue(state.codeText.contains(spec.name))
  }
}
