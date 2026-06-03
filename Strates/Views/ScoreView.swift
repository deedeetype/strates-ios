import SwiftUI

// MARK: - Barre de score animée en temps réel

struct ScoreView: View {
    @ObservedObject var vm: GameViewModel
    @State private var animatedScore: Int = 1000
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 6) {
            // Score numérique + delta
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(animatedScore)")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(scoreColor)
                    .contentTransition(.numericText(countsDown: vm.scoreDelta < 0))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: animatedScore)

                Text("pts")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)

                Spacer()

                // Delta flottant
                if vm.showDelta {
                    Text(vm.scoreDelta >= 0 ? "+\(vm.scoreDelta)" : "\(vm.scoreDelta)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(vm.scoreDelta >= 0 ? Color.green : Color.red)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                }
            }

            // Barre de progression
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Fond
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 10)

                    // Remplissage animé
                    RoundedRectangle(cornerRadius: 6)
                        .fill(progressGradient)
                        .frame(width: geo.size.width * vm.scoreProgression, height: 10)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: vm.scoreProgression)

                    // Brillance
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: geo.size.width * vm.scoreProgression, height: 5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: vm.scoreProgression)
                }
            }
            .frame(height: 10)

            // Labels strates
            HStack {
                Text("Strate 6")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                Spacer()
                Text("Strate 1")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .onChange(of: vm.scoreActuel) { _, newVal in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                animatedScore = newVal
                pulseScale = 1.15
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) { pulseScale = 1.0 }
            }
        }
        .onAppear { animatedScore = vm.scoreActuel }
    }

    private var scoreColor: Color {
        let ratio = vm.scoreProgression
        if ratio > 0.65 { return Color(red: 0.25, green: 0.78, blue: 0.42) }
        if ratio > 0.35 { return Color(red: 0.95, green: 0.65, blue: 0.15) }
        return Color(red: 0.90, green: 0.30, blue: 0.25)
    }

    private var progressGradient: LinearGradient {
        let ratio = vm.scoreProgression
        let colors: [Color]
        if ratio > 0.65 {
            colors = [Color(red: 0.25, green: 0.85, blue: 0.50), Color(red: 0.15, green: 0.70, blue: 0.38)]
        } else if ratio > 0.35 {
            colors = [Color(red: 1.0, green: 0.78, blue: 0.20), Color(red: 0.95, green: 0.55, blue: 0.10)]
        } else {
            colors = [Color(red: 1.0, green: 0.45, blue: 0.35), Color(red: 0.85, green: 0.20, blue: 0.15)]
        }
        return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
    }
}
