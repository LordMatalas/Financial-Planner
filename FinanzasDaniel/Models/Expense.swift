import Foundation
import SwiftData

@Model
class Expense {
    var id: UUID
    var amount: Double
    var merchant: String
    var category: ExpenseCategory
    var date: Date
    var source: ExpenseSource
    var note: String

    init(id: UUID = UUID(), amount: Double, merchant: String, category: ExpenseCategory, date: Date = .now, source: ExpenseSource = .manual, note: String = "") {
        self.id = id
        self.amount = amount
        self.merchant = merchant
        self.category = category
        self.date = date
        self.source = source
        self.note = note
    }
}
