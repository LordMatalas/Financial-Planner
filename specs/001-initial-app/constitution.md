# Project Constitution: FinanzasDaniel

## Core Development Rules (The Laws)

1. **Native Only**: No third-party dependencies (SPM, CocoaPods). Use ONLY native Apple frameworks (SwiftUI, SwiftData, AppIntents).
2. **SwiftUI First**: No UIKit unless strictly necessary for integration (e.g., `UIApplication.shared.open`). Use `@Observable` (not `@ObservableObject`).
3. **SwiftData Persistence**: All data persistence must use `SwiftData`. Models must be annotated with `@Model`.
4. **SF Symbols & Emojis**: No external images or assets. Use SF Symbols for icons and standard Emojis.
5. **System Colors**: Use semantic system colors (e.g., `systemBackground`, `systemGreen`, `systemRed`) to support Dark Mode natively.
6. **Currency Formatting**: All monetary displays must be formatted for COP ($) using `.monospacedDigit` font.

## Technical Design Standards

- **Architecture**: Lightweight MVVM (Views + @Observable ViewModels).
- **Minimum Target**: iOS 17.0.
- **Data Privacy**: All financial data remains on-device via SwiftData.

## Success Criteria

- **Metas**: Real-time projection of completion dates based on monthly contributions.
- **Gastos Hormiga**: Automatic registration via Apple Wallet + Shortcuts integration.
- **Dashboard**: Real-time "Free Balance" calculation (Income - Fixed - Variables).
