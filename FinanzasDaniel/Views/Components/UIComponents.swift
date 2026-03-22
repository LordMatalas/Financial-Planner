import SwiftUI

// Card
struct AntigravityCard<Content: View>: View {
    let padding: CGFloat
    let content: Content
    
    init(padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(Color.bgSurface)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.borderSubtle, lineWidth: 0.5)
            )
    }
}

// Progress bar
struct ProgressBar: View {
    var progress: Double // 0.0 to 1.0
    var useViolet: Bool = false
    var isWarning: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.06))
                    .frame(height: 6)
                
                Capsule()
                    .fill(isWarning ? AnyShapeStyle(Color.accentAmber) : (useViolet ? AnyShapeStyle(Color.gradViolet) : AnyShapeStyle(Color.gradMint)))
                    .frame(width: max(0, min(geometry.size.width * CGFloat(progress), geometry.size.width)), height: 6)
            }
        }
        .frame(height: 6)
        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: progress)
    }
}

// Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var useViolet: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.bgBase)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(useViolet ? Color.gradViolet : Color.gradMint)
                .cornerRadius(16)
        }
    }
}

// Secondary Button
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.accentMint)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.accentMint, lineWidth: 1)
                )
        }
    }
}

// Progress Ring
struct ProgressRing: View {
    var progress: Double
    var size: CGFloat = 200
    var strokeWidth: CGFloat = 12
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.05), lineWidth: strokeWidth)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(Color.gradMint, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: progress)
        }
        .frame(width: size, height: size)
    }
}

// Chip View
struct ChipView: View {
    let title: String
    let isPositive: Bool
    var isWarning: Bool = false
    
    private var bgColor: Color {
        if isWarning { return Color.accentAmber.opacity(0.1) }
        return isPositive ? Color.accentMint.opacity(0.1) : Color.accentViolet.opacity(0.1)
    }
    
    private var fgColor: Color {
        if isWarning { return Color.accentAmber }
        return isPositive ? Color.accentMint : Color.accentViolet
    }
    
    var body: some View {
        Text(title)
            .font(.chipLabel(size: 13))
            .kerning(0.39) // ~0.03em tracking
            .foregroundColor(fgColor)
            .padding(.horizontal, 12)
            .frame(height: 28)
            .background(bgColor)
            .clipShape(Capsule())
    }
}
