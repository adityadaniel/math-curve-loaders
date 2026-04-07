import CoreGraphics
import Foundation

extension CurveParameters {
  func value(_ key: String) -> Double { self[key] }
  func integer(_ key: String) -> Int { Int(self[key].rounded()) }
}

internal func point(_ x: Double, _ y: Double) -> CGPoint {
  CGPoint(x: x, y: y)
}
