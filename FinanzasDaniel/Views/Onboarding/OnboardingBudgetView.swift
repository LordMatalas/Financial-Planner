import SwiftUI

struct OnboardingBudgetView: View {
    let income: Double
    let fixed: Double
    let goals: Double
    let buffer: Double
    @Binding var notificationsOptIn: Bool
    var onFinish: () -> Void
    
    var variable: Double {
        max(income - fixed - goals - buffer, 0)
    }
    
    @State private var showingFormula = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                Text("Aquí va tu panorama, Daniel.")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                BudgetBreakdownCard(income: income, fixed: fixed, goals: goals, buffer: buffer, variable: variable)
                
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Este es el presupuesto que calculamos para tus gastos variables. No te preguntamos — lo calculamos por ti.")
                            .font(.system(size: 13))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        Button {
                            withAnimation { showingFormula.toggle() }
                        } label: {
                            Text(showingFormula ? "Ocultar fórmula" : "Ver cómo lo calculamos")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(DesignSystem.Colors.secondary)
                        }
                        
                        if showingFormula {
                            Text("Ingresos - (Gastos Fijos + Metas + 10% de seguridad)")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, DesignSystem.Spacing.l)
            
            AntigravityCard(padding: 16) {
                HStack(spacing: 16) {
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 28))
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("¿Te avisamos cuando toca pagar?")
                            .font(.system(size: 16, weight: .bold))
                        Text("Te recordamos un día antes de cada gasto fijo y te preguntamos si ya lo hiciste.")
                            .font(.system(size: 13))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Toggle("", isOn: $notificationsOptIn)
                        .labelsHidden()
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.l)
            
            Spacer()
            
            PrimaryButton(title: "Entrar →", action: onFinish)
                .padding(.horizontal, DesignSystem.Spacing.l)
                .padding(.bottom, DesignSystem.Spacing.xl)
        }
    }
}
