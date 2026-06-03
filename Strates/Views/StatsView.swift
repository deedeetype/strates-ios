import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    private var stats: Statistiques { Statistiques.charger() }

    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark
                    ? Color(red: 0.08, green: 0.07, blue: 0.14)
                    : Color(red: 0.96, green: 0.95, blue: 1.0))
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Grille de stats
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            StatCard(titre: "Parties", valeur: "\(stats.partiesJouees)", icone: "gamecontroller.fill", couleur: .purple)
                            StatCard(titre: "Victoires", valeur: "\(stats.tauxVictoire)%", icone: "trophy.fill", couleur: .yellow)
                            StatCard(titre: "Série actuelle", valeur: "\(stats.serieActuelle)", icone: "flame.fill", couleur: .orange)
                            StatCard(titre: "Meilleur score", valeur: "\(stats.meilleurScore)", icone: "star.fill", couleur: Color(red: 0.45, green: 0.35, blue: 0.90))
                        }
                        .padding(.horizontal, 16)

                        // Distribution par strate
                        if stats.partiesGagnees > 0 {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundStyle(.purple)
                                    Text("Victoires par strate")
                                        .font(.headline)
                                }
                                .padding(.horizontal, 20)

                                VStack(spacing: 10) {
                                    ForEach((1...6).reversed(), id: \.self) { strate in
                                        let count = stats.distributionStrates[strate] ?? 0
                                        let ratio = stats.partiesGagnees > 0 ? Double(count) / Double(stats.partiesGagnees) : 0

                                        HStack(spacing: 12) {
                                            // Icône strate
                                            ZStack {
                                                Circle()
                                                    .fill(couleurStrate(strate).opacity(0.15))
                                                    .frame(width: 30, height: 30)
                                                Text("\(strate)")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundStyle(couleurStrate(strate))
                                            }

                                            // Barre
                                            GeometryReader { geo in
                                                ZStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .fill(Color(.tertiarySystemFill))
                                                        .frame(height: 20)
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .fill(couleurStrate(strate))
                                                        .frame(width: geo.size.width * ratio, height: 20)
                                                        .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(Double(6 - strate) * 0.08), value: ratio)
                                                }
                                            }
                                            .frame(height: 20)

                                            Text("\(count)")
                                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                                .foregroundStyle(.secondary)
                                                .frame(width: 20, alignment: .trailing)
                                                .monospacedDigit()
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(colorScheme == .dark
                                          ? Color(red: 0.14, green: 0.12, blue: 0.22)
                                          : Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.purple.opacity(0.15), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                        } else {
                            VStack(spacing: 12) {
                                MascoView(state: .curious)
                                Text("Jouez votre première partie\npour voir vos stats !")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(40)
                        }

                        Spacer(minLength: 32)
                    }
                    .padding(.top, 16)
                }
            }
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
        case 6: return Color(red: 0.55, green: 0.40, blue: 0.95)
        case 5: return Color(red: 0.30, green: 0.60, blue: 1.0)
        case 4: return Color(red: 0.20, green: 0.75, blue: 0.85)
        case 3: return Color(red: 0.25, green: 0.80, blue: 0.55)
        case 2: return Color(red: 0.95, green: 0.65, blue: 0.15)
        case 1: return Color(red: 0.95, green: 0.35, blue: 0.35)
        default: return .purple
        }
    }
}

struct StatCard: View {
    let titre: String
    let valeur: String
    let icone: String
    let couleur: Color
    @Environment(\.colorScheme) private var colorScheme
    @State private var appear = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(couleur.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: icone)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(couleur)
                }
                Spacer()
            }

            Text(valeur)
                .font(.system(size: 30, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(Color.primary)
                .scaleEffect(appear ? 1.0 : 0.7)
                .opacity(appear ? 1.0 : 0)

            Text(titre)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark
                      ? Color(red: 0.14, green: 0.12, blue: 0.22)
                      : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(couleur.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: couleur.opacity(0.08), radius: 8, x: 0, y: 3)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) {
                appear = true
            }
        }
    }
}

#Preview {
    StatsView()
}
