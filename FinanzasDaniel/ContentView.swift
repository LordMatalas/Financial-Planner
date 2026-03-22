import SwiftUI

enum AppTab {
    case goals, dashboard, expenses
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .dashboard
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.bgBase.ignoresSafeArea()
            
            // Content
            Group {
                switch selectedTab {
                case .goals:
                    GoalsView()
                case .dashboard:
                    DashboardView()
                case .expenses:
                    ExpensesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            customTabBar
        }
        .preferredColorScheme(.dark)
    }
    
    var customTabBar: some View {
        HStack(spacing: 0) {
            TabBarButton(icon: "target", tab: .goals, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "chart.pie.fill", tab: .dashboard, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "creditcard.fill", tab: .expenses, selectedTab: $selectedTab)
        }
        .padding(.horizontal, 40)
        .frame(height: 82)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let tab: AppTab
    @Binding var selectedTab: AppTab
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(selectedTab == tab ? .accentMint : .textTertiary)
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    ContentView()
}
