import Combine
import Foundation

public final class CurveDetailState: ObservableObject {
  public let spec: CurveSpec
  public let controls: [CurveControl]

  @Published public private(set) var parameters: CurveParameters

  public init(spec: CurveSpec, globalControls: [CurveControl]) {
    self.spec = spec
    controls = globalControls + spec.controls
    parameters = CurveParameters(defaults: spec.defaults)
  }

  public func value(for key: String) -> Double {
    parameters[key]
  }

  public func updateValue(for key: String, rawValue: Double) {
    parameters.setValue(key, rawValue: rawValue, controls: controls)
    objectWillChange.send()
  }

  public func reset() {
    parameters = CurveParameters(defaults: spec.defaults)
  }

  public var formulaText: String {
    spec.formula(parameters)
  }

  public var codeText: String {
    CurveCodeFormatter.render(spec: spec, parameters: parameters)
  }
}
