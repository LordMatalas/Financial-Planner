import SwiftUI

struct ExpensesView: View {
    @State private var selectedFilter = "Todos"
    let filters = ["Todos", "🍔 Comida", "🚌 Trans.", "🎮 Ocio", "💊 Salud", "💸 Otro"]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    budgetHeader
                    filtersCarousel
                    expensesList
                    
                    Spacer(minLength: 100) // TabBar space
                }
                .padding(.top, 16)
            }
            .background(Color.bgBase)
            
            // FAB
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.bgBase)
                    .frame(width: 60, height: 60)
                    .background(Color.gradViolet)
                    .clipShape(Circle())
            }
            .padding(.trailing, 24)
            .padding(.bottom, 106) // 82 tab bar + 24
        }
    }
    
    private var budgetHeader: some View {
        AntigravityCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("GASTOS VARIABLES · MARZO")
                    .font(.system(size: 12, weight: .semibold))
                    .kerning(1.2)
                    .foregroundColor(.textSecondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("$303.000")
                        .font(.moneyNumber(size: 28, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    Text("de $450.000")
                        .font(.system(size: 18))
                        .foregroundColor(.textSecondary)
                }
                
                ProgressBar(progress: 0.67, isWarning: true) // 67% amber warning
                
                Text("Quedan $147.000 · 11 días del mes")
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var filtersCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        withAnimation { selectedFilter = filter }
                    }) {
                        Text(filter == "Todos" ? "Todos ●" : filter)
                            .font(.system(size: 13, weight: .medium))
                            .padding(.horizontal, 16)
                            .frame(height: 32)
                            .background(
                                selectedFilter == filter ? Color.accentViolet : Color.clear
                            )
                            .foregroundColor(
                                selectedFilter == filter ? Color.bgBase : Color.textTertiary
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(selectedFilter == filter ? Color.clear : Color.textTertiary.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var expensesList: some View {
        VStack(alignment: .leading, spacing: 24) {
            expenseGroup(title: "HOY", date: "Mar 22", items: [
                ("🍔", "Juan Valdez", "Café · Chapinero", "$8.500", .wallet, Color.accentMint),
                ("🚌", "SITP", "Transporte", "$4.200", .wallet, Color.accentViolet),
                ("🎮", "Netflix", "Suscripción", "$21.900", .manual, Color.accentAmber)
            ])
            
            expenseGroup(title: "AYER", date: "Mar 21", items: [
                ("🍔", "Crepes & Waffles", "Almuerzo", "$34.000", .wallet, Color.accentMint),
                ("🚌", "Uber", "Transporte", "$18.500", .wallet, Color.accentViolet)
            ])
        }
    }
    
    private func expenseGroup(title: String, date: String, items: [(String, String, String, String, ExpenseType, Color)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .kerning(1.2)
                    .foregroundColor(.textTertiary)
                Spacer()
                Text(date)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                ForEach(0..<items.count, id: \.self) { i in
                    let item = items[i]
                    expenseRow(emoji: item.0, name: item.1, category: item.2, amount: item.3, type: item.4, color: item.5)
                        .padding(.horizontal, 20)
                    
                    if i < items.count - 1 {
                        Divider()
                            .background(Color.borderSubtle)
                            .padding(.leading, 70)
                    }
                }
            }
        }
    }
    
    enum ExpenseType { case wallet, manual }
    
    private func expenseRow(emoji: String, name: String, category: String, amount: String, type: ExpenseType, color: Color) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(Text(emoji))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.bodyText(size: 15))
                    .foregroundColor(.textPrimary)
                HStack {
                    Text(category)
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    
                    Image(systemName: type == .wallet ? "creditcard.fill" : "pencil")
                        .font(.system(size: 10))
                        .foregroundColor(type == .wallet ? .textPrimary : .textSecondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            Text(amount)
                .font(.moneyNumber(size: 15))
                .foregroundColor(.textPrimary)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    ExpensesView()
}
