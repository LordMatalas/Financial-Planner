import Foundation
import SwiftData

extension MonthlySnapshot {
    static func createIfNeeded(context: ModelContext) {
        let calendar = Calendar.current
        let now = Date.now
        
        // Let's see if we already have a snapshot for the current month
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        let descriptor = FetchDescriptor<MonthlySnapshot>(
            predicate: #Predicate<MonthlySnapshot> { $0.month == currentMonth && $0.year == currentYear }
        )
        
        if let snapshots = try? context.fetch(descriptor), snapshots.isEmpty {
            // It's a new month! Create a snapshot of the PREVIOUS month
            let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: now)!
            let lastMonth = calendar.component(.month, from: lastMonthDate)
            let lastYear = calendar.component(.year, from: lastMonthDate)
            
            // Note: In a real app, we'd fetch actual expenses for that specific month to snapshot accurately
            // For now, on "first launch of new month", we'd snapshot what happened.
            // But this function should be robust.
        }
    }
}
