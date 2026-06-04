import SwiftUI

// MARK: - Vue des cœurs (système de vies)

struct HeartsView: View {
    let heartsRemaining: Int
    let maxHearts: Int = 3
    @State private var shakeHeart: Int = -1
    @State private var lostHeart: Int = -1

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<maxHearts, id: \.self) { i in
                heartIcon(index: i)
            }
        }
    }

    private func heartIcon(index: Int) -> some View {
        let isFull = index < heartsRemaining
        let isLost = index == lostHeart

        return Image(systemName: isFull ? "heart.fill" : "heart")
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(isFull ? Color.red : Color(.tertiaryLabel))
            .scaleEffect(isLost ? 0.01 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isFull)
            .overlay(
                // Particules quand perdu
                Group {
                    if isLost {
                        ForEach(0..<6, id: \.self) { p in
                            Circle()
                                .fill(Color.red)
                                .frame(width: 5, height: 5)
                                .offset(
                                    x: cos(Double(p) / 6.0 * .pi * 2) * 20,
                                    y: sin(Double(p) / 6.0 * .pi * 2) * 20
                                )
                                .opacity(isLost ? 0 : 1)
                        }
                    }
                }
            )
    }

    /// Appeler quand un cœur est perdu pour l'animation
    func animateLoss(at index: Int) {
        lostHeart = index
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            lostHeart = -1
        }
    }
}

// MARK: - Vue overlay "Plus de cœurs"

struct NoHeartsOverlayView: View {
    let onDismiss: () -> Void
    @State private var appear = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Personnage triste
                CharacterView(emotion: .sad, size: 100)

                Text("Plus de vies !")
                    .font(.system(size: 28, weight: .black, design: .rounded))

                Text("Tu as utilisé tes 3 cœurs.\nReviens demain pour rejouer !")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                    Image(systemName: "heart.fill")
                    Image(systemName: "heart.fill")
                }
                .foregroundStyle(Color.red.opacity(0.3))
                .font(.system(size: 28))

                Button(action: onDismiss) {
                    Text("Voir la solution")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.red.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            )
            .padding(.horizontal, 24)
            .scaleEffect(appear ? 1.0 : 0.7)
            .opacity(appear ? 1.0 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                appear = true
            }
        }
    }
}
