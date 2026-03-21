import Foundation
import SwiftData
import Observation

@Observable
class ExpensesViewModel {
    var modelContext: ModelContext
    
    // User preferences (hardcoded for now as per spec, but could be from UserDefaults)
    var monthlyBudget: Double = 450000
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addExpense(amount: Double, merchant: String, category: ExpenseCategory, date: Date, source: ExpenseSource) {
        let newExpense = Expense(
            amount: amount,
            merchant: merchant,
            category: category,
            date: date,
            source: source
        )
        modelContext.insert(newExpense)
    }
    
    func deleteExpense(_ expense: Expense) {
        modelContext.delete(expense)
    }
    
    func totalSpent(in expenses: [Expense]) -> Double {
        expenses.filter { 
            Calendar.current.isDate($0.date, equalTo: .now, toGranularity: .month) 
        }.reduce(0) { $0 + $1.amount }
    }
}
