import SwiftUI

struct GoalCardView: View {
    let goal: SavingsGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.emoji)
                    .font(.system(size: 40))
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading) {
                    Text(goal.name)
                        .font(.headline)
                    Text(goal.targetAmount.cop)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(Int(progress * 100))%")
                        .font(.headline)
                        .monospacedDigit()
                    Text(monthsRemainingText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZWBProgressShape(progress: progress)
                    .stroke(Color.accentColor, lineWidth: 8)
                    .frame(height: 8)
            }
            .frame(height: 8)
            .padding(.top, 4)
            
            HStack {
                Text(goal.savedAmount.cop)
                    .font(.caption)
                    .monospacedDigit()
                    .bold()
                Spacer()
                Text("Faltan \((goal.targetAmount - goal.savedAmount).cop)")
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var progress: Double {
        guard goal.targetAmount > 0 else { return 0 }
        return goal.savedAmount / goal.targetAmount
    }
    
    private var monthsRemainingText: String {
        let remaining = goal.targetAmount - goal.savedAmount
        guard remaining > 0, goal.monthlyContribution > 0 else { return "Meta alcanzada!" }
        let months = Int(ceil(remaining / goal.monthlyContribution))
        return "\(months) meses"
    }
}

// Custom Progress Shape (Simple Capsule-like)
struct ZWBProgressShape: Shape {
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * CGFloat(progress), y: rect.midY))
        return path
    }
}
