import SwiftUI

struct OnboardingGoalsView: View {
    @Binding var goals: [TempSavingsGoal]
    let income: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                Text("¿Hacia qué estás ahorrando?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Una meta, un viaje, lo que sea.")
                    .font(.system(size: 17))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.l)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach($goals) { $goal in
                        VStack(alignment: .trailing, spacing: 12) {
                            GoalEditorCard(
                                emoji: $goal.emoji,
                                name: $goal.name,
                                target: $goal.target,
                                monthly: $goal.monthly,
                                useDeadline: $goal.useDeadline,
                                deadline: $goal.deadline,
                                income: income
                            )
                            
                            Button {
                                withAnimation {
                                    goals.removeAll { $0.id == goal.id }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Eliminar")
                                }
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.destructive.opacity(0.8))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(DesignSystem.Colors.destructive.opacity(0.1))
                                .clipShape(Capsule())
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    Button {
                        withAnimation(DesignSystem.Transitions.spring) {
                            goals.append(TempSavingsGoal(emoji: "🎯", name: "", target: 0, monthly: 0))
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Agregar otra meta")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.l)
                .padding(.bottom, 120)
            }
        }
    }
}

struct TempSavingsGoal: Identifiable, Equatable {
    let id = UUID()
    var emoji: String
    var name: String
    var target: Double
    var monthly: Double
    var useDeadline: Bool = false
    var deadline: Date = Date().addingTimeInterval(365 * 24 * 60 * 60) // Default 1 year
}
