import Foundation

public struct MockPriceTag: Identifiable {
    public var id: String
    public var labelText: String
    public var parsedPlantName: String
    public var parsedScientificName: String
    public var room: String
    public var intervalDays: Int
    public var iconSymbol: String
    public var botanicalInfo: BotanicalInfo
    
    public init(
        id: String,
        labelText: String,
        parsedPlantName: String,
        parsedScientificName: String,
        room: String,
        intervalDays: Int,
        iconSymbol: String,
        botanicalInfo: BotanicalInfo
    ) {
        self.id = id
        self.labelText = labelText
        self.parsedPlantName = parsedPlantName
        self.parsedScientificName = parsedScientificName
        self.room = room
        self.intervalDays = intervalDays
        self.iconSymbol = iconSymbol
        self.botanicalInfo = botanicalInfo
    }
}

public final class MockCameraScannerService {
    public static let shared = MockCameraScannerService()
    
    // Набор образцов этикеток и ценников для демонстрации в эмуляторе (по методичке)
    public let samplePriceTags: [MockPriceTag] = [
        MockPriceTag(
            id: "tag_1",
            labelText: "ЦЕННИК: Спатифиллум Уоллиса / Spathiphyllum Wallisii / Арт. 44109 / 890 руб.",
            parsedPlantName: "Спатифиллум Уоллиса",
            parsedScientificName: "Spathiphyllum Wallisii",
            room: "Гостиная",
            intervalDays: 4,
            iconSymbol: "drop.circle.fill",
            botanicalInfo: BotanicalInfo(
                light: "Полутень, рассеянный свет. При прямом солнце сохнут кончики.",
                humidity: "Высокая (от 65%). Любит регулярные опрыскивания.",
                temperature: "18-24 °C. Беречь от холодных подоконников.",
                soil: "Слабокислый субстрат. Полив при легком поникании листьев.",
                description: "Популярный «Женское счастье» с белыми прицветниками-покрывалами."
            )
        ),
        MockPriceTag(
            id: "tag_2",
            labelText: "ЭТИКЕТКА ПИТОМНИКА: Замиокулькас Занзибар / Zamioculcas Zamiifolia / 1450 руб.",
            parsedPlantName: "Замиокулькас",
            parsedScientificName: "Zamioculcas Zamiifolia",
            room: "Прихожая",
            intervalDays: 18,
            iconSymbol: "shield.lefthalf.filled",
            botanicalInfo: BotanicalInfo(
                light: "Любое: от яркого солнца до полумрака.",
                humidity: "Абсолютно нетребователен к влажности.",
                temperature: "16-26 °C. Засухоустойчив.",
                soil: "Грунт для кактусов с дренажом. Полив редкий, после высыхания.",
                description: "«Долларовое дерево» с клубневидным корневищем и глянцевыми листьями."
            )
        ),
        MockPriceTag(
            id: "tag_3",
            labelText: "БИРКА: Калатея Орната / Calathea Ornata / Семейство Марантовые / 1200 руб.",
            parsedPlantName: "Калатея Орната",
            parsedScientificName: "Calathea Ornata",
            room: "Спальня",
            intervalDays: 3,
            iconSymbol: "sparkles",
            botanicalInfo: BotanicalInfo(
                light: "Мягкий рассеянный свет, без прямых солнечных лучей.",
                humidity: "Очень высокая (70-85%). Нужен увлажнитель воздуха.",
                temperature: "20-24 °C. Не терпит перепадов температур.",
                soil: "Специальный грунт для марантовых. Полив фильтрованной водой.",
                description: "Декоративное растение с тонкими розовыми полосками на листьях."
            )
        )
    ]
}
