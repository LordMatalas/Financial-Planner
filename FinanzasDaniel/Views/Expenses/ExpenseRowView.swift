import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 12) {
            Text(expense.category.emoji)
                .font(.title3)
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.merchant)
                    .font(.headline)
                HStack {
                    Text(expense.source == .wallet ? "💳 Apple Wallet" : "✏️ Manual")
                        .font(.caption)
                    if !expense.note.isEmpty {
                        Text("• \(expense.note)")
                            .font(.caption)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(expense.amount.cop)
                .font(.subheadline).bold()
                .monospacedDigit()
        }
        .padding(.vertical, 4)
    }
}
