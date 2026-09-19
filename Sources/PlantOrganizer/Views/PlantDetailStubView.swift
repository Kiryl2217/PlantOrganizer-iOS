import SwiftUI

public struct PlantDetailStubView: View {
    @Bindable public var viewModel: PlantListViewModel
    public let plantId: UUID
    @State private var showingAddLogSheet = false
    @State private var selectedCareType: CareType = .watering
    @State private var logNote: String = ""
    
    public init(viewModel: PlantListViewModel, plantId: UUID) {
        self.viewModel = viewModel
        self.plantId = plantId
    }
    
    private var plant: Plant? {
        viewModel.plants.first(where: { $0.id == plantId })
    }
    
    public var body: some View {
        Group {
            if let plant = plant {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Шапка растения
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(plant.isWateringOverdue ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                                    .frame(width: 70, height: 70)
                                
                                Image(systemName: plant.iconSymbol)
                                    .font(.system(size: 32))
                                    .foregroundStyle(plant.isWateringOverdue ? Color.red : Color.green)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(plant.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(plant.scientificName)
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundStyle(Color.secondary)
                                
                                StatusBadgeView(isOverdue: plant.isWateringOverdue, isToday: plant.isWateringToday)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // 1. БОТАНИЧЕСКАЯ СПРАВКА (Вариант 7)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ботаническая справка")
                                .font(.headline)
                            
                            Text(plant.botanicalInfo.description)
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                                .padding(.bottom, 4)
                            
                            BotanicalCardView(
                                icon: "sun.max.fill",
                                title: "Освещение",
                                description: plant.botanicalInfo.light,
                                iconColor: .orange
                            )
                            
                            BotanicalCardView(
                                icon: "humidity.fill",
                                title: "Влажность воздуха",
                                description: plant.botanicalInfo.humidity,
                                iconColor: .blue
                            )
                            
                            BotanicalCardView(
                                icon: "thermometer.medium",
                                title: "Температура",
                                description: plant.botanicalInfo.temperature,
                                iconColor: .red
                            )
                            
                            BotanicalCardView(
                                icon: "drop.fill",
                                title: "Почва и полив",
                                description: plant.botanicalInfo.soil,
                                iconColor: .teal
                            )
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // 2. ЖУРНАЛ УХОДА ЗА РАСТЕНИЕМ (Вариант 7)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Журнал процедур")
                                    .font(.headline)
                                Spacer()
                                Button {
                                    showingAddLogSheet = true
                                } label: {
                                    Label("Добавить запись", systemImage: "plus.circle.fill")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                            }
                            
                            if plant.careLogs.isEmpty {
                                Text("История ухода пока пуста. Добавьте первую запись!")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                                    .padding(.vertical, 8)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(plant.careLogs) { log in
                                        CareLogItemView(entry: log)
                                        if log.id != plant.careLogs.last?.id {
                                            Divider()
                                        }
                                    }
                                }
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            } else {
                Text("Растение не найдено")
            }
        }
        .navigationTitle("Паспорт растения")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddLogSheet) {
            NavigationStack {
                Form {
                    Section("Тип процедуры") {
                        Picker("Процедура", selection: $selectedCareType) {
                            ForEach(CareType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("Комментарий к процедуре") {
                        TextField("Например: Полив отстоянной водой", text: $logNote)
                    }
                }
                .navigationTitle("Новая запись")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отмена") { showingAddLogSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Сохранить") {
                            viewModel.addCareLog(plantId: plantId, type: selectedCareType, note: logNote)
                            logNote = ""
                            showingAddLogSheet = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
}
