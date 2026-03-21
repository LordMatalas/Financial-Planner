import SwiftUI

struct ProgressRingView: View {
    var progress: Double
    var emoji: String
    var color: Color = .accentColor
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.1)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            Text(emoji)
                .font(.system(size: 60))
        }
    }
}

#Preview {
    ProgressRingView(progress: 0.6, emoji: "🏍️")
        .padding(40)
}
