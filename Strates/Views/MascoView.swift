import SwiftUI

// MARK: - Mascotte STRATES (SF Symbols animé, style Duolingo)

struct MascoView: View {
    let state: MascoState
    @State private var bounce: Bool = false
    @State private var wiggle: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var eyeBlink: Bool = false
    @State private var blinkTimer: Timer? = nil

    var body: some View {
        ZStack {
            // Corps principal — cercle coloré
            Circle()
                .fill(bodyGradient)
                .frame(width: 80, height: 80)
                .shadow(color: bodyColor.opacity(0.35), radius: 8, x: 0, y: 4)

            // Icône centrale
            Image(systemName: iconName)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.white)
                .symbolEffect(.bounce, value: bounce)
                .scaleEffect(scale)
                .rotationEffect(.degrees(wiggle))

            // Badge état
            if state == .celebrating {
                VStack {
                    HStack {
                        Spacer()
                        starBadge
                    }
                    Spacer()
                }
                .frame(width: 80, height: 80)
            }
        }
        .scaleEffect(bounce ? 1.08 : 1.0)
        .animation(.spring(response: 0.35, dampingFraction: 0.5), value: bounce)
        .onChange(of: state) { _, newState in
            animateForState(newState)
        }
        .onAppear {
            animateForState(state)
            startBlinkLoop()
        }
        .onDisappear {
            blinkTimer?.invalidate()
        }
    }

    // MARK: - Sous-vues

    private var starBadge: some View {
        ZStack {
            Circle()
                .fill(Color.yellow)
                .frame(width: 22, height: 22)
            Image(systemName: "star.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
        }
        .offset(x: 4, y: -4)
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Style selon état

    private var bodyColor: Color {
        switch state {
        case .idle:        return Color(red: 0.45, green: 0.35, blue: 0.90)
        case .curious:     return Color(red: 0.25, green: 0.65, blue: 0.95)
        case .celebrating: return Color(red: 0.25, green: 0.78, blue: 0.42)
        case .sad:         return Color(red: 0.65, green: 0.35, blue: 0.35)
        }
    }

    private var bodyGradient: LinearGradient {
        LinearGradient(
            colors: [bodyColor.opacity(0.85), bodyColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var iconName: String {
        switch state {
        case .idle:        return "mountain.2.fill"
        case .curious:     return "eye.fill"
        case .celebrating: return "star.fill"
        case .sad:         return "cloud.rain.fill"
        }
    }

    // MARK: - Animations

    private func animateForState(_ state: MascoState) {
        switch state {
        case .idle:
            withAnimation(.easeInOut(duration: 0.3)) {
                scale = 1.0
                wiggle = 0
            }
            startIdlePulse()

        case .curious:
            // Petit saut + inclinaison
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                bounce = true
                wiggle = 12
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring()) { self.bounce = false; self.wiggle = 0 }
            }

        case .celebrating:
            // Rebonds répétés
            for i in 0..<4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.18) {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                        self.bounce = true
                        self.scale = 1.15
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        withAnimation(.spring()) {
                            self.bounce = false
                            self.scale = 1.0
                        }
                    }
                }
            }
            // Rotation rapide
            withAnimation(.easeInOut(duration: 0.5)) {
                wiggle = 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.wiggle = 0
            }

        case .sad:
            // Shake horizontal
            let shakeOffsets: [Double] = [0, -8, 8, -6, 6, -4, 4, 0]
            for (i, offset) in shakeOffsets.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.07) {
                    withAnimation(.easeInOut(duration: 0.06)) {
                        self.wiggle = offset
                    }
                }
            }
            withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                scale = 0.88
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.spring()) { self.scale = 1.0; self.wiggle = 0 }
            }
        }
    }

    private func startIdlePulse() {
        // Légère respiration en idle
        Timer.scheduledTimer(withTimeInterval: 2.2, repeats: true) { t in
            guard self.state == .idle else { t.invalidate(); return }
            withAnimation(.easeInOut(duration: 0.6)) { self.scale = 1.06 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeInOut(duration: 0.6)) { self.scale = 1.0 }
            }
        }
    }

    private func startBlinkLoop() {
        blinkTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.08)) { self.eyeBlink = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.08)) { self.eyeBlink = false }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 24) {
        MascoView(state: .idle)
        MascoView(state: .curious)
        MascoView(state: .celebrating)
        MascoView(state: .sad)
    }
    .padding()
}
