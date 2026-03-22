import Foundation
import SwiftData

@Model
class MonthlySnapshot {
    var id: UUID
    var month: Int
    var year: Int
    var totalExpenses: Double
    var totalSaved: Double
    var totalIncome: Double
    var suggestedBudget: Double
    var createdAt: Date?
    
    init(id: UUID = UUID(), month: Int, year: Int, totalExpenses: Double = 0.0, totalSaved: Double = 0.0, totalIncome: Double, suggestedBudget: Double, createdAt: Date? = .now) {
        self.id = id
        self.month = month
        self.year = year
        self.totalExpenses = totalExpenses
        self.totalSaved = totalSaved
        self.totalIncome = totalIncome
        self.suggestedBudget = suggestedBudget
        self.createdAt = createdAt
    }
}
