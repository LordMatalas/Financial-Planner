import Foundation
import SwiftData

@Model
class FixedExpense {
    var id: UUID
    var name: String
    var amount: Double
    var dueDay: Int
    var endsOnMonth: Int? // Cuántos meses desde hoy (para cuotas)
    var category: ExpenseCategory
    var isActive: Bool
    var paidThisMonth: Bool = false
    var lastPaidDate: Date?
    var paidMonths: [String]? // Format: "YYYY-MM"
    var createdAt: Date?

    init(id: UUID = UUID(), name: String, amount: Double, dueDay: Int, endsOnMonth: Int? = nil, category: ExpenseCategory = .other, isActive: Bool = true, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.amount = amount
        self.dueDay = dueDay
        self.endsOnMonth = endsOnMonth
        self.category = category
        self.isActive = isActive
        self.paidMonths = []
        self.createdAt = createdAt
    }
    
    func isPaid(month: Int, year: Int) -> Bool {
        let key = String(format: "%d-%02d", year, month)
        return (paidMonths ?? []).contains(key)
    }
    
    func markAsPaid(month: Int, year: Int) {
        let key = String(format: "%d-%02d", year, month)
        if paidMonths == nil { paidMonths = [] }
        if !paidMonths!.contains(key) {
            paidMonths!.append(key)
        }
    }
    
    var activeThisMonth: Bool {
        guard isActive else { return false }
        guard let endsOnMonth = endsOnMonth else { return true }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: createdAt ?? .now, to: .now)
        let monthsElapsed = components.month ?? 0
        
        return monthsElapsed < endsOnMonth
    }
}
