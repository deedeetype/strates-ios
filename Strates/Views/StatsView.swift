import SwiftUI

// MARK: - Vue statistiques

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    private var stats: Statistiques { Statistiques.charger() }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Chiffres clés
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        StatCard(titre: "Parties jouées", valeur: "\(stats.partiesJouees)", icone: "gamecontroller.fill", couleur: .purple)
                        StatCard(titre: "Taux de victoire", valeur: "\(stats.tauxVictoire)%", icone: "percent", couleur: .green)
                        StatCard(titre: "Série actuelle", valeur: "\(stats.serieActuelle)", icone: "flame.fill", couleur: .orange)
                        StatCard(titre: "Meilleure série", valeur: "\(stats.meilleureSerieActuelle)", icone: "trophy.fill", couleur: .yellow)
                    }
                    .padding(.horizontal, 16)

                    // Distribution des victoires par strate
                    if stats.partiesGagnees > 0 {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Victoires par strate")
                                .font(.headline)
                                .padding(.horizontal, 20)

                            VStack(spacing: 8) {
                                ForEach((1...6).reversed(), id: \.self) { strate in
                                    let count = stats.distributionStrates[strate] ?? 0
                                    let ratio = stats.partiesGagnees > 0 ? Double(count) / Double(stats.partiesGagnees) : 0

                                    HStack(spacing: 10) {
                                        Text("Strate \(strate)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 60, alignment: .leading)

                                        GeometryReader { geo in
                                            HStack(spacing: 0) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(couleurStrate(strate))
                                                    .frame(width: geo.size.width * ratio)

                                                Spacer(minLength: 0)
                                            }
                                        }
                                        .frame(height: 22)
                                        .background(Color(.tertiarySystemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 4))

                                        Text("\(count)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 24, alignment: .trailing)
                                            .monospacedDigit()
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                    } else {
                        Text("Aucune victoire pour l'instant.\nJouez pour voir vos statistiques !")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(40)
                    }

                    Spacer(minLength: 32)
                }
                .padding(.top, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Statistiques")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func couleurStrate(_ strate: Int) -> Color {
        switch strate {
        case 6: return .purple.opacity(0.4)
        case 5: return .purple.opacity(0.55)
        case 4: return .purple.opacity(0.7)
        case 3: return .purple.opacity(0.8)
        case 2: return .purple.opacity(0.9)
        case 1: return .purple
        default: return .purple
        }
    }
}

// MARK: - Carte stat

struct StatCard: View {
    let titre: String
    let valeur: String
    let icone: String
    let couleur: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icone)
                    .foregroundStyle(couleur)
                    .font(.system(size: 16))
                Spacer()
            }

            Text(valeur)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .monospacedDigit()

            Text(titre)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator).opacity(0.4), lineWidth: 0.5)
        )
    }
}

#Preview {
    StatsView()
}
