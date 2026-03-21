import Foundation

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
