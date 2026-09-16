import Foundation
import Observation

@Observable
public final class PlantListViewModel {
    public var plants: [Plant] = []
    public var careTasks: [CareTask] = []
    public var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    public var searchText: String = ""
    public var filteredPlants: [Plant] = []
    
    public init() {
        loadMockData()
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
    
    private func loadMockData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let inTwoDays = calendar.date(byAdding: .day, value: 2, to: today)!
        let inFiveDays = calendar.date(byAdding: .day, value: 5, to: today)!
        
        let p1 = Plant(
            name: "Монстера Деликатесная",
            scientificName: "Monstera Deliciosa",
            room: "Гостиная",
            nextWateringDate: yesterday, // Просрочен полив (красная карточка)
            wateringIntervalDays: 5,
            iconSymbol: "leaf.fill"
        )
        
        let p2 = Plant(
            name: "Фикус Бенджамина",
            scientificName: "Ficus Benjamina",
            room: "Спальня",
            nextWateringDate: today, // Полить сегодня (оранжевая карточка)
            wateringIntervalDays: 3,
            iconSymbol: "tree.fill"
        )
        
        let p3 = Plant(
            name: "Сансевиерия",
            scientificName: "Sansevieria Trifasciata",
            room: "Кабинет",
            nextWateringDate: inTwoDays, // В норме (стандартная карточка)
            wateringIntervalDays: 14,
            iconSymbol: "camera.macro"
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
