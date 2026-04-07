import Foundation

enum CurveCodeFormatter {
  public static func render(spec: CurveSpec, parameters: CurveParameters) -> String {
    let kvLines = parameters.allValues
      .sorted(by: { $0.key < $1.key })
      .map { key, value in
        "  \(key): \(formatted(value)),"
      }

    return [
      "let curve = [",
      "  name: \"\(spec.name)\",",
      "  tag: \"\(spec.tag)\",",
      "  rotate: \(spec.rotate),",
      kvLines.joined(separator: "\n"),
      "]",
      "",
      spec.pointCode,
    ].joined(separator: "\n")
  }

  private static func formatted(_ value: Double) -> String {
    if value.rounded() == value {
      return String(Int(value))
    }
    return String(format: "%.4f", value)
  }
}
