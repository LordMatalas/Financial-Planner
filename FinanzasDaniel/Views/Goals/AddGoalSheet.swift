import SwiftUI
import SwiftData

struct AddGoalSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var emoji = "🏍️"
    @State private var targetAmount: Double = 0
    @State private var monthlyContribution: Double = 0
    @State private var deadline = Date()
    @State private var useDeadline = false
    
    let emojis = ["🏍️", "🚗", "🏠", "✈️", "💻", "💍", "🎓", "🎮", "🏝️", "💰"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles de la meta") {
                    TextField("Nombre (ej. BMW G 310 GS)", text: $name)
                    
                    Picker("Emoji", selection: $emoji) {
                        ForEach(emojis, id: \.self) { e in
                            Text(e).tag(e)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Montos (COP)") {
                    HStack {
                        Text("Meta")
                        Spacer()
                        TextField("0", value: $targetAmount, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Aporte mensual")
                        Spacer()
                        TextField("0", value: $monthlyContribution, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    Toggle("¿Tienes una fecha límite?", isOn: $useDeadline)
                    if useDeadline {
                        DatePicker("Fecha límite", selection: $deadline, displayedComponents: .date)
                    }
                } footer: {
                    if targetAmount > 0 && monthlyContribution > 0 {
                        let months = Int(ceil(targetAmount / monthlyContribution))
                        Text("Proyección: Alcanzarás esta meta en \(months) meses (\(Date().addingTimeInterval(TimeInterval(months * 30 * 24 * 60 * 60)).formatted(date: .abbreviated, time: .omitted)))")
                    }
                }
            }
            .navigationTitle("Nueva Meta")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveGoal()
                        dismiss()
                    }
                    .disabled(name.isEmpty || targetAmount <= 0 || monthlyContribution <= 0)
                }
            }
        }
    }
    
    private var goalsViewModel: GoalsViewModel {
        GoalsViewModel(modelContext: modelContext)
    }
    
    private func saveGoal() {
        goalsViewModel.addGoal(
            name: name,
            emoji: emoji,
            targetAmount: targetAmount,
            monthlyContribution: monthlyContribution,
            deadline: useDeadline ? deadline : nil
        )
    }
}

#Preview {
    AddGoalSheet()
        .modelContainer(for: SavingsGoal.self, inMemory: true)
}
