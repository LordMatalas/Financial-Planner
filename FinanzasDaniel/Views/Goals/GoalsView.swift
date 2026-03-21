import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavingsGoal.createdAt, order: .reverse) private var goals: [SavingsGoal]
    
    @State private var showingAddGoal = false
    @State private var viewModel: GoalsViewModel?

    var body: some View {
        NavigationStack {
            List {
                ForEach(goals) { goal in
                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                        GoalCardView(goal: goal)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            goalsViewModel.deleteGoal(goal)
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Metas")
            .toolbar {
                Button {
                    showingAddGoal = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalSheet()
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = GoalsViewModel(modelContext: modelContext)
                }
            }
        }
    }
    
    private var goalsViewModel: GoalsViewModel {
        viewModel ?? GoalsViewModel(modelContext: modelContext)
    }
}

#Preview {
    GoalsView()
        .modelContainer(for: SavingsGoal.self, inMemory: true)
}
