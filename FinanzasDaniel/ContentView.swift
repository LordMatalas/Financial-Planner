import SwiftUI

enum AppTab {
    case dashboard, goals, debts, expenses
}

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab: AppTab = .dashboard
    
    var body: some View {
        Group {
            if appState.onboardingComplete {
                mainView
            } else {
                OnboardingFlow()
                    .transition(.opacity)
            }
        }
        .animation(DesignSystem.Transitions.spring, value: appState.onboardingComplete)
    }
    
    var mainView: some View {
        ZStack(alignment: .bottom) {
            DesignSystem.Colors.background.ignoresSafeArea()
            
            // Content
            Group {
                switch selectedTab {
                case .dashboard:
                    DashboardView()
                case .goals:
                    GoalsView()
                case .debts:
                    DebtsView()
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
            TabBarButton(icon: "chart.pie.fill", tab: .dashboard, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "target", tab: .goals, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "creditcard.fill", tab: .debts, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "cart.fill", tab: .expenses, selectedTab: $selectedTab)
        }
        .padding(.horizontal, 30)
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
            withAnimation(DesignSystem.Transitions.spring) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(selectedTab == tab ? DesignSystem.Colors.primary : DesignSystem.Colors.textTertiary)
                .frame(width: 50, height: 50)
        }
    }
}
