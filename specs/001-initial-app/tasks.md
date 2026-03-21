# Tasks: Financial Planner (FinanzasDaniel)

**Input**: spec.md, plan.md

## Phase 1: Setup
- [ ] T001 Initialize SwiftUI Project structure
- [ ] T002 Configure `ModelContainer` in `FinanzasDanielApp.swift`
- [ ] T003 Implement `CurrencyFormatter.swift` for COP

## Phase 2: Foundational
- [ ] T004 Create `SavingsGoal.swift` model
- [ ] T005 Create `Expense.swift` and `FixedExpense.swift` models
- [ ] T006 Create `Contribution.swift` model
- [ ] T007 [P] Implement `DateHelpers.swift`

## Phase 3: User Story 1 - Savings Goals (Priority: P1) 🎯 MVP
**Goal**: Create and track savings goals with projections.
- [ ] T008 Implement `GoalsViewModel.swift`
- [ ] T009 Build `GoalsView.swift` (List of goals)
- [ ] T010 Build `GoalCardView.swift` with progress bar
- [ ] T011 Implement `AddGoalSheet.swift`
- [ ] T012 Build `GoalDetailView.swift` with `ProgressRingView`
- [ ] T013 Implement contribution logic and slider projection

## Phase 4: User Story 2 - Automated Expenses (Priority: P2)
**Goal**: Automatically record Wallet payments and manage expenses.
- [ ] T014 Implement `ExpensesViewModel.swift`
- [ ] T015 Build `ExpensesView.swift` with budget header
- [ ] T016 Build `ExpenseRowView.swift`
- [ ] T017 Implement `AddExpenseSheet.swift` (Manual)
- [ ] T018 Implement `RegisterWalletExpenseIntent.swift` (AppIntents)
- [ ] T019 Build `WalletSetupView.swift` (Onboarding instructions)

## Phase 5: User Story 3 - Dashboard (Priority: P3)
**Goal**: High-level financial overview.
- [ ] T020 Implement `DashboardViewModel.swift`
- [ ] T021 Build `DashboardView.swift`
- [ ] T022 Implement "Free Balance" calculation logic
- [ ] T023 Build Category Chart using `GeometryReader`

## Phase 6: Polish & Automation
- [ ] T024 Implement Local Notifications (Budget alerts/Daily reminders)
- [ ] T025 Build `SettingsView.swift` (UserDefaults integration)
- [ ] T026 Add animations and haptic feedback
