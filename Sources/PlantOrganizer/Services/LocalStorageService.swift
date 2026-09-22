import Foundation

public final class LocalStorageService {
    public static let shared = LocalStorageService()
    private let storageKey = "PlantOrganizer_DB_Plants_v1"
    
    private init() {}
    
    // 1. ОСНОВНАЯ БАЗА ДАННЫХ: Сохранение массива растений на постоянный диск
    public func savePlants(_ plants: [Plant]) {
        if let encoded = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    // Загрузка массива растений из локальной базы данных
    public func loadPlants() -> [Plant]? {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Plant].self, from: data) else {
            return nil
        }
        return decoded
    }
    
    // 2. ВСПОМОГАТЕЛЬНОЕ ХРАНИЛИЩЕ: Справочник семейств растений
    public func getFamilyReferences() -> [PlantFamilyReference] {
        return [
            PlantFamilyReference(id: "fam_1", name: "Ароидные (Araceae)", icon: "leaf.fill", description: "Тропические лианы и травы с крупными листьями (Монстера, Спатифиллум, Замиокулькас)."),
            PlantFamilyReference(id: "fam_2", name: "Тутовые (Moraceae)", icon: "tree.fill", description: "Деревья и кустарники с плотными глянцевыми листьями и млечным соком (Фикусы)."),
            PlantFamilyReference(id: "fam_3", name: "Спаржевые (Asparagaceae)", icon: "camera.macro", description: "Суккуленты и выносливые растения с мечевидными листьями (Сансевиерия, Драцена)."),
            PlantFamilyReference(id: "fam_4", name: "Марантовые (Marantaceae)", icon: "sparkles", description: "Тенелюбивые растения с уникальным узорчатым рисунком листьев (Калатея, Маранта).")
        ]
    }
    
    // ВСПОМОГАТЕЛЬНОЕ ХРАНИЛИЩЕ: Справочник типов удобрений
    public func getFertilizerReferences() -> [FertilizerReference] {
        return [
            FertilizerReference(id: "fert_1", name: "Азотный комплекс (N)", icon: "leaf.arrow.triangle.circlepath", applicationSeason: "Весна / Лето (стимулирует активный рост побегов и зелени)"),
            FertilizerReference(id: "fert_2", name: "Фосфорно-калийное (P-K)", icon: "flame.fill", applicationSeason: "Осень (укрепляет корни и повышает иммунитет)"),
            FertilizerReference(id: "fert_3", name: "Хелат железа (Fe)", icon: "drop.fill", applicationSeason: "При признаках хлороза и пожелтения листьев"),
            FertilizerReference(id: "fert_4", name: "Органоминеральный биогумус", icon: "sparkle", applicationSeason: "Период активной вегетации (раз в 14 дней)")
        ]
    }
}
