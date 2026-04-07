import Foundation

extension CurveCatalog {
  internal static let roseAndThinkingCurves: [CurveSpec] = [
    makeThinkingSpec(
      id: "original-thinking",
      name: "Original Thinking",
      petalCount: 7,
      particleCount: 64,
      trailSpan: 0.38,
      durationMs: 4600,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4200,
      strokeWidth: 5.5
    ),
    makeThinkingSpec(
      id: "thinking-five",
      name: "Thinking Five",
      petalCount: 5,
      particleCount: 62,
      trailSpan: 0.38,
      durationMs: 4600,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4200,
      strokeWidth: 5.5
    ),
    makeThinkingSpec(
      id: "thinking-nine",
      name: "Thinking Nine",
      petalCount: 9,
      particleCount: 68,
      trailSpan: 0.39,
      durationMs: 4700,
      rotationDurationMs: 30_000,
      pulseDurationMs: 4200,
      strokeWidth: 5.5
    ),
    makeRoseOrbit(),
    makeRoseCurve(),
    makeRoseVariant(
      id: "rose-two",
      name: "Rose Two",
      tag: "r = a cos(2θ)",
      fixedK: 2,
      particleCount: 74,
      trailSpan: 0.30,
      durationMs: 5200,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4300,
      strokeWidth: 4.6
    ),
    makeRoseVariant(
      id: "rose-three",
      name: "Rose Three",
      tag: "r = a cos(3θ)",
      fixedK: 3,
      particleCount: 76,
      trailSpan: 0.31,
      durationMs: 5300,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4400,
      strokeWidth: 4.6
    ),
    makeRoseVariant(
      id: "rose-four",
      name: "Rose Four",
      tag: "r = a cos(4θ)",
      fixedK: 4,
      particleCount: 78,
      trailSpan: 0.32,
      durationMs: 5400,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4500,
      strokeWidth: 4.6
    ),
  ]

