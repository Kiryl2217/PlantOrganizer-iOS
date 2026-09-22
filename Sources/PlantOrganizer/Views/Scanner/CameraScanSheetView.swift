import SwiftUI

public struct CameraScanSheetView: View {
    @Bindable public var viewModel: PlantListViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTag: MockPriceTag = MockCameraScannerService.shared.samplePriceTags[0]
    @State private var isScanning: Bool = false
    @State private var recognizedName: String = ""
    @State private var recognizedScientific: String = ""
    @State private var scanSuccess: Bool = false
    
    public init(viewModel: PlantListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Видоискатель камеры
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.85))
                            .frame(height: 200)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 54))
                                .foregroundStyle(isScanning ? Color.yellow : (scanSuccess ? Color.green : Color.white))
                            
                            Text(isScanning ? "Распознавание текста (OCR)..." : (scanSuccess ? "✓ Текст этикетки успешно распознан!" : "Наведите камеру на ценник или бирку цветка"))
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    // 2. Выбор тестового ценника (Mock камеры для симулятора)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Тестовые этикетки из магазина:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.secondary)
                            .padding(.horizontal)
                        
                        ForEach(MockCameraScannerService.shared.samplePriceTags) { tag in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(tag.labelText)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(selectedTag.id == tag.id ? Color.primary : Color.secondary)
                                }
                                Spacer()
                                if selectedTag.id == tag.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.green)
                                }
                            }
                            .padding(10)
                            .background(selectedTag.id == tag.id ? Color.green.opacity(0.12) : Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedTag.id == tag.id ? Color.green : Color.clear, lineWidth: 1.5)
                            )
                            .padding(.horizontal)
                            .onTapGesture {
                                selectedTag = tag
                                scanSuccess = false
                            }
                        }
                    }
                    
                    // 3. Кнопка сканирования
                    Button {
                        isScanning = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            recognizedName = selectedTag.parsedPlantName
                            recognizedScientific = selectedTag.parsedScientificName
                            isScanning = false
                            scanSuccess = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Сканировать ценник")
                        }
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                    .disabled(isScanning)
                    
                    // 4. Карточка распознанного растения и добавление в БД
                    if scanSuccess {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Распознано с камеры:")
                                .font(.headline)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(recognizedName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text(recognizedScientific)
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundStyle(Color.secondary)
                                
                                Divider()
                                
                                Text("Комната: \(selectedTag.room)")
                                    .font(.caption)
                                Text("Интервал полива: раз в \(selectedTag.intervalDays) дн.")
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Button {
                                viewModel.addNewPlantFromScan(selectedTag: selectedTag)
                                dismiss()
                            } label: {
                                Text("Сохранить в базу данных")
                                    .font(.headline)
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Сканер растений")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}
