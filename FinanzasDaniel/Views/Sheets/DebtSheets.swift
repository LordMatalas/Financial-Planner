import SwiftUI
import SwiftData

struct DebtPaymentSheet: View {
    let debt: Debt
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var amount: String
    @State private var date: Date = Date()
    @State private var note: String = ""
    
    init(debt: Debt) {
        self.debt = debt
        self._amount = State(initialValue: String(format: "%.0f", debt.monthlyPayment))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Registrar pago")
                            .font(.system(size: 22, weight: .semibold))
                        Text(debt.name)
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Hero amount input
                    VStack(spacing: 8) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$")
                                .font(.system(size: 20, design: .monospaced))
                                .foregroundColor(.accentRose)
                            
                            TextField("0", text: $amount)
                                .font(.system(size: 52, weight: .bold, design: .monospaced))
                                .keyboardType(.numberPad)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Rectangle()
                            .fill(Color.accentRose)
                            .frame(width: 200, height: 2)
                        
                        Text("Cuota sugerida: $\(Int(debt.monthlyPayment).formatted())")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                    }
                    .padding(.top, 16)
                    
                    // Breakdown Card
                    let paidAmount = Double(amount) ?? 0
                    let interest = debt.currentBalance * debt.monthlyRate
                    let principal = max(paidAmount - interest, 0)
                    let newBalance = max(debt.currentBalance - principal, 0)
                    let newPayoffMonths = simulatePayoff(bal: newBalance, p: debt.monthlyPayment, r: debt.monthlyRate)
                    let newPayoffDate = formatDate(months: newPayoffMonths)
                    
                    DebtBreakdownCard(
                        principal: principal,
                        interest: interest,
                        newBalance: newBalance,
                        newPayoffDate: "Mes \(newPayoffMonths) · \(newPayoffDate)"
                    )
                    .padding(.horizontal, 20)
                    .animation(.spring(), value: amount)
                    
