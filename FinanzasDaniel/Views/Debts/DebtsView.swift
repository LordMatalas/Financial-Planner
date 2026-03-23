import SwiftUI
import SwiftData

struct DebtsView: View {
    @Query(filter: #Predicate<Debt> { $0.isActive }, sort: \.createdAt, order: .reverse) 
    var activeDebts: [Debt]
    
    @State private var showingAddDebt = false
    @State private var selectedDebtForPayment: Debt?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mis deudas")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Libre de deudas en ~\(maxMonthsToPayoff) meses")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Timeline Strip
                        DebtTimelineStrip(
                            items: getTimelineItems(),
                            leftMonth: currentMonthString,
                            rightMonth: payoffMonthString
                        )
                        .padding(.horizontal, 20)
                        
                        // Debt List
                        VStack(spacing: 16) {
                            if activeDebts.isEmpty {
                                emptyState
                            } else {
                                ForEach(activeDebts) { debt in
                                    DebtCardView(debt: debt, onRegisterPayment: {
                                        selectedDebtForPayment = debt
                                    })
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 150) // More space for FAB and TabBar
                    }
                }
                .background(Color.bgBase)
                
                // FAB
                Button(action: { showingAddDebt = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 60, height: 60)
                        .background(Color.accentRose)
                        .clipShape(Circle())
                        .shadow(color: Color.accentRose.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(24)
                .padding(.bottom, 82) // Above tab bar
            }
            .sheet(isPresented: $showingAddDebt) {
                AddDebtSheet()
            }
            .sheet(item: $selectedDebtForPayment) { debt in
                DebtPaymentSheet(debt: debt)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "creditcard.and.123")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)
            Text("No tienes deudas activas")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textSecondary)
            Text("¡Felicidades! Estás en verde.")
                .font(.system(size: 14))
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }
    
    private var currentMonthString: String {
        Date.now.formatted(.dateTime.month(.abbreviated).year())
    }
    
    private var payoffMonthString: String {
        let maxMonths = maxMonthsToPayoff
        let date = Calendar.current.date(byAdding: .month, value: maxMonths, to: .now) ?? .now
        return date.formatted(.dateTime.month(.abbreviated).year())
    }
    
    private var maxMonthsToPayoff: Int {
        activeDebts.compactMap { $0.monthsToPayoff }.max() ?? 0
    }
    
    private func getTimelineItems() -> [(label: String, color: Color, width: CGFloat)] {
        let sorted = activeDebts.sorted { ($0.monthsToPayoff ?? 0) > ($1.monthsToPayoff ?? 0) }
        let totalMonths = Double(maxMonthsToPayoff)
        guard totalMonths > 0 else { return [] }
        
        return sorted.map { debt in
            let months = Double(debt.monthsToPayoff ?? 0)
            let width = months / totalMonths
            return (debt.name, debt.hasInterest ? .accentRose : .accentViolet, CGFloat(width))
        }
    }
}

struct DebtCardView: View {
    let debt: Debt
    var onRegisterPayment: () -> Void
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Text(debt.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(debt.name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(debt.hasInterest ? "Con interés" : "Sin interés")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background((debt.hasInterest ? Color.accentRose : Color.accentViolet).opacity(0.12))
                            .foregroundColor(debt.hasInterest ? .accentRose : .accentViolet)
                            .clipShape(Capsule())
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                InvertedProgressBar(progress: debt.progressPercent, color: debt.hasInterest ? .accentRose : .accentViolet)
                
                HStack {
                    Text("$\(Int(debt.currentBalance).formatted()) restantes")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(debt.hasInterest ? .accentRose : .textSecondary)
                    
                    Text("· de $\(Int(debt.originalBalance).formatted())")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                }
            }
            
            // Stats Row
            HStack(alignment: .top, spacing: 0) {
                StatCol(label: "Cuota", value: "$\(Int(debt.monthlyPayment).formatted())", design: .monospaced)
                Spacer()
                StatCol(label: "Interés", value: debt.annualInterestRate > 0 ? "$\(Int(debt.monthlyInterest).formatted())" : "—", color: .accentRose)
                Spacer()
                StatCol(label: "Libre en", value: "\(debt.monthsToPayoff ?? 0) meses", color: .accentMint)
            }
            .padding(.top, 4)
            
            HStack {
                Text("Tasa: \(String(format: "%.2f", debt.annualInterestRate * 100))% EA")
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                Image(systemName: "pencil")
                    .font(.system(size: 11))
                    .foregroundColor(.textTertiary)
                Spacer()
            }
            
            // Deadline Chip
            HStack {
                let months = debt.monthsToPayoff ?? 0
                let date = debt.projectedPayoffDate?.formatted(.dateTime.month().year()) ?? ""
                let icon = debt.hasInterest ? "⚡" : "📅"
                let chipColor: Color = months <= 6 ? .accentMint : (debt.hasInterest ? .accentAmber : .accentViolet)
                
                Text("\(icon) \(date) · \(months) meses")
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(chipColor.opacity(0.1))
                    .foregroundColor(chipColor)
                    .clipShape(Capsule())
            }
            
            Divider()
                .background(Color.borderSubtle)
                .padding(.top, 4)
            
            HStack(spacing: 4) {
                Button(action: onRegisterPayment) {
                    Text("+ Registrar pago")
                }
                Text("·")
                Button("Ver detalle →") {
                    showingDetail = true
                }
            }
            .font(.system(size: 13))
            .foregroundColor(.textSecondary)
        }
        .padding(20)
        .background(Color.surfacePrimary)
        .cornerRadius(22)
        .overlay(
            Rectangle()
                .fill(debt.hasInterest ? Color.accentRose : Color.accentViolet)
                .frame(width: 3)
                .cornerRadius(3)
                .padding(.vertical, 20),
            alignment: .leading
        )
        .navigationDestination(isPresented: $showingDetail) {
            DebtDetailView(debt: debt)
        }
    }
}

struct StatCol: View {
    let label: String
    let value: String
    var color: Color = .white
    var design: Font.Design = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 14, weight: .medium, design: design))
                .foregroundColor(color)
                .lineLimit(1)
        }
    }
}
