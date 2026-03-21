import SwiftUI
import SwiftData

struct AddContributionSheet: View {
    @Bindable var goal: SavingsGoal
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: Double = 0
    @State private var note = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Monto del aporte") {
                    TextField("Monto", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                        .monospacedDigit()
                }
                
                Section("Detalles") {
                    TextField("Nota (opcional)", text: $note)
                    DatePicker("Fecha", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Añadir Aporte")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveContribution()
                        dismiss()
                    }
                    .disabled(amount <= 0)
                }
            }
        }
    }
    
    private func saveContribution() {
        let contribution = Contribution(amount: amount, note: note, date: date, goal: goal)
        modelContext.insert(contribution)
        goal.savedAmount += amount
        // SwiftData saves automatically usually, but we can call try? modelContext.save()
    }
}
