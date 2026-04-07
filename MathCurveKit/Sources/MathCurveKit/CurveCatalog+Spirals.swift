import Foundation

extension CurveCatalog {
  internal static let spiralCurves: [CurveSpec] = [
    makePetalSpiral(
      id: "three-petal-spiral",
      name: "Three-Petal Spiral",
      tag: "R = 3, r = 1, d = 3",
      spiralR: 3,
      particleCount: 82
    ),
    makePetalSpiral(
      id: "four-petal-spiral",
      name: "Four-Petal Spiral",
      tag: "R = 4, r = 1, d = 3",
      spiralR: 4,
      particleCount: 84
    ),
    makePetalSpiral(
      id: "five-petal-spiral",
      name: "Five-Petal Spiral",
      tag: "R = 5, r = 1, d = 3",
      spiralR: 5,
      particleCount: 85
    ),
    makePetalSpiral(
      id: "six-petal-spiral",
      name: "Six-Petal Spiral",
      tag: "R = 6, r = 1, d = 3",
      spiralR: 6,
      particleCount: 86
    ),
  ]

  private static func makePetalSpiral(
    id: String,
    name: String,
    tag: String,
    spiralR: Double,
    particleCount: Double
  ) -> CurveSpec {
    let defaults = defaults(
      particleCount: particleCount,
      trailSpan: 0.34,
      durationMs: 4600,
      rotationDurationMs: 28_000,
      pulseDurationMs: 4200,
      strokeWidth: 4.4,
      custom: [
        "spiralR": spiralR,
        "spiralr": 1,
        "spirald": 3,
        "spiralScale": 2.2,
        "spiralBreath": 0.45,
      ]
    )

    return CurveSpec(
      id: id,
      name: name,
      tag: tag,
      description: "Rolling-circle spiral flower with unified breathing.",
      rotate: true,
      defaults: defaults,
      controls: [
        CurveControl(key: "spiralR", label: "R", min: 2, max: 8, step: 1, format: .integer),
        CurveControl(key: "spiralr", label: "r", min: 1, max: 3, step: 0.1, format: .fixed(1)),
        CurveControl(key: "spirald", label: "d", min: 1, max: 5, step: 0.1, format: .fixed(1)),
        CurveControl(
          key: "spiralScale",
          label: "Scale",
          min: 1.2,
          max: 3.5,
          step: 0.05,
          format: .fixed(2)
        ),
        CurveControl(
          key: "spiralBreath",
          label: "Pulse",
          min: 0,
          max: 1,
          step: 0.05,
          format: .fixed(2)
        ),
      ],
      formula: { p in
        [
          "u(t) = ((R-r) cos t + d cos((R-r)t/r), (R-r) sin t - d sin((R-r)t/r))",
          "m(t) = \(f(p.value("spiralScale"), 2)) + \(f(p.value("spiralBreath"), 2))s",
          "(x, y) = 50 + u(t) · m(t)",
          "R = \(f(p.value("spiralR"))), r = \(f(p.value("spiralr"))), d = \(f(p.value("spirald")))",
        ].joined(separator: "\n")
      },
      pointCode:
        "func point(progress: Double, detailScale: Double, params: CurveParameters) -> CGPoint { /* petal spiral */ }",
      point: { progress, detailScale, p in
        let t = progress * .pi * 2
        let d = p.value("spirald") + detailScale * 0.25
        let baseX =
          (p.value("spiralR") - p.value("spiralr")) * cos(t) + d
          * cos(((p.value("spiralR") - p.value("spiralr")) / p.value("spiralr")) * t)
        let baseY =
          (p.value("spiralR") - p.value("spiralr")) * sin(t) - d
          * sin(((p.value("spiralR") - p.value("spiralr")) / p.value("spiralr")) * t)
        let scale = p.value("spiralScale") + detailScale * p.value("spiralBreath")
        return point(50 + baseX * scale, 50 + baseY * scale)
      }
    )
  }
}
