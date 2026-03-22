import SwiftUI

struct GoalDetailView: View {
    @State private var monthlyContribution: Double = 1200000
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.bgBase.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    navBar
                    heroSection
                    statsRow
                    simulatorCard
                    historySection
                    
                    Spacer(minLength: 120) // Bottom sticky space
                }
            }
            
            // Bottom Sticky Button
            VStack {
                Spacer()
                PrimaryButton(title: "+ Añadir aporte", action: {})
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .padding(.top, 16)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea(edges: .bottom)
                    )
            }
        }
        .navigationBarHidden(true)
    }
    
    private var navBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var heroSection: some View {
        VStack(spacing: 16) {
            Text("🏍️")
                .font(.system(size: 48))
            
            VStack(spacing: 4) {
                Text("BMW G 310 GS")
                    .font(.display(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text("Antes de los 25")
                    .font(.bodyText(size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            ZStack {
                // Glow
                Circle()
                    .fill(Color.glowMint)
                    .frame(width: 220, height: 220)
                    .blur(radius: 40)
                
                ProgressRing(progress: 0.18, size: 200, strokeWidth: 12)
                
                VStack {
                    Text("18%")
                        .font(.moneyNumber(size: 34, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    Text("$2.4M ahorrado")
                        .font(.bodyText(size: 12))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.top, 16)
        }
    }
    
    private var statsRow: some View {
        HStack(spacing: 12) {
            metricCard(title: "Ahorrado", value: "$2.400.000", color: .accentMint)
            metricCard(title: "Faltante", value: "$10.850.000", color: .accentRose)
            metricCard(title: "Restantes", value: "14 meses", color: .accentViolet)
        }
        .padding(.horizontal, 20)
    }
    
    private func metricCard(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.textTertiary)
            Text(value)
                .font(.moneyNumber(size: 15, weight: .semibold).monospacedDigit())
                .foregroundColor(color)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgElevated)
        .cornerRadius(14)
    }
    
    // Computed value for simulator based on slider (just mock math)
    private var simulatedMonths: Int {
        if monthlyContribution == 0 { return 99 }
        let remaining = 10850000.0
        return Int(ceil(remaining / monthlyContribution))
    }
    
    private var simulatorCard: some View {
        AntigravityCard {
            VStack(alignment: .leading, spacing: 20) {
                Text("Simulador de aporte")
                    .font(.heading(size: 14))
                    .foregroundColor(.textPrimary)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("$\(Int(monthlyContribution).formatted()) / mes")
                            .font(.moneyNumber(size: 16, weight: .semibold))
                            .foregroundColor(.accentViolet)
                        Spacer()
                    }
                    
                    Slider(value: $monthlyContribution, in: 100000...3000000, step: 50000)
                        .tint(.accentViolet)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Llegarías en Mes \(simulatedMonths)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: simulatedMonths)
                    
                    HStack(spacing: 4) {
                        Text("Tienes \(String(format: "%.1f", 23.8 + Double(simulatedMonths)/12.0)) años")
                            .font(.system(size: 13))
                            .foregroundColor(simulatedMonths <= 14 ? .accentMint : .accentAmber)
                        if simulatedMonths <= 14 {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.accentMint)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Aportes recientes")
                .font(.heading(size: 14))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                historyRow(date: "15 Mar", label: "Ahorro quincenal", amount: "+$600.000")
                Divider().background(Color.borderSubtle).padding(.leading, 70)
                historyRow(date: "1 Mar", label: "Primer aporte", amount: "+$1.200.000")
                Divider().background(Color.borderSubtle).padding(.leading, 70)
                historyRow(date: "1 Feb", label: "Aporte inicial", amount: "+$600.000")
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func historyRow(date: String, label: String, amount: String) -> some View {
        HStack {
            Text(date)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .frame(width: 50, alignment: .leading)
            
            Text(label)
                .font(.bodyText(size: 15))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(amount)
                .font(.moneyNumber(size: 15, weight: .medium))
                .foregroundColor(.accentMint)
        }
        .frame(height: 44)
    }
}

#Preview {
    GoalDetailView()
}
