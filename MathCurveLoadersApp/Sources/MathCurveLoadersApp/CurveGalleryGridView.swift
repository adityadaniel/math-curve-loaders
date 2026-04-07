import MathCurveKit
import SwiftUI

struct CurveGalleryGridView: View {
  private let columns = [GridItem(.adaptive(minimum: 170), spacing: 16)]

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        Text(AppStrings.gallerySubtitle)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .padding(.horizontal)

        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(CurveCatalog.specs) { spec in
            NavigationLink(value: spec.id) {
              CurveCardView(spec: spec)
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.horizontal)
      }
      .padding(.vertical)
    }
    .navigationDestination(for: String.self) { curveID in
      if let spec = CurveCatalog.specs.first(where: { $0.id == curveID }) {
        CurveDetailScreen(spec: spec)
      } else {
        ContentUnavailableView(AppStrings.placeholderTitle, systemImage: "questionmark.circle")
      }
    }
  }
}
