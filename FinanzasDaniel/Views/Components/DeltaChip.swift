import SwiftUI

struct DeltaChip: View {
    let value: Double
    let isPositiveBetter: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: isPositiveBetter ? (value >= 0 ? "arrow.up.right" : "arrow.down.right") : (value <= 0 ? "arrow.down.right" : "arrow.up.right"))
            
            Text("\(Int(abs(value)))%")
                .font(.system(size: 11, weight: .bold))
                .monospacedDigit()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundColor(isPositiveBetter ? (value >= 0 ? DesignSystem.Colors.primary : DesignSystem.Colors.destructive) : (value <= 0 ? DesignSystem.Colors.primary : DesignSystem.Colors.destructive))
        .background(isPositiveBetter ? (value >= 0 ? DesignSystem.Colors.primary.opacity(0.1) : DesignSystem.Colors.destructive.opacity(0.1)) : (value <= 0 ? DesignSystem.Colors.primary.opacity(0.1) : DesignSystem.Colors.destructive.opacity(0.1)))
        .clipShape(Capsule())
    }
}
