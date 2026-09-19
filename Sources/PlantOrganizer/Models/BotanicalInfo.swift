import Foundation

public struct BotanicalInfo: Codable {
    public var light: String
    public var humidity: String
    public var temperature: String
    public var soil: String
    public var description: String
    
    public init(
        light: String,
        humidity: String,
        temperature: String,
        soil: String,
        description: String
    ) {
        self.light = light
        self.humidity = humidity
        self.temperature = temperature
        self.soil = soil
        self.description = description
    }
}
