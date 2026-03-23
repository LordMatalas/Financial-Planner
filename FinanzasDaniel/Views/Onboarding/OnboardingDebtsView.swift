import SwiftUI
import SwiftData

struct OnboardingDebtsView: View {
    @Binding var debts: [TempDebt]
    
    let presets = [
        ("💳", "Tarjeta de crédito"),
        ("🦷", "Salud/Ortodoncia"),
        ("🏠", "Crédito"),
        ("🚗", "Vehículo"),
        ("📚", "Estudio")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("¿Tienes deudas activas?")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                Text("Lo que debes hoy.")
                    .font(.system(size: 14))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.horizontal, 24)
            
            // Preset Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(presets, id: \.1) { preset in
                        let isSelected = debts.contains { $0.name == preset.1 }
                        Button(action: { togglePreset(preset) }) {
                            Text("\(preset.0) \(preset.1)")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(isSelected ? Color.accentRose.opacity(0.1) : DesignSystem.Colors.surface)
                                .foregroundColor(isSelected ? .accentRose : .white)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(isSelected ? Color.accentRose : DesignSystem.Colors.border, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Debt List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach($debts) { $item in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(item.emoji)
                                TextField("Nombre", text: $item.name)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Button(action: { debts.removeAll { $0.id == item.id } }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 12))
                                        .foregroundColor(DesignSystem.Colors.textTertiary)
                                }
                            }
                            
                            HStack {
                                OnboardingField(label: "Saldo", value: $item.balance, prefix: "$")
                                OnboardingField(label: "Tasa", value: $item.rate, suffix: "%", color: .accentRose)
                            }
                            
                            HStack {
                                OnboardingField(label: "Cuota/mes", value: $item.payment, prefix: "$")
                                OnboardingField(label: "Día", value: $item.day)
                            }
                        }
                        .padding(18)
                        .background(DesignSystem.Colors.surface)
                        .cornerRadius(18)
                    }
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Running total
            let total = debts.reduce(0) { $0 + (Double($1.balance) ?? 0) }
            Text("Total deudas: $\(Int(total).formatted())")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
        }
        .background(DesignSystem.Colors.background)
    }
    
    private func togglePreset(_ preset: (String, String)) {
        if let index = debts.firstIndex(where: { $0.name == preset.1 }) {
            debts.remove(at: index)
        } else {
            debts.append(TempDebt(emoji: preset.0, name: preset.1, balance: "0", rate: preset.1.contains("Tarjeta") ? "25.19" : "0", payment: "0", day: "10"))
        }
    }
}

struct TempDebt: Identifiable {
    let id = UUID()
    var emoji: String
    var name: String
    var balance: String
    var rate: String
    var payment: String
    var day: String
}

struct OnboardingField: View {
    let label: String
    @Binding var value: String
    var prefix: String = ""
    var suffix: String = ""
    var color: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(DesignSystem.Colors.textTertiary)
            HStack(spacing: 2) {
                if !prefix.isEmpty { Text(prefix).foregroundColor(color) }
                TextField("", text: $value)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(color)
                    .keyboardType(.decimalPad)
                if !suffix.isEmpty { Text(suffix).foregroundColor(color) }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
