# Tasks: Financial Planner (FinanzasDaniel)

**Input**: spec.md, plan.md

## Phase 1: Setup
- [x] T001 Initialize SwiftUI Project structure
- [x] T002 Configure `ModelContainer` in `FinanzasDanielApp.swift`
- [x] T003 Implement `CurrencyFormatter.swift` for COP

## Phase 2: Foundational
- [x] T004 Create `SavingsGoal.swift` model
- [x] T005 Create `Expense.swift` and `FixedExpense.swift` models
- [x] T006 Create `Contribution.swift` model
- [x] T007 Implement `CurrencyFormatter.swift` (Already in P1)

## Phase 3: User Story 1 - Savings Goals (Priority: P1) 🎯 MVP
**Goal**: Create and track savings goals with projections.
- [x] T008 Implement `GoalsViewModel.swift`
- [x] T009 Build `GoalsView.swift` (List of goals)
- [x] T010 Build `GoalCardView.swift` with progress bar
- [x] T011 Implement `AddGoalSheet.swift`
- [x] T012 Build `GoalDetailView.swift` with `ProgressRingView`
- [x] T013 Implement contribution logic and slider projection

## Phase 4: User Story 2 - Automated Expenses (Priority: P2)
**Goal**: Automatically record Wallet payments and manage expenses.
- [x] T014 Implement `ExpensesViewModel.swift`
- [x] T015 Build `ExpensesView.swift` with budget header
- [x] T016 Build `ExpenseRowView.swift`
- [x] T017 Implement `AddExpenseSheet.swift` (Manual)
- [x] T018 Implement `RegisterWalletExpenseIntent.swift` (AppIntents)
- [x] T019 Build `WalletSetupView.swift` (Onboarding instructions)

## Phase 5: User Story 3 - Dashboard (Priority: P3)
**Goal**: High-level financial overview.
- [x] T020 Implement `DashboardViewModel.swift`
- [x] T021 Build `DashboardView.swift`
- [x] T022 Implement "Free Balance" calculation logic
- [x] T023 Build Category Chart using `GeometryReader`

## Phase 6: Polish & Automation
- [x] T024 Implement Local Notifications (Budget alerts/Daily reminders)
- [x] T025 Build `SettingsView.swift` (UserDefaults integration)
- [x] T026 Add animations and haptic feedback
- [x] T027 Configure XcodeGen Build System (`project.yml`)
- [x] T028 Fix AppIntent Schema & Return Type issues
- [x] T029 Implement Wallet push notifications
