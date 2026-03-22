# FinanzasDaniel · Antigravity UI Prompt

---

## DESIGN SYSTEM (léelo todo antes de generar)

**App:** FinanzasDaniel — tracker de metas de ahorro + gastos hormiga. iOS nativa, SwiftUI.  
**Vibe:** Fintech startup premium. Oscuro, sofisticado, motivador. Como si Revolut y Copilot Money tuvieran un hijo colombiano.  
**Usuario:** Hombre, 23 años, quiere comprarse una moto BMW. La app lo ayuda a llegar ahí.

---

### Paleta de color

| Token            | Hex                      | Uso                                               |
| ---------------- | ------------------------ | ------------------------------------------------- |
| `bg-base`        | `#07070F`                | Fondo raíz. Negro azulado profundo.               |
| `bg-surface`     | `#10101C`                | Tarjetas y sheets.                                |
| `bg-elevated`    | `#18182A`                | Elementos flotantes, inputs activos.              |
| `accent-mint`    | `#0AFFA0`                | Ahorro, progreso positivo, CTAs principales.      |
| `accent-violet`  | `#7C6FFF`                | Metas, gráficos, highlights secundarios.          |
| `accent-rose`    | `#FF4D72`                | Deuda, alertas, gasto excedido.                   |
| `accent-amber`   | `#FFB930`                | Advertencias suaves, deadlines cercanos.          |
| `text-primary`   | `#F0F0FF`                | Texto principal. Casi blanco, leve matiz frío.    |
| `text-secondary` | `#8080A0`                | Labels, subtítulos.                               |
| `text-tertiary`  | `#404058`                | Placeholders, separadores de sección.             |
| `border-subtle`  | `rgba(255,255,255,0.06)` | Bordes de cards. Apenas perceptible.              |
| `glow-mint`      | `rgba(10,255,160,0.12)`  | Resplandor suave detrás de elementos de progreso. |

**Regla de gradientes:** Solo dos gradientes permitidos.

- `grad-mint`: `#0AFFA0` → `#00C8FF` (de éxito/ahorro)
- `grad-violet`: `#7C6FFF` → `#C06FFF` (de meta/proyección)

---

### Tipografía

- **Display / Hero numbers:** SF Pro Display, weight Semibold/Bold
- **Headings:** SF Pro Display, weight Medium
- **Body:** SF Pro Text, weight Regular
- **Moneda / Números:** SF Pro Mono — SIEMPRE para cifras en pesos. Evita el salto visual.
- **Chips / Labels:** SF Pro Text, weight Medium, tracking +0.03em

---

### Componentes base

**Cards:** `bg-surface`, corner radius 22pt, border `border-subtle` 0.5px, sin sombra. Se elevan con color, no con sombra.

**Progress bar:** 6pt alto, pill corners, track `rgba(255,255,255,0.06)`, fill con `grad-mint` o `grad-violet` según contexto.

**Progress ring:** stroke 10-14pt, track `rgba(255,255,255,0.05)`, fill con `grad-mint`. Porcentaje en SF Mono en el centro.

**Botón primario:** altura 56pt, corner 16pt, fill `grad-mint`, texto `#07070F` (negro), peso Semibold.

**Botón secundario:** misma altura, sin fill, border 1px `accent-mint`, texto `accent-mint`.

**Chips/Tags:** altura 28pt, pill, bg `rgba(10,255,160,0.1)`, texto `accent-mint` para positivos; `rgba(124,111,255,0.1)` / `accent-violet` para neutrales.

**Tab bar:** blur ultraThinMaterial sobre `bg-base`, 3 íconos SF Symbols filled, seleccionado = `accent-mint`, no seleccionado = `text-tertiary`. Sin labels de texto.

**Input fields:** bg `bg-elevated`, corner 14pt, border `border-subtle`, texto `text-primary`, placeholder `text-tertiary`, focus border `accent-violet` 1px.

---

## PANTALLAS A GENERAR

Genera cada pantalla en **390×844pt (iPhone 15 Pro)**, modo oscuro, status bar dark.

---

### PANTALLA 1 — Home / Dashboard

**Nombre de pantalla:** `Dashboard`  
**Tab activo:** ícono central (gráfico)

**Contenido de arriba hacia abajo:**

