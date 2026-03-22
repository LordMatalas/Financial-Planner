import SwiftUI
import SwiftData

struct AddExpenseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""
    @State private var selectedCategory: ExpenseCategory = .food
    @State private var merchant: String = ""
    @State private var note: String = ""
    @State private var date: Date = Date()
    
    // Grid layout for 3 columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DesignSystem.Colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Drag indicator simulation
                    Capsule()
                        .fill(DesignSystem.Colors.textTertiary)
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                    
                    headerSection
                        .padding(.top, 8)
                    
                    heroInput
                    
                    categoryGrid
                    
                    inputForms
                    
                    dateSection
                    
                    Spacer(minLength: 120) // Space for CTA
                }
            }
            
            // CTA
            VStack {
                Spacer()
                PrimaryButton(title: "Guardar gasto", action: saveExpense, useViolet: true)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
                    .padding(.top, 16)
                    .background(DesignSystem.Colors.background.opacity(0.9))
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        
        ExpenseManager.shared.addExpense(
            amount: amountValue,
            merchant: merchant.isEmpty ? "Sin nombre" : merchant,
            category: selectedCategory,
            date: date,
            note: note,
            context: modelContext
        )
        
        dismiss()
    }
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Nuevo gasto")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Text("Registra un gasto manual")
                .font(.system(size: 14))
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }
    
    private var heroInput: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("$")
                .font(.system(size: 20))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            TextField("0", text: $amount)
                .font(.system(size: 52, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .keyboardType(.numberPad)
                .tint(DesignSystem.Colors.primary) // blink cursor color
                .fixedSize() // Let it grow from center
                .currencyFormat()
        }
        .padding(.top, 16)
    }
    
    private var categoryGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(ExpenseCategory.allCases, id: \.self) { cat in
                Button(action: {
                    withAnimation { selectedCategory = cat }
                }) {
                    VStack(spacing: 4) {
                        Text(cat.emoji)
                            .font(.system(size: 24))
                        Text(cat.rawValue)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(selectedCategory == cat ? DesignSystem.Colors.secondary : DesignSystem.Colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(selectedCategory == cat ? DesignSystem.Colors.secondary.opacity(0.15) : DesignSystem.Colors.surface)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(selectedCategory == cat ? DesignSystem.Colors.secondary : Color.clear, lineWidth: 1)
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var inputForms: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "storefront")
                    .foregroundColor(DesignSystem.Colors.textTertiary)
                    .frame(width: 24)
                TextField("¿Dónde gastaste?", text: $merchant)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .font(.system(size: 16))
                
                if !merchant.isEmpty {
                    Button(action: { merchant = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                    }
                }
            }
            .padding()
            .background(DesignSystem.Colors.elevated)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(DesignSystem.Colors.border, lineWidth: 1))
            
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(DesignSystem.Colors.textTertiary)
                    .frame(width: 24)
                TextField("Nota opcional...", text: $note)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .font(.system(size: 16))
            }
            .padding()
            .background(DesignSystem.Colors.elevated)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(DesignSystem.Colors.border, lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
    
    private var dateSection: some View {
        DatePicker("📅 Fecha", selection: $date, displayedComponents: [.date])
            .padding()
            .background(DesignSystem.Colors.elevated)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(DesignSystem.Colors.border, lineWidth: 1))
            .padding(.horizontal, 20)
    }
}

#Preview {
    AddExpenseSheet()
}