                    // Date row
                    VStack(alignment: .leading, spacing: 12) {
                        DatePicker(selection: $date, displayedComponents: .date) {
                            HStack {
                                Text("📅")
                                Text("Fecha de pago")
                                    .font(.system(size: 14))
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(Color.surfacePrimary)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    
                    // Note field
                    TextField("Nota opcional...", text: $note)
                        .padding(18)
                        .background(Color.surfacePrimary)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    
                    // CTA
                    Button(action: recordPayment) {
                        Text("Confirmar pago $\((Int(paidAmount)).formatted())")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.accentRose)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .background(Color.bgBase)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
    
    private func recordPayment() {
        let paidAmount = Double(amount) ?? 0
        let interest = debt.currentBalance * debt.monthlyRate
        let principal = max(paidAmount - interest, 0)
        let before = debt.currentBalance
        let after = max(before - principal, 0)
        
        let payment = DebtPayment(
            totalPaid: paidAmount,
            principalPaid: principal,
            interestPaid: interest,
            balanceBefore: before,
            balanceAfter: after,
            date: date,
            note: note,
            source: .manual
        )
        
        debt.payments.append(payment)
        debt.currentBalance = after
        
        try? modelContext.save()
        dismiss()
    }
    
    private func simulatePayoff(bal: Double, p: Double, r: Double) -> Int {
        guard bal > 0 else { return 0 }
        guard r > 0 else {
            return p > 0 ? Int(ceil(bal / p)) : 0
        }
        guard p > bal * r else { return 0 }
        let n = -log(1 - (bal * r) / p) / log(1 + r)
        return Int(ceil(n))
    }
    
    private func formatDate(months: Int) -> String {
        let d = Calendar.current.date(byAdding: .month, value: months, to: date) ?? date
        return d.formatted(.dateTime.month().year())
    }
}

// MARK: - AddDebtSheet

struct AddDebtSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name: String = ""
    @State private var emoji: String = "💳"
    @State private var type: DebtType = .creditCard
    @State private var balance: String = ""
    @State private var annualRate: Double = 0.2519
    @State private var monthlyPayment: String = ""
    @State private var dueDay: Int = 10
    @State private var hasDeadline: Bool = false
    @State private var deadline: Date = Date().addingTimeInterval(3600*24*30*12)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Nueva deuda")
                        .font(.system(size: 22, weight: .semibold))
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    // Emoji + Name
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Text(emoji)
                                .font(.system(size: 24))
                                .frame(width: 44, height: 44)
                                .background(Color.surfacePrimary)
                                .clipShape(Circle())
                        }
                        
                        TextField("Nombre de la deuda", text: $name)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    
                    // Type Segmented
                    Picker("Tipo", selection: $type) {
                        Text("💳 Tarjeta").tag(DebtType.creditCard)
                        Text("📅 Plazo fijo").tag(DebtType.fixedTerm)
                        Text("💸 Otro").tag(DebtType.custom)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    
                    // Saldo Actual
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Saldo actual")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$")
                                .font(.system(size: 20, design: .monospaced))
                                .foregroundColor(.accentRose)
                            TextField("0", text: $balance)
                                .font(.system(size: 44, weight: .bold, design: .monospaced))
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Interest Rate
                    if type != .fixedTerm || annualRate > 0 {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Tasa anual (EA)")
                                    .font(.system(size: 14, weight: .medium))
                                Spacer()
                                Stepper("\(String(format: "%.2f", annualRate * 100))%", value: $annualRate, in: 0...0.6, step: 0.0001)
                                    .font(.system(.body, design: .monospaced))
                            }
                            
                            let monthlyRate = (pow(1 + annualRate, 1.0/12.0) - 1) * 100
                            Text("= \(String(format: "%.3f", monthlyRate))% mensual")
                                .font(.system(size: 12))
                                .foregroundColor(.textTertiary)
                            
                            Text("Tasa actual para tarjetas de crédito en Colombia")
                                .font(.system(size: 11))
                                .foregroundColor(.textTertiary)
                        }
                        .padding(18)
                        .background(Color.surfacePrimary)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }
                    
                    // Cuota mensual
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cuota mensual")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                        TextField("0", text: $monthlyPayment)
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .keyboardType(.numberPad)
                        
                        let b = Double(balance) ?? 0
                        let p = Double(monthlyPayment) ?? 0
                        let r = (pow(1 + annualRate, 1.0/12.0) - 1)
                        if p <= b * r && b > 0 && r > 0 {
                            Text("⚠️ Esta cuota solo cubre intereses — nunca reduces el saldo")
                                .font(.system(size: 12))
                                .foregroundColor(.accentAmber)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Projected Payoff
                    let months = simulatePayoff(bal: Double(balance) ?? 0, p: Double(monthlyPayment) ?? 0, r: (pow(1 + annualRate, 1.0/12.0) - 1))
                    if months > 0 {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("📅 Libre en: Mes \(months) · \(formatDate(months: months))")
                            if annualRate > 0 {
                                Text("Pagarás $\(Int(simulateTotalInterest()).formatted()) en intereses")
                                    .foregroundColor(.accentRose)
                            }
                        }
                        .font(.system(size: 14))
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surfaceSecondary)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }
                    
                    Button(action: saveDebt) {
                        Text("Agregar deuda")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.accentRose)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
                .padding(.bottom, 40)
            }
            .background(Color.bgBase)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
    
    private func saveDebt() {
        let b = Double(balance) ?? 0
        let p = Double(monthlyPayment) ?? 0
        let debt = Debt(
            name: name,
            emoji: emoji,
            debtType: type,
            originalBalance: b,
            currentBalance: b,
            annualInterestRate: annualRate,
            monthlyPayment: p,
            dueDay: dueDay,
            deadline: hasDeadline ? deadline : nil
        )
        modelContext.insert(debt)
        dismiss()
    }
    
    private func simulatePayoff(bal: Double, p: Double, r: Double) -> Int {
        guard bal > 0 && p > 0 else { return 0 }
        guard r > 0 else { return Int(ceil(bal / p)) }
        guard p > bal * r else { return 0 }
        let n = -log(1 - (bal * r) / p) / log(1 + r)
        return Int(ceil(n))
    }
    
    private func formatDate(months: Int) -> String {
        let d = Calendar.current.date(byAdding: .month, value: months, to: Date()) ?? Date()
        return d.formatted(.dateTime.month().year())
    }
    
    private func simulateTotalInterest() -> Double {
        let bal = Double(balance) ?? 0
        let p = Double(monthlyPayment) ?? 0
        let r = (pow(1 + annualRate, 1.0/12.0) - 1)
        let months = simulatePayoff(bal: bal, p: p, r: r)
        var total = 0.0
        var b = bal
        for _ in 0..<months {
            let interest = b * r
            total += interest
            b -= (p - interest)
            if b <= 0 { break }
        }
        return total
    }
}
