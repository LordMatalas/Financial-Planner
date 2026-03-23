import SwiftUI
import SwiftData

struct DebtDetailView: View {
    let debt: Debt
    @Environment(\.dismiss) var dismiss
    @State private var showingPaymentSheet = false
    @State private var simulatorAmount: Double
    @State private var showingAmortization = false
    
    init(debt: Debt) {
        self.debt = debt
        self._simulatorAmount = State(initialValue: debt.monthlyPayment)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Hero Section
                VStack(spacing: 8) {
                    Text(debt.emoji)
                        .font(.system(size: 48))
                    
                    Text(debt.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(debt.hasInterest ? "Con interés · \(String(format: "%.2f", debt.annualInterestRate * 100))% EA" : "Sin interés")")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                
                // Payoff Ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 12)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(debt.progressPercent))
                        .stroke(debt.hasInterest ? Color.accentRose : Color.accentViolet, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .shadow(color: (debt.hasInterest ? Color.accentRose : Color.accentViolet).opacity(0.3), radius: 10)
                    
                    VStack(spacing: 4) {
                        Text("\(Int(debt.progressPercent * 100))%")
                            .font(.system(size: 34, weight: .semibold, design: .monospaced))
                        
                        Text("$\(Int(debt.originalBalance - debt.currentBalance).formatted()) pagado")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                }
                .frame(width: 200, height: 200)
                .frame(maxWidth: .infinity)
                
                // Stats Grid (2x2)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    StatGridCard(
                        label: "Balance restante",
                        value: "$\(Int(debt.currentBalance).formatted())",
                        color: .accentRose
                    )
                    StatGridCard(
                        label: "Cuota mensual",
                        value: "$\(Int(debt.monthlyPayment).formatted())",
                        color: .textPrimary
                    )
                    StatGridCard(
                        label: "Interés mensual",
                        value: "$\(Int(debt.monthlyInterest).formatted())",
                        color: .accentAmber
                    )
                    StatGridCard(
                        label: "Libre en",
                        value: "\(debt.monthsToPayoff ?? 0) meses",
                        color: .accentMint
                    )
                }
                .padding(.horizontal, 20)
                
                // Interest Callout Card
                if debt.hasInterest {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("💸 En \(debt.monthsToPayoff ?? 0) meses pagarás $\(Int(debt.totalInterestRemaining).formatted()) solo en intereses.")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.surfaceSecondary)
                    .cornerRadius(16)
                    .overlay(
                        Rectangle()
                            .fill(Color.accentRose)
                            .frame(width: 3)
                            .cornerRadius(3),
                        alignment: .leading
                    )
                    .padding(.horizontal, 20)
                }
                
                // Simulator Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("¿Qué pasa si pago más?")
                        .font(.system(size: 14, weight: .medium))
                    
                    VStack(spacing: 8) {
                        let safeMin = min(debt.monthlyInterest + 1, debt.currentBalance == 0 ? 1 : debt.currentBalance)
                        let safeMax = max(debt.currentBalance, safeMin + 1)
                        
                        Slider(value: $simulatorAmount, in: safeMin...safeMax)
                            .accentColor(.accentRose)
                        
                        HStack {
                            Text("$\(Int(safeMin).formatted()) min")
                            Spacer()
                            Text("$\(Int(safeMax).formatted()) max")
                        }
                        .font(.system(size: 11))
                        .foregroundColor(.textTertiary)
                    }
                    
                    let simulatedMonths = simulatePayoff(amount: simulatorAmount)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Quedarías libre en: Mes \(simulatedMonths) · \(simulatedPayoffDate(months: simulatedMonths))")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        let interestSavings = debt.totalInterestRemaining - simulateTotalInterest(amount: simulatorAmount)
                        if interestSavings > 0 {
                            Text("Ahorrarías $\(Int(interestSavings).formatted()) en intereses")
                                .font(.system(size: 13))
                                .foregroundColor(.accentMint)
                        }
                        
                        let delta = simulatorAmount - debt.monthlyPayment
                        if delta > 0 {
                            Text("Pagando $\(Int(delta).formatted()) más/mes")
                                .font(.system(size: 12))
                                .foregroundColor(.textTertiary)
                        }
                    }
                    .animation(.spring(), value: simulatorAmount)
                }
                .padding(20)
                .background(Color.surfacePrimary)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // Amortization Preview
                VStack(alignment: .leading, spacing: 16) {
                    Button(action: { showingAmortization.toggle() }) {
                        HStack {
                            Text("Ver tabla de pagos")
                            Spacer()
                            Image(systemName: showingAmortization ? "chevron.up" : "chevron.down")
                        }
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    }
                    
                    if showingAmortization {
                        AmortizationTable(debt: debt)
                    }
                }
                .padding(.horizontal, 20)
                
                // Footer Padding
                Spacer().frame(height: 100)
            }
        }
        .background(Color.bgBase)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: { showingPaymentSheet = true }) {
                    Text("Registrar pago")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.accentRose, Color.accentRose.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .background(
                    Color.bgBase.opacity(0.8)
                        .blur(radius: 20)
                        .edgesIgnoringSafeArea(.bottom)
                )
            }
        )
        .sheet(isPresented: $showingPaymentSheet) {
            DebtPaymentSheet(debt: debt)
        }
    }
    
    private func simulatePayoff(amount: Double) -> Int {
        let r = debt.monthlyRate
        let b = max(debt.currentBalance, 0)
        guard amount > b * r else { return 0 }
        let n = -log(1 - (b * r) / amount) / log(1 + r)
        return max(0, Int(ceil(n)))
    }
    
    private func simulatedPayoffDate(months: Int) -> String {
        let date = Calendar.current.date(byAdding: .month, value: months, to: Date()) ?? Date()
        return date.formatted(.dateTime.month().year())
    }
    
    private func simulateTotalInterest(amount: Double) -> Double {
        let months = simulatePayoff(amount: amount)
        var total = 0.0
        var bal = debt.currentBalance
        let r = debt.monthlyRate
        for _ in 0..<months {
            let interest = bal * r
            total += interest
            bal -= (amount - interest)
            if bal <= 0 { break }
        }
        return total
    }
}

