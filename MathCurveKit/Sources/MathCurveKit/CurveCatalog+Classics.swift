import Foundation

extension CurveCatalog {
  internal static let classicCurves: [CurveSpec] = [
    makeLissajousDrift(),
    makeLemniscateBloom(),
    makeHypotrochoidLoop(),
  ]

  private static func makeLissajousDrift() -> CurveSpec {
    let defaults = defaults(
      particleCount: 68,
      trailSpan: 0.34,
      durationMs: 6000,
      rotationDurationMs: 36_000,
      pulseDurationMs: 5400,
      strokeWidth: 4.7,
      custom: [
        "lissajousAmp": 24,
        "lissajousAmpBoost": 6,
        "lissajousAX": 3,
        "lissajousBY": 4,
        "lissajousPhase": 1.57,
        "lissajousYScale": 0.92,
      ]
    )

    return CurveSpec(
      id: "lissajous-drift",
      name: "Lissajous Drift",
      tag: "x = sin(at), y = sin(bt)",
      description: "Two-frequency oscillator with phase-shifted weave.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(
          key: "lissajousAmp",
          label: "Amplitude",
          min: 8,
          max: 36,
          step: 0.5,
          format: .fixed(1)
        ),
        CurveControl(
          key: "lissajousAmpBoost",
          label: "Amp pulse",
          min: 0,
          max: 12,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(key: "lissajousAX", label: "a", min: 1, max: 8, step: 1, format: .integer),
        CurveControl(key: "lissajousBY", label: "b", min: 1, max: 8, step: 1, format: .integer),
        CurveControl(
          key: "lissajousYScale",
          label: "Y scale",
          min: 0.4,
          max: 1.4,
          step: 0.01,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "A = \(f(p.value("lissajousAmp"))) + \(f(p.value("lissajousAmpBoost")))s",
          "x(t) = 50 + sin(\(p.integer("lissajousAX"))t + \(f(p.value("lissajousPhase"), 2))) · A",
          "y(t) = 50 + sin(\(p.integer("lissajousBY"))t) · \(f(p.value("lissajousYScale"), 2))A",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* lissajous */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let amp = p.value("lissajousAmp") + detailScale * p.value("lissajousAmpBoost")
        return point(
          50 + sin(Double(p.integer("lissajousAX")) * t + p.value("lissajousPhase")) * amp,
          50 + sin(Double(p.integer("lissajousBY")) * t) * (amp * p.value("lissajousYScale"))
        )
      }
    )
  }

  private static func makeLemniscateBloom() -> CurveSpec {
    let defaults = defaults(
      particleCount: 70,
      trailSpan: 0.40,
      durationMs: 5600,
      rotationDurationMs: 34_000,
      pulseDurationMs: 5000,
      strokeWidth: 4.8,
      custom: ["lemniscateA": 20, "lemniscateBoost": 7]
    )

    return CurveSpec(
      id: "lemniscate-bloom",
      name: "Lemniscate Bloom",
      tag: "Bernoulli Lemniscate",
      description: "Infinity loop with pulsing scale.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(key: "lemniscateA", label: "a", min: 8, max: 30, step: 0.5, format: .fixed(1)),
        CurveControl(
          key: "lemniscateBoost",
          label: "Pulse",
          min: 0,
          max: 12,
          step: 0.1,
          format: .fixed(1)
        ),
      ],
      formula: { p in
        [
          "a = \(f(p.value("lemniscateA"))) + \(f(p.value("lemniscateBoost")))s",
          "x(t) = 50 + a cos t / (1 + sin² t)",
          "y(t) = 50 + a sin t cos t / (1 + sin² t)",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* lemniscate */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let scale = p.value("lemniscateA") + detailScale * p.value("lemniscateBoost")
        let denom = 1 + pow(sin(t), 2)
        return point(
          50 + scale * cos(t) / denom,
          50 + scale * sin(t) * cos(t) / denom
        )
      }
    )
  }

  private static func makeHypotrochoidLoop() -> CurveSpec {
    let defaults = defaults(
      particleCount: 82,
      trailSpan: 0.46,
      durationMs: 7600,
      rotationDurationMs: 42_000,
      pulseDurationMs: 6200,
      strokeWidth: 4.6,
      custom: [
        "spiroR": 8.2,
        "spiror": 2.7,
        "spirorBoost": 0.45,
        "spirod": 4.8,
        "spirodBoost": 1.2,
        "spiroScale": 3.05,
      ]
    )

    return CurveSpec(
      id: "hypotrochoid-loop",
      name: "Hypotrochoid Loop",
      tag: "Inner Spirograph",
      description: "Inner rolling-circle curve with breathing r/d terms.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(key: "spiroR", label: "R", min: 4, max: 12, step: 0.1, format: .fixed(1)),
        CurveControl(key: "spiror", label: "r", min: 1, max: 5, step: 0.1, format: .fixed(1)),
        CurveControl(key: "spirod", label: "d", min: 1, max: 8, step: 0.1, format: .fixed(1)),
        CurveControl(
          key: "spiroScale",
          label: "Scale",
          min: 1.5,
          max: 4.5,
          step: 0.05,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "x(t) = 50 + ((R-r) cos t + d cos((R-r)t/r)) · \(f(p.value("spiroScale"), 2))",
          "y(t) = 50 + ((R-r) sin t - d sin((R-r)t/r)) · \(f(p.value("spiroScale"), 2))",
          "R = \(f(p.value("spiroR"))), r = \(f(p.value("spiror"))) + \(f(p.value("spirorBoost"), 2))s, d = \(f(p.value("spirod"))) + \(f(p.value("spirodBoost")))s",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* hypotrochoid */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let r = p.value("spiror") + detailScale * p.value("spirorBoost")
        let d = p.value("spirod") + detailScale * p.value("spirodBoost")
        let x = (p.value("spiroR") - r) * cos(t) + d * cos(((p.value("spiroR") - r) / r) * t)
        let y = (p.value("spiroR") - r) * sin(t) - d * sin(((p.value("spiroR") - r) / r) * t)
        return point(50 + x * p.value("spiroScale"), 50 + y * p.value("spiroScale"))
      }
    )
  }
}
