import UserNotifications
import Foundation

class NotificationScheduler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationScheduler()
    
    private let fixedExpenseCategory = "FIXED_EXPENSE_CATEGORY"
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        setupCategories()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permisos de notificación concedidos")
            }
        }
    }
    
    private func setupCategories() {
        let paidAction = UNNotificationAction(identifier: "PAID_ACTION",
                                             title: "Sí, ya pagué",
                                             options: .foreground)
        
        let remindLaterAction = UNNotificationAction(identifier: "REMIND_LATER_ACTION",
                                                   title: "Recordármelo mañana",
                                                   options: [])
        
        let category = UNNotificationCategory(identifier: fixedExpenseCategory,
                                              actions: [paidAction, remindLaterAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func rescheduleAll(fixedExpenses: [FixedExpense]) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for expense in fixedExpenses where expense.isActive {
            scheduleFixedExpenseReminder(expense: expense)
        }
    }
    
    private func scheduleFixedExpenseReminder(expense: FixedExpense) {
        let content = UNMutableNotificationContent()
        content.title = "💸 Mañana toca pagar \(expense.name)"
        content.body = "Son $\(Int(expense.amount)). ¿Ya lo hiciste?"
        content.sound = .default
        content.categoryIdentifier = fixedExpenseCategory
        content.userInfo = ["expenseID": expense.id.uuidString, "expenseName": expense.name]
        
        var dateComponents = DateComponents()
        dateComponents.day = max(1, expense.dueDay - 1)
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "fixed_\(expense.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleMonthlySummary() {
        let content = UNMutableNotificationContent()
        content.title = "Resumen del Mes 📊"
        content.body = "El mes ha terminado. Revisa tu desempeño financiero ahora."
        content.sound = .default
        
        // To schedule for the last day of the month, we can't do it with a single UNCalendarNotificationTrigger efficiently for all months.
        // A common way is to schedule it for the 28th, 29th, 30th, 31st depending on the month, 
        // or just on the 1st of next month. But user said "last day of month".
        // We will schedule it for the 1st of the next month at 8:00 AM as a fallback if "last day" is too complex for native triggers,
        // OR we can calculate the date and schedule a non-repeating one for the next 12 months.
        
        let calendar = Calendar.current
        let now = Date.now
        
        for i in 0..<12 {
            if let date = calendar.date(byAdding: .month, value: i, to: now),
               let range = calendar.range(of: .day, in: .month, for: date),
               let lastDay = range.last {
                
                var components = calendar.dateComponents([.year, .month], from: date)
                components.day = lastDay
                components.hour = 19
                components.minute = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: "monthly_summary_\(components.month!)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func sendBudgetAlert(amountRemaining: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Alerta de Presupuesto ⚠️"
        content.body = "Has alcanzado el 80% de tu presupuesto. Te quedan $\(Int(amountRemaining)) para el resto del mes."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let expenseName = userInfo["expenseName"] as? String
        
        if response.actionIdentifier == "PAID_ACTION" {
            // Logic to mark as paid in SwiftData
            // This usually needs to interact with the model context.
            // Since we use AppState or similar, we might need a way to access context here.
        } else if response.actionIdentifier == "REMIND_LATER_ACTION" {
            // Reschedule in 24 hours
            let content = response.notification.request.content.mutableCopy() as! UNMutableNotificationContent
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 24 * 3600, repeats: false)
            let request = UNNotificationRequest(identifier: response.notification.request.identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        
        completionHandler()
    }
}
