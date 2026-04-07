import CoreGraphics

public struct ParticleSample: Equatable {
  public let point: CGPoint
  public let radius: Double
  public let opacity: Double

  public init(point: CGPoint, radius: Double, opacity: Double) {
    self.point = point
    self.radius = radius
    self.opacity = opacity
  }
}
