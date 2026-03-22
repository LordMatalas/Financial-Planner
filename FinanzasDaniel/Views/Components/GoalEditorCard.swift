import SwiftUI

struct GoalEditorCard: View {
    @Binding var emoji: String
    @Binding var name: String
    @Binding var target: Double
    @Binding var monthly: Double
    @Binding var useDeadline: Bool
    @Binding var deadline: Date
    let income: Double
    
    @State private var showingEmojiPicker = false
    @FocusState private var isTargetFocused: Bool
    
    var percentOfAvailable: Double {
        guard income > 0 else { return 0 }
        return (monthly / income) * 100
    }
    
    var completionMonths: Int {
        guard monthly > 0 else { return 0 }
        return Int(ceil(target / monthly))
    }
    
    var completionDate: Date {
        Calendar.current.date(byAdding: .month, value: completionMonths, to: .now) ?? .now
    }
    
    var body: some View {
        AntigravityCard(padding: 20) {
            VStack(alignment: .leading, spacing: 20) {
                // Header (Emoji Circle + Goal Name)
                HStack(spacing: 16) {
                    Button(action: { showingEmojiPicker = true }) {
                        Text(emoji)
                            .font(.system(size: 24))
                            .frame(width: 44, height: 44)
                            .background(DesignSystem.Colors.elevated)
                            .clipShape(Circle())
                    }
                    
                    TextField("BMW G 310 GS", text: $name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(DesignSystem.Colors.background)
                        .cornerRadius(12)
                }
                
                // Rows (Meta Total & Aporte Mensual)
                VStack(spacing: 20) {
                    // Meta Total
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .bottom) {
                            Text("Meta total")
                                .font(.system(size: 15))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Spacer()
                            HStack(spacing: 0) {
                                Text("$")
                                TextField("0", value: $target, format: .number)
                                    .keyboardType(.numberPad)
                                    .focused($isTargetFocused)
                                    .multilineTextAlignment(.trailing)
                            }
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(DesignSystem.Colors.primary)
                            .frame(height: 2)
                    }
                    
                    // Aporte Mensual
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .bottom) {
                            Text("Aporte mensual")
                                .font(.system(size: 15))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 0) {
                                    Text("$")
                                    TextField("0", value: $monthly, format: .number)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                }
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(DesignSystem.Colors.secondary)
                                
                                Text("= \(Int(percentOfAvailable))% de tu ingreso disponible")
                                    .font(.system(size: 11))
                                    .foregroundColor(DesignSystem.Colors.textTertiary)
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(DesignSystem.Colors.secondary)
                            .frame(height: 2)
                    }
                }
                
                // Deadline Toggle
                HStack {
                    Text("¿Tiene fecha límite?")
                        .font(.system(size: 15))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    Spacer()
                    Toggle("", isOn: $useDeadline)
                        .labelsHidden()
                        .tint(DesignSystem.Colors.primary)
                }
                
                if useDeadline {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        DatePicker("", selection: $deadline, displayedComponents: .date)
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "es_CO"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(DesignSystem.Colors.background)
                    .cornerRadius(12)
                }
                
                // Projection Footer (Only if values are set)
                if target > 0 && monthly > 0 {
                    VStack(spacing: 0) {
                        Divider().background(DesignSystem.Colors.border)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 10))
                                    Text("Llegarías en:")
                                        .font(.system(size: 11, weight: .semibold))
                                }
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                                
                                Text("Mes \(completionMonths) · \(completionDate.formatted(.dateTime.month().year()))")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                            }
                            
                            Spacer()
                            
                            // Age chip (Using mocked heuristic + months until next age)
                            HStack(spacing: 4) {
                                Text("Tendrías \(24 + Double(completionMonths)/12.0, specifier: "%.1f") años ✅")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(DesignSystem.Colors.primary.opacity(0.1))
                            .clipShape(Capsule())
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, -20)
                    .padding(.bottom, -20)
                    .padding(.top, 4)
                    .background(DesignSystem.Colors.elevated.opacity(0.3))
                }
            }
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPickerGrid(selectedEmoji: $emoji)
        }
    }
}

struct EmojiPickerGrid: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) var dismiss
    
    let emojis = [
        "🏍️", "🚗", "🏠", "🏖️", "💻", "🎮", "📱", "✈️",
        "🏔️", "🚲", "🎸", "⌚", "🥋", "🏋️", "🏀", "⚽",
        "🎓", "💼", "💍", "👶", "🐶", "🐱", "🥂", "🍔",
        "🍕", "🍩", "🍣", "🥗", "🍇", "🍓", "🍎", "🍊",
        "🍍", "🥕", "🥑", "🥦", "🥐", "🥖", "🥨", "🥞"
    ]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 8)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button(action: {
                            selectedEmoji = emoji
                            dismiss()
                        }) {
                            Text(emoji)
                                .font(.system(size: 32))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Selecciona Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
