import SwiftUI
import SwiftData

// MARK: - Dashboard Update Component

struct DebtDashboardSection: View {
    @Query(filter: #Predicate<Debt> { $0.isActive }, sort: \.createdAt) var activeDebts: [Debt]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Deudas")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                // In a real app, this would use a shared state or environment to switch tabs
                Text("Ver todas →")
                    .font(.system(size: 13))
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
            .padding(.horizontal, 20)
            
            if activeDebts.isEmpty {
                emptyState
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(activeDebts) { debt in
                            MiniDebtCard(debt: debt)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var emptyState: some View {
        AntigravityCard {
            Text("No tienes deudas activas. ¡Excelente!")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .padding()
        }
        .padding(.horizontal, 20)
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(style: StrokeStyle(lineWidth: 1, dash: [4])).foregroundColor(DesignSystem.Colors.border).padding(.horizontal, 20))
    }
}
