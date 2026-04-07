import CoreGraphics

public struct CurveSpec: Identifiable {
  public typealias PointFunction = (
    _ progress: Double, _ detailScale: Double, _ parameters: CurveParameters
  ) -> CGPoint
  public typealias FormulaFunction = (_ parameters: CurveParameters) -> String

  public let id: String
  public let name: String
  public let tag: String
  public let description: String
  public let rotate: Bool
  public let defaults: [String: Double]
  public let controls: [CurveControl]
  public let formula: FormulaFunction
  public let pointCode: String
  public let point: PointFunction

  public init(
    id: String,
    name: String,
    tag: String,
    description: String,
    rotate: Bool,
    defaults: [String: Double],
    controls: [CurveControl],
    formula: @escaping FormulaFunction,
    pointCode: String,
    point: @escaping PointFunction
  ) {
    self.id = id
    self.name = name
    self.tag = tag
    self.description = description
    self.rotate = rotate
    self.defaults = defaults
    self.controls = controls
    self.formula = formula
    self.pointCode = pointCode
    self.point = point
  }
}
