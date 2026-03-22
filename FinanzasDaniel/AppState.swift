import SwiftUI
import Observation
import SwiftData

@Observable
class AppState {
    static let shared = AppState()
    
    // Core from UserDefaults
    var onboardingComplete: Bool = UserDefaults.standard.bool(forKey: "onboarding_complete") {
        didSet { UserDefaults.standard.set(onboardingComplete, forKey: "onboarding_complete") }
    }
    
    var monthlyIncome: Double = UserDefaults.standard.double(forKey: "monthly_income") {
        didSet { UserDefaults.standard.set(monthlyIncome, forKey: "monthly_income") }
    }
    
    var payDay: Int = UserDefaults.standard.integer(forKey: "pay_day") {
        didSet { UserDefaults.standard.set(payDay, forKey: "pay_day") }
    }
    
    var suggestedVariableBudget: Double = UserDefaults.standard.double(forKey: "suggested_variable_budget") {
        didSet { UserDefaults.standard.set(suggestedVariableBudget, forKey: "suggested_variable_budget") }
    }
    
    var notificationsGranted: Bool = UserDefaults.standard.bool(forKey: "notifications_granted") {
        didSet { UserDefaults.standard.set(notificationsGranted, forKey: "notifications_granted") }
    }
    
    // Live Metrics (should be updated by queries in Views or via observers)
    var currentMonthExpenses: Double = 0
    var currentMonthSaved: Double = 0
    var activeGoals: [SavingsGoal] = []
    
    var currentMonthSnapshot: MonthlySnapshot?
    var previousMonthSnapshot: MonthlySnapshot?
    
    private init() {}
    
    func recalculateSuggestedBudget(fixedExpenses: [FixedExpense], goals: [SavingsGoal]) {
        self.suggestedVariableBudget = BudgetCalculator.suggested(
            income: monthlyIncome,
            fixed: fixedExpenses,
            goals: goals
        )
    }
    
    func scheduleAllNotifications(fixedExpenses: [FixedExpense]) {
        NotificationScheduler.shared.rescheduleAll(fixedExpenses: fixedExpenses)
    }
    
    func snapshotPreviousMonthIfNeeded(context: ModelContext) {
        // Logic will be in MonthlySnapshot+AutoCreate.swift
    }
}
