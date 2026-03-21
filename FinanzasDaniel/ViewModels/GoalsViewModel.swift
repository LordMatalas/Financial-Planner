import Foundation
import SwiftData
import Observation

@Observable
class GoalsViewModel {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func deleteGoal(_ goal: SavingsGoal) {
        modelContext.delete(goal)
    }
    
    func addGoal(name: String, emoji: String, targetAmount: Double, monthlyContribution: Double, deadline: Date?) {
        let newGoal = SavingsGoal(
            name: name,
            emoji: emoji,
            targetAmount: targetAmount,
            monthlyContribution: monthlyContribution,
            deadline: deadline
        )
        modelContext.insert(newGoal)
    }
}
