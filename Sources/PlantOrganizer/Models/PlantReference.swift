import Foundation

// Модель семейства растений для справочника
public struct PlantFamilyReference: Identifiable, Codable {
    public var id: String
    public var name: String
    public var icon: String
    public var description: String
    
    public init(id: String, name: String, icon: String, description: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
    }
}

// Модель типа удобрения для справочника
public struct FertilizerReference: Identifiable, Codable {
    public var id: String
    public var name: String
    public var icon: String
    public var applicationSeason: String
    
    public init(id: String, name: String, icon: String, applicationSeason: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.applicationSeason = applicationSeason
    }
}
