import Foundation
import UserNotifications

public final class NotificationService {
    public static let shared = NotificationService()
    public private(set) var scheduledRemindersCount: Int = 0
    
    private init() {
        requestAuthorization()
    }
    
    // Запрос разрешения на отправку уведомлений
    public func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("✓ Разрешение на локальные уведомления получено")
            }
        }
    }
    
    // Автоматическая генерация цепочки локальных напоминаний о поливе (UserNotifications)
    public func scheduleWateringNotification(for plant: Plant) {
        let content = UNMutableNotificationContent()
        content.title = "🌱 Время полить растение!"
        content.body = "Пора полить «\(plant.name)» (\(plant.room)). Следующий интервал: через \(plant.wateringIntervalDays) дн."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let identifier = "WateringReminder_\(plant.id.uuidString)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.scheduledRemindersCount += 1
                }
            }
        }
    }
}