  private static func makeThinkingSpec(
    id: String,
    name: String,
    petalCount: Double,
    particleCount: Double,
    trailSpan: Double,
    durationMs: Double,
    rotationDurationMs: Double,
    pulseDurationMs: Double,
    strokeWidth: Double
  ) -> CurveSpec {
    let defaults = defaults(
      particleCount: particleCount,
      trailSpan: trailSpan,
      durationMs: durationMs,
      rotationDurationMs: rotationDurationMs,
      pulseDurationMs: pulseDurationMs,
      strokeWidth: strokeWidth,
      custom: [
        "baseRadius": 7,
        "detailAmplitude": 3,
        "petalCount": petalCount,
        "curveScale": 3.9,
      ]
    )

    return CurveSpec(
      id: id,
      name: name,
      tag: "Custom Rose Trail",
      description: "A rose-like orbit built by combining base and petal harmonics.",
      rotate: true,
      defaults: defaults,
      controls: [
        CurveControl(
          key: "baseRadius",
          label: "Base radius",
          min: 4,
          max: 10,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "detailAmplitude",
          label: "Detail",
          min: 1,
          max: 5,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "petalCount",
          label: "Petals",
          min: 3,
          max: 12,
          step: 1,
          format: .integer
        ),
        CurveControl(
          key: "curveScale",
          label: "Scale",
          min: 2.5,
          max: 5.5,
          step: 0.1,
          format: .fixed(1)
        ),
      ],
      formula: { p in
        [
          "x(t) = 50 + (\(f(p.value("baseRadius"))) cos t - \(f(p.value("detailAmplitude")))s cos \(p.integer("petalCount"))t) * \(f(p.value("curveScale")))",
          "y(t) = 50 + (\(f(p.value("baseRadius"))) sin t - \(f(p.value("detailAmplitude")))s sin \(p.integer("petalCount"))t) * \(f(p.value("curveScale")))",
          "s = detailScale(time)",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* rose trail */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let petals = Double(p.integer("petalCount"))
        let x =
          p.value("baseRadius") * cos(t) - p.value("detailAmplitude") * detailScale
          * cos(petals * t)
        let y =
          p.value("baseRadius") * sin(t) - p.value("detailAmplitude") * detailScale
          * sin(petals * t)
        return point(50 + x * p.value("curveScale"), 50 + y * p.value("curveScale"))
      }
    )
  }

  private static func makeRoseOrbit() -> CurveSpec {
    let defaults = defaults(
      particleCount: 72,
      trailSpan: 0.42,
      durationMs: 5200,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4600,
      strokeWidth: 5.2,
      custom: [
        "orbitRadius": 7,
        "detailAmplitude": 2.7,
        "petalCount": 7,
        "curveScale": 3.9,
      ]
    )

    return CurveSpec(
      id: "rose-orbit",
      name: "Rose Orbit",
      tag: "r = cos(kθ)",
      description: "A radial rose orbit with pulsing petal depth.",
      rotate: true,
      defaults: defaults,
      controls: [
        CurveControl(
          key: "orbitRadius",
          label: "Base radius",
          min: 4,
          max: 10,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "detailAmplitude",
          label: "Detail",
          min: 1,
          max: 5,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(key: "petalCount", label: "k", min: 3, max: 12, step: 1, format: .integer),
        CurveControl(
          key: "curveScale",
          label: "Scale",
          min: 2.5,
          max: 5.5,
          step: 0.1,
          format: .fixed(1)
        ),
      ],
      formula: { p in
        [
          "r(t) = \(f(p.value("orbitRadius"))) - \(f(p.value("detailAmplitude")))s cos(\(p.integer("petalCount"))t)",
          "x(t) = 50 + cos t · r(t) · \(f(p.value("curveScale")))",
          "y(t) = 50 + sin t · r(t) · \(f(p.value("curveScale")))",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* rose orbit */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let k = Double(p.integer("petalCount"))
        let r = p.value("orbitRadius") - p.value("detailAmplitude") * detailScale * cos(k * t)
        return point(
          50 + cos(t) * r * p.value("curveScale"),
          50 + sin(t) * r * p.value("curveScale")
        )
      }
    )
  }

  private static func makeRoseCurve() -> CurveSpec {
    let defaults = defaults(
      particleCount: 78,
      trailSpan: 0.32,
      durationMs: 5400,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4600,
      strokeWidth: 4.5,
      custom: [
        "roseA": 9.2,
        "roseABoost": 0.6,
        "roseBreathBase": 0.72,
        "roseBreathBoost": 0.28,
        "roseK": 5,
        "roseScale": 3.25,
      ]
    )

    return CurveSpec(
      id: "rose-curve",
      name: "Rose Curve",
      tag: "r = a cos(kθ)",
      description: "Generalized rose with breathing amplitude.",
      rotate: true,
      defaults: defaults,
      controls: [
        CurveControl(key: "roseA", label: "a", min: 5, max: 14, step: 0.1, format: .fixed(1)),
        CurveControl(
          key: "roseABoost",
          label: "a boost",
          min: 0,
          max: 2,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "roseBreathBase",
          label: "Base pulse",
          min: 0.3,
          max: 1.2,
          step: 0.01,
          format: .fixed(2)
        ),
        CurveControl(
          key: "roseBreathBoost",
          label: "Pulse boost",
          min: 0,
          max: 0.8,
          step: 0.01,
          format: .fixed(2)
        ),
        CurveControl(key: "roseK", label: "k", min: 2, max: 10, step: 1, format: .integer),
        CurveControl(
          key: "roseScale",
          label: "Scale",
          min: 2,
          max: 5,
          step: 0.05,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "r(t) = (\(f(p.value("roseA"))) + \(f(p.value("roseABoost"), 2))s)(\(f(p.value("roseBreathBase"), 2)) + \(f(p.value("roseBreathBoost"), 2))s) cos(\(p.integer("roseK"))t)",
          "x(t) = 50 + cos t · r(t) · \(f(p.value("roseScale"), 2))",
          "y(t) = 50 + sin t · r(t) · \(f(p.value("roseScale"), 2))",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* rose k */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let a = p.value("roseA") + detailScale * p.value("roseABoost")
        let k = Double(p.integer("roseK"))
        let r =
          a * (p.value("roseBreathBase") + detailScale * p.value("roseBreathBoost")) * cos(k * t)
        return point(50 + cos(t) * r * p.value("roseScale"), 50 + sin(t) * r * p.value("roseScale"))
      }
    )
  }

  private static func makeRoseVariant(
    id: String,
    name: String,
    tag: String,
    fixedK: Double,
    particleCount: Double,
    trailSpan: Double,
    durationMs: Double,
    rotationDurationMs: Double,
    pulseDurationMs: Double,
    strokeWidth: Double
  ) -> CurveSpec {
    let defaults = defaults(
      particleCount: particleCount,
      trailSpan: trailSpan,
      durationMs: durationMs,
      rotationDurationMs: rotationDurationMs,
      pulseDurationMs: pulseDurationMs,
      strokeWidth: strokeWidth,
      custom: [
        "roseA": 9.2,
        "roseABoost": 0.6,
        "roseBreathBase": 0.72,
        "roseBreathBoost": 0.28,
        "roseScale": 3.25,
      ]
    )

    return CurveSpec(
      id: id,
      name: name,
      tag: tag,
      description: "Fixed-frequency rose variant with pulsing core.",
      rotate: true,
      defaults: defaults,
      controls: [
        CurveControl(key: "roseA", label: "a", min: 5, max: 14, step: 0.1, format: .fixed(1)),
        CurveControl(
          key: "roseABoost",
          label: "a boost",
          min: 0,
          max: 2,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "roseBreathBase",
          label: "Base pulse",
          min: 0.3,
          max: 1.2,
          step: 0.01,
          format: .fixed(2)
        ),
        CurveControl(
          key: "roseBreathBoost",
          label: "Pulse boost",
          min: 0,
          max: 0.8,
          step: 0.01,
          format: .fixed(2)
        ),
        CurveControl(
          key: "roseScale",
          label: "Scale",
          min: 2,
          max: 5,
          step: 0.05,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "r(t) = (\(f(p.value("roseA"))) + \(f(p.value("roseABoost"), 2))s)(\(f(p.value("roseBreathBase"), 2)) + \(f(p.value("roseBreathBoost"), 2))s) cos(\(Int(fixedK))t)",
          "x(t) = 50 + cos t · r(t) · \(f(p.value("roseScale"), 2))",
          "y(t) = 50 + sin t · r(t) · \(f(p.value("roseScale"), 2))",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* rose fixed k */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let a = p.value("roseA") + detailScale * p.value("roseABoost")
        let r =
          a * (p.value("roseBreathBase") + detailScale * p.value("roseBreathBoost"))
          * cos(fixedK * t)
        return point(50 + cos(t) * r * p.value("roseScale"), 50 + sin(t) * r * p.value("roseScale"))
      }
    )
  }
}
