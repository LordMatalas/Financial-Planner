import SwiftUI

struct FixedExpenseRow: View {
    @Binding var name: String
    @Binding var amount: Double
    @Binding var dueDay: Int
    var onDelete: () -> Void
    
    var body: some View {
        AntigravityCard(padding: 12) {
            HStack(spacing: 12) {
                // Icon simulation
                Circle()
                    .fill(DesignSystem.Colors.elevated)
                    .frame(width: 32, height: 32)
                    .overlay(Image(systemName: "hand.tap.fill").font(.system(size: 14)).foregroundColor(DesignSystem.Colors.textSecondary))
                
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Nombre", text: $name)
                        .font(.system(size: 15, weight: .semibold))
                    
                    HStack {
                        Text("Día")
                            .font(.system(size: 12))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        TextField("DD", value: $dueDay, format: .number)
                            .font(.system(size: 12, weight: .medium))
                            .keyboardType(.numberPad)
                            .frame(width: 30)
                    }
                }
                
                Spacer()
                
                TextField("0", value: $amount, format: .number)
                    .font(.system(size: 17, weight: .bold))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
                    .onAppear {
                        // Ensure it fits
                    }
                
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DesignSystem.Colors.destructive.opacity(0.4))
                }
            }
        }
    }
}
