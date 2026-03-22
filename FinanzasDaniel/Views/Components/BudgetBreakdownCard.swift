import SwiftUI

struct BudgetBreakdownCard: View {
    let income: Double
    let fixed: Double
    let goals: Double
    let buffer: Double
    let variable: Double
    
    var body: some View {
        AntigravityCard {
            VStack(spacing: DesignSystem.Spacing.m) {
                HStack {
                    Text("Tu ingreso mensual")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    Spacer()
                    Text("$\(Int(income))")
                        .bold()
                        .monospacedDigit()
                }
                
                HStack {
                    Text("Gastos fijos")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    Spacer()
                    Text("−$\(Int(fixed))")
                        .foregroundColor(DesignSystem.Colors.destructive)
                        .monospacedDigit()
                }
                
                HStack {
                    Text("Aporte a metas")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    Spacer()
                    Text("−$\(Int(goals))")
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .monospacedDigit()
                }
                
                HStack {
                    Text("Colchón (10%)")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    Spacer()
                    Text("−$\(Int(buffer))")
                        .foregroundColor(DesignSystem.Colors.warning)
                        .monospacedDigit()
                }
                
                Divider().background(DesignSystem.Colors.border)
                
                HStack {
                    Text("Para gastos del día a día")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text("$\(Int(variable))")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.primary)
                        .monospacedDigit()
                }
            }
            .font(.system(size: 15))
        }
    }
}
