import Foundation

public struct CurveParameters: Equatable, Hashable {
  private var values: [String: Double]

  public init(defaults: [String: Double]) {
    values = defaults
  }

  public subscript(key: String) -> Double {
    get { values[key] ?? 0 }
    set { values[key] = newValue }
  }

  public var allValues: [String: Double] { values }

  public mutating func setValue(
    _ key: String,
    rawValue: Double,
    controls: [CurveControl]
  ) {
    guard let control = controls.first(where: { $0.key == key }) else {
      values[key] = rawValue
      return
    }

    values[key] = control.clampAndQuantize(rawValue)
  }
}
