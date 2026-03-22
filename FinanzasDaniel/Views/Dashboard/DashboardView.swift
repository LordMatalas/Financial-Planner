import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @Query private var goals: [SavingsGoal]
    @Query private var fixedExpenses: [FixedExpense]
    @Query(sort: \MonthlySnapshot.createdAt, order: .reverse) private var snapshots: [MonthlySnapshot]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                statsSection
                heroCard
                goalsSection
                expensesSection
                
                Spacer(minLength: 100) // Space for TabBar
            }
            .padding(.top, 16)
        }
        .background(DesignSystem.Colors.background)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hola, Daniel 👋")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                Text(Date.now.formatted(.dateTime.month(.wide).year()))
                    .font(.system(size: 14))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 22))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                if let current = snapshots.first {
                    let prev = snapshots.count > 1 ? snapshots[1] : nil
                    StatsComparisonCard(
                        title: "Gastos vs. Anterior",
                        current: current.totalExpenses,
                        previous: prev?.totalExpenses ?? 0,
                        isPositiveBetter: false
                    )
                    
                    StatsComparisonCard(
                        title: "Ahorro vs. Anterior",
                        current: current.totalSaved,
                        previous: prev?.totalSaved ?? 0,
                        isPositiveBetter: true
                    )
                } else {
                    // Empty state logic from speckit.specify
                    AntigravityCard {
                        Text("Aún no hay mes anterior para comparar. Vuelve en \(daysUntilNextMonth()) días.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                            .padding()
                    }
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(style: StrokeStyle(lineWidth: 1, dash: [4])))
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func daysUntilNextMonth() -> Int {
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: .now)!
        let firstOfNext = calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth))!
        return calendar.dateComponents([.day], from: .now, to: firstOfNext).day ?? 0
    }
    
    private var heroCard: some View {
        let totalIncome = appState.monthlyIncome
        let fixedTotal = fixedExpenses.filter { $0.activeThisMonth }.reduce(0) { $0 + $1.amount }
        let goalTotal = goals.reduce(0) { $0 + $1.monthlyContribution }
        
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: .now))!
        let monthExpenses = expenses.filter { $0.date >= startOfMonth }
        let variableSpent = monthExpenses.reduce(0) { $0 + $1.amount }
        
        let freeBalance = totalIncome - fixedTotal - goalTotal - variableSpent
        
        return AntigravityCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SALDO LIBRE ESTE MES")
                        .font(.system(size: 12, weight: .semibold))
                        .kerning(1.2)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Text("$\(Int(freeBalance))")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.primary)
                        .currencyFormat()
                }
                
                Divider()
                    .background(DesignSystem.Colors.border)
                
                HStack(spacing: 0) {
                    metricCol(title: "Ingresos", amount: "$\(Int(totalIncome))", color: DesignSystem.Colors.primary)
                    Spacer()
                    metricCol(title: "Fijos", amount: "$\(Int(fixedTotal))", color: DesignSystem.Colors.destructive.opacity(0.6))
                    Spacer()
                    metricCol(title: "Variables", amount: "$\(Int(variableSpent))", color: DesignSystem.Colors.warning)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func metricCol(title: String, amount: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            Text(amount)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(color)
                .currencyFormat()
        }
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tus metas")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                Spacer()
                Button(action: {}) {
                    Text("Ver todas →")
                        .font(.system(size: 13))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(goals) { goal in
                        miniGoalCard(emoji: goal.emoji, name: goal.name, progress: goal.savedAmount / goal.targetAmount, percentStr: "\(Int((goal.savedAmount / goal.targetAmount) * 100))%", subtitle: "Aporte $\(Int(goal.monthlyContribution))")
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func miniGoalCard(emoji: String, name: String, progress: Double, percentStr: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(emoji)
                .font(.system(size: 32))
            
            Text(name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(1)
            
            ProgressBar(progress: progress)
            
            HStack {
                Text(percentStr)
                    .font(.system(size: 13))
                    .foregroundColor(DesignSystem.Colors.primary)
                    .currencyFormat()
                Spacer()
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
        }
        .padding(16)
        .frame(width: 140, height: 160)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(18)
    }
    
    private var expensesSection: some View {
        let today = Calendar.current.startOfDay(for: .now)
        let todayExpenses = expenses.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        let todayTotal = todayExpenses.reduce(0) { $0 + $1.amount }
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Hoy · $\(Int(todayTotal)) gastados")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                ForEach(todayExpenses) { expense in
                    expenseRow(emoji: expense.category.emoji, name: expense.merchant, amount: "$\(Int(expense.amount))", category: expense.category.rawValue, type: expense.source == .wallet ? .wallet : .manual, color: DesignSystem.Colors.primary)
                    if expense != todayExpenses.last {
                        Divider().background(DesignSystem.Colors.border).padding(.leading, 70)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    enum ExpenseType { case wallet, manual }
    
    private func expenseRow(emoji: String, name: String, amount: String, category: String, type: ExpenseType, color: Color) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(Text(emoji))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 15))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                HStack {
                    Text(category)
                        .font(.system(size: 13))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    Spacer()
                    Image(systemName: type == .wallet ? "creditcard.fill" : "pencil")
                        .font(.system(size: 10))
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                        .padding(4)
                        .background(DesignSystem.Colors.elevated)
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            Text(amount)
                .font(.system(size: 15))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .currencyFormat()
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    DashboardView()
}
