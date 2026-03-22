import SwiftUI

struct DashboardView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                heroCard
                goalsSection
                expensesSection
                
                Spacer(minLength: 100) // Space for TabBar
            }
            .padding(.top, 16)
        }
        .background(Color.bgBase)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hola, Daniel 👋")
                    .font(.display(size: 26))
                    .foregroundColor(.textPrimary)
                Text("Marzo 2026")
                    .font(.bodyText(size: 14))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var heroCard: some View {
        AntigravityCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SALDO LIBRE ESTE MES")
                        .font(.system(size: 12, weight: .semibold))
                        .kerning(1.2)
                        .foregroundColor(.textSecondary)
                    
                    Text("$847.000")
                        .font(.moneyNumber(size: 38, weight: .bold))
                        .foregroundColor(.accentMint)
                }
                
                Divider()
                    .background(Color.borderSubtle)
                
                HStack(spacing: 0) {
                    metricCol(title: "Ingresos", amount: "$2.450.000", color: .accentMint)
                    Spacer()
                    metricCol(title: "Fijos", amount: "$1.300.000", color: .accentRose.opacity(0.6))
                    Spacer()
                    metricCol(title: "Variables", amount: "$303.000", color: .accentAmber)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func metricCol(title: String, amount: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
            Text(amount)
                .font(.moneyNumber(size: 15, weight: .semibold))
                .foregroundColor(color)
        }
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tus metas")
                    .font(.heading(size: 16))
                    .foregroundColor(.textPrimary)
                Spacer()
                Button(action: {}) {
                    Text("Ver todas →")
                        .font(.system(size: 13))
                        .foregroundColor(.accentViolet)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    miniGoalCard(emoji: "🏍️", name: "BMW G 310...", progress: 0.34, percentStr: "34%", subtitle: "Mes 14")
                    miniGoalCard(emoji: "🛡️", name: "Fondo emerg.", progress: 0.26, percentStr: "26%", subtitle: "Mes 8")
                    miniGoalCard(emoji: "✈️", name: "Viaje a Med.", progress: 0.67, percentStr: "67%", subtitle: "Mes 2")
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
                .foregroundColor(.textPrimary)
                .lineLimit(1)
            
            ProgressBar(progress: progress)
            
            HStack {
                Text(percentStr)
                    .font(.moneyNumber(size: 13))
                    .foregroundColor(.accentMint)
                Spacer()
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(16)
        .frame(width: 140, height: 160)
        .background(Color.bgElevated)
        .cornerRadius(18)
    }
    
    private var expensesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hoy · $37.500 gastados")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                expenseRow(emoji: "🍔", name: "Juan Valdez", amount: "$8.500", category: "Café · Chapinero", type: .wallet, color: .accentMint)
                Divider().background(Color.borderSubtle).padding(.leading, 70)
                expenseRow(emoji: "🚌", name: "SITP", amount: "$4.200", category: "Transporte", type: .wallet, color: .accentViolet)
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
                    .font(.bodyText(size: 15))
                    .foregroundColor(.textPrimary)
                HStack {
                    Text(category)
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Image(systemName: type == .wallet ? "creditcard.fill" : "pencil")
                        .font(.system(size: 10))
                        .foregroundColor(.textTertiary)
                        .padding(4)
                        .background(Color.bgElevated)
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
    DashboardView()
}
