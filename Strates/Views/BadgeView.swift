import SwiftUI

// MARK: - Toast badge (apparaît en haut, disparaît après 3s)

struct BadgeToastView: View {
    let badge: Badge
    @State private var appear = false

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(badge.couleur.opacity(0.15)).frame(width: 40, height: 40)
                Image(systemName: badge.icone)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(badge.couleur)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Badge débloqué !")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(badge.rawValue)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(badge.couleur.opacity(0.3), lineWidth: 1))
        .shadow(color: badge.couleur.opacity(0.2), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 16)
        .offset(y: appear ? 0 : -100)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { appear = true }
        }
    }
}

// MARK: - Popup Combo

struct ComboPopupView: View {
    let combo: Int
    @State private var scale: CGFloat = 0.5

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 32, weight: .black))
                .foregroundStyle(.orange)
            Text("COMBO x\(combo)")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(LinearGradient(
                    colors: [.orange, .yellow],
                    startPoint: .leading, endPoint: .trailing))
            Text("Mots trouvés sans révéler !")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.orange.opacity(0.4), lineWidth: 1.5))
        .shadow(color: .orange.opacity(0.25), radius: 16, x: 0, y: 6)
        .scaleEffect(scale)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.45)) { scale = 1.15 }
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6).delay(0.15)) { scale = 1.0 }
        }
    }
}

// MARK: - Indicateur chrono + bonus temps

struct ChronoView: View {
    let secondes: Int
    let bonusPotentiel: Int

    private var couleur: Color {
        if secondes < 15 { return .green }
        if secondes < 30 { return .orange }
        return .red
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "timer")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(couleur)
            Text(formatTemps(secondes))
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundStyle(couleur)
            if bonusPotentiel > 0 {
                Text("+\(bonusPotentiel)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
    }

    private func formatTemps(_ s: Int) -> String {
        String(format: "%d:%02d", s / 60, s % 60)
    }
}
