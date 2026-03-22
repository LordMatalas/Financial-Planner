import AppIntents

struct FinancialShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: RegisterWalletExpenseIntent(),
            phrases: [
                "Registrar un gasto en \(.applicationName)",
                "Guardar pago de Wallet en \(.applicationName)",
                "Añadir gasto a \(.applicationName)",
                "Pagué con Wallet en \(.applicationName)"
            ],
            shortTitle: "Registrar pago de Wallet",
            systemImageName: "creditcard"
        )
    }
}
