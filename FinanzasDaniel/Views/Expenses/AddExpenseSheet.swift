import SwiftUI
import SwiftData

struct AddExpenseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: Double = 0
    @State private var merchant = ""
    @State private var category: ExpenseCategory = .food
    @State private var date = Date()
    @State private var note = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Monto del gasto") {
                    TextField("Monto", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                        .monospacedDigit()
                }
                
                Section("Detalles") {
                    TextField("Comercio (ej. Rappi, Starbucks)", text: $merchant)
                    Picker("Categoría", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { cat in
                            Text("\(cat.emoji) \(cat.rawValue)").tag(cat)
                        }
                    }
                    DatePicker("Fecha", selection: $date, displayedComponents: .date)
                    TextField("Nota (opcional)", text: $note)
                }
            }
            .navigationTitle("Nuevo Gasto")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveExpense()
                        dismiss()
                    }
                    .disabled(amount <= 0 || merchant.isEmpty)
                }
            }
        }
    }
    
    private func saveExpense() {
        let expense = Expense(
            amount: amount,
            merchant: merchant,
            category: category,
            date: date,
            source: .manual,
            note: note
        )
        modelContext.insert(expense)
    }
}

#Preview {
    AddExpenseSheet()
        .modelContainer(for: Expense.self, inMemory: true)
}
