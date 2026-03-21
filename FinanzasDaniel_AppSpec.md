# FinanzasDaniel – App Spec para Agente de IA

> **Instrucciones para el agente:** Este documento es la especificación completa de una app iOS nativa construida con SwiftUI + Swift Data. Léelo entero antes de escribir una sola línea de código. Cada sección es una fuente de verdad. Cuando tengas dudas entre dos implementaciones, elige siempre la más simple que cumpla el requisito.

---

## 1. Contexto del usuario

- Nombre: Daniel
- Edad: 23 años. Meta de vida: ejecutar sus metas financieras antes de cumplir 25.
- Salario neto mensual: **$2,450,000 COP**
- Gastos fijos mensuales:
  - Icetex: $600,000
  - Ortodoncia: $200,000 (termina en el mes 10 desde hoy)
  - Tarjeta de crédito: saldo $4,300,000 — pago mínimo $300,000, este mes $1,000,000
- Vive con sus padres (sin arriendo)
- Gastos de vida variables: alimentación, transporte, ocio (~$450,000/mes objetivo)

---

## 2. Objetivo de la app

Una app personal de finanzas con tres módulos:

| Módulo | Propósito |
|--------|-----------|
| **Metas** | Rastrear el progreso hacia múltiples metas de ahorro con fecha límite y proyección |
| **Gastos hormiga** | Registrar automáticamente cada pago con Apple Wallet y categorizar el gasto |
| **Flujo mensual** | Vista resumen del mes: ingresos, gastos fijos, saldo libre, porcentaje de meta cumplido |

---

## 3. Stack técnico

- **Lenguaje:** Swift 5.9+
- **UI:** SwiftUI (no UIKit, salvo que sea estrictamente necesario para alguna integración)
- **Persistencia:** SwiftData (`@Model`, `ModelContainer`, `ModelContext`)
- **Automatización Wallet:** `Shortcuts` framework + `AppIntents` (iOS 16+)
- **Notificaciones:** `UserNotifications` framework
- **Mínimo de despliegue:** iOS 17.0
- **Sin dependencias externas** (sin SPM packages, sin CocoaPods). Todo con frameworks nativos de Apple.

---

## 4. Modelos de datos (SwiftData)

```swift
// MARK: - Meta de ahorro
@Model
class SavingsGoal {
    var id: UUID
    var name: String           // "BMW G 310 GS", "Fondo de emergencia", etc.
    var emoji: String          // "🏍️", "🏠", "✈️" — el usuario lo elige
    var targetAmount: Double   // Monto total a ahorrar
    var savedAmount: Double    // Acumulado hasta hoy
    var deadline: Date?        // Fecha límite opcional
    var monthlyContribution: Double  // Cuánto aporta el usuario cada mes
    var isActive: Bool
    var createdAt: Date
    var contributions: [Contribution]  // relación 1-N

    // Computed (no persistidos):
    // var progressPercent: Double  → savedAmount / targetAmount
    // var monthsRemaining: Int     → ceil((targetAmount - savedAmount) / monthlyContribution)
    // var projectedCompletionDate: Date
}

// MARK: - Aporte manual a una meta
@Model
class Contribution {
    var id: UUID
    var amount: Double
    var note: String
    var date: Date
    var goal: SavingsGoal  // relación inversa
}

// MARK: - Gasto registrado (hormiga o manual)
@Model
class Expense {
    var id: UUID
    var amount: Double
    var merchant: String        // Nombre del comercio (viene de Wallet o lo ingresa el usuario)
    var category: ExpenseCategory
    var date: Date
    var source: ExpenseSource   // .wallet / .manual
    var note: String
}

// MARK: - Gasto fijo recurrente
@Model
class FixedExpense {
    var id: UUID
    var name: String
    var amount: Double
    var dueDay: Int             // Día del mes en que cae (1–31)
    var endsOnMonth: Int?       // Mes (contando desde hoy) en que se acaba. Nil = indefinido
    var category: ExpenseCategory
    var isActive: Bool
}

// MARK: - Enums
enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "Comida"
    case transport = "Transporte"
    case entertainment = "Ocio"
    case health = "Salud"
    case clothing = "Ropa"
    case digital = "Digital/Suscripciones"
    case other = "Otro"

    var emoji: String {
        switch self {
        case .food: return "🍔"
        case .transport: return "🚌"
        case .entertainment: return "🎮"
        case .health: return "💊"
        case .clothing: return "👟"
        case .digital: return "📱"
        case .other: return "💸"
        }
    }
}

enum ExpenseSource: String, Codable {
    case wallet = "Apple Wallet"
    case manual = "Manual"
}
```

