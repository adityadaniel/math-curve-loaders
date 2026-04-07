import XCTest

@testable import MathCurveKit

final class CurveParameterTests: XCTestCase {
  func testClampAndQuantizeIntegerControl() {
    var parameters = CurveParameters(defaults: ["particleCount": 64])
    let control = CurveControl(
      key: "particleCount",
      label: "Particles",
      min: 24,
      max: 140,
      step: 1,
      format: .integer
    )

    parameters.setValue("particleCount", rawValue: 141.2, controls: [control])
    XCTAssertEqual(parameters["particleCount"], 140)

    parameters.setValue("particleCount", rawValue: 42.7, controls: [control])
    XCTAssertEqual(parameters["particleCount"], 43)
  }

  func testClampAndQuantizeDecimalControl() {
    var parameters = CurveParameters(defaults: ["trailSpan": 0.38])
    let control = CurveControl(
      key: "trailSpan",
      label: "Trail",
      min: 0.12,
      max: 0.68,
      step: 0.01,
      format: .fixed(2)
    )

    parameters.setValue("trailSpan", rawValue: 0.684, controls: [control])
    XCTAssertEqual(parameters["trailSpan"], 0.68, accuracy: 0.000001)

    parameters.setValue("trailSpan", rawValue: 0.125, controls: [control])
    XCTAssertEqual(parameters["trailSpan"], 0.13, accuracy: 0.000001)
  }

  func testUnknownKeyWritesRawValue() {
    var parameters = CurveParameters(defaults: [:])
    parameters.setValue("custom", rawValue: 12.34, controls: [])
    XCTAssertEqual(parameters["custom"], 12.34)
  }

  func testDurationFormattingMatchesWebStyle() {
    let control = CurveControl(
      key: "durationMs",
      label: "Loop",
      min: 2400,
      max: 12_000,
      step: 100,
      format: .durationMs
    )

    XCTAssertEqual(control.formatValue(4600), "4.6s")
  }
}
