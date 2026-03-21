import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var goals: [SavingsGoal]
    @Query private var expenses: [Expense]
    @Query private var fixedExpenses: [FixedExpense]
    
    @State private var viewModel: DashboardViewModel?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Monthly Flow Card
                    monthlyFlowCard
                    
                    // Goal Progress Mini Cards
                    goalsSummarySection
                    
                    // Category Chart
                    categoryBreaksdownSection
                }
                .padding()
            }
            .navigationTitle(currentMonthTitle)
            .onAppear {
                if viewModel == nil {
                    viewModel = DashboardViewModel(modelContext: modelContext)
                }
            }
        }
    }
    
    private var dashboardViewModel: DashboardViewModel {
        viewModel ?? DashboardViewModel(modelContext: modelContext)
    }
    
    private var currentMonthTitle: String {
        Date().formatted(.dateTime.month(.wide).year())
    }
    
    private var monthlyFlowCard: some View {
        let flow = dashboardViewModel.calculateMonthlyFlow(fixed: fixedExpenses, variable: expenses)
        
        return VStack(spacing: 16) {
            HStack {
                Text("Flujo Mensual")
                    .font(.headline)
                Spacer()
                Text(flow.freeBalance.cop)
                    .font(.title2).bold()
                    .foregroundColor(flow.freeBalance >= 0 ? .green : .red)
                    .monospacedDigit()
            }
            
            Divider()
            
            HStack {
                FlowItem(title: "Ingresos", amount: dashboardViewModel.monthlyIncome.cop, color: .primary)
                Spacer()
                FlowItem(title: "Gastos Fijos", amount: flow.fixedTotal.cop, color: .secondary)
                Spacer()
                FlowItem(title: "Gastos Var.", amount: flow.variableTotal.cop, color: .secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private var goalsSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metas Activas")
                .font(.headline)
            
            if goals.filter({ $0.isActive }).isEmpty {
                Text("No hay metas activas")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(goals.filter({ $0.isActive })) { goal in
                            GoalMiniCard(goal: goal)
                        }
                    }
                }
            }
        }
    }
    
    private var categoryBreaksdownSection: some View {
        let categoryStats = dashboardViewModel.expensesByCategory(expenses: expenses)
        let maxAmount = categoryStats.map { $0.amount }.max() ?? 1
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Gastos por Categoría")
                .font(.headline)
            
            if categoryStats.isEmpty {
                Text("Sin gastos registrados este mes")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(categoryStats, id: \.category) { stat in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(stat.category.emoji) \(stat.category.rawValue)")
                                    .font(.caption)
                                Spacer()
                                Text(stat.amount.cop)
                                    .font(.caption).bold()
                                    .monospacedDigit()
                            }
                            
                            GeometryReader { geometry in
                                Capsule()
                                    .fill(Color.accentColor.opacity(0.8))
                                    .frame(width: geometry.size.width * CGFloat(stat.amount / maxAmount))
                            }
                            .frame(height: 8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct FlowItem: View {
    let title: String
    let amount: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(amount)
                .font(.caption).bold()
                .monospacedDigit()
                .foregroundColor(color)
        }
    }
}

struct GoalMiniCard: View {
    let goal: SavingsGoal
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(goal.emoji)
                .font(.title2)
            Text(goal.name)
                .font(.caption).bold()
                .lineLimit(1)
            
            let progress = goal.targetAmount > 0 ? goal.savedAmount / goal.targetAmount : 0
            let remaining = goal.targetAmount - goal.savedAmount
            let months = goal.monthlyContribution > 0 ? Int(ceil(remaining / goal.monthlyContribution)) : 0
            
            Text("\(Int(progress * 100))% • \(months) m")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(width: 100)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