struct StatGridCard: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 15, weight: .medium, design: .monospaced))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.surfacePrimary)
        .cornerRadius(12)
    }
}

struct AmortizationTable: View {
    let debt: Debt
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Mes").frame(width: 40, alignment: .leading)
                Text("Capital").frame(maxWidth: .infinity, alignment: .trailing)
                Text("Interés").frame(maxWidth: .infinity, alignment: .trailing)
                Text("Saldo").frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.textTertiary)
            .padding(.bottom, 8)
            
            // Rows
            let rows = getAmortizationRows()
            ForEach(rows.indices, id: \.self) { i in
                HStack {
                    Text("\(i + 1)").frame(width: 40, alignment: .leading)
                    Text("$\(Int(rows[i].principal).formatted())").foregroundColor(.accentMint).frame(maxWidth: .infinity, alignment: .trailing)
                    Text("$\(Int(rows[i].interest).formatted())").foregroundColor(.accentRose).frame(maxWidth: .infinity, alignment: .trailing)
                    Text("$\(Int(rows[i].balance).formatted())").frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.system(size: 12, design: .monospaced))
                .padding(.vertical, 8)
                .overlay(Rectangle().frame(height: 0.5).foregroundColor(.borderSubtle), alignment: .bottom)
            }
            
            Button("Ver todos los \(debt.monthsToPayoff ?? 0) meses →") {
                // Future expansion
            }
            .font(.system(size: 12))
            .foregroundColor(.accentMint)
            .padding(.top, 12)
        }
    }
    
    struct RowData {
        let principal: Double
        let interest: Double
        let balance: Double
    }
    
    private func getAmortizationRows() -> [RowData] {
        var rows: [RowData] = []
        var bal = debt.currentBalance
        let r = debt.monthlyRate
        let p = debt.monthlyPayment
        
        let limit = max(0, min(5, debt.monthsToPayoff ?? 0))
        for _ in 0..<limit {
            let interest = bal * r
            let principal = p - interest
            bal -= principal
            rows.append(RowData(principal: principal, interest: interest, balance: max(bal, 0)))
        }
        return rows
    }
}
