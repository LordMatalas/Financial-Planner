import SwiftUI

struct StatsComparisonCard: View {
    let title: String
    let current: Double
    let previous: Double
    let isPositiveBetter: Bool
    
    var delta: Double {
        guard previous > 0 else { return 0 }
        return ((current - previous) / previous) * 100
    }
    
    var body: some View {
        AntigravityCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Spacer()
                    
                    DeltaChip(value: delta, isPositiveBetter: isPositiveBetter)
                }
                
                HStack(alignment: .bottom, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$\(Int(current))")
                            .font(.system(size: 22, weight: .bold))
                            .monospacedDigit()
                        
                        Text("Actual")
                            .font(.system(size: 11))
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                    }
                    
                    Spacer()
                    
                    // Simple Canvas Bar Chart
                    Canvas { context, size in
                        let barWidth: CGFloat = 20
                        let spacing: CGFloat = 12
                        let maxVal = max(current, previous, 1)
                        
                        let h1 = (current / maxVal) * size.height
                        let h2 = (previous / maxVal) * size.height
                        
                        // Previous Bar
                        context.fill(
                            Path(roundedRect: CGRect(x: size.width - barWidth, y: size.height - h2, width: barWidth, height: h2), cornerRadius: 4),
                            with: .color(DesignSystem.Colors.textTertiary.opacity(0.3))
                        )
                        
                        // Current Bar
                        context.fill(
                            Path(roundedRect: CGRect(x: size.width - (barWidth * 2) - spacing, y: size.height - h1, width: barWidth, height: h1), cornerRadius: 4),
                            with: .color(DesignSystem.Colors.primary)
                        )
                    }
                    .frame(width: 60, height: 40)
                }
            }
        }
    }
}
