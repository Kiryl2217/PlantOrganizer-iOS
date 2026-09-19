import Foundation

public struct CareLogEntry: Identifiable, Codable {
    public var id: UUID
    public var date: Date
    public var type: CareType
    public var note: String
    
    public init(id: UUID = UUID(), date: Date = Date(), type: CareType, note: String = "") {
        self.id = id
        self.date = date
        self.type = type
        self.note = note
    }
}
