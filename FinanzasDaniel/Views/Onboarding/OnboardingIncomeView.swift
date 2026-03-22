import SwiftUI

struct OnboardingIncomeView: View {
    @Binding var income: Double
    @Binding var payDay: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
            Text("¿Cuánto entra cada mes?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            HeroNumberInput(value: $income)
            
            Text("Escribe tu salario neto — lo que llega a tu cuenta.")
                .font(.system(size: 15))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer().frame(height: 20)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                Text("¿Qué día te pagan?")
                    .font(.system(size: 17, weight: .semibold))
                
                Picker("Día de Pago", selection: $payDay) {
                    ForEach(1...31, id: \.self) { day in
                        Text("\(day)").tag(day)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(16)
            }
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.l)
    }
}