```
Status bar (dark)

── Header ──────────────────────────────────
"Hola, Daniel 👋"              [SF Pro Display 26pt, text-primary]
"Marzo 2026"                   [SF Pro Text 14pt, text-secondary]
                               [⚙️ gear icon top-right, text-secondary]

── Hero Card ───────────────────────────────
Card bg-surface, full-width, corner 22pt, padding 20pt

  "Saldo libre este mes"       [12pt, text-secondary, all-caps tracking]
  "$847.000"                   [SF Mono 38pt Bold, accent-mint]

  Divider sutil (border-subtle)

  3 columnas:
  ┌──────────────┬──────────────┬──────────────┐
  │ Ingresos     │ Fijos        │ Variables     │
  │ $2.450.000   │ $1.300.000   │ $303.000      │
  │ [mint]       │ [rose 60%]   │ [amber]       │
  └──────────────┴──────────────┴──────────────┘
  [Todos en SF Mono 15pt semibold, labels 11pt text-secondary]

── Sección Metas ───────────────────────────
"Tus metas"  [16pt Medium]    "Ver todas →" [13pt accent-violet]

  Scroll horizontal de MiniGoalCards (3 visibles, peek del 4to):
  Card 140×160pt, bg-elevated, corner 18pt:
    Emoji grande 32pt
    Nombre [13pt medium, text-primary]
    Mini progress bar [grad-mint]
    "34%" [SF Mono 13pt, accent-mint]
    "Mes 14" [11pt, text-tertiary]

── Sección Gastos hoy ──────────────────────
"Hoy · $37.500 gastados"       [14pt medium, text-primary]

  2 expense rows recientes (ver diseño en Pantalla 3)

Tab bar (blur, 3 tabs)
```

---

### PANTALLA 2 — Metas (Goals Tab)

**Nombre:** `GoalsView`  
**Tab activo:** ícono izquierdo (objetivo/diana)

```
Status bar

── Header en scroll ────────────────────────
"Mis metas"                    [SF Pro Display 28pt Bold, text-primary]
"3 activas · 1 completada"     [14pt, text-secondary]

── GoalCard #1 — BMW G 310 GS ──────────────
Card full-width, bg-surface, corner 22pt, padding 20pt
Borde sutil izquierdo 3pt accent-mint (detalle premium)

  Fila superior:
  "🏍️"  [36pt]  "BMW G 310 GS"  [17pt Semibold]  "18%" [chip mint]

  Progress bar con grad-mint, 6pt, animada

  Fila inferior:
  "$2.400.000" [SF Mono 14pt accent-mint] " de $13.250.000" [text-secondary]

  "📅 14 meses restantes"  [chip amber, porque es la meta principal]

  Fila de acción (sutil):
  [+ Añadir aporte]  [Ver detalle →]    [13pt, text-secondary]

── GoalCard #2 — Fondo de emergencia ───────
Mismo layout, accent-violet en lugar de mint, chip "26%", "8 meses"

── GoalCard #3 — Viaje a Medellín ──────────
Mismo layout, accent-violet, chip "67%", "2 meses", chip "¡Casi!" en amber

── FAB ─────────────────────────────────────
Botón circular 60pt, bg grad-mint, ícono "+" negro bold
Bottom-right, 24pt desde borde y tab bar

Tab bar
```

---

### PANTALLA 3 — Detalle de Meta (BMW)

**Nombre:** `GoalDetailView`  
**Sheet o push desde GoalCard**

