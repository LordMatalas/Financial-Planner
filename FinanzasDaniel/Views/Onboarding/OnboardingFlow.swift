import SwiftUI
import SwiftData

enum OnboardingStep: Int, CaseIterable {
    case welcome, income, fixed, debts, goals, budget
}

struct OnboardingFlow: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    
    @State private var currentStep: OnboardingStep = .welcome
    
    // Step Data
    @State private var income: Double = 0
    @State private var payDay: Int = 1
    @State private var fixedExpenses: [TempFixedExpense] = []
    @State private var debts: [TempDebt] = [
        TempDebt(emoji: "💳", name: "Tarjeta de Crédito", balance: "4300000", rate: "25.19", payment: "1000000", day: "10"),
        TempDebt(emoji: "🦷", name: "Ortodoncia", balance: "2000000", rate: "0", payment: "200000", day: "5")
    ]
    @State private var goals: [TempSavingsGoal] = [
        TempSavingsGoal(emoji: "🏍️", name: "BMW G 310 GS", target: 13250000, monthly: 1200000)
    ]
    @State private var notificationsOptIn = true
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background.ignoresSafeArea()
            
            VStack {
                if currentStep != .welcome {
                    headerSection
                        .padding(.top, 16)
                    
                    ProgressBar(progress: Double(currentStep.rawValue + 1) / Double(OnboardingStep.allCases.count))
                        .padding(.horizontal, DesignSystem.Spacing.l)
                        .padding(.top, 10)
                }
                
                ZStack {
                    switch currentStep {
                    case .welcome:
                        OnboardingWelcomeView()
                            .onTapGesture { nextStep() }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    if currentStep == .welcome {
                                        nextStep()
                                    }
                                }
                            }
                    case .income:
                        OnboardingIncomeView(income: $income, payDay: $payDay)
                    case .fixed:
                        OnboardingFixedView(fixedExpenses: $fixedExpenses)
                    case .debts:
                        OnboardingDebtsView(debts: $debts)
                    case .goals:
                        OnboardingGoalsView(goals: $goals, income: income)
                    case .budget:
                        let debtsTotal = debts.reduce(0) { $0 + (Double($1.payment) ?? 0) }
                        OnboardingBudgetView(
                            income: income,
                            fixed: fixedExpenses.reduce(0) { $0 + $1.amount },
                            debts: debtsTotal,
                            goals: goals.reduce(0) { $0 + $1.monthly },
                            buffer: max(income * 0.10, 50_000),
                            notificationsOptIn: $notificationsOptIn,
                            onFinish: finishOnboarding
                        )
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(DesignSystem.Transitions.spring, value: currentStep)
                
                if currentStep != .welcome && currentStep != .budget {
                    footerSection
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: previousStep) {
                Image(systemName: "chevron.left")
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .font(.system(size: 20, weight: .bold))
            }
            .opacity(currentStep == .income ? 0 : 1)
            
            Spacer()
            
            Text("Paso \(currentStep.rawValue + 1) de \(OnboardingStep.allCases.count)")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            // Empty placeholder for symmetry
            Image(systemName: "chevron.left")
                .opacity(0)
        }
        .padding(.horizontal, DesignSystem.Spacing.l)
    }
    
    private var footerSection: some View {
        VStack {
            PrimaryButton(title: currentStep == .goals ? "Ya casi →" : "Continuar →", action: nextStep)
                .disabled(!isStepValid)
                .padding(.horizontal, DesignSystem.Spacing.l)
                .padding(.bottom, DesignSystem.Spacing.xl)
        }
    }
    
    private var isStepValid: Bool {
        switch currentStep {
        case .income: return income > 0
        case .fixed: return true // Optional
        case .debts: return true // Optional
        case .goals: return !goals.isEmpty && goals.allSatisfy { !$0.name.isEmpty && $0.target > 0 }
        default: return true
        }
    }
    
    private func nextStep() {
        if let next = OnboardingStep(rawValue: currentStep.rawValue + 1) {
            withAnimation(DesignSystem.Transitions.spring) {
                currentStep = next
            }
        }
    }
    
    private func previousStep() {
        if let prev = OnboardingStep(rawValue: currentStep.rawValue - 1) {
            withAnimation(DesignSystem.Transitions.spring) {
                currentStep = prev
            }
        }
    }
    
    private func finishOnboarding() {
        print("Finalizando onboarding...")
        
        // Wire to AppState
        appState.monthlyIncome = income
        appState.payDay = payDay
        
        // Save Fixed Expenses to SwiftData
        for temp in fixedExpenses {
            let fixed = FixedExpense(name: temp.name, amount: temp.amount, dueDay: temp.dueDay)
            modelContext.insert(fixed)
        }
        
        // Save Debts to SwiftData
        for temp in debts {
            let debt = Debt(
                name: temp.name,
                emoji: temp.emoji,
                debtType: temp.name.contains("Tarjeta") ? .creditCard : .fixedTerm,
                originalBalance: Double(temp.balance) ?? 0,
                currentBalance: Double(temp.balance) ?? 0,
                annualInterestRate: (Double(temp.rate) ?? 0) / 100.0,
                monthlyPayment: Double(temp.payment) ?? 0,
                dueDay: Int(temp.day) ?? 10
            )
            modelContext.insert(debt)
        }
        
        // Save Goals to SwiftData
        for temp in goals {
            let goal = SavingsGoal(name: temp.name, emoji: temp.emoji, targetAmount: temp.target, monthlyContribution: temp.monthly)
            modelContext.insert(goal)
        }
        
        // Try to save context
        do {
            try modelContext.save()
            print("Datos de onboarding guardados exitosamente.")
        } catch {
            print("Error al guardar contexto: \(error)")
        }
        
        // Calculate Suggested Budget
        appState.suggestedVariableBudget = BudgetCalculator.suggested(
            income: income,
            fixed: fixedExpenses.map { FixedExpense(name: $0.name, amount: $0.amount, dueDay: $0.dueDay) },
            goals: goals.map { SavingsGoal(name: $0.name, emoji: $0.emoji, targetAmount: $0.target, monthlyContribution: $0.monthly) }
        )
        
        // Handle Notifications
        if notificationsOptIn {
            NotificationScheduler.shared.requestAuthorization()
            appState.notificationsGranted = true
        }
        
        // Complete
        print("Marcando onboarding como completo...")
        withAnimation(DesignSystem.Transitions.spring) {
            appState.onboardingComplete = true
        }
    }
}

struct AddFixedExpenseSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var amount: Double = 0
    @State private var dueDay = 1
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $name)
                TextField("Monto", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
                Stepper("Día de vencimiento: \(dueDay)", value: $dueDay, in: 1...31)
            }
            .navigationTitle("Nuevo Gasto Fijo")
            .toolbar {
                Button("Guardar") {
                    let expense = FixedExpense(name: name, amount: amount, dueDay: dueDay)
                    modelContext.insert(expense)
                    dismiss()
                }
            }
        }
    }
}
