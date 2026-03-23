import Foundation

struct BudgetCalculator {
    static func suggested(income: Double, fixed: [FixedExpense], debts: [Debt] = [], goals: [SavingsGoal]) -> Double {
        let fixedTotal = fixed.filter { $0.isActive }.reduce(0) { $0 + $1.amount }
        let debtsTotal = debts.filter { $0.isActive }.reduce(0) { $0 + $1.monthlyPayment }
        let goalsTotal = goals.reduce(0) { $0 + $1.monthlyContribution }
        let buffer = max(income * 0.10, 50_000)
        
        return max(income - fixedTotal - debtsTotal - goalsTotal - buffer, 0)
    }
}
