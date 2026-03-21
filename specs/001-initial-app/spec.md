# Feature Specification: Financial Planner (FinanzasDaniel)

**Feature Branch**: `001-initial-spec`  
**Created**: 2026-03-21  
**Status**: Draft  
**Input**: FinanzasDaniel_AppSpec.md

## User Scenarios & Testing

### User Story 1 - Savings Goals Management (Priority: P1)

As Daniel, I want to create and track my savings goals (like my BMW G 310 GS) with a clear progress visualization, so I know exactly how much I need and when I will reach my goal.

**Why this priority**: Focuses on the user's primary motivation: achieving financial goals before age 25.
**Independent Test**: User can create a goal with a target amount and monthly contribution, and see the projected completion date.

**Acceptance Scenarios**:
1. **Given** no goals exist, **When** I add "BMW G 310 GS" with $13,250,000 target and $1,200,000 monthly, **Then** I should see it in the list with "23 months" remaining.
2. **Given** a goal, **When** I add a manual contribution of $500,000, **Then** the saved amount increases and the projected date moves earlier.

---

### User Story 2 - Automated Expense Tracking (Priority: P2)

As Daniel, I want my Apple Wallet payments to be automatically recorded as "gastos hormiga", so I don't have to manually type every small purchase.

**Why this priority**: Core "smart" feature of the app to prevent friction in tracking small expenses.
**Independent Test**: Simulate an AppIntent call with amount and merchant, and verify it appears in the expenses list.

**Acceptance Scenarios**:
1. **Given** the app is installed, **When** a Shortcut triggers the `RegisterWalletExpenseIntent` with $8,500 from "Juan Valdez", **Then** a new expense is saved with category "Food".

---

### User Story 3 - Monthly Financial Health Dashboard (Priority: P3)

As Daniel, I want to see my "Free Balance" (Ingresos - Gastos Fijos - Gastos Variables) at a glance, so I know if I'm staying within my budget.

**Why this priority**: Provides the high-level financial overview needed for decision making.
**Independent Test**: Dashboard displays sum of fixed and variable expenses correctly subtracted from the $2.45M salary.

---

## Requirements

### Functional Requirements

- **FR-001**: System MUST persist data using SwiftData.
- **FR-002**: System MUST support multiple Savings Goals with names, emojis, and targets.
- **FR-003**: System MUST calculate projected completion dates dynamically.
- **FR-004**: System MUST allow manual and automated (Wallet) expense entry.
- **FR-005**: System MUST provide a monthly budget visualization for variable expenses.
- **FR-006**: System MUST send local notifications for budget alerts (80%) and daily reminders.

### Key Entities

- **SavingsGoal**: Main entity for tracking savings targets.
- **Expense**: Represents a one-time cost (manual or Wallet).
- **FixedExpense**: Represents a recurring monthly cost.
- **Contribution**: Represents an addition to a specific goal.

## Success Criteria

### Measurable Outcomes

- **SC-001**: User can record an expense (manual or Wallet) in under 5 seconds.
- **SC-002**: Financial dashboard updates in real-time after any data entry.
- **SC-003**: Projections for goals adjust immediately when the monthly contribution slider is moved.