---

## 5. Arquitectura de la app

Usar **MVVM ligero**: Views + `@Observable` ViewModels. No usar `@ObservableObject` ni Combine.

```
FinanzasDanielApp
├── ContentView (TabView con 3 tabs)
│   ├── Tab 1: GoalsView
│   │   ├── GoalCardView
│   │   ├── GoalDetailView
│   │   │   ├── ProgressRingView (custom Shape)
│   │   │   ├── ContributionListView
│   │   │   └── AddContributionSheet
│   │   └── AddGoalSheet
│   ├── Tab 2: ExpensesView
│   │   ├── ExpenseSummaryHeaderView
│   │   ├── ExpenseRowView
│   │   └── AddExpenseSheet
│   └── Tab 3: DashboardView
│       ├── MonthlyFlowCardView
│       ├── FixedExpensesCardView
│       └── GoalProgressMiniCardView
├── ViewModels
│   ├── GoalsViewModel
│   ├── ExpensesViewModel
│   └── DashboardViewModel
├── Models (SwiftData)
├── AppIntents (Wallet automation)
└── Utilities
    ├── CurrencyFormatter.swift
    └── DateHelpers.swift
```

---

## 6. Pantallas y flujos

### 6.1 Tab: Metas 🎯

**GoalsView**
- Lista de `SavingsGoal` activas
- Cada card muestra: emoji + nombre, barra de progreso animada, monto ahorrado / meta, días o meses restantes
- Botón `+` → `AddGoalSheet`
- Swipe left → eliminar (con confirmación)

**AddGoalSheet**
- Campos: nombre (TextField), emoji picker (cuadrícula de emojis por categoría), monto meta (teclado numérico COP), aporte mensual, fecha límite (DatePicker, opcional)
- Al guardar: calcula automáticamente `projectedCompletionDate` y muestra aviso si no alcanza antes del deadline

**GoalDetailView**
- Anillo de progreso circular (custom `Shape` con `trim`)  
- Estadísticas: % completado, monto faltante, proyección de fecha de cierre, aporte mensual
- Historial de aportes con fecha y nota
- Botón "Añadir aporte" → sheet con monto y nota
- **Slider interactivo**: "¿Qué pasa si aporto $X más por mes?" — muestra en tiempo real cómo cambia la fecha de cierre

**Datos precargados (primera apertura):**
```swift
SavingsGoal(
    name: "BMW G 310 GS",
    emoji: "🏍️",
    targetAmount: 13_250_000,
    savedAmount: 0,
    deadline: Calendar.current.date(byAdding: .month, value: 23, to: .now),
    monthlyContribution: 1_200_000
)
```

---

### 6.2 Tab: Gastos hormiga 🐜

**ExpensesView**
- Header: total gastado este mes vs. presupuesto del mes (configurable en Settings)
- Barra de progreso de presupuesto: verde < 70%, amarillo 70–90%, rojo > 90%
- Lista de gastos agrupados por día, ordenados por fecha descendente
- Cada fila: merchant emoji de categoría + nombre + monto + fuente (Wallet 💳 o Manual ✏️)
- Botón `+` → `AddExpenseSheet` para registro manual
- Filtro por categoría (chips horizontales scrolleables)

**AddExpenseSheet**
- Campos: monto, merchant (TextField), categoría (picker), nota (opcional)
- Fecha (por defecto: hoy, editable)

**Comportamiento de gastos hormiga:**
- El presupuesto mensual de gastos variables lo configura el usuario en Settings (default: $450,000)
- Al superar el 80% del presupuesto → notificación push: "🐜 Ya vas en el 80% de tu presupuesto de gastos este mes"
- Al cierre de mes (último día) → resumen push con el total

---

### 6.3 Tab: Dashboard 📊

**DashboardView**
- Mes y año actual como título
- **Card Flujo mensual:**
  - Ingresos: $2,450,000
  - Gastos fijos (suma de `FixedExpense` activos ese mes)
  - Gastos variables (suma de `Expense` del mes)
  - **Saldo libre** = ingresos − fijos − variables (resaltado en verde si > 0, rojo si < 0)
- **Card Metas activas:** mini versión de cada goal con % y meses restantes
- **Card Gastos por categoría:** gráfico de barras horizontales (dibujado con `GeometryReader` + `RoundedRectangle`, sin librerías externas)

---

## 7. Automatización con Apple Wallet (CRÍTICO)

### 7.1 Cómo funciona

