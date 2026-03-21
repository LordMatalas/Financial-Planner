import SwiftUI

struct SettingsView: View {
    @AppStorage("monthlyIncome") private var monthlyIncome: Double = 2450000
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 450000
    @AppStorage("dailyReminderEnabled") private var dailyReminderEnabled = true
    @AppStorage("budgetAlertEnabled") private var budgetAlertEnabled = true
    
    @State private var showingWalletSetup = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Perfil Financiero") {
                    HStack {
                        Text("Salario neto")
                        Spacer()
                        TextField("Monto", value: $monthlyIncome, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Presupuesto variables")
                        Spacer()
                        TextField("Monto", value: $monthlyBudget, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Automatización") {
                    Button {
                        showingWalletSetup = true
                    } label: {
                        Label("Configurar Apple Wallet", systemImage: "creditcard.and.1.line")
                    }
                }
                
                Section("Notificaciones") {
                    Toggle("Recordatorio diario", isOn: $dailyReminderEnabled)
                    Toggle("Alertas de presupuesto", isOn: $budgetAlertEnabled)
                }
                
                Section {
                    Link("GitHub Spec Kit", destination: URL(string: "https://github.com/github/spec-kit")!)
                } footer: {
                    Text("FinanzasDaniel v1.0 • Built with Spec-Kit")
                }
            }
            .navigationTitle("Ajustes")
            .sheet(isPresented: $showingWalletSetup) {
                WalletSetupView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