```
Safe area top con botón "‹" back en text-secondary

── Hero Section ────────────────────────────
Centered, padding-top 32pt

  "🏍️"  [48pt, centered]
  "BMW G 310 GS"   [SF Pro Display 22pt Semibold]
  "Antes de los 25" [14pt text-secondary]

  Progress Ring 200pt diameter:
  - Track: rgba(255,255,255,0.05) stroke 12pt
  - Fill: grad-mint stroke 12pt, lineCap .round
  - Centro: "18%" [SF Mono 34pt Semibold, text-primary]
             "$2.4M ahorrado" [12pt text-secondary]

  Glow detrás del ring: círculo difuso glow-mint, blur 40pt

── Stats Row ───────────────────────────────
3 MetricCards en HStack, bg-elevated, corner 14pt, padding 12pt

  ┌─────────────┬──────────────┬─────────────┐
  │ Ahorrado    │ Faltante     │ Restantes   │
  │ $2.400.000  │ $10.850.000  │ 14 meses    │
  │ [mint]      │ [rose]       │ [violet]    │
  └─────────────┴──────────────┴─────────────┘
  [SF Mono 15pt semibold, labels 11pt text-tertiary]

── "¿Y si aporto más?" Card ────────────────
Card bg-surface, corner 22pt

  Título: "Simulador de aporte" [14pt Medium]

  Slider custom accent-violet:
  "$1.200.000 / mes"  ←──●────────→

  Resultado animado:
  "Llegarías en Mes 14 · Enero 2027"  [14pt text-primary]
  "Tienes 23.8 años ✓"                [13pt accent-mint]

  (Al mover slider, el texto se actualiza con spring animation)

── Historial de aportes ────────────────────
"Aportes recientes"  [14pt Medium]

  Fila: "15 Mar"  "Ahorro quincenal"  "+$600.000" [mint]
  Fila: "1 Mar"   "Primer aporte"     "+$1.200.000" [mint]
  Fila: "1 Feb"   "Aporte inicial"    "+$600.000" [mint]
  [Cada fila: 44pt alto, separadas por border-subtle]

── Bottom sticky ───────────────────────────
Botón primario full-width "+ Añadir aporte"
bg-elevated blur, padding 16pt bottom + safe area
```

---

### PANTALLA 4 — Gastos Hormiga (Expenses Tab)

**Nombre:** `ExpensesView`  
**Tab activo:** ícono derecho (billetera/card)

```
Status bar

── Budget Header Card ──────────────────────
Card bg-surface full-width corner 22pt padding 20pt

  "Gastos variables · Marzo" [12pt text-secondary all-caps]

  Fila: "$303.000"  [SF Mono 28pt semibold, text-primary]
         " de $450.000" [18pt text-secondary]

  Progress bar 8pt:
  - 67% llenado → color amber (warning)
  - Track rgba white 6%

  "Quedan $147.000 · 11 días del mes"  [12pt text-secondary]

── Filtros ─────────────────────────────────
Scroll horizontal chips, gap 8pt:
[Todos ●] [🍔 Comida] [🚌 Trans.] [🎮 Ocio] [💊 Salud] [💸 Otro]
(Todos = filled accent-violet, resto = outlined text-tertiary)

── Lista agrupada por día ──────────────────

"HOY"  [11pt text-tertiary all-caps tracking]  "Mar 22"

  ExpenseRow:
  ┌─────────────────────────────────────────┐
  │ [🍔] círculo bg rgba(mint,0.1) 40pt    │
  │ "Juan Valdez"        "$8.500" [mono]   │
  │ "Café · Chapinero"   [💳 Wallet chip]  │
  └─────────────────────────────────────────┘

  ExpenseRow:
  │ [🚌] círculo bg rgba(violet,0.1)       │
  │ "SITP"               "$4.200" [mono]   │
  │ "Transporte"         [💳 Wallet chip]  │

  ExpenseRow:
  │ [🎮] círculo bg rgba(amber,0.1)        │
  │ "Netflix"            "$21.900" [mono]  │
  │ "Suscripción"        [✏️ Manual chip]  │

"AYER"  [mismo estilo separador]

  2-3 filas más de gastos...

── FAB ─────────────────────────────────────
Botón circular 60pt, bg grad-violet, "+" negro
(mismo estilo que Goals pero en violet)

Tab bar
```

---

### PANTALLA 5 — Agregar Gasto (Sheet)

**Nombre:** `AddExpenseSheet`  
**Presenta:** desde FAB como sheet con detent `.large`

```
Drag indicator (pill redondeado, text-tertiary)
bg-base full sheet

── Header ──────────────────────────────────
"Nuevo gasto"  [SF Pro Display 22pt Semibold]
"Registra un gasto manual"  [14pt text-secondary]

── Monto (hero input) ──────────────────────
Centered, padding-top 32pt:

  "$"  [SF Mono 20pt text-secondary]
  "0"  → campo editable  [SF Mono 52pt Bold text-primary]
         (cursor parpadeante accent-mint)

── Categoría ───────────────────────────────
Grid 3×2 de CategoryButtons:
  Cada uno: 100pt wide, 64pt tall, corner 14pt
  Seleccionado: bg accent-violet 15% + border accent-violet 1px
  No seleccionado: bg-elevated

  [🍔 Comida]  [🚌 Trans.]  [🎮 Ocio]
  [💊 Salud]   [👟 Ropa]    [💸 Otro]

── Comercio ────────────────────────────────
Input field:
  Ícono 🏪 left | "¿Dónde gastaste?" placeholder | clear button

── Nota (opcional) ─────────────────────────
Input field:
  Ícono 📝 left | "Nota opcional..." placeholder

── Fecha ───────────────────────────────────
Row: "📅 Hoy, 22 de marzo"  [chevron right → DatePicker inline]

── CTA ─────────────────────────────────────
Botón primario "Guardar gasto" full-width
[Abajo del todo, sobre safe area]
```

