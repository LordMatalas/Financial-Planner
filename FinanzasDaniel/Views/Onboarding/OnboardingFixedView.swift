import SwiftUI

struct OnboardingFixedView: View {
    @Binding var fixedExpenses: [TempFixedExpense]
    
    let presets = [
        Preset(name: "Icetex", emoji: "🎓", amount: 600000),
        Preset(name: "Arriendo", emoji: "🏠", amount: 1200000),
        Preset(name: "Crédito", emoji: "💳", amount: 300000),
        Preset(name: "Netflix", emoji: "📺", amount: 45000),
        Preset(name: "Spotify", emoji: "🎵", amount: 20000),
        Preset(name: "Gym", emoji: "🏋️", amount: 90000)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                Text("¿Qué gastos fijos tienes?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Arriendo, créditos, suscripciones... lo que sale sí o sí.")
                    .font(.system(size: 17))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.l)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(presets) { preset in
                        Button {
                            withAnimation(.spring()) {
                                addPreset(preset)
                            }
                        } label: {
                            Text(preset.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(DesignSystem.Colors.primary.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                    
                    Button {
                        withAnimation(.spring()) {
                            fixedExpenses.append(TempFixedExpense(name: "", amount: 0, dueDay: 1))
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("Agregar")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(DesignSystem.Colors.elevated)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.l)
            }
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach($fixedExpenses) { $expense in
                        FixedExpenseRow(name: $expense.name, amount: $expense.amount, dueDay: $expense.dueDay) {
                            fixedExpenses.removeAll { $0.id == expense.id }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.l)
            }
        }
    }
    
    private func addPreset(_ preset: Preset) {
        if !fixedExpenses.contains(where: { $0.name == preset.name }) {
            fixedExpenses.append(TempFixedExpense(name: preset.name, amount: preset.amount, dueDay: 1))
        }
    }
}

struct TempFixedExpense: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var amount: Double
    var dueDay: Int
}

struct Preset: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let amount: Double
}
