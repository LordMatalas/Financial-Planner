import SwiftUI

struct HeroNumberInput: View {
    @Binding var value: Double
    var prefix: String = "$"
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(prefix)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            TextField("0", value: $value, format: .number)
                .font(.system(size: 52, weight: .bold, design: .monospaced))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.leading)
                .fixedSize()
                .monospacedDigit()
        }
        .padding(.vertical, DesignSystem.Spacing.m)
    }
}
