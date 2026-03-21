import AppIntents
import SwiftData
import Foundation

struct RegisterWalletExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Registrar gasto de Wallet"
    static var description = IntentDescription("Guarda un pago de Apple Wallet como gasto hormiga")

    @Parameter(title: "Monto")
    var amount: Double

    @Parameter(title: "Comercio")
    var merchant: String

    @Parameter(title: "Categoría")
    var categoryName: String // En Shortcuts enviamos el String

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let category = ExpenseCategory(rawValue: categoryName) ?? .other
        
        // Setup SwiftData in background intent
        let schema = Schema([Expense.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        
        let expense = Expense(
            amount: amount,
            merchant: merchant,
            category: category,
            date: .now,
            source: .wallet,
            note: ""
        )
        
        context.insert(expense)
        try context.save()
        
        return .result(value: "✅ Registrado: \(merchant) por \(amount.cop)", dialog: "Gasto de \(merchant) guardado.")
    }
}
