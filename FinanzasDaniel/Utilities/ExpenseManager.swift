import Foundation
import SwiftData
import SwiftUI

@Observable
class ExpenseManager {
    static let shared = ExpenseManager()
    
    private init() {}
    
    func addExpense(amount: Double, merchant: String, category: ExpenseCategory, date: Date, note: String, context: ModelContext) {
        let expense = Expense(amount: amount, merchant: merchant, category: category, date: date, source: .manual, note: note)
        context.insert(expense)
        
        checkAndCreateSnapshot(for: date, context: context)
        
        // Check for budget alert (80%)
        checkBudgetAlert(context: context)
    }
    
    private func checkAndCreateSnapshot(for date: Date, context: ModelContext) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let descriptor = FetchDescriptor<MonthlySnapshot>(
            predicate: #Predicate<MonthlySnapshot> { $0.month == month && $0.year == year }
        )
        
        if let snapshots = try? context.fetch(descriptor), snapshots.isEmpty {
            // No snapshot for this month, create one
            let appState = AppState.shared
            let snapshot = MonthlySnapshot(
                month: month,
                year: year,
                totalIncome: appState.monthlyIncome,
                suggestedBudget: appState.suggestedVariableBudget
            )
            context.insert(snapshot)
        }
    }
    
    func checkBudgetAlert(context: ModelContext) {
        let appState = AppState.shared
        let totalLimit = appState.suggestedVariableBudget
        guard totalLimit > 0 else { return }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: .now)
        let startOfMonth = calendar.date(from: components)!
        
        let descriptor = FetchDescriptor<Expense>(
            predicate: #Predicate<Expense> { $0.date >= startOfMonth }
        )
        
        if let monthExpenses = try? context.fetch(descriptor) {
            let totalSpent = monthExpenses.reduce(0) { $0 + $1.amount }
            if totalSpent >= (totalLimit * 0.8) {
                NotificationScheduler.shared.sendBudgetAlert(amountRemaining: totalLimit - totalSpent)
            }
        }
    }
}