---

### PANTALLA 6 — Onboarding de Wallet Automation

**Nombre:** `WalletSetupView`  
**Presenta:** primera vez que el usuario abre la tab de Gastos

```
bg-base full screen

── Progress indicators ─────────────────────
Top: 3 pills horizontales, gap 6pt, activo = accent-mint, inactivo = bg-elevated

── Paso 1 de 3 ─────────────────────────────

  Ícono central animado:
  Círculo 100pt bg-elevated, ícono Apple Wallet SF Symbol 48pt,
  rodeado de partículas/anillos estáticos decorativos en accent-mint 10%

  "Automatiza tus pagos"    [Display 26pt Semibold, centered]

  "Cada vez que pagues con Apple Pay, FinanzasDaniel
   registrará el gasto automáticamente. Sin tocar nada."
  [15pt text-secondary, centered, line-height 1.6, padding horizontal 32pt]

  Botón primario "Configurar ahora" full-width
  Botón secundario "Hacerlo después" (texto plano, text-secondary)

── Paso 2 de 3 (siguiente pantalla del flow) ─

  Ícono: SF Symbol "gear.badge.checkmark" en círculo

  "Abre la app Atajos"      [Display 26pt]

  Instrucción visual tipo card:
  Card bg-surface, 3 steps numerados con indicadores circulares:

  ① "Toca Automatización → +"     [14pt text-primary]
    "En la app Atajos de iOS"     [12pt text-secondary]
  ── border-subtle ──
  ② "Selecciona Transacción de Apple Pay"
  ── border-subtle ──
  ③ "Elige FinanzasDaniel como acción"

  Botón "Abrir Atajos →" (primario)
  Botón "Ya lo hice" (secundario)

── Paso 3 de 3 ─────────────────────────────

  Ícono: checkmark.circle.fill en accent-mint, 64pt
  Glow mint detrás

  "¡Listo, Daniel!"             [Display 28pt]
  "Ya tienes el radar encendido.
   Cada peso que gastes quedará registrado."
  [15pt text-secondary]

  Botón "Empezar a ahorrar" (primario, grad-mint)
```

---

## INSTRUCCIONES DE ENTREGA PARA ANTIGRAVITY

```
Generate all 6 screens above as individual frames in a single Figma-style canvas.

Technical specs:
- Frame size: 390×844pt each (iPhone 15 Pro)
- Color mode: Dark only
- Export: @2x PNG per screen + component library panel if possible
- Font: SF Pro family throughout (Display / Text / Mono weights)
- Status bar: dark content, show battery/signal/time "9:41"

Layout behavior:
- All cards use 20pt horizontal margins from screen edge
- Vertical gap between sections: 24pt standard, 32pt between major sections
- Tab bar height: 82pt (includes 34pt safe area bottom)
- Content starts 16pt below navigation title or status bar

SwiftUI mapping hints (for developer handoff):
- Every card → ZStack with RoundedRectangle fill bg-surface + stroke border-subtle
- Progress bars → GeometryReader + RoundedRectangle trim animation
- Progress rings → Circle().trim(from:to:).stroke(style: StrokeStyle(lineCap:.round))
- Tab bar → custom overlay + .toolbar(.hidden, for: .tabBar)
- Number displays → Text(amount).monospacedDigit()
- All transitions → .spring(response: 0.5, dampingFraction: 0.75)

Style guardrails:
- NO default iOS list rows
- NO light backgrounds anywhere
- NO drop shadows (use surface layering instead)
- NO gradients outside the two approved (grad-mint, grad-violet)
- NO color outside the defined palette
- All currency in SF Mono, period.

Naming convention for layers:
- Screens: [01] Dashboard, [02] Goals, [03] GoalDetail, [04] Expenses, [05] AddExpense, [06] WalletSetup
- Components: Card/, Button/, Chip/, Row/, Input/, Ring/, Bar/
```
