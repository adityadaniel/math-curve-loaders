import Foundation

public enum CurveCatalog {
  public static let globalControls: [CurveControl] = [
    CurveControl(
      key: "particleCount",
      label: "Particles",
      min: 24,
      max: 140,
      step: 1,
      format: .integer
    ),
    CurveControl(
      key: "trailSpan",
      label: "Trail",
      min: 0.12,
      max: 0.68,
      step: 0.01,
      format: .fixed(2)
    ),
    CurveControl(
      key: "durationMs",
      label: "Loop",
      min: 2400,
      max: 12_000,
      step: 100,
      format: .durationMs
    ),
    CurveControl(
      key: "pulseDurationMs",
      label: "Pulse",
      min: 1800,
      max: 10_000,
      step: 100,
      format: .durationMs
    ),
    CurveControl(
      key: "rotationDurationMs",
      label: "Rotate",
      min: 6000,
      max: 60_000,
      step: 500,
      format: .durationMs
    ),
    CurveControl(
      key: "strokeWidth",
      label: "Stroke",
      min: 2.5,
      max: 7.5,
      step: 0.1,
      format: .fixed(2)
    ),
  ]

  public static let specs: [CurveSpec] =
    roseAndThinkingCurves + classicCurves + spiralCurves + expressiveCurves

  public static func spec(for style: CurveLoaderStyle) -> CurveSpec {
    guard let spec = specByID[style.specID] else {
      preconditionFailure("Missing curve spec mapping for style '\(style)'")
    }
    return spec
  }

  internal static func defaults(
    particleCount: Double,
    trailSpan: Double,
    durationMs: Double,
    rotationDurationMs: Double,
    pulseDurationMs: Double,
    strokeWidth: Double,
    custom: [String: Double] = [:]
  ) -> [String: Double] {
    var values: [String: Double] = [
      "particleCount": particleCount,
      "trailSpan": trailSpan,
      "durationMs": durationMs,
      "rotationDurationMs": rotationDurationMs,
      "pulseDurationMs": pulseDurationMs,
      "strokeWidth": strokeWidth,
    ]

    for (key, value) in custom {
      values[key] = value
    }

    return values
  }

  internal static func f(_ value: Double, _ decimals: Int = 1) -> String {
    String(format: "%.*f", decimals, value)
  }

  private static let specByID: [String: CurveSpec] = {
    var map: [String: CurveSpec] = [:]
    for spec in specs {
      map[spec.id] = spec
    }
    return map
  }()
}