Cuando el usuario paga con Apple Pay / Wallet, iOS puede disparar un Shortcut. La app expone un **AppIntent** que recibe los datos del pago y los guarda como `Expense`.

### 7.2 Implementación

```swift
// AppIntents/RegisterWalletExpenseIntent.swift

import AppIntents
import SwiftData

struct RegisterWalletExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Registrar gasto de Wallet"
    static var description = IntentDescription("Guarda un pago de Apple Wallet como gasto hormiga")

    @Parameter(title: "Monto")
    var amount: Double

    @Parameter(title: "Comercio")
    var merchant: String

    @Parameter(title: "Categoría")
    var category: ExpenseCategory

    func perform() async throws -> some IntentResult {
        let expense = Expense(
            id: UUID(),
            amount: amount,
            merchant: merchant,
            category: category,
            date: .now,
            source: .wallet,
            note: ""
        )
        // Guardar en SwiftData usando ModelContainer compartido
        let container = try ModelContainer(for: Expense.self)
        let context = ModelContext(container)
        context.insert(expense)
        try context.save()
        return .result(dialog: "✅ Gasto de \(merchant) por $\(Int(amount).formatted()) registrado")
    }
}
```

### 7.3 Shortcut que el usuario debe crear en iOS

Incluir en la app una pantalla de onboarding (`WalletSetupView`) con instrucciones paso a paso y botón "Abrir Atajos" (`UIApplication.shared.open(URL(string: "shortcuts://")!)`):

```
Instrucciones para el usuario:
1. Abre la app Atajos en tu iPhone
2. Toca "Automatización" → "+"  → "Transacción de Apple Pay"
3. Condición: "Cualquier tarjeta"
4. Acción: "FinanzasDaniel → Registrar gasto de Wallet"
5. Completa: Monto = Importe de la transacción
            Comercio = Nombre del comerciante
            Categoría = (el usuario elige o deja "Otro")
6. Desactiva "Preguntar antes de ejecutar"
```

### 7.4 Limitaciones importantes (documentar en la app)

- Apple no expone el monto exacto de la transacción de Wallet a Shortcuts de forma directa en todas las versiones. Si el agente encuentra limitaciones de API, implementar el flujo alternativo: el Shortcut pide al usuario confirmar el monto antes de guardar.
- La automatización de "Transacción de Apple Pay" en Shortcuts sí está disponible desde iOS 16.4+.

---

## 8. Notificaciones locales

```swift
// Triggers a programar:
// 1. Diario a las 9pm si el usuario no ha registrado ningún gasto ese día
//    → "¿Gastaste hoy? Registra tus gastos hormiga 🐜"
// 2. Cuando un gasto nuevo supera el 80% del presupuesto mensual
//    → "Alerta de presupuesto: ya vas en el X% este mes"
// 3. Primer día de cada mes: resumen del mes anterior
//    → "Resumen de [Mes]: gastaste $X, ahorraste $Y hacia tus metas"
// 4. Una semana antes del deadline de una meta activa
//    → "📅 Tu meta '[nombre]' vence en 7 días. Te faltan $X"
```

---

## 9. Settings / Configuración

Vista accesible desde cada tab con botón de engranaje ⚙️:

| Setting | Tipo | Default |
|---------|------|---------|
| Salario neto mensual | Double | 2,450,000 |
| Presupuesto de gastos variables | Double | 450,000 |
| Recordatorio diario de gastos | Toggle + TimePicker | On, 9:00 PM |
| Notificaciones de presupuesto | Toggle | On |
| Notificaciones de metas | Toggle | On |

Guardar en `UserDefaults` (no en SwiftData — son preferencias, no datos).

---

## 10. Diseño visual

- **Paleta:** Fondo `systemBackground`, acentos en `systemGreen` (positivo/ahorro), `systemRed` (deuda/alerta), `systemBlue` (meta)
- **Tipografía:** SF Pro (sistema). Montos en `.monospacedDigit` para evitar saltos al actualizar
- **Corner radius:** 16pt en cards principales, 10pt en elementos internos
- **Sin imágenes externas.** Todos los íconos son SF Symbols o emojis
- **Dark mode:** soporte completo usando colores semánticos del sistema

### Formateo de moneda COP

```swift
// Utilities/CurrencyFormatter.swift
extension Double {
    var cop: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "$"
        f.currencyCode = "COP"
        f.maximumFractionDigits = 0
        f.locale = Locale(identifier: "es_CO")
        return f.string(from: NSNumber(value: self)) ?? "$0"
    }
}
// Uso: (1_200_000.0).cop → "$1.200.000"
```

---

## 11. Estructura de archivos Xcode

