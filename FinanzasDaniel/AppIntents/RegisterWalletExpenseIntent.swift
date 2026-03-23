import AppIntents
import SwiftData
import Foundation
import UserNotifications

struct RegisterWalletExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Registrar gasto de Wallet"
    static var description = IntentDescription("Guarda un pago de Apple Wallet como gasto hormiga")

    @Parameter(title: "Monto")
    var amount: Double

    @Parameter(title: "Comercio")
    var merchant: String

    @Parameter(title: "Categoría", default: .food)
    var category: ShortcutCategory

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let expenseCategory = ExpenseCategory(rawValue: category.rawValue) ?? .other
        
        // IMPORTANT: Schema must match the main app to avoid "no such table" errors
        let schema = Schema([
            SavingsGoal.self,
            Contribution.self,
            Expense.self,
            FixedExpense.self,
            MonthlySnapshot.self,
            Debt.self,
            DebtPayment.self
        ])
        
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        
        let expense = Expense(
            amount: amount,
            merchant: merchant,
            category: expenseCategory,
            date: .now,
            source: .wallet,
            note: ""
        )
        
        context.insert(expense)
        try context.save()
        
        // Push Success Notification
        let content = UNMutableNotificationContent()
        content.title = "✅ Gasto Registrado"
        content.body = "\(merchant): \(amount.cop)"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        try? await UNUserNotificationCenter.current().add(request)
        
        return .result(value: "✅ Registrado: \(merchant) por \(amount.cop)", dialog: "Gasto de \(merchant) guardado.")
    }
}

enum ShortcutCategory: String, AppEnum {
    case food = "Comida"
    case transport = "Transporte"
    case shopping = "Compras"
    case leisure = "Ocio"
    case services = "Servicios"
    case health = "Salud"
    case other = "Otro"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Categoría de Gasto"
    static var caseDisplayRepresentations: [ShortcutCategory: DisplayRepresentation] = [
        .food: "🍔 Comida",
        .transport: "🚌 Transporte",
        .shopping: "🛍️ Compras",
        .leisure: "🎬 Ocio",
        .services: "💡 Servicios",
        .health: "🏥 Salud",
        .other: "➕ Otro"
    ]
}
