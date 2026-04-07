import CoreGraphics
import Foundation

public enum CurveEngine {
  public static func normalizeProgress(_ progress: Double) -> Double {
    ((progress.truncatingRemainder(dividingBy: 1)) + 1).truncatingRemainder(dividingBy: 1)
  }

  public static func buildPath(
    spec: CurveSpec,
    parameters: CurveParameters,
    detailScale: Double,
    steps: Int = 480
  ) -> [CGPoint] {
    guard steps > 0 else { return [] }

    return (0...steps).map { index in
      let progress = Double(index) / Double(steps)
      return spec.point(progress, detailScale, parameters)
    }
  }

  public static func particle(
    spec: CurveSpec,
    parameters: CurveParameters,
    index: Int,
    progress: Double,
    detailScale: Double
  ) -> ParticleSample {
    let particleCount = max(1, Int(parameters["particleCount"].rounded()))
    let denominator = max(1, particleCount - 1)
    let tailOffset = Double(index) / Double(denominator)
    let trailSpan = parameters["trailSpan"]
    let offsetProgress = normalizeProgress(progress - tailOffset * trailSpan)
    let point = spec.point(offsetProgress, detailScale, parameters)
    let fade = pow(1 - tailOffset, 0.56)

    return ParticleSample(
      point: point,
      radius: 0.9 + fade * 2.7,
      opacity: 0.04 + fade * 0.96
    )
  }

  public static func detailScale(
    timeMs: Double,
    pulseDurationMs: Double,
    phaseOffset: Double
  ) -> Double {
    guard pulseDurationMs > 0 else { return 1 }

    let phaseTime = timeMs + phaseOffset * pulseDurationMs
    let pulseProgress = normalizeProgress(phaseTime / pulseDurationMs)
    let pulseAngle = pulseProgress * .pi * 2
    return 0.52 + ((sin(pulseAngle + 0.55) + 1) / 2) * 0.48
  }

  public static func rotation(
    timeMs: Double,
    rotationDurationMs: Double,
    phaseOffset: Double,
    rotate: Bool
  ) -> Double {
    guard rotate, rotationDurationMs > 0 else { return 0 }

    let phaseTime = timeMs + phaseOffset * rotationDurationMs
    return -normalizeProgress(phaseTime / rotationDurationMs) * 360
  }

  public static func runtime(
    spec: CurveSpec,
    parameters: CurveParameters,
    elapsedMs: Double,
    phaseOffset: Double
  ) -> CurveRuntime {
    let durationMs = max(1, parameters["durationMs"])
    let progress = normalizeProgress((elapsedMs + phaseOffset * durationMs) / durationMs)
    let detail = detailScale(
      timeMs: elapsedMs,
      pulseDurationMs: parameters["pulseDurationMs"],
      phaseOffset: phaseOffset
    )
    let rotation = rotation(
      timeMs: elapsedMs,
      rotationDurationMs: parameters["rotationDurationMs"],
      phaseOffset: phaseOffset,
      rotate: spec.rotate
    )

    return CurveRuntime(progress: progress, detailScale: detail, rotationDegrees: rotation)
  }
}
