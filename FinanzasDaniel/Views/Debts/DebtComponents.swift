import SwiftUI

// MARK: - InvertedProgressBar
struct InvertedProgressBar: View {
    let progress: Double // 0 to 1
    let color: Color
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 6)
                
                Capsule()
                    .fill(color)
                    .frame(width: geo.size.width * CGFloat(progress), height: 6)
            }
        }
        .frame(height: 6)
    }
}

// MARK: - MiniDebtCard
struct MiniDebtCard: View {
    let debt: Debt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(debt.emoji)
                .font(.system(size: 32))
            
            Text(debt.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
            
            InvertedProgressBar(progress: debt.progressPercent, color: debt.hasInterest ? .accentRose : .accentViolet)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(Int(debt.progressPercent * 100))% pagado")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundColor(debt.hasInterest ? .accentRose : .accentViolet)
                
                if let months = debt.monthsToPayoff, months > 0 {
                    let date = debt.projectedPayoffDate ?? Date()
                    let monthStr = date.formatted(.dateTime.month().year())
                    Text("\(monthStr) libre")
                        .font(.system(size: 11))
                        .foregroundColor(months < 6 ? .accentMint : .textTertiary)
                }
            }
        }
        .padding(16)
        .frame(width: 140, height: 160)
        .background(Color.surfaceSecondary)
        .cornerRadius(18)
    }
}

// MARK: - DebtTimelineStrip
struct DebtTimelineStrip: View {
    let items: [(label: String, color: Color, width: CGFloat)]
    let leftMonth: String
    let rightMonth: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { i in
                    Rectangle()
                        .fill(items[i].color)
                        .frame(maxWidth: .infinity)
                        .frame(height: 10)
                        .clipShape(
                            StatPill(
                                isFirst: i == 0,
                                isLast: i == items.count - 1
                            )
                        )
                }
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(5)
            
            HStack {
                Text(leftMonth)
                Spacer()
                Text(rightMonth)
            }
            .font(.system(size: 11))
            .foregroundColor(.textTertiary)
        }
    }
}

struct StatPill: Shape {
    var isFirst: Bool
    var isLast: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radii = CGSize(width: rect.height / 2, height: rect.height / 2)
        let corners: UIRectCorner = [
            isFirst ? .topLeft : [],
            isFirst ? .bottomLeft : [],
            isLast ? .topRight : [],
            isLast ? .bottomRight : []
        ]
        
        let pathBezier = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: radii
        )
        path = Path(pathBezier.cgPath)
        return path
    }
}

// MARK: - DebtBreakdownCard
struct DebtBreakdownCard: View {
    let principal: Double
    let interest: Double
    let newBalance: Double
    let newPayoffDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("De este pago:")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Capital (reduce deuda)")
                    Spacer()
                    Text("$\(Int(principal).formatted())")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.accentMint)
                }
                
                HStack {
                    Text("Interés (costo)")
                    Spacer()
                    Text("$\(Int(interest).formatted())")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.accentRose)
                }
                
                Divider()
                    .background(Color.borderSubtle)
                
                HStack {
                    Text("Nuevo saldo")
                    Spacer()
                    Text("$\(Int(newBalance).formatted())")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
            .font(.system(size: 14))
            
            Text("Nueva fecha libre: \(newPayoffDate)")
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
        .padding(20)
        .background(Color.surfacePrimary)
        .cornerRadius(18)
    }
}

// MARK: - RateEditorRow
struct RateEditorRow: View {
    @Binding var rate: Double
    var onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Tasa anual")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                HStack {
                    Text("\(String(format: "%.2f", rate * 100))% EA")
                        .font(.system(.body, design: .monospaced))
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                    }
                }
            }
            
            let monthlyRate = (pow(1 + rate, 1.0/12.0) - 1) * 100
            Text("= \(String(format: "%.3f", monthlyRate))% mensual")
                .font(.system(size: 12))
                .foregroundColor(.textTertiary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.surfacePrimary)
        .cornerRadius(16)
    }
}
