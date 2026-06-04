import SwiftUI

// MARK: - Personnage principal STRATES (SwiftUI pur, style Duolingo)

enum CharacterEmotion: Equatable {
    case idle
    case happy
    case celebrating
    case sad
    case scared
    case thinking
    case winking
}

struct CharacterView: View {
    let emotion: CharacterEmotion
    var size: CGFloat = 120

    @State private var blinkTimer: Timer?
    @State private var isBlinking = false
    @State private var bodyWobble: Double = 0
    @State private var armAngle: Double = 0
    @State private var bounceOffset: CGFloat = 0
    @State private var pupilOffset: CGSize = .zero
    @State private var mouthStretch: CGFloat = 1.0
    @State private var idle_breathe: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Ombre portée
            Ellipse()
                .fill(Color.black.opacity(0.12))
                .frame(width: size * 0.7, height: size * 0.12)
                .offset(y: size * 0.52)
                .blur(radius: 4)
                .scaleEffect(x: 1.0 - bounceOffset * 0.002)

            // Corps principal
            bodyView
                .offset(y: bounceOffset)
                .scaleEffect(idle_breathe)
                .rotationEffect(.degrees(bodyWobble))
        }
        .frame(width: size, height: size * 1.15)
        .onAppear {
            startIdleAnimations()
            startBlinking()
        }
        .onDisappear {
            blinkTimer?.invalidate()
        }
        .onChange(of: emotion) { _, newEmotion in
            triggerEmotionAnimation(newEmotion)
        }
    }

    // MARK: - Corps

    private var bodyView: some View {
        ZStack {
            // Bras gauche
            armView(side: -1)
                .offset(x: -size * 0.44, y: size * 0.08)
                .rotationEffect(.degrees(armAngle * -1 - leftArmBase), anchor: .top)

            // Bras droit
            armView(side: 1)
                .offset(x: size * 0.44, y: size * 0.08)
                .rotationEffect(.degrees(armAngle + rightArmBase), anchor: .top)

            // Corps (tronc)
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(bodyGradient)
                .frame(width: size * 0.58, height: size * 0.52)
                .offset(y: size * 0.22)

            // Ventre clair
            Ellipse()
                .fill(Color.white.opacity(0.25))
                .frame(width: size * 0.32, height: size * 0.28)
                .offset(y: size * 0.24)

            // Tête
            headView
                .offset(y: -size * 0.04)

            // Jambes
            HStack(spacing: size * 0.08) {
                legView
                legView
            }
            .offset(y: size * 0.5)
        }
    }

    // MARK: - Tête

    private var headView: some View {
        ZStack {
            // Tête principale
            Circle()
                .fill(bodyGradient)
                .frame(width: size * 0.68, height: size * 0.68)

            // Joues
            if emotion == .happy || emotion == .celebrating {
                HStack(spacing: size * 0.28) {
                    Circle()
                        .fill(Color.pink.opacity(0.35))
                        .frame(width: size * 0.14, height: size * 0.10)
                    Circle()
                        .fill(Color.pink.opacity(0.35))
                        .frame(width: size * 0.14, height: size * 0.10)
                }
                .offset(y: size * 0.08)
            }

            // Yeux
            HStack(spacing: size * 0.18) {
                eyeView(isRight: false)
                eyeView(isRight: true)
            }
            .offset(y: -size * 0.05)

            // Bouche
            mouthView
                .offset(y: size * 0.10)
                .scaleEffect(x: mouthStretch, y: 1.0)

            // Chapeau/Accessoire pensée
            if emotion == .thinking {
                Image(systemName: "ellipsis")
                    .font(.system(size: size * 0.14, weight: .black))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .offset(x: size * 0.22, y: -size * 0.36)
            }
        }
    }

    // MARK: - Œil

    private func eyeView(isRight: Bool) -> some View {
        ZStack {
            // Blanc de l'œil
            if isBlinking {
                // Clin d'œil = ligne
                Capsule()
                    .fill(eyeColor)
                    .frame(width: size * 0.14, height: size * 0.04)
            } else if emotion == .winking && isRight {
                Capsule()
                    .fill(eyeColor)
                    .frame(width: size * 0.14, height: size * 0.04)
            } else if emotion == .sad {
                // Yeux tristes = demi-cercle vers le bas
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.18, height: size * 0.18)
                    // Pupille vers le bas
                    Circle()
                        .fill(eyeColor)
                        .frame(width: size * 0.10, height: size * 0.10)
                        .offset(y: size * 0.02)
                    // Sourcil triste
                    RoundedRectangle(cornerRadius: 2)
                        .fill(eyeColor)
                        .frame(width: size * 0.14, height: size * 0.025)
                        .rotationEffect(.degrees(isRight ? -15 : 15))
                        .offset(y: -size * 0.13)
                }
            } else if emotion == .scared {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.20, height: size * 0.20)
                    Circle()
                        .fill(eyeColor)
                        .frame(width: size * 0.13, height: size * 0.13)
                        .offset(pupilOffset)
                }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.18, height: size * 0.18)
                    // Pupille
                    Circle()
                        .fill(eyeColor)
                        .frame(width: size * 0.10, height: size * 0.10)
                        .offset(
                            x: pupilOffset.width * (isRight ? 1 : -1),
                            y: pupilOffset.height
                        )
                    // Reflet
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: size * 0.04, height: size * 0.04)
                        .offset(x: size * 0.02, y: -size * 0.02)
                }
            }
        }
        .frame(width: size * 0.20, height: size * 0.20)
    }

    // MARK: - Bouche

    private var mouthView: some View {
        Group {
            switch emotion {
            case .celebrating, .happy:
                // Grand sourire
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 0))
                    p.addQuadCurve(
                        to: CGPoint(x: size * 0.28, y: 0),
                        control: CGPoint(x: size * 0.14, y: size * 0.14)
                    )
                }
                .stroke(eyeColor, style: StrokeStyle(lineWidth: size * 0.035, lineCap: .round))
                .frame(width: size * 0.28, height: size * 0.14)
                .offset(x: -size * 0.01)

            case .sad:
                // Bouche triste
                Path { p in
                    p.move(to: CGPoint(x: 0, y: size * 0.10))
                    p.addQuadCurve(
                        to: CGPoint(x: size * 0.24, y: size * 0.10),
                        control: CGPoint(x: size * 0.12, y: -size * 0.02)
                    )
                }
                .stroke(eyeColor, style: StrokeStyle(lineWidth: size * 0.03, lineCap: .round))
                .frame(width: size * 0.24, height: size * 0.12)
                .offset(x: -size * 0.01)

            case .scared:
                // Bouche en O
                Circle()
                    .stroke(eyeColor, lineWidth: size * 0.03)
                    .frame(width: size * 0.14, height: size * 0.14)

            case .thinking:
                // Bouche de côté
                RoundedRectangle(cornerRadius: 4)
                    .fill(eyeColor)
                    .frame(width: size * 0.12, height: size * 0.03)
                    .offset(x: size * 0.04)

            default:
                // Sourire neutre
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 0))
                    p.addQuadCurve(
                        to: CGPoint(x: size * 0.20, y: 0),
                        control: CGPoint(x: size * 0.10, y: size * 0.08)
                    )
                }
                .stroke(eyeColor, style: StrokeStyle(lineWidth: size * 0.03, lineCap: .round))
                .frame(width: size * 0.20, height: size * 0.08)
                .offset(x: -size * 0.005)
            }
        }
    }

    // MARK: - Bras

    private func armView(side: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: size * 0.06)
            .fill(bodyGradient)
            .frame(width: size * 0.13, height: size * 0.32)
    }

    // MARK: - Jambe

    private var legView: some View {
        RoundedRectangle(cornerRadius: size * 0.06)
            .fill(bodyGradient)
            .frame(width: size * 0.14, height: size * 0.22)
    }

    // MARK: - Styles

    private var bodyGradient: LinearGradient {
        let colors = emotionColors
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var emotionColors: [Color] {
        switch emotion {
        case .idle, .thinking:
            return [Color(red: 0.55, green: 0.40, blue: 0.95), Color(red: 0.38, green: 0.22, blue: 0.82)]
        case .happy, .winking:
            return [Color(red: 0.25, green: 0.75, blue: 0.50), Color(red: 0.15, green: 0.60, blue: 0.38)]
        case .celebrating:
            return [Color(red: 0.95, green: 0.65, blue: 0.10), Color(red: 0.85, green: 0.45, blue: 0.05)]
        case .sad:
            return [Color(red: 0.45, green: 0.55, blue: 0.75), Color(red: 0.30, green: 0.40, blue: 0.65)]
        case .scared:
            return [Color(red: 0.80, green: 0.30, blue: 0.30), Color(red: 0.65, green: 0.18, blue: 0.18)]
        }
    }

    private var eyeColor: Color {
        switch emotion {
        case .celebrating: return Color(red: 0.5, green: 0.28, blue: 0.02)
        case .sad, .scared: return Color(red: 0.15, green: 0.20, blue: 0.40)
        default: return Color(red: 0.18, green: 0.10, blue: 0.40)
        }
    }

    private var leftArmBase: Double {
        switch emotion {
        case .celebrating: return -60
        case .sad: return 30
        case .scared: return -40
        default: return 10
        }
    }

    private var rightArmBase: Double {
        switch emotion {
        case .celebrating: return 60
        case .sad: return -30
        case .scared: return 40
        default: return -10
        }
    }

    // MARK: - Animations

    private func startIdleAnimations() {
        // Respiration douce
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            idle_breathe = 1.03
        }
        // Regarder légèrement à gauche/droite
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { t in
            guard emotion == .idle else { return }
            withAnimation(.easeInOut(duration: 0.8)) {
                pupilOffset = CGSize(width: CGFloat.random(in: -2...2), height: CGFloat.random(in: -1...1))
            }
        }
    }

    private func startBlinking() {
        blinkTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.07)) { isBlinking = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                withAnimation(.easeInOut(duration: 0.07)) { isBlinking = false }
            }
        }
    }

    private func triggerEmotionAnimation(_ emotion: CharacterEmotion) {
        switch emotion {
        case .celebrating:
            // Sauts joyeux répétés
            for i in 0..<5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) {
                        bounceOffset = -18
                        armAngle = 25
                        bodyWobble = CGFloat(i % 2 == 0 ? 8 : -8)
                        mouthStretch = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                            bounceOffset = 0
                            armAngle = 0
                            bodyWobble = 0
                        }
                    }
                }
            }

        case .sad:
            withAnimation(.easeInOut(duration: 0.5)) {
                bodyWobble = -5
                armAngle = -15
                bounceOffset = 6
                mouthStretch = 0.9
            }

        case .scared:
            // Tremblement
            let shakes: [CGFloat] = [0, -6, 6, -5, 5, -3, 3, 0]
            for (i, v) in shakes.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                    withAnimation(.easeInOut(duration: 0.05)) {
                        bodyWobble = v
                        pupilOffset = CGSize(width: v * 0.3, height: 2)
                    }
                }
            }

        case .happy:
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                bounceOffset = -10
                armAngle = 15
                bodyWobble = 5
                mouthStretch = 1.15
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring()) {
                    bounceOffset = 0
                    armAngle = 0
                    bodyWobble = 0
                }
            }

        case .thinking:
            withAnimation(.easeInOut(duration: 0.4)) {
                bodyWobble = 8
                armAngle = 10
                pupilOffset = CGSize(width: 3, height: -2)
            }

        case .winking:
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                bounceOffset = -6
                bodyWobble = -4
                mouthStretch = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) { bounceOffset = 0; bodyWobble = 0 }
            }

        case .idle:
            withAnimation(.easeInOut(duration: 0.6)) {
                bodyWobble = 0
                armAngle = 0
                bounceOffset = 0
                pupilOffset = .zero
                mouthStretch = 1.0
            }
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        VStack {
            CharacterView(emotion: .idle, size: 80)
            Text("idle").font(.caption2)
        }
        VStack {
            CharacterView(emotion: .celebrating, size: 80)
            Text("célèbre").font(.caption2)
        }
        VStack {
            CharacterView(emotion: .sad, size: 80)
            Text("triste").font(.caption2)
        }
        VStack {
            CharacterView(emotion: .scared, size: 80)
            Text("peur").font(.caption2)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
