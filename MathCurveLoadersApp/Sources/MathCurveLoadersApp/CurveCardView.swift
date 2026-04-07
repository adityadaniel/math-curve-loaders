import MathCurveKit
import SwiftUI

struct CurveCardView: View {
  let spec: CurveSpec

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      CurveLoaderView(
        spec: spec,
        parameters: CurveParameters(defaults: spec.defaults),
        pathSteps: 280
      )
      .frame(height: 140)
      .frame(maxWidth: .infinity)
      .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

      Text(spec.name)
        .font(.headline)
        .lineLimit(1)

      Text(spec.tag)
        .font(.caption)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    .padding(12)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color(uiColor: .secondarySystemBackground))
    )
  }
}
