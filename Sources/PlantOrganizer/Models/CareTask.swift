import Foundation

public enum CareType: String, CaseIterable, Codable, Identifiable {
    case watering = "Полив"
    case fertilizing = "Подкормка"
    case spraying = "Опрыскивание"
    case repotting = "Пересадка"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .watering: return "drop.fill"
        case .fertilizing: return "leaf.arrow.triangle.circlepath"
        case .spraying: return "cloud.drizzle.fill"
        case .repotting: return "archivebox.fill"
        }
    }
}

public struct CareTask: Identifiable, Codable {
    public var id: UUID
    public var plantId: UUID
    public var plantName: String
    public var type: CareType
    public var dueDate: Date
    public var isCompleted: Bool
    
    public init(id: UUID = UUID(), plantId: UUID, plantName: String, type: CareType, dueDate: Date, isCompleted: Bool = false) {
        self.id = id
        self.plantId = plantId
        self.plantName = plantName
        self.type = type
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
