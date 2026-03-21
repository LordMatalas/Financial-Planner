import SwiftUI

struct WalletSetupView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "creditcard.and.1.line")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Text("Automatiza tus gastos")
                        .font(.title).bold()
                    
                    Text("Configura una automatización en la app **Atajos** para que cada vez que pagues con Apple Pay, el gasto se guarde solo.")
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        StepItem(number: 1, text: "Abre la app Atajos en tu iPhone")
                        StepItem(number: 2, text: "Toca 'Automatización' -> '+' -> 'Transacción de Apple Pay'")
                        StepItem(number: 3, text: "Acción: 'FinanzasDaniel -> Registrar gasto de Wallet'")
                        StepItem(number: 4, text: "Configura: Monto como 'Importe' y Comercio como 'Nombre'")
                        StepItem(number: 5, text: "Desactiva 'Preguntar antes de ejecutar'")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button {
                        if let url = URL(string: "shortcuts://") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Abrir Atajos")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Wallet Automation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

struct StepItem: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption).bold()
                .foregroundColor(.white)
                .padding(6)
                .background(Color.accentColor)
                .clipShape(Circle())
            
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    WalletSetupView()
}
