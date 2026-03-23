import Foundation
import SwiftData

@Model
class Debt {
    var id: UUID = UUID()
    var name: String
    var emoji: String
    var debtType: DebtType
    var originalBalance: Double
    var currentBalance: Double
    var annualInterestRate: Double // EAR as decimal (0.2519 = 25.19%)
    var monthlyPayment: Double
    var dueDay: Int
    var deadline: Date?
    var isActive: Bool = true
    var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \DebtPayment.debt)
    var payments: [DebtPayment] = []
    
    var notes: String = ""
    
    init(name: String, emoji: String, debtType: DebtType, originalBalance: Double, currentBalance: Double, annualInterestRate: Double, monthlyPayment: Double, dueDay: Int, deadline: Date? = nil, notes: String = "") {
        self.name = name
        self.emoji = emoji
        self.debtType = debtType
        self.originalBalance = originalBalance
        self.currentBalance = currentBalance
        self.annualInterestRate = annualInterestRate
        self.monthlyPayment = monthlyPayment
        self.dueDay = dueDay
        self.deadline = deadline
        self.notes = notes
    }
    
    // MARK: - Computed Properties
    
    var monthlyRate: Double {
        pow(1 + annualInterestRate, 1.0/12.0) - 1
    }
    
    var monthlyInterest: Double {
        currentBalance * monthlyRate
    }
    
    var monthlyPrincipal: Double {
        max(monthlyPayment - monthlyInterest, 0)
    }
    
    var monthsToPayoff: Int? {
        guard annualInterestRate > 0 else {
            return monthlyPayment > 0 ? max(0, Int(ceil(currentBalance / monthlyPayment))) : nil
        }
        
        let r = monthlyRate
        let P = monthlyPayment
        let B = max(currentBalance, 0.0)
        
        guard P > B * r else { return nil } // Paying only interest or less
        
        let n = -log(1 - (B * r) / P) / log(1 + r)
        return max(0, Int(ceil(n)))
    }
    
    var projectedPayoffDate: Date? {
        guard let months = monthsToPayoff else { return nil }
        return Calendar.current.date(byAdding: .month, value: months, to: Date())
    }
    
    var totalInterestRemaining: Double {
        guard let months = monthsToPayoff, annualInterestRate > 0 else { return 0 }
        
        var totalInterest = 0.0
        var tempBalance = currentBalance
        let r = monthlyRate
        let P = monthlyPayment
        
        for _ in 0..<months {
            let interest = tempBalance * r
            totalInterest += interest
            tempBalance -= (P - interest)
            if tempBalance <= 0 { break }
        }
        
        return totalInterest
    }
    
    var progressPercent: Double {
        guard originalBalance > 0 else { return 0 }
        return (originalBalance - currentBalance) / originalBalance
    }
    
    var isOnTrack: Bool {
        guard let deadline = deadline, let payoffDate = projectedPayoffDate else { return true }
        return payoffDate <= deadline
    }
    
    var hasInterest: Bool {
        annualInterestRate > 0
    }
}

enum DebtType: String, Codable, CaseIterable {
    case creditCard = "Tarjeta de crédito"
    case fixedTerm = "Plazo fijo"
    case custom = "Otro"
}

@Model
class DebtPayment {
    var id: UUID = UUID()
    var debt: Debt?
    var totalPaid: Double
    var principalPaid: Double
    var interestPaid: Double
    var balanceBefore: Double
    var balanceAfter: Double
    var date: Date
    var note: String
    var source: PaymentSource
    
    init(totalPaid: Double, principalPaid: Double, interestPaid: Double, balanceBefore: Double, balanceAfter: Double, date: Date = Date(), note: String = "", source: PaymentSource = .manual) {
        self.totalPaid = totalPaid
        self.principalPaid = principalPaid
        self.interestPaid = interestPaid
        self.balanceBefore = balanceBefore
        self.balanceAfter = balanceAfter
        self.date = date
        self.note = note
        self.source = source
    }
}

enum PaymentSource: String, Codable {
    case manual = "Manual"
    case notification = "Notificación"
}
