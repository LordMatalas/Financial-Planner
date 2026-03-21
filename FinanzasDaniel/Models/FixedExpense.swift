import Foundation
import SwiftData

@Model
class FixedExpense {
    var id: UUID
    var name: String
    var amount: Double
    var dueDay: Int
    var endsOnMonth: Int? // Meses desde hoy (opcional)
    var category: ExpenseCategory
    var isActive: Bool

    init(id: UUID = UUID(), name: String, amount: Double, dueDay: Int, endsOnMonth: Int? = nil, category: ExpenseCategory = .other, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.amount = amount
        self.dueDay = dueDay
        self.endsOnMonth = endsOnMonth
        self.category = category
        self.isActive = isActive
    }
}
