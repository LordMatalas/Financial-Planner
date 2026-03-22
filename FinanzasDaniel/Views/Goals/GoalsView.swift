import SwiftUI

struct GoalsView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                        .padding(.top, 16)
                    
                    goalCardBMW
                    goalCardEmergency
                    goalCardTrip
                    
                    Spacer(minLength: 100) // Space for TabBar
                }
                .padding(.horizontal, 20)
            }
            .background(Color.bgBase)
            
            // FAB
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.bgBase)
                    .frame(width: 60, height: 60)
                    .background(Color.gradMint)
                    .clipShape(Circle())
            }
            .padding(.trailing, 24)
            .padding(.bottom, 106) // 82 for tab bar + 24
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Mis metas")
                .font(.display(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            Text("3 activas · 1 completada")
                .font(.bodyText(size: 14))
                .foregroundColor(.textSecondary)
        }
    }
    
    // Hardcoded for UI mapping, would normally be dynamic
    private var goalCardBMW: some View {
        GoalCard(
            emoji: "🏍️",
            name: "BMW G 310 GS",
            progress: 0.18,
            percentStr: "18%",
            saved: "$2.400.000",
            total: "$13.250.000",
            timeTag: "📅 14 meses restantes",
            isPrimary: true,
            useViolet: false
        )
    }
    
    private var goalCardEmergency: some View {
        GoalCard(
            emoji: "🛡️",
            name: "Fondo de emergencia",
            progress: 0.26,
            percentStr: "26%",
            saved: "$1.500.000",
            total: "$5.700.000",
            timeTag: "📅 8 meses restantes",
            isPrimary: false,
            useViolet: true
        )
    }
    
    private var goalCardTrip: some View {
        GoalCard(
            emoji: "✈️",
            name: "Viaje a Medellín",
            progress: 0.67,
            percentStr: "67%",
            saved: "$800.000",
            total: "$1.200.000",
            timeTag: "📅 2 meses restantes",
            isPrimary: false,
            useViolet: true,
            extraChip: "¡Casi!"
        )
    }
}

struct GoalCard: View {
    let emoji: String
    let name: String
    let progress: Double
    let percentStr: String
    let saved: String
    let total: String
    let timeTag: String
    let isPrimary: Bool
    let useViolet: Bool
    var extraChip: String? = nil
    
    var body: some View {
        AntigravityCard {
            VStack(alignment: .leading, spacing: 16) {
                // Top row
                HStack(alignment: .center, spacing: 12) {
                    Text(emoji)
                        .font(.system(size: 36))
                    
                    Text(name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    ChipView(title: percentStr, isPositive: !useViolet)
                    if let extra = extraChip {
                        ChipView(title: extra, isPositive: false, isWarning: true)
                    }
                }
                
                ProgressBar(progress: progress, useViolet: useViolet)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text(saved)
                            .font(.moneyNumber(size: 14))
                            .foregroundColor(useViolet ? .accentViolet : .accentMint)
                        Text("de \(total)")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                    
                    ChipView(title: timeTag, isPositive: false, isWarning: isPrimary)
                }
                
                HStack {
                    Button(action: {}) {
                        Text("+ Añadir aporte")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    Spacer()
                    Button(action: {}) {
                        Text("Ver detalle →")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.top, 4)
            }
        }
        .overlay(
            // Premium detail line on the left side
            Rectangle()
                .fill(useViolet ? Color.accentViolet : Color.accentMint)
                .frame(width: 3)
                .cornerRadius(1.5),
            alignment: .leading
        )
    }
}

#Preview {
    GoalsView()
}
