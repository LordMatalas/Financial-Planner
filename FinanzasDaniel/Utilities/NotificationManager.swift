import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permisos de notificación concedidos")
            }
        }
    }
    
    func scheduleDailyReminder(at hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "¿Gastaste hoy? 🐜"
        content.body = "Registra tus gastos hormiga para mantener tu presupuesto bajo control."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendBudgetAlert(percent: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Alerta de Presupuesto ⚠️"
        content.body = "¡Cuidado! Ya has gastado el \(percent)% de tu presupuesto mensual para gastos hormiga."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
