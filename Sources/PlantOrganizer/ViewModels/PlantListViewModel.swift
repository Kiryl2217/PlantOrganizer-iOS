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
    
    // Добавление новой записи в журнал ухода и обновление даты следующего полива
    public func addCareLog(plantId: UUID, type: CareType, note: String) {
        guard let index = plants.firstIndex(where: { $0.id == plantId }) else { return }
        
        let newEntry = CareLogEntry(
            date: Date(),
            type: type,
            note: note.isEmpty ? "Процедура выполнена" : note
        )
        plants[index].careLogs.insert(newEntry, at: 0)
        
        // Если полили — сбрасываем дату просрочки на новый интервал
        if type == .watering {
            plants[index].nextWateringDate = Calendar.current.date(
                byAdding: .day,
                value: plants[index].wateringIntervalDays,
                to: Date()
            ) ?? Date()
        }
        updateFilteredPlants()
    }
    
    private func loadMockData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        let inTwoDays = calendar.date(byAdding: .day, value: 2, to: today)!
        let inFiveDays = calendar.date(byAdding: .day, value: 5, to: today)!
        
        // 1. Монстера
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
                soil: "Рыхлый субстрат для ароидных с корой и перлитом. Полив после просыхания верхнего слоя.",
                description: "Крупная тропическая лиана семейства Ароидные с характерными перфорированными листьями."
            ),
            careLogs: [
                CareLogEntry(date: threeDaysAgo, type: .spraying, note: "Опрыскивание теплой водой"),
                CareLogEntry(date: calendar.date(byAdding: .day, value: -6, to: today)!, type: .watering, note: "Обильный полив")
            ]
        )
        
        // 2. Фикус
        let p2 = Plant(
            name: "Фикус Бенджамина",
            scientificName: "Ficus Benjamina",
            room: "Спальня",
            nextWateringDate: today,
            wateringIntervalDays: 3,
            iconSymbol: "tree.fill",
            botanicalInfo: BotanicalInfo(
                light: "Хорошее освещение без прямых лучей. Пестролистным формам нужно больше света.",
                humidity: "Умеренная или повышенная (50-70%).",
                temperature: "18-24 °C круглый год. Резкий перепад температур вызывает сброс листьев.",
                soil: "Универсальный грунт для декоративно-лиственных с дренажом.",
                description: "Вечнозеленое дерево или кустарник семейства Тутовые с тонкими ветвями и мелкими глянцевыми листьями."
            ),
            careLogs: [
                CareLogEntry(date: calendar.date(byAdding: .day, value: -3, to: today)!, type: .watering, note: "Плановый полив"),
                CareLogEntry(date: calendar.date(byAdding: .day, value: -10, to: today)!, type: .fertilizing, note: "Подкормка азотным удобрением")
            ]
        )
        
        // 3. Сансевиерия
        let p3 = Plant(
            name: "Сансевиерия",
            scientificName: "Sansevieria Trifasciata",
            room: "Кабинет",
            nextWateringDate: inTwoDays,
            wateringIntervalDays: 14,
            iconSymbol: "camera.macro",
            botanicalInfo: BotanicalInfo(
                light: "Неприхотлива: от яркого солнца до глубокой тени.",
                humidity: "Сухой воздух комнат, в опрыскивании не нуждается.",
                temperature: "16-28 °C. Выдерживает кратковременное понижение до 10 °C.",
                soil: "Субстрат для кактусов и суккулентов с большим количеством песка.",
                description: "Суккулентное бесстебельное растение с жесткими мечевидными прямостоячими листьями."
            ),
            careLogs: [
                CareLogEntry(date: calendar.date(byAdding: .day, value: -12, to: today)!, type: .watering, note: "Умеренный полив под корень")
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
