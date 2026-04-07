import Foundation

public struct CurveRuntime: Equatable, Hashable {
  public let progress: Double
  public let detailScale: Double
  public let rotationDegrees: Double

  public init(progress: Double, detailScale: Double, rotationDegrees: Double) {
    self.progress = progress
    self.detailScale = detailScale
    self.rotationDegrees = rotationDegrees
  }
}
