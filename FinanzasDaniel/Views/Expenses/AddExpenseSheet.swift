import SwiftUI

struct AddExpenseSheet: View {
    @State private var amount: String = ""
    @State private var selectedCategory: String = "🍔 Comida"
    @State private var merchant: String = ""
    @State private var note: String = ""
    @State private var date: Date = Date()
    
    let categories = [
        "🍔 Comida", "🚌 Trans.", "🎮 Ocio",
        "💊 Salud", "👟 Ropa", "💸 Otro"
    ]
    
    // Grid layout for 3 columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.bgBase.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Drag indicator simulation (handled by pure sheet or manually here)
                    Capsule()
                        .fill(Color.textTertiary)
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
                PrimaryButton(title: "Guardar gasto", action: { dismiss() }, useViolet: true)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
                    .padding(.top, 16)
                    .background(Color.bgBase.opacity(0.9))
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Nuevo gasto")
                .font(.display(size: 22, weight: .semibold))
                .foregroundColor(.textPrimary)
            Text("Registra un gasto manual")
                .font(.bodyText(size: 14))
                .foregroundColor(.textSecondary)
        }
    }
    
    private var heroInput: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("$")
                .font(.moneyNumber(size: 20))
                .foregroundColor(.textSecondary)
            
            TextField("0", text: $amount)
                .font(.moneyNumber(size: 52, weight: .bold))
                .foregroundColor(.textPrimary)
                .keyboardType(.numberPad)
                .tint(.accentMint) // blink cursor color
                .fixedSize() // Let it grow from center
        }
        .padding(.top, 16)
    }
    
    private var categoryGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories, id: \.self) { cat in
                Button(action: {
                    withAnimation { selectedCategory = cat }
                }) {
                    Text(cat)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedCategory == cat ? .accentViolet : .textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(selectedCategory == cat ? Color.accentViolet.opacity(0.15) : Color.bgElevated)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(selectedCategory == cat ? Color.accentViolet : Color.clear, lineWidth: 1)
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
                    .foregroundColor(.textTertiary)
                    .frame(width: 24)
                TextField("¿Dónde gastaste?", text: $merchant)
                    .foregroundColor(.textPrimary)
                    .font(.bodyText(size: 16))
                
                if !merchant.isEmpty {
                    Button(action: { merchant = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .padding()
            .background(Color.bgElevated)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderSubtle, lineWidth: 1))
            
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.textTertiary)
                    .frame(width: 24)
                TextField("Nota opcional...", text: $note)
                    .foregroundColor(.textPrimary)
                    .font(.bodyText(size: 16))
            }
            .padding()
            .background(Color.bgElevated)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderSubtle, lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
    
    private var dateSection: some View {
        HStack {
            Text("📅 Hoy, 22 de marzo")
                .font(.system(size: 16))
                .foregroundColor(.textPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.textTertiary)
                .font(.system(size: 14))
        }
        .padding()
        .background(Color.bgElevated)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderSubtle, lineWidth: 1))
        .padding(.horizontal, 20)
    }
}

#Preview {
    AddExpenseSheet()
}
