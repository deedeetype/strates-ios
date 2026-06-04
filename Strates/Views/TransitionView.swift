import SwiftUI

// MARK: - Overlay de transition entre deux mots

struct TransitionView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var appear = false
    @State private var scoreAnimate = false

    var body: some View {
        ZStack {
            // Fond semi-transparent
            Color.black.opacity(0.55).ignoresSafeArea()
                .onTapGesture { } // bloquer tap-through

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 24) {

                    // ── Personnage ──
                    CharacterView(emotion: vm.phase == .perdu ? .sad : .celebrating, size: 90)
                        .scaleEffect(appear ? 1.0 : 0.5)
                        .opacity(appear ? 1 : 0)

                    // ── Résultat du mot ──
                    VStack(spacing: 6) {
                        switch vm.phase {
                        case .gagne(let strate):
                            Text("Trouvé à la strate \(strate) !")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(.secondary)

                            // Score avec combo
                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Text("\(vm.scoreActuel)")
                                    .font(.system(size: 44, weight: .black, design: .rounded))
                                    .foregroundStyle(LinearGradient(
                                        colors: [Color(red:0.45,green:0.35,blue:0.90), Color(red:0.65,green:0.45,blue:1.0)],
                                        startPoint: .leading, endPoint: .trailing))
                                Text("pts").font(.system(size: 18, weight: .bold)).foregroundStyle(.secondary)
                            }
                            .scaleEffect(scoreAnimate ? 1.0 : 0.7)

                            // Détail bonus
                            HStack(spacing: 12) {
                                if vm.comboActuel > 1 {
                                    badgePill("x\(vm.comboActuel) COMBO", color: .orange, icon: "bolt.fill")
                                }
                                if vm.bonusTemps > 0 {
                                    badgePill("+\(vm.bonusTemps) rapide", color: .green, icon: "clock.fill")
                                }
                                badgePill("\(vm.secondesEcoulees)s", color: .blue, icon: "timer")
                            }

                        case .perdu:
                            Text("Le mot était :").font(.subheadline).foregroundStyle(.secondary)
                            Text(vm.mot.reponse)
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundStyle(.primary)

                        case .enCours:
                            EmptyView()
                        }
                    }
                    .multilineTextAlignment(.center)

                    // ── Score session ──
                    sessionScoreView

                    // ── Boutons ──
                    VStack(spacing: 10) {
                        // Mot suivant
                        Button(action: {
                            SoundManager.shared.hapticMedium()
                            vm.motSuivant()
                        }) {
                            HStack(spacing: 10) {
                                Text("Mot suivant")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 18))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity).frame(height: 54)
                            .background(LinearGradient(
                                colors: [Color(red:0.55,green:0.40,blue:0.95), Color(red:0.40,green:0.25,blue:0.85)],
                                startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.purple.opacity(0.4), radius: 10, x: 0, y: 5)
                        }

                        // Partager + Terminer
                        HStack(spacing: 10) {
                            Button(action: { vm.montrerPartage = true }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Partager")
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity).frame(height: 44)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .padding(28)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(colorScheme == .dark
                              ? Color(red: 0.12, green: 0.10, blue: 0.20)
                              : Color.white)
                        .shadow(color: .black.opacity(0.25), radius: 30, x: 0, y: -10)
                )
                .offset(y: appear ? 0 : 300)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) { appear = true }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) { scoreAnimate = true }
        }
    }

    // ── Score session running total ──
    private var sessionScoreView: some View {
        HStack(spacing: 0) {
            sessionStat(titre: "Session", valeur: "\(vm.scoreSession) pts", icone: "sum", couleur: .purple)
            Divider().frame(height: 32)
            sessionStat(titre: "Mots", valeur: "\(vm.motsJoues.count)", icone: "text.word.spacing", couleur: .blue)
            Divider().frame(height: 32)
            sessionStat(titre: "Combo", valeur: "x\(vm.comboActuel)", icone: "bolt.fill", couleur: .orange)
            Divider().frame(height: 32)
            sessionStat(titre: "Streak", valeur: "🔥\(vm.streakJours)", icone: "flame.fill", couleur: .red)
        }
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func sessionStat(titre: String, valeur: String, icone: String, couleur: Color) -> some View {
        VStack(spacing: 2) {
            Text(valeur)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(couleur)
            Text(titre)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private func badgePill(_ label: String, color: Color, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 10, weight: .bold))
            Text(label).font(.system(size: 11, weight: .bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(color.opacity(0.3), lineWidth: 1))
    }
}
