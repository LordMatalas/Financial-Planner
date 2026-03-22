import SwiftUI

struct DesignSystem {
    struct Colors {
        static let background = Color.bgBase
        static let surface = Color.bgSurface
        static let elevated = Color.bgElevated
        static let primary = Color.accentMint
        static let secondary = Color.accentViolet
        static let destructive = Color.accentRose
        static let warning = Color.accentAmber
        
        static let textPrimary = Color.textPrimary
        static let textSecondary = Color.textSecondary
        static let textTertiary = Color.textTertiary
        
        static let border = Color.borderSubtle
        
        static let gradMint = Color.gradMint
        static let gradViolet = Color.gradViolet
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct Radius {
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 20
        static let xl: CGFloat = 28
    }
    
    struct Transitions {
        static let spring = Animation.spring(response: 0.5, dampingFraction: 0.75)
    }
}

extension View {
    func currencyFormat() -> some View {
        self.fontDesign(.monospaced)
            .monospacedDigit()
    }
}
