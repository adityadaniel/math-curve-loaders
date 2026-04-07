import MathCurveKit
import SwiftUI

struct RootView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @State private var selectedCurveID: String? = CurveCatalog.specs.first?.id

  var body: some View {
    Group {
      if horizontalSizeClass == .regular {
        splitLayout
      } else {
        compactLayout
      }
    }
  }

  private var splitLayout: some View {
    NavigationSplitView {
      List(CurveCatalog.specs, selection: $selectedCurveID) { spec in
        HStack(spacing: 12) {
          CurveLoaderView(
            spec: spec,
            parameters: CurveParameters(defaults: spec.defaults),
            pathSteps: 240
          )
          .frame(width: 48, height: 48)

          VStack(alignment: .leading, spacing: 2) {
            Text(spec.name)
              .font(.headline)
            Text(spec.tag)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
        .tag(spec.id)
      }
      .navigationTitle(AppStrings.galleryTitle)
    } detail: {
      if let selectedCurveID,
        let spec = CurveCatalog.specs.first(where: { $0.id == selectedCurveID })
      {
        CurveDetailScreen(spec: spec)
      } else {
        ContentUnavailableView(
          AppStrings.placeholderTitle,
          systemImage: "waveform.path.ecg",
          description: Text(AppStrings.placeholderBody)
        )
      }
    }
  }

  private var compactLayout: some View {
    NavigationStack {
      CurveGalleryGridView()
        .navigationTitle(AppStrings.galleryTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}
