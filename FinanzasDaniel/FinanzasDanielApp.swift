import SwiftUI
import SwiftData

@main
struct FinanzasDanielApp: App {
    @State private var appState = AppState.shared
    
    let container: ModelContainer = {
        let schema = Schema([
            SavingsGoal.self,
            Contribution.self,
            Expense.self,
            FixedExpense.self,
            MonthlySnapshot.self
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
                .environment(appState)
                .onAppear {
                    // Seed only if needed and not already done
                    seedInitialData()
                }
        }
    }
    
    private func seedInitialData() {
        // We only seed if user has already completed onboarding or for debugging
        // But the new requirement says OnboardingFlow shows on first launch.
    }
}
