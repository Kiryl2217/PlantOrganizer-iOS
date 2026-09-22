import Foundation
import Observation
import Combine

@Observable
public final class PlantListViewModel {
    public var plants: [Plant] = []
    public var careTasks: [CareTask] = []
    public var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    public var searchText: String = ""
    public var filteredPlants: [Plant] = []
    
    public init() {
        loadDataFromDatabase()
    }
    
    public func updateFilteredPlants() {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredPlants = plants
        } else {
            filteredPlants = plants.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.room.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var tasksForSelectedDate: [CareTask] {
        careTasks.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
    }
    
    public func toggleTaskCompletion(taskId: UUID) {
        if let index = careTasks.firstIndex(where: { $0.id == taskId }) {
            careTasks[index].isCompleted.toggle()
        }
    }
    
    public func addCareLog(plantId: UUID, type: CareType, note: String) {
        guard let index = plants.firstIndex(where: { $0.id == plantId }) else { return }
        
        let newEntry = CareLogEntry(
            date: Date(),
            type: type,
            note: note.isEmpty ? "Процедура выполнена" : note
        )
        plants[index].careLogs.insert(newEntry, at: 0)
        
        if type == .watering {
            plants[index].nextWateringDate = Calendar.current.date(
                byAdding: .day,
                value: plants[index].wateringIntervalDays,
                to: Date()
            ) ?? Date()
            // Перепланируем напоминание о следующем поливе
            NotificationService.shared.scheduleWateringNotification(for: plants[index])
        }
        
        updateFilteredPlants()
        saveDataToDatabase()
    }
    
    // Добавление растения с регламентом из REST API и регистрацией цепочки напоминаний
    public func addNewPlantFromScan(selectedTag: MockPriceTag, customBotanical: BotanicalInfo? = nil) {
        let calendar = Calendar.current
        let nextWatering = calendar.date(byAdding: .day, value: selectedTag.intervalDays, to: Date()) ?? Date()
        
        let newPlant = Plant(
            name: selectedTag.parsedPlantName,
            scientificName: selectedTag.parsedScientificName,
            room: selectedTag.room,
            nextWateringDate: nextWatering,
            wateringIntervalDays: selectedTag.intervalDays,
            iconSymbol: selectedTag.iconSymbol,
            botanicalInfo: customBotanical ?? selectedTag.botanicalInfo,
            careLogs: [
                CareLogEntry(date: Date(), type: .watering, note: "Регламент ухода загружен через REST API (Combine)")
            ]
        )
        
        plants.insert(newPlant, at: 0)
        updateFilteredPlants()
        saveDataToDatabase()
        
        // Генерация цепочки локальных push-напоминаний через UserNotifications
        NotificationService.shared.scheduleWateringNotification(for: newPlant)
    }
    
    private func saveDataToDatabase() {
        LocalStorageService.shared.savePlants(plants)
    }
    
    private func loadDataFromDatabase() {
        if let savedPlants = LocalStorageService.shared.loadPlants(), !savedPlants.isEmpty {
            self.plants = savedPlants
            self.filteredPlants = savedPlants
            generateTasksFromPlants()
        } else {
            loadMockData()
            saveDataToDatabase()
        }
    }
    
    private func generateTasksFromPlants() {
        careTasks = plants.map { plant in
            CareTask(
                plantId: plant.id,
                plantName: plant.name,
                type: .watering,
                dueDate: plant.nextWateringDate,
                isCompleted: false
            )
        }
    }
    
    private func loadMockData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        let inTwoDays = calendar.date(byAdding: .day, value: 2, to: today)!
        let inFiveDays = calendar.date(byAdding: .day, value: 5, to: today)!
        
        let p1 = Plant(
            name: "Монстера Деликатесная",
            scientificName: "Monstera Deliciosa",
            room: "Гостиная",
            nextWateringDate: yesterday,
            wateringIntervalDays: 5,
            iconSymbol: "leaf.fill",
            botanicalInfo: BotanicalInfo(
                light: "Яркий рассеянный свет, полутень. Избегать прямых солнечных лучей.",
                humidity: "Высокая (60-80%). Требуется регулярное опрыскивание листьев.",
                temperature: "Оптимально 20-25 °C. Не переносит сквозняки ниже 16 °C.",
                soil: "Рыхлый субстрат для ароидных с корой и перлитом.",
                description: "Регламент ухода синхронизирован с энциклопедией Perenual API."
            ),
            careLogs: [
                CareLogEntry(date: threeDaysAgo, type: .spraying, note: "Опрыскивание теплой водой"),
                CareLogEntry(date: calendar.date(byAdding: .day, value: -6, to: today)!, type: .watering, note: "Обильный полив")
            ]
        )
        
        let p2 = Plant(
            name: "Фикус Бенджамина",
            scientificName: "Ficus Benjamina",
            room: "Спальня",
            nextWateringDate: today,
            wateringIntervalDays: 3,
            iconSymbol: "tree.fill",
            botanicalInfo: BotanicalInfo(
                light: "Хорошее освещение без прямых лучей.",
                humidity: "Умеренная или повышенная (50-70%).",
                temperature: "18-24 °C круглый год.",
                soil: "Универсальный грунт для декоративно-лиственных с дренажом.",
                description: "Вечнозеленое дерево семейства Тутовые."
            ),
            careLogs: [
                CareLogEntry(date: calendar.date(byAdding: .day, value: -3, to: today)!, type: .watering, note: "Плановый полив")
            ]
        )
        
        let p3 = Plant(
            name: "Сансевиерия",
            scientificName: "Sansevieria Trifasciata",
            room: "Кабинет",
            nextWateringDate: inTwoDays,
            wateringIntervalDays: 14,
            iconSymbol: "camera.macro",
            botanicalInfo: BotanicalInfo(
                light: "Неприхотлива: от яркого солнца до тени.",
                humidity: "Сухой воздух комнат, в опрыскивании не нуждается.",
                temperature: "16-28 °C.",
                soil: "Субстрат для кактусов и суккулентов.",
                description: "Суккулентное растение с прямостоячими листьями."
            ),
            careLogs: [
                CareLogEntry(date: calendar.date(byAdding: .day, value: -12, to: today)!, type: .watering, note: "Умеренный полив")
            ]
        )
        
        plants = [p1, p2, p3]
        filteredPlants = plants
        
        careTasks = [
            CareTask(plantId: p1.id, plantName: p1.name, type: .watering, dueDate: yesterday, isCompleted: false),
            CareTask(plantId: p2.id, plantName: p2.name, type: .watering, dueDate: today, isCompleted: false),
            CareTask(plantId: p2.id, plantName: p2.name, type: .spraying, dueDate: today, isCompleted: true),
            CareTask(plantId: p3.id, plantName: p3.name, type: .fertilizing, dueDate: inTwoDays, isCompleted: false),
            CareTask(plantId: p1.id, plantName: p1.name, type: .repotting, dueDate: inFiveDays, isCompleted: false)
        ]
    }
}
