import SwiftUI

extension Color {
    static let bgBase = Color(hex: "07070F")
    static let bgSurface = Color(hex: "10101C")
    static let bgElevated = Color(hex: "18182A")
    static let accentMint = Color(hex: "0AFFA0")
    static let accentViolet = Color(hex: "7C6FFF")
    static let accentRose = Color(hex: "FF4D72")
    static let accentAmber = Color(hex: "FFB930")
    static let textPrimary = Color(hex: "F0F0FF")
    static let textSecondary = Color(hex: "8080A0")
    static let textTertiary = Color(hex: "404058")
    static let borderSubtle = Color.white.opacity(0.06)
    static let glowMint = Color(red: 10/255, green: 255/255, blue: 160/255).opacity(0.12)
    
    // Gradients
    static let gradMint = LinearGradient(colors: [Color(hex: "0AFFA0"), Color(hex: "00C8FF")], startPoint: .leading, endPoint: .trailing)
    static let gradViolet = LinearGradient(colors: [Color(hex: "7C6FFF"), Color(hex: "C06FFF")], startPoint: .leading, endPoint: .trailing)
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}
