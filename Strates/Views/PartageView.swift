import SwiftUI

struct PartageView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var starsAnimate = false

    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark
                    ? Color(red: 0.08, green: 0.07, blue: 0.14)
                    : Color(red: 0.96, green: 0.95, blue: 1.0))
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    // Mascotte en mode résultat
                    MascoView(state: vm.mascoState)
                        .scaleEffect(1.3)

                    // Résultat
                    VStack(spacing: 10) {
                        switch vm.phase {
                        case .gagne(let strate):
                            Text("Trouvé à la strate \(strate) !")
                                .font(.system(size: 22, weight: .bold, design: .rounded))

                            Text("\(vm.scoreActuel) pts")
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 0.45, green: 0.35, blue: 0.90),
                                                 Color(red: 0.65, green: 0.45, blue: 1.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                        case .perdu:
                            Text("Défaite")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                            Text("Le mot était : \(vm.mot.reponse)")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))

                        case .enCours:
                            EmptyView()
                        }
                    }
                    .multilineTextAlignment(.center)

                    // Émojis résultat
                    VStack(spacing: 10) {
                        Text(vm.scoreEmoji)
                            .font(.system(size: 30))
                            .tracking(6)
                        Text("🟫 Strate révélée  •  ⬜ Non révélée")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark
                                  ? Color(red: 0.14, green: 0.12, blue: 0.22)
                                  : Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Stats rapides
                    StatsRapidesView()
                        .padding(.horizontal, 24)

                    Spacer()

                    // Bouton partage
                    ShareLink(item: vm.textePartage) {
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .bold))
                            Text("Partager")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.55, green: 0.40, blue: 0.95),
                                         Color(red: 0.40, green: 0.25, blue: 0.85)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.purple.opacity(0.35), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 24)
                    }

                    Button("Fermer") { dismiss() }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("STRATES")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.black)
                        .tracking(4)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct StatsRapidesView: View {
    private var stats: Statistiques { Statistiques.charger() }

    var body: some View {
        HStack(spacing: 0) {
            StatItem(valeur: "\(stats.partiesJouees)", label: "Parties")
            Divider().frame(height: 36)
            StatItem(valeur: "\(stats.tauxVictoire)%", label: "Victoires")
            Divider().frame(height: 36)
            StatItem(valeur: "\(stats.serieActuelle)", label: "Série")
            Divider().frame(height: 36)
            StatItem(valeur: "\(stats.meilleurScore)", label: "Record")
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.4), lineWidth: 0.5))
    }
}

struct StatItem: View {
    let valeur: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(valeur)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .monospacedDigit()
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

#Preview {
    PartageView(vm: GameViewModel())
}
