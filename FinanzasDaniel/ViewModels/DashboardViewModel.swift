import Foundation
import SwiftData
import Observation

@Observable
class DashboardViewModel {
    var modelContext: ModelContext
    
    // User preferences
    var monthlyIncome: Double = 2450000
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func calculateMonthlyFlow(fixed: [FixedExpense], variable: [Expense]) -> (fixedTotal: Double, variableTotal: Double, freeBalance: Double) {
        let fixedTotal = fixed.filter { $0.isActive }.reduce(0) { $0 + $1.amount }
        let variableTotal = variable.filter { 
            Calendar.current.isDate($0.date, equalTo: .now, toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }
        
        let freeBalance = monthlyIncome - fixedTotal - variableTotal
        return (fixedTotal, variableTotal, freeBalance)
    }
    
    func expensesByCategory(expenses: [Expense]) -> [(category: ExpenseCategory, amount: Double)] {
        let currentMonthExpenses = expenses.filter { 
            Calendar.current.isDate($0.date, equalTo: .now, toGranularity: .month)
        }
        
        let grouped = Dictionary(grouping: currentMonthExpenses) { $0.category }
        return ExpenseCategory.allCases.map { category in
            let amount = grouped[category]?.reduce(0) { $0 + $1.amount } ?? 0
            return (category, amount)
        }.filter { $0.amount > 0 }.sorted(by: { $0.amount > $1.amount })
    }
}
