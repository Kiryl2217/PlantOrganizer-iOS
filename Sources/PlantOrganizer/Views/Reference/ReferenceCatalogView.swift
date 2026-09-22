import SwiftUI

public struct ReferenceCatalogView: View {
    @Environment(\.dismiss) private var dismiss
    private let families = LocalStorageService.shared.getFamilyReferences()
    private let fertilizers = LocalStorageService.shared.getFertilizerReferences()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Семейства растений (Справочник)").font(.subheadline).fontWeight(.bold)) {
                    ForEach(families) { fam in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: fam.icon)
                                    .foregroundStyle(Color.green)
                                Text(fam.name)
                                    .font(.headline)
                            }
                            Text(fam.description)
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Типы удобрений и сезоны применения").font(.subheadline).fontWeight(.bold)) {
                    ForEach(fertilizers) { fert in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: fert.icon)
                                    .foregroundStyle(Color.orange)
                                Text(fert.name)
                                    .font(.headline)
                            }
                            Text(fert.applicationSeason)
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Справочник базы данных")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
            }
        }
    }
}
