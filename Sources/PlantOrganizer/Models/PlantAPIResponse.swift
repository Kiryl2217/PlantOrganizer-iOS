import Foundation

// Модель ответа REST API энциклопедии растений
public struct PlantAPIDTO: Codable {
    public let id: Int
    public let commonName: String
    public let scientificName: [String]
    public let watering: String
    public let sunlight: [String]
    public let careLevel: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case watering
        case sunlight
        case careLevel = "care_level"
    }
}

public struct PlantAPISearchResponse: Codable {
    public let data: [PlantAPIDTO]
    public let status: String
}
