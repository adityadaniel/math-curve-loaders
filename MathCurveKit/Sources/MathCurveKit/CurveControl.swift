import Foundation

public struct CurveControl: Identifiable, Hashable {
  public enum ValueFormat: Hashable {
    case integer
    case fixed(Int)
    case durationMs
  }

  public let key: String
  public let label: String
  public let min: Double
  public let max: Double
  public let step: Double
  public let format: ValueFormat

  public var id: String { key }

  public init(
    key: String,
    label: String,
    min: Double,
    max: Double,
    step: Double,
    format: ValueFormat
  ) {
    self.key = key
    self.label = label
    self.min = min
    self.max = max
    self.step = step
    self.format = format
  }

  public func clampAndQuantize(_ rawValue: Double) -> Double {
    let clamped = Swift.min(Swift.max(rawValue, min), max)
    guard step > 0 else {
      return applyFormat(clamped)
    }

    let normalized = ((clamped - min) / step).rounded() * step + min
    return applyFormat(normalized)
  }

  public func formatValue(_ value: Double) -> String {
    switch format {
    case .durationMs:
      return String(format: "%.1fs", value / 1000)
    case .integer:
      return "\(Int(value.rounded()))"
    case .fixed(let decimals):
      return String(format: "%.*f", decimals, value)
    }
  }

  private func applyFormat(_ value: Double) -> Double {
    switch format {
    case .integer:
      return value.rounded()
    case .fixed, .durationMs:
      return value
    }
  }
}
