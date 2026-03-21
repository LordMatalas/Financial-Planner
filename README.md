# FinanzasDaniel 🏍️💰

FinanzasDaniel is a modern, 100% native iOS application built specifically to track savings goals and day-to-day "gastos hormiga" (small expenses). It was created to help Daniel achieve his goal of buying a BMW G 310 GS before turning 25.

![FinanzasDaniel Dashboard Mockup](docs/mockup.png)

## 🚀 Features

*   **Metas (Goals)**: Track savings targets with dynamic circular progress rings.
*   **Gastos Hormiga (Expenses)**: Quickly log daily expenses with Apple Wallet automation via AppIntents.
*   **Dashboard**: Monitor your monthly "Free Balance" flow and see spending breakdowns by category.
*   **Alerts**: Get daily reminders to log expenses and budget warnings via Local Notifications.

## 🛠️ Tech Stack

*   **Platform**: iOS 17.0+
*   **Architecture**: MVVM
*   **UI Framework**: SwiftUI (100% Native, system colors, SF Symbols)
*   **Persistence**: SwiftData
*   **Automation**: AppIntents (Shortcuts integration)
*   **Tools**: Built using [GitHub Spec Kit](https://github.com/github/spec-kit)

## 📱 Installation

1.  Clone this repository.
2.  Open `FinanzasDaniel.xcodeproj` in Xcode 15 or later.
3.  Build and run on your iPhone simulator or physical device.

## 🪄 Apple Wallet Automation

To automatically track expenses made with Apple Wallet:

1.  Open the **Shortcuts (Atajos)** app on your iPhone.
2.  Go to the **Automation** tab and tap **+**.
3.  Select **Apple Pay Transaction**.
4.  Choose your card and tap Next.
5.  Add Action: Search for "FinanzasDaniel" and select **Registrar gasto de Wallet**.
6.  Configure the action to use the `Amount` and `Merchant` from the transaction.
7.  Turn off "Ask Before Running".

## 📁 Spec-Kit Documentation

The original specifications, implementation plans, and tasks generated during the creation of this app can be found in the `specs/001-initial-app/` directory.

---
*Built with ❤️ for Daniel.*
