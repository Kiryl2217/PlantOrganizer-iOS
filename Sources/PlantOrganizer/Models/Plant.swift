import Foundation

public struct Plant: Identifiable, Codable {
    public var id: UUID
    public var name: String
    public var scientificName: String
    public var room: String
    public var nextWateringDate: Date
    public var wateringIntervalDays: Int
    public var iconSymbol: String
    public var botanicalInfo: BotanicalInfo
    public var careLogs: [CareLogEntry]
    
    public init(
        id: UUID = UUID(),
        name: String,
        scientificName: String,
        room: String,
        nextWateringDate: Date,
        wateringIntervalDays: Int,
        iconSymbol: String,
        botanicalInfo: BotanicalInfo,
        careLogs: [CareLogEntry] = []
    ) {
        self.id = id
        self.name = name
        self.scientificName = scientificName
        self.room = room
        self.nextWateringDate = nextWateringDate
        self.wateringIntervalDays = wateringIntervalDays
        self.iconSymbol = iconSymbol
        self.botanicalInfo = botanicalInfo
        self.careLogs = careLogs
    }
    
    public var isWateringOverdue: Bool {
        nextWateringDate < Calendar.current.startOfDay(for: Date())
    }
    
    public var isWateringToday: Bool {
        Calendar.current.isDateInToday(nextWateringDate)
    }
}
