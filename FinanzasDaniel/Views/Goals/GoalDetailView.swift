import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Bindable var goal: SavingsGoal
    @State private var showingAddContribution = false
    @State private var extraContribution: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with Progress Ring
                ProgressRingView(progress: progress, emoji: goal.emoji)
                    .frame(width: 200, height: 200)
                    .padding(.top)
                
                VStack(spacing: 8) {
                    Text(goal.name)
                        .font(.title).bold()
                    Text("Meta: \(goal.targetAmount.cop)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(title: "Ahorrado", value: goal.savedAmount.cop, color: .green)
                    StatCard(title: "Faltante", value: (goal.targetAmount - goal.savedAmount).cop, color: .red)
                    StatCard(title: "Aporte mensual", value: goal.monthlyContribution.cop, color: .blue)
                    StatCard(title: "Proyección", value: monthsRemainingText, color: .orange)
                }
                .padding(.horizontal)
                
                // Interactive Slider
                VStack(alignment: .leading, spacing: 12) {
                    Text("¿Qué pasa si aporto más?")
                        .font(.headline)
                    
                    HStack {
                        Text("+$0")
                        Slider(value: $extraContribution, in: 0...1000000, step: 50000)
                        Text("+1M")
                    }
                    
                    if extraContribution > 0 {
                        Text("Aportando \((goal.monthlyContribution + extraContribution).cop)/mes terminas en **\(projectedMonthsWithExtra) meses**")
                            .font(.subheadline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                
                // History
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Historial de aportes")
                            .font(.headline)
                        Spacer()
                        Button("Añadir") {
                            showingAddContribution = true
                        }
                    }
                    
                    if goal.contributions.isEmpty {
                        Text("No hay aportes aún")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(goal.contributions.sorted(by: { $0.date > $1.date })) { contribution in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(contribution.amount.cop)
                                        .bold()
                                        .monospacedDigit()
                                    Text(contribution.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if !contribution.note.isEmpty {
                                    Text(contribution.note)
                                        .font(.caption)
                                        .italic()
                                }
                            }
                            .padding(.vertical, 4)
                            Divider()
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddContribution) {
            AddContributionSheet(goal: goal)
        }
    }
    
    private var progress: Double {
        guard goal.targetAmount > 0 else { return 0 }
        return goal.savedAmount / goal.targetAmount
    }
    
    private var monthsRemainingText: String {
        let remaining = goal.targetAmount - goal.savedAmount
        guard remaining > 0, goal.monthlyContribution > 0 else { return "Hoy" }
        let months = Int(ceil(remaining / goal.monthlyContribution))
        return "\(months) meses"
    }
    
    private var projectedMonthsWithExtra: Int {
        let remaining = goal.targetAmount - goal.savedAmount
        let totalMonthly = goal.monthlyContribution + extraContribution
        guard totalMonthly > 0 else { return 0 }
        return Int(ceil(remaining / totalMonthly))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(.subheadline, design: .monospaced))
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
