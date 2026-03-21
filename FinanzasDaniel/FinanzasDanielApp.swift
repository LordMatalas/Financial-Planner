import SwiftUI
import SwiftData

@main
struct FinanzasDanielApp: App {
    let container: ModelContainer = {
        let schema = Schema([
            SavingsGoal.self,
            Contribution.self,
            Expense.self,
            FixedExpense.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("No se pudo crear ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    seedInitialData()
                }
        }
    }
    
    private func seedInitialData() {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<SavingsGoal>()
        if let count = try? context.fetchCount(fetchDescriptor), count == 0 {
            let bmw = SavingsGoal(
                name: "BMW G 310 GS",
                emoji: "🏍️",
                targetAmount: 13250000,
                savedAmount: 0,
                deadline: Calendar.current.date(byAdding: .month, value: 23, to: .now),
                monthlyContribution: 1200000
            )
            context.insert(bmw)
            
            // Fixed Expenses from spec
            let icetex = FixedExpense(name: "Icetex", amount: 600000, dueDay: 1, category: .other)
            let ortodoncia = FixedExpense(name: "Ortodoncia", amount: 200000, dueDay: 15, endsOnMonth: 10, category: .health)
            context.insert(icetex)
            context.insert(ortodoncia)
            
            try? context.save()
        }
    }
}
