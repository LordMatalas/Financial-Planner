import SwiftUI

extension Font {
    static func heroNumber(size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }
    
    static func display(size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    static func heading(size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    
    static func bodyText(size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    
    static func moneyNumber(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
    
    static func chipLabel(size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
}
