import SwiftUI

public struct CurveLoaderView: View {
  public let spec: CurveSpec
  public let parameters: CurveParameters
  public var pathSteps: Int
  public var particleScale: CGFloat
  public var particleOpacityBoost: Double
  public var pathOpacity: Double
  private var controlOverrides: [String: Double] = [:]

  @State private var startDate = Date()
  @State private var phaseOffset = Double.random(in: 0...1)

  public init(
    spec: CurveSpec,
    parameters: CurveParameters,
    pathSteps: Int = 480,
    particleScale: CGFloat = 1,
    particleOpacityBoost: Double = 0,
    pathOpacity: Double = 0.1
  ) {
    self.spec = spec
    self.parameters = parameters
    self.pathSteps = pathSteps
    self.particleScale = particleScale
    self.particleOpacityBoost = particleOpacityBoost
    self.pathOpacity = pathOpacity
  }

  public init(
    style: CurveLoaderStyle,
    configure: ((inout CurveParameters) -> Void)? = nil,
    pathSteps: Int = 480,
    particleScale: CGFloat = 1,
    particleOpacityBoost: Double = 0,
    pathOpacity: Double = 0.1
  ) {
    let resolvedSpec = CurveCatalog.spec(for: style)
    var resolvedParameters = CurveParameters(defaults: resolvedSpec.defaults)
    configure?(&resolvedParameters)

    self.init(
      spec: resolvedSpec,
      parameters: CurveLoaderView.sanitizedParameters(resolvedParameters, for: resolvedSpec),
      pathSteps: pathSteps,
      particleScale: particleScale,
      particleOpacityBoost: particleOpacityBoost,
      pathOpacity: pathOpacity
    )
  }

  public func curveControl(_ key: String, value: Double) -> Self {
    var copy = self
    copy.controlOverrides[key] = value
    return copy
  }

  public func curveParticleCount(_ value: Double) -> Self {
    curveControl("particleCount", value: value)
  }

  public func curveTrailSpan(_ value: Double) -> Self {
    curveControl("trailSpan", value: value)
  }

  public func curveDuration(milliseconds value: Double) -> Self {
    curveControl("durationMs", value: value)
  }

  public func curvePulseDuration(milliseconds value: Double) -> Self {
    curveControl("pulseDurationMs", value: value)
  }

  public func curveRotationDuration(milliseconds value: Double) -> Self {
    curveControl("rotationDurationMs", value: value)
  }

  public func curveStrokeWidth(_ value: Double) -> Self {
    curveControl("strokeWidth", value: value)
  }

  public var body: some View {
    TimelineView(.animation(minimumInterval: 1 / 60)) { timeline in
      Canvas { context, size in
        drawFrame(context: &context, size: size, at: timeline.date)
      }
    }
    .onAppear {
      startDate = Date()
      phaseOffset = Double.random(in: 0...1)
    }
  }

  private func drawFrame(context: inout GraphicsContext, size: CGSize, at date: Date) {
    let runtimeParameters = resolvedParameters()
    let elapsedMs = date.timeIntervalSince(startDate) * 1000
    let runtime = CurveEngine.runtime(
      spec: spec,
      parameters: runtimeParameters,
      elapsedMs: elapsedMs,
      phaseOffset: phaseOffset
    )

    let side = min(size.width, size.height)
    let xPad = (size.width - side) / 2
    let yPad = (size.height - side) / 2

    context.translateBy(x: xPad, y: yPad)
    context.scaleBy(x: side / 100, y: side / 100)
    context.translateBy(x: 50, y: 50)
    context.rotate(by: .degrees(runtime.rotationDegrees))
    context.translateBy(x: -50, y: -50)

    let points = CurveEngine.buildPath(
      spec: spec,
      parameters: runtimeParameters,
      detailScale: runtime.detailScale,
      steps: pathSteps
    )

    var path = Path()
    if let first = points.first {
      path.move(to: first)
      for point in points.dropFirst() {
        path.addLine(to: point)
      }
    }

    context.stroke(
      path,
      with: .color(.primary.opacity(pathOpacity)),
      style: StrokeStyle(
        lineWidth: runtimeParameters["strokeWidth"],
        lineCap: .round,
        lineJoin: .round
      )
    )

    let particleCount = max(1, Int(runtimeParameters["particleCount"].rounded()))
    for index in 0..<particleCount {
      let particle = CurveEngine.particle(
        spec: spec,
        parameters: runtimeParameters,
        index: index,
        progress: runtime.progress,
        detailScale: runtime.detailScale
      )

      let radius = particle.radius * particleScale
      let rect = CGRect(
        x: particle.point.x - radius,
        y: particle.point.y - radius,
        width: radius * 2,
        height: radius * 2
      )
      context.fill(
        Path(ellipseIn: rect),
        with: .color(.primary.opacity(min(1, particle.opacity + particleOpacityBoost)))
      )
    }
  }

  internal func resolvedParameters() -> CurveParameters {
    var resolved = CurveLoaderView.sanitizedParameters(parameters, for: spec)
    guard !controlOverrides.isEmpty else { return resolved }

    let controls = CurveLoaderView.controls(for: spec)
    let knownKeys = Set(controls.map(\.key))
    for (key, value) in controlOverrides {
      guard knownKeys.contains(key) else { continue }
      resolved.setValue(key, rawValue: value, controls: controls)
    }
    return resolved
  }

  private static func controls(for spec: CurveSpec) -> [CurveControl] {
    CurveCatalog.globalControls + spec.controls
  }

  private static func sanitizedParameters(
    _ parameters: CurveParameters,
    for spec: CurveSpec
  ) -> CurveParameters {
    var sanitized = parameters
    for control in controls(for: spec) {
      sanitized.setValue(control.key, rawValue: sanitized[control.key], controls: [control])
    }
    return sanitized
  }
}
