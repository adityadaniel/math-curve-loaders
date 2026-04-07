import Foundation

extension CurveCatalog {
  internal static let expressiveCurves: [CurveSpec] = [
    makeButterflyPhase(),
    makeCardioidGlow(),
    makeCardioidHeart(),
    makeHeartWave(),
    makeSpiralSearch(),
    makeFourierFlow(),
  ]

  private static func makeButterflyPhase() -> CurveSpec {
    let defaults = defaults(
      particleCount: 88,
      trailSpan: 0.32,
      durationMs: 9000,
      rotationDurationMs: 50_000,
      pulseDurationMs: 7000,
      strokeWidth: 4.4,
      custom: [
        "butterflyTurns": 12,
        "butterflyScale": 4.6,
        "butterflyPulse": 0.45,
        "butterflyCosWeight": 2,
        "butterflyPower": 5,
      ]
    )

    return CurveSpec(
      id: "butterfly-phase",
      name: "Butterfly Phase",
      tag: "Butterfly Curve",
      description: "A parametric butterfly with pulsing scale.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(
          key: "butterflyTurns",
          label: "Turns",
          min: 6,
          max: 18,
          step: 0.5,
          format: .fixed(1)
        ),
        CurveControl(
          key: "butterflyScale",
          label: "Scale",
          min: 2.5,
          max: 7,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "butterflyPulse",
          label: "Pulse",
          min: 0,
          max: 1.2,
          step: 0.01,
          format: .fixed(2)
        ),
        CurveControl(
          key: "butterflyCosWeight",
          label: "Cos weight",
          min: 0.5,
          max: 4,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "butterflyPower",
          label: "Power",
          min: 2,
          max: 8,
          step: 1,
          format: .integer
        ),
      ],
      formula: { p in
        [
          "u = \(f(p.value("butterflyTurns")))t",
          "B(u) = e^{cos u} - \(f(p.value("butterflyCosWeight"), 2)) cos 4u - sin^\(p.integer("butterflyPower"))(u/12)",
          "x(t) = 50 + sin u · B(u) · (\(f(p.value("butterflyScale"), 2)) + \(f(p.value("butterflyPulse"), 2))s)",
          "y(t) = 50 + cos u · B(u) · (\(f(p.value("butterflyScale"), 2)) + \(f(p.value("butterflyPulse"), 2))s)",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* butterfly */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * p.value("butterflyTurns")
        let exponent = Double(p.integer("butterflyPower"))
        let s =
          exp(cos(t)) - p.value("butterflyCosWeight") * cos(4 * t) - pow(sin(t / 12), exponent)
        let scale = p.value("butterflyScale") + detailScale * p.value("butterflyPulse")
        return point(50 + sin(t) * s * scale, 50 + cos(t) * s * scale)
      }
    )
  }

  private static func makeCardioidGlow() -> CurveSpec {
    let defaults = defaults(
      particleCount: 72,
      trailSpan: 0.36,
      durationMs: 6200,
      rotationDurationMs: 36_000,
      pulseDurationMs: 5200,
      strokeWidth: 4.9,
      custom: ["cardioidA": 8.4, "cardioidPulse": 0.8, "cardioidScale": 2.15]
    )

    return CurveSpec(
      id: "cardioid-glow",
      name: "Cardioid Glow",
      tag: "Cardioid",
      description: "Classic cardioid with breathing radius.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(key: "cardioidA", label: "a", min: 4, max: 14, step: 0.1, format: .fixed(1)),
        CurveControl(
          key: "cardioidPulse",
          label: "Pulse",
          min: 0,
          max: 2,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "cardioidScale",
          label: "Scale",
          min: 1,
          max: 3.5,
          step: 0.05,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "a = \(f(p.value("cardioidA"))) + \(f(p.value("cardioidPulse"), 2))s",
          "r(t) = a(1 - cos t)",
          "x(t) = 50 + cos t · r(t) · \(f(p.value("cardioidScale"), 2))",
          "y(t) = 50 + sin t · r(t) · \(f(p.value("cardioidScale"), 2))",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* cardioid glow */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let a = p.value("cardioidA") + detailScale * p.value("cardioidPulse")
        let r = a * (1 - cos(t))
        return point(
          50 + cos(t) * r * p.value("cardioidScale"),
          50 + sin(t) * r * p.value("cardioidScale")
        )
      }
    )
  }

  private static func makeCardioidHeart() -> CurveSpec {
    let defaults = defaults(
      particleCount: 74,
      trailSpan: 0.36,
      durationMs: 6200,
      rotationDurationMs: 36_000,
      pulseDurationMs: 5200,
      strokeWidth: 4.9,
      custom: ["cardioidA": 8.8, "cardioidPulse": 0.8, "cardioidScale": 2.15]
    )

    return CurveSpec(
      id: "cardioid-heart",
      name: "Cardioid Heart",
      tag: "r = a(1 + cosθ)",
      description: "Rotated cardioid to produce an upright heart.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(key: "cardioidA", label: "a", min: 4, max: 14, step: 0.1, format: .fixed(1)),
        CurveControl(
          key: "cardioidPulse",
          label: "Pulse",
          min: 0,
          max: 2,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "cardioidScale",
          label: "Scale",
          min: 1,
          max: 3.5,
          step: 0.05,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "a = \(f(p.value("cardioidA"))) + \(f(p.value("cardioidPulse"), 2))s",
          "r(t) = a(1 + cos t)",
          "x'(t) = -sin t · r(t)",
          "y'(t) = -cos t · r(t), m = \(f(p.value("cardioidScale"), 2))",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* cardioid heart */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let a = p.value("cardioidA") + detailScale * p.value("cardioidPulse")
        let r = a * (1 + cos(t))
        let baseX = cos(t) * r
        let baseY = sin(t) * r
        return point(50 - baseY * p.value("cardioidScale"), 50 - baseX * p.value("cardioidScale"))
      }
    )
  }

  private static func makeHeartWave() -> CurveSpec {
    let defaults = defaults(
      particleCount: 104,
      trailSpan: 0.18,
      durationMs: 8400,
      rotationDurationMs: 22_000,
      pulseDurationMs: 5600,
      strokeWidth: 3.9,
      custom: [
        "heartWaveB": 6.4,
        "heartWaveRoot": 3.3,
        "heartWaveAmp": 0.9,
        "heartWaveScaleX": 23.2,
        "heartWaveScaleY": 24.5,
      ]
    )

    return CurveSpec(
      id: "heart-wave",
      name: "Heart Wave",
      tag: "f(x) Heart Wave",
      description: "Heart-shaped function with internal sine wave.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(key: "heartWaveB", label: "b", min: 2, max: 12, step: 0.1, format: .fixed(1)),
        CurveControl(
          key: "heartWaveRoot",
          label: "Root span",
          min: 2.2,
          max: 4.2,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "heartWaveAmp",
          label: "Wave amp",
          min: 0.3,
          max: 1.6,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "heartWaveScaleX",
          label: "X scale",
          min: 14,
          max: 30,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "heartWaveScaleY",
          label: "Y scale",
          min: 14,
          max: 34,
          step: 0.1,
          format: .fixed(1)
        ),
      ],
      formula: { p in
        [
          "f(x) = |x|^(2/3) + \(f(p.value("heartWaveAmp"), 2))√(\(f(p.value("heartWaveRoot"), 2)) - x²) sin(\(f(p.value("heartWaveB")))πx)",
          "screenX = 50 + x · \(f(p.value("heartWaveScaleX")))",
          "screenY = 18 + (1.75 - f(x))(\(f(p.value("heartWaveScaleY"))) + 1.5s)",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* heart wave */ }",
      point: { progress, detailScale, p in
        let xLimit = sqrt(p.value("heartWaveRoot"))
        let x = -xLimit + progress * xLimit * 2
        let safeRoot = max(0, p.value("heartWaveRoot") - x * x)
        let wave = p.value("heartWaveAmp") * sqrt(safeRoot) * sin(p.value("heartWaveB") * .pi * x)
        let curve = pow(abs(x), 2 / 3.0)
        let y = curve + wave
        let scaleY = p.value("heartWaveScaleY") + detailScale * 1.5
        return point(50 + x * p.value("heartWaveScaleX"), 18 + (1.75 - y) * scaleY)
      }
    )
  }

  private static func makeSpiralSearch() -> CurveSpec {
    let defaults = defaults(
      particleCount: 86,
      trailSpan: 0.28,
      durationMs: 7800,
      rotationDurationMs: 44_000,
      pulseDurationMs: 6800,
      strokeWidth: 4.3,
      custom: [
        "searchTurns": 4,
        "searchBaseRadius": 8,
        "searchRadiusAmp": 8.5,
        "searchPulse": 2.4,
        "searchScale": 1,
      ]
    )

    return CurveSpec(
      id: "spiral-search",
      name: "Spiral Search",
      tag: "Archimedean Spiral",
      description: "Spiral expansion with cosine-modulated radius.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(
          key: "searchTurns",
          label: "Turns",
          min: 2,
          max: 8,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "searchBaseRadius",
          label: "Base radius",
          min: 2,
          max: 16,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "searchRadiusAmp",
          label: "Radius amp",
          min: 2,
          max: 16,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "searchPulse",
          label: "Pulse",
          min: 0,
          max: 6,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "searchScale",
          label: "Scale",
          min: 0.5,
          max: 1.8,
          step: 0.05,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "θ(t) = \(f(p.value("searchTurns")))t",
          "r(t) = \(f(p.value("searchBaseRadius"))) + (1 - cos t)(\(f(p.value("searchRadiusAmp"))) + \(f(p.value("searchPulse")))s)",
          "x(t) = 50 + cos θ · r(t) · \(f(p.value("searchScale"), 2))",
          "y(t) = 50 + sin θ · r(t) · \(f(p.value("searchScale"), 2))",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* spiral search */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let angle = t * p.value("searchTurns")
        let radius =
          p.value("searchBaseRadius") + (1 - cos(t))
          * (p.value("searchRadiusAmp") + detailScale * p.value("searchPulse"))
        return point(
          50 + cos(angle) * radius * p.value("searchScale"),
          50 + sin(angle) * radius * p.value("searchScale")
        )
      }
    )
  }

  private static func makeFourierFlow() -> CurveSpec {
    let defaults = defaults(
      particleCount: 92,
      trailSpan: 0.31,
      durationMs: 8400,
      rotationDurationMs: 44_000,
      pulseDurationMs: 6800,
      strokeWidth: 4.2,
      custom: [
        "fourierX1": 17,
        "fourierX3": 7.5,
        "fourierX5": 3.2,
        "fourierY1": 15,
        "fourierY2": 8.2,
        "fourierY4": 4.2,
        "fourierMixBase": 1,
        "fourierMixPulse": 0.16,
      ]
    )

    return CurveSpec(
      id: "fourier-flow",
      name: "Fourier Flow",
      tag: "Fourier Curve",
      description: "Mixed harmonics that morph over time.",
      rotate: false,
      defaults: defaults,
      controls: [
        CurveControl(
          key: "fourierX1",
          label: "x cos1",
          min: 4,
          max: 24,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "fourierX3",
          label: "x cos3",
          min: 0,
          max: 14,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "fourierX5",
          label: "x sin5",
          min: 0,
          max: 10,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "fourierY1",
          label: "y sin1",
          min: 4,
          max: 24,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "fourierY2",
          label: "y sin2",
          min: 0,
          max: 14,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "fourierY4",
          label: "y cos4",
          min: 0,
          max: 10,
          step: 0.1,
          format: .fixed(1)
        ),
        CurveControl(
          key: "fourierMixPulse",
          label: "Mix pulse",
          min: 0,
          max: 0.8,
          step: 0.01,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "x(t) = 50 + \(f(p.value("fourierX1"))) cos t + \(f(p.value("fourierX3"))) cos(3t + 0.6m) + \(f(p.value("fourierX5"))) sin(5t - 0.4)",
          "y(t) = 50 + \(f(p.value("fourierY1"))) sin t + \(f(p.value("fourierY2"))) sin(2t + 0.25) - \(f(p.value("fourierY4"))) cos(4t - 0.5m)",
          "m = \(f(p.value("fourierMixBase"), 2)) + \(f(p.value("fourierMixPulse"), 2))s",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* fourier */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let mix = p.value("fourierMixBase") + detailScale * p.value("fourierMixPulse")
        let x =
          p.value("fourierX1") * cos(t)
          + p.value("fourierX3") * cos(3 * t + 0.6 * mix)
          + p.value("fourierX5") * sin(5 * t - 0.4)
        let y =
          p.value("fourierY1") * sin(t)
          + p.value("fourierY2") * sin(2 * t + 0.25)
          - p.value("fourierY4") * cos(4 * t - 0.5 * mix)
        return point(50 + x, 50 + y)
      }
    )
  }
}
