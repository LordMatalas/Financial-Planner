import SwiftUI

struct WalletSetupView: View {
    @State private var currentStep = 1
    
    var body: some View {
        ZStack {
            Color.bgBase.ignoresSafeArea()
            
            VStack {
                progressIndicators
                    .padding(.top, 16)
                
                Spacer()
                
                Group {
                    if currentStep == 1 {
                        step1View
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if currentStep == 2 {
                        step2View
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else {
                        step3View
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentStep)
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var progressIndicators: some View {
        HStack(spacing: 6) {
            ForEach(1...3, id: \.self) { step in
                Capsule()
                    .fill(currentStep >= step ? Color.accentMint : Color.bgElevated)
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var step1View: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .stroke(Color.accentMint.opacity(0.1), lineWidth: 1)
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(Color.bgElevated)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.textPrimary)
            }
            .padding(.top, 40)
            
            VStack(spacing: 16) {
                Text("Automatiza tus pagos")
                    .font(.display(size: 26))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Cada vez que pagues con Apple Pay, FinanzasDaniel registrará el gasto automáticamente. Sin tocar nada.")
                    .font(.bodyText(size: 15))
                    .lineSpacing(4)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            VStack(spacing: 16) {
                PrimaryButton(title: "Configurar ahora", action: { currentStep = 2 })
                
                Button("Hacerlo después") {
                    // disimss
                }
                .font(.system(size: 17))
                .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var step2View: some View {
        VStack(spacing: 40) {
            Circle()
                .fill(Color.bgElevated)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "gear.badge.checkmark")
                        .font(.system(size: 32))
                        .foregroundColor(.textPrimary)
                )
            
            Text("Abre la app Atajos")
                .font(.display(size: 26))
                .foregroundColor(.textPrimary)
            
            AntigravityCard(padding: 0) {
                VStack(spacing: 0) {
                    instructionRow(number: "1", title: "Toca Automatización → +", subtitle: "En la app Atajos de iOS")
                    Divider().background(Color.borderSubtle).padding(.leading, 56)
                    instructionRow(number: "2", title: "Selecciona Transacción de Apple Pay", subtitle: nil)
                    Divider().background(Color.borderSubtle).padding(.leading, 56)
                    instructionRow(number: "3", title: "Elige FinanzasDaniel como acción", subtitle: nil)
                }
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                PrimaryButton(title: "Abrir Atajos →", action: {
                    // Open shortcuts app pseudo code
                })
                
                SecondaryButton(title: "Ya lo hice", action: {
                    currentStep = 3
                })
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func instructionRow(number: String, title: String, subtitle: String?) -> some View {
        HStack(spacing: 16) {
            Text(number)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.bgBase)
                .frame(width: 24, height: 24)
                .background(Color.accentMint)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bodyText(size: 14))
                    .foregroundColor(.textPrimary)
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
            }
            Spacer()
        }
        .padding(16)
    }
    
    private var step3View: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .fill(Color.glowMint)
                    .frame(width: 140, height: 140)
                    .blur(radius: 40)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.accentMint)
            }
            .padding(.top, 40)
            
            VStack(spacing: 16) {
                Text("¡Listo, Daniel!")
                    .font(.display(size: 28))
                    .foregroundColor(.textPrimary)
                
                Text("Ya tienes el radar encendido.\nCada peso que gastes quedará registrado.")
                    .font(.bodyText(size: 15))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            PrimaryButton(title: "Empezar a ahorrar", action: {
                // finish onboarding
            })
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
    }
}

#Preview {
    WalletSetupView()
}
