import SwiftUI

struct OnboardingWelcomeView: View {
    @State private var emoji = "🏍️"
    @State private var morphScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            Spacer()
            
            Text(emoji)
                .font(.system(size: 80))
                .scaleEffect(morphScale)
                .onAppear {
                    animateEmojis()
                }
            
            VStack(spacing: DesignSystem.Spacing.m) {
                Text("Hola. Vamos a ordenar tus finanzas.")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("4 preguntas. 2 minutos. Sin excusas.")
                    .font(.system(size: 17))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.l)
            
            Spacer()
            
            Text("Toca en cualquier lugar para empezar")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .padding(.bottom, DesignSystem.Spacing.xl)
        }
    }
    
    private func animateEmojis() {
        let cycle = ["🏍️", "💰", "📈"]
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                index = (index + 1) % cycle.count
                emoji = cycle[index]
                morphScale = 1.2
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    morphScale = 1.0
                }
            }
        }
    }
}
