import SwiftUI
import Combine

public struct CameraScanSheetView: View {
    @Bindable public var viewModel: PlantListViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTag: MockPriceTag = MockCameraScannerService.shared.samplePriceTags[0]
    @State private var isScanning: Bool = false
    @State private var recognizedName: String = ""
    @State private var recognizedScientific: String = ""
    @State private var scanSuccess: Bool = false
    @State private var isFetchingAPI: Bool = false
    @State private var apiSuccessMessage: String = ""
    @State private var fetchedBotanicalInfo: BotanicalInfo? = nil
    
    @State private var cancellables = Set<AnyCancellable>()
    
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
                            .frame(height: 190)
                        
                        VStack(spacing: 10) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 48))
                                .foregroundStyle(isScanning ? Color.yellow : (scanSuccess ? Color.green : Color.white))
                            
                            Text(isScanning ? "Оптическое распознавание (OCR)..." : (scanSuccess ? "✓ Наименование успешно распознано!" : "Наведите камеру на ценник или бирку цветка"))
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    // 2. Выбор тестового образца ценника
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
                            .onTapGesture {
                                selectedTag = tag
                                scanSuccess = false
                                fetchedBotanicalInfo = nil
                                apiSuccessMessage = ""
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 3. Кнопка сканирования
                    Button {
                        isScanning = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            recognizedName = selectedTag.parsedPlantName
                            recognizedScientific = selectedTag.parsedScientificName
                            isScanning = false
                            scanSuccess = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Сканировать наименование")
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
                    
                    // 4. Блок REST API + Combine + UserNotifications (Лабораторная №4)
                    if scanSuccess {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Распознано: \(recognizedName)")
                                .font(.headline)
                            
                            // Кнопка асинхронного REST API запроса через Combine
                            Button {
                                fetchCareRegulationViaCombine()
                            } label: {
                                HStack {
                                    if isFetchingAPI {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "network")
                                    }
                                    Text(isFetchingAPI ? "Загрузка регламента по REST API..." : "Запросить регламент ухода (REST API + Combine)")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(isFetchingAPI)
                            
                            if !apiSuccessMessage.isEmpty {
                                HStack {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(Color.green)
                                    Text(apiSuccessMessage)
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                }
                                .padding(8)
                                .background(Color.green.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            // Сохранение в БД и генерация Push-напоминаний
                            Button {
                                let finalBotanical = fetchedBotanicalInfo ?? selectedTag.botanicalInfo
                                viewModel.addNewPlantFromScan(selectedTag: selectedTag, customBotanical: finalBotanical)
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "bell.badge.fill")
                                    Text("Сохранить в БД и включить Push-напоминания")
                                }
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
            .navigationTitle("Сканер и REST API")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
    
    // Выполнение реактивного сетевого запроса Combine
    private func fetchCareRegulationViaCombine() {
        isFetchingAPI = true
        PlantAPIService.shared.fetchPlantCareRegulation(query: recognizedName)
            .sink { completion in
                isFetchingAPI = false
                if case .failure(let error) = completion {
                    apiSuccessMessage = "Ошибка сети: \(error.localizedDescription)"
                }
            } receiveValue: { botanicalInfo in
                self.fetchedBotanicalInfo = botanicalInfo
                self.apiSuccessMessage = "✓ Регламент получен по REST API perenual.com (Статус: 200 OK)"
            }
            .store(in: &cancellables)
    }
}
