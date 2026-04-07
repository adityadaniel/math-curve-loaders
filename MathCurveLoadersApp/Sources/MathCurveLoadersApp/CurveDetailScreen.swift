import MathCurveKit
import SwiftUI

struct CurveDetailScreen: View {
  let spec: CurveSpec

  @StateObject private var state: CurveDetailState

  init(spec: CurveSpec) {
    self.spec = spec
    _state = StateObject(
      wrappedValue: CurveDetailState(spec: spec, globalControls: CurveCatalog.globalControls)
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      previewBlock
        .padding([.top, .horizontal])

      Divider()
        .padding(.top, 12)

      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          metadataBlock
          controlsBlock
          textBlock(title: AppStrings.formulaTitle, content: state.formulaText)
          textBlock(title: AppStrings.codeTitle, content: state.codeText)
        }
        .padding([.horizontal, .bottom])
        .padding(.top, 12)
      }
    }
    .navigationTitle(spec.name)
    .navigationBarTitleDisplayMode(.inline)
  }

  private var previewBlock: some View {
    CurveLoaderView(
      spec: spec,
      parameters: state.parameters,
      pathSteps: 480,
      particleScale: 1.35,
      particleOpacityBoost: 0.04
    )
    .frame(height: 280)
    .frame(maxWidth: .infinity)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
  }

  private var metadataBlock: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(spec.tag)
        .font(.subheadline)
        .foregroundStyle(.secondary)
      Text(spec.description)
        .font(.body)

      Button(AppStrings.reset) {
        state.reset()
      }
      .buttonStyle(.bordered)
    }
  }

  private var controlsBlock: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(AppStrings.controlsTitle)
        .font(.headline)

      ForEach(state.controls) { control in
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            Text(control.label)
              .font(.subheadline)
            Spacer()
            Text(control.formatValue(state.value(for: control.key)))
              .font(.caption.monospacedDigit())
              .foregroundStyle(.secondary)
          }

          Slider(
            value: Binding(
              get: { state.value(for: control.key) },
              set: { state.updateValue(for: control.key, rawValue: $0) }
            ),
            in: control.min...control.max,
            step: control.step
          )
        }
        .padding(10)
        .background(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(uiColor: .secondarySystemBackground))
        )
      }
    }
  }

  private func textBlock(title: String, content: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.headline)

      ScrollView(.horizontal, showsIndicators: false) {
        Text(content)
          .font(.system(.caption, design: .monospaced))
          .textSelection(.enabled)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(12)
          .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
              .fill(Color(uiColor: .secondarySystemBackground))
          )
      }
    }
  }
}
