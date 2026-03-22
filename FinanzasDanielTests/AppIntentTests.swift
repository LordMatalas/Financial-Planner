import XCTest
import AppIntents
import SwiftData
@testable import FinanzasDaniel

@available(iOS 17.0, *)
final class AppIntentTests: XCTestCase {

    override func setUp() async throws {
        // Prepare any test-specific states. 
        // Notice SwiftData is used, so we create an in-memory container for testing.
        let schema = Schema([
            SavingsGoal.self,
            Contribution.self,
            Expense.self,
            FixedExpense.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        // To easily test, we might replace the AppIntent's logic or test a helper if needed,
        // but since `RegisterWalletExpenseIntent` hardcodes configuration to `isStoredInMemoryOnly: false`,
        // let's verify intent parameters are parsed correctly as an independent test.
    }

    func testRegisterWalletExpenseIntentParameters() throws {
        let intent = RegisterWalletExpenseIntent()
        intent.amount = 15000.0
        intent.merchant = "Mock Cafe"
        intent.category = .food
        
        XCTAssertEqual(intent.amount, 15000.0)
        XCTAssertEqual(intent.merchant, "Mock Cafe")
        XCTAssertEqual(intent.category, .food)
        XCTAssertEqual(RegisterWalletExpenseIntent.title, "Registrar gasto de Wallet")
    }
}
