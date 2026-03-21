import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                GoalsView()
                    .tabItem {
                        Label("Metas", systemImage: "target")
                    }
                    .tag(0)
                
                ExpensesView()
                    .tabItem {
                        Label("Gastos", systemImage: "tray.and.arrow.down")
                    }
                    .tag(1)
                
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "chart.pie")
                    }
                    .tag(2)
            }
            .navigationTitle("FinanzasDaniel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
