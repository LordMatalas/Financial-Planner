import Foundation
import SwiftData

@Model
class SavingsGoal {
    var id: UUID
    var name: String
    var emoji: String
    var targetAmount: Double
    var savedAmount: Double
    var deadline: Date?
    var monthlyContribution: Double
    var isActive: Bool
    var createdAt: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \Contribution.goal)
    var contributions: [Contribution] = []

    init(id: UUID = UUID(), name: String, emoji: String, targetAmount: Double, savedAmount: Double = 0, deadline: Date? = nil, monthlyContribution: Double, isActive: Bool = true, createdAt: Date? = .now) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.targetAmount = targetAmount
        self.savedAmount = savedAmount
        self.deadline = deadline
        self.monthlyContribution = monthlyContribution
        self.isActive = isActive
        self.createdAt = createdAt
    }
}
