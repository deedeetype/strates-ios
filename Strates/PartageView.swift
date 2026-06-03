import SwiftUI

// MARK: - Vue de partage

struct PartageView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {

                Spacer()

                // Titre résultat
                VStack(spacing: 8) {
                    switch vm.phase {
                    case .gagne(let strate):
                        Image(systemName: "star.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.yellow)
                        Text("Trouvé à la strate \(strate) !")
                            .font(.title2)
                            .fontWeight(.bold)
                    case .perdu:
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.secondary)
                        Text("Défaite")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        Text("Le mot était : \(vm.mot.reponse)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    case .enCours:
                        EmptyView()
                    }
                }

                // Émojis résultat
                VStack(spacing: 12) {
                    Text(vm.scoreEmoji)
                        .font(.system(size: 32))
                        .tracking(4)

                    Text(legendeEmoji)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)

                // Stats rapides
                StatsRapidesView()
                    .padding(.horizontal, 24)

                Spacer()

                // Bouton partager natif
                ShareLink(item: vm.textePartage) {
                    HStack(spacing: 10) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Partager")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.purple)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 24)
                }

                Button("Fermer") { dismiss() }
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("STRATES")
                        .font(.system(.headline, design: .rounded))
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

    private var legendeEmoji: String {
        "🟫 Strate révélée  •  ⬜ Non révélée  •  ⬛ Défaite"
    }
}

// MARK: - Stats rapides

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
            StatItem(valeur: "\(stats.meilleureSerieActuelle)", label: "Record")
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator).opacity(0.4), lineWidth: 0.5)
        )
    }
}

struct StatItem: View {
    let valeur: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(valeur)
                .font(.title3)
                .fontWeight(.bold)
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
