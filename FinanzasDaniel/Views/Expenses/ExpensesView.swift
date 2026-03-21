import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    
    @State private var showingAddExpense = false
    @State private var viewModel: ExpensesViewModel?
    @State private var selectedCategory: ExpenseCategory?

    var body: some View {
        NavigationStack {
            VStack {
                // Budget Header
                budgetHeader
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        FilterChip(title: "Todos", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            FilterChip(title: category.rawValue, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Expenses List
                List {
                    ForEach(groupedExpenses.keys.sorted(by: >), id: \.self) { date in
                        Section(header: Text(date.formatted(date: .long, time: .omitted))) {
                            ForEach(groupedExpenses[date] ?? []) { expense in
                                ExpenseRowView(expense: expense)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            expensesViewModel.deleteExpense(expense)
                                        } label: {
                                            Label("Eliminar", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Gastos Hormiga")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseSheet()
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = ExpensesViewModel(modelContext: modelContext)
                }
            }
        }
    }
    
    private var expensesViewModel: ExpensesViewModel {
        viewModel ?? ExpensesViewModel(modelContext: modelContext)
    }
    
    private var budgetHeader: some View {
        let total = expensesViewModel.totalSpent(in: expenses)
        let budget = expensesViewModel.monthlyBudget
        let progress = min(total / budget, 1.0)
        
        return VStack(spacing: 8) {
            HStack {
                Text("Este mes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(total.cop) / \(budget.cop)")
                    .font(.subheadline).bold()
                    .monospacedDigit()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.secondarySystemBackground))
                    Capsule()
                        .fill(progressColor(progress))
                        .frame(width: geometry.size.width * CGFloat(progress))
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private func progressColor(_ progress: Double) -> Color {
        if progress < 0.7 { return .green }
        if progress < 0.9 { return .yellow }
        return .red
    }
    
    private var filteredExpenses: [Expense] {
        if let category = selectedCategory {
            return expenses.filter { $0.category == category }
        }
        return expenses
    }
    
    private var groupedExpenses: [Date: [Expense]] {
        Dictionary(grouping: filteredExpenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption).bold()
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