```
FinanzasDaniel/
├── FinanzasDanielApp.swift          ← ModelContainer setup aquí
├── ContentView.swift                ← TabView
├── Models/
│   ├── SavingsGoal.swift
│   ├── Contribution.swift
│   ├── Expense.swift
│   ├── FixedExpense.swift
│   └── Enums.swift
├── ViewModels/
│   ├── GoalsViewModel.swift
│   ├── ExpensesViewModel.swift
│   └── DashboardViewModel.swift
├── Views/
│   ├── Goals/
│   │   ├── GoalsView.swift
│   │   ├── GoalCardView.swift
│   │   ├── GoalDetailView.swift
│   │   ├── ProgressRingView.swift
│   │   └── AddGoalSheet.swift
│   ├── Expenses/
│   │   ├── ExpensesView.swift
│   │   ├── ExpenseRowView.swift
│   │   └── AddExpenseSheet.swift
│   ├── Dashboard/
│   │   └── DashboardView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Onboarding/
│       └── WalletSetupView.swift
├── AppIntents/
│   └── RegisterWalletExpenseIntent.swift
├── Utilities/
│   ├── CurrencyFormatter.swift
│   └── DateHelpers.swift
└── Resources/
    └── Assets.xcassets
```

---

## 12. Setup del ModelContainer

```swift
// FinanzasDanielApp.swift
@main
struct FinanzasDanielApp: App {
    let container: ModelContainer = {
        let schema = Schema([SavingsGoal.self, Contribution.self, Expense.self, FixedExpense.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("No se pudo crear ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
```

---

## 13. Datos de prueba (Preview / primer launch)

```swift
// Para Previews de SwiftUI — NO para producción
extension SavingsGoal {
    static var preview: SavingsGoal {
        SavingsGoal(id: UUID(), name: "BMW G 310 GS", emoji: "🏍️",
                    targetAmount: 13_250_000, savedAmount: 2_400_000,
                    deadline: Calendar.current.date(byAdding: .month, value: 14, to: .now)!,
                    monthlyContribution: 1_200_000, isActive: true, createdAt: .now, contributions: [])
    }
}

extension Expense {
    static var previewList: [Expense] {
        [
            Expense(id: UUID(), amount: 8500, merchant: "Juan Valdez", category: .food, date: .now, source: .wallet, note: ""),
            Expense(id: UUID(), amount: 4200, merchant: "SITP", category: .transport, date: .now, source: .wallet, note: ""),
            Expense(id: UUID(), amount: 25000, merchant: "Rappi", category: .food, date: .now, source: .manual, note: "Cena"),
        ]
    }
}
```

---

## 14. Orden de implementación sugerido al agente

1. **Modelos SwiftData** + `FinanzasDanielApp.swift` con `ModelContainer`
2. **GoalsView** + `GoalCardView` + `AddGoalSheet` (el módulo más importante)
3. **GoalDetailView** con `ProgressRingView` y slider interactivo
4. **ExpensesView** + `AddExpenseSheet` (registro manual)
5. **DashboardView** con flujo mensual y gráfico de categorías
6. **AppIntent** `RegisterWalletExpenseIntent` + `WalletSetupView` con instrucciones
7. **Notificaciones locales**
8. **SettingsView**
9. Datos de preview + pulir animaciones

---

## 15. Cosas que el agente NO debe hacer

- No usar `UIKit` salvo para el `UIApplication.shared.open` de Atajos
- No usar `@ObservableObject` ni `@StateObject` — solo `@Observable` y SwiftData
- No usar librerías de gráficos externas — todo con SwiftUI nativo
- No hardcodear colores con hex — solo colores semánticos del sistema (`Color(.systemGreen)`, etc.)
- No olvidar `.monospacedDigit` en todos los textos que muestren montos
- No crear un solo archivo de 800 líneas — respetar la estructura de carpetas del apartado 11

---

## 16. Preguntas que el agente puede hacerle al usuario antes de empezar

1. ¿Quieres que la app tenga ícono y nombre personalizado (`FinanzasDaniel`) o usamos el nombre genérico `Finanzas`?
2. ¿Tienes ya un Apple Developer account activo para instalar en el iPhone, o vamos a usar el free provisioning de Xcode?
3. ¿Quieres que la primera pantalla sea un onboarding de configuración inicial (salario, presupuesto) o arrancamos directo con los datos precargados?
4. ¿Necesitas soporte para iPad también, o solo iPhone?

---

*Documento generado el 20 de marzo de 2026. Última meta del usuario: BMW G 310 GS antes de los 25 años. 🏍️*
