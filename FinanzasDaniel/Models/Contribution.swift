import Foundation
import SwiftData

@Model
class Contribution {
    var id: UUID
    var amount: Double
    var note: String
    var date: Date
    var goal: SavingsGoal?

    init(id: UUID = UUID(), amount: Double, note: String, date: Date = .now, goal: SavingsGoal? = nil) {
        self.id = id
        self.amount = amount
        self.note = note
        self.date = date
        self.goal = goal
    }
}
