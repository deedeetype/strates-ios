import SwiftUI

// MARK: - Vue principale

struct ContentView: View {

    @StateObject private var vm = GameViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    // En-tête
                    EnteteView(vm: vm)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 16)

                    // Barre de score (couches)
                    BarreScoreView(vm: vm)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // Pile de strates
                    PileStratesView(vm: vm)
                        .padding(.horizontal, 16)

                    // Message de feedback
                    FeedbackView(vm: vm)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    // Tentatives précédentes
                    TentativesView(tentatives: vm.tentatives, motReponse: vm.mot.reponse, phase: vm.phase)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    // Zone de saisie + boutons
                    ZoneSaisieView(vm: vm)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.montrerStats = true
                    } label: {
                        Image(systemName: "chart.bar.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $vm.montrerStats) {
                StatsView()
            }
            .sheet(isPresented: $vm.montrerPartage) {
                PartageView(vm: vm)
            }
        }
    }
}

// MARK: - En-tête

struct EnteteView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(spacing: 4) {
            Text("STRATES")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tracking(6)
            Text(dateAujourdhui())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func dateAujourdhui() -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "fr_FR")
        fmt.dateStyle = .long
        return fmt.string(from: Date())
    }
}

// MARK: - Barre de score

struct BarreScoreView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<6) { i in
                let strateNum = 6 - i  // 6 → 1
                let isRevelee = strateNum <= vm.mot.strates[vm.stratesRevelees].id && i <= vm.stratesRevelees
                let isCourante = i == vm.stratesRevelees

                RoundedRectangle(cornerRadius: 4)
                    .fill(couleurDot(isRevelee: isRevelee, isCourante: isCourante))
                    .frame(height: 8)
                    .animation(.easeInOut(duration: 0.3), value: vm.stratesRevelees)
            }
        }
    }

    private func couleurDot(isRevelee: Bool, isCourante: Bool) -> Color {
        if isCourante {
            return .purple
        } else if isRevelee {
            return Color(.systemFill)
        } else {
            return Color(.tertiarySystemFill)
        }
    }
}

// MARK: - Pile de strates

struct PileStratesView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(vm.stratesVisibles.enumerated()), id: \.element.id) { index, strate in
                StrateRowView(
                    strate: strate,
                    estCourante: index == vm.stratesVisibles.count - 1,
                    phase: vm.phase
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))

                if index < vm.stratesVisibles.count - 1 {
                    Divider()
                        .padding(.leading, 120)
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator).opacity(0.4), lineWidth: 0.5)
        )
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: vm.stratesRevelees)
    }
}

// MARK: - Ligne de strate

struct StrateRowView: View {
    let strate: Strate
    let estCourante: Bool
    let phase: PhaseJeu

    var body: some View {
        HStack(spacing: 0) {

            // Indicateur gauche
            Rectangle()
                .fill(estCourante && !estTerminee ? Color.purple : Color.clear)
                .frame(width: 3)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: strate.id == 6 ? 14 : 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0
                    )
                )

            // Étiquette
            VStack(alignment: .leading, spacing: 2) {
                Text("Strate \(strate.id)")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tertiary)
                    .tracking(1)
                Text(strate.type)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 110, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.leading, 12)

            // Séparateur
            Rectangle()
                .fill(Color(.separator).opacity(0.4))
                .frame(width: 0.5)
                .padding(.vertical, 8)

            // Contenu
            Text(strate.contenu)
                .font(strate.estMono
                      ? .system(.body, design: .monospaced).weight(.semibold)
                      : .body)
                .foregroundStyle(strate.estMono ? Color.purple : Color.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 56)
    }

    private var estTerminee: Bool {
        switch phase {
        case .gagne, .perdu: return true
        case .enCours: return false
        }
    }
}

// MARK: - Feedback

struct FeedbackView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        Group {
            if let resultat = vm.dernierResultat {
                switch resultat {
                case .incorrect:
                    Label("Ce n'est pas le bon mot. Continuez !", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))

                case .correct:
                    Label("Bravo ! Mot trouvé !", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))

                case .motVide:
                    EmptyView()
                }
            } else {
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: vm.dernierResultat != nil)
    }
}

// MARK: - Tentatives précédentes

struct TentativesView: View {
    let tentatives: [String]
    let motReponse: String
    let phase: PhaseJeu

    var body: some View {
        if !tentatives.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(tentatives, id: \.self) { t in
                        let correct = t == motReponse
                        Text(t)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(correct ? Color.green.opacity(0.15) : Color.red.opacity(0.1))
                            .foregroundStyle(correct ? Color.green : Color.red)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(correct ? Color.green.opacity(0.4) : Color.red.opacity(0.25), lineWidth: 0.5)
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Zone de saisie

struct ZoneSaisieView: View {
    @ObservedObject var vm: GameViewModel
    @FocusState private var inputFocus: Bool

    private var estTerminee: Bool {
        switch vm.phase {
        case .gagne, .perdu: return true
        case .enCours: return false
        }
    }

    var body: some View {
        VStack(spacing: 10) {

            // Message fin de partie
            if estTerminee {
                FinDePartieView(vm: vm)
            } else {
                // Champ de saisie + Tenter
                HStack(spacing: 8) {
                    TextField("Votre mot...", text: $vm.champSaisie)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .submitLabel(.go)
                        .focused($inputFocus)
                        .onSubmit { vm.tenterMot() }
                        .padding(.horizontal, 14)
                        .frame(height: 46)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator).opacity(0.5), lineWidth: 0.5)
                        )

                    Button(action: { vm.tenterMot() }) {
                        Text("Tenter")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 18)
                            .frame(height: 46)
                            .background(Color.purple)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!vm.peutTenter)
                }

                // Bouton révéler
                if vm.peutRévélerSuivante {
                    Button(action: { vm.révélerStrate() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.down.circle")
                            Text("Révéler la strate suivante")
                                .fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator).opacity(0.5), lineWidth: 0.5)
                        )
                    }
                } else if case .enCours = vm.phase {
                    // Toutes les strates révélées → bouton abandon
                    Button(action: { vm.déclarerDéfaite() }) {
                        Text("Abandonner")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.red.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.red.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
}

// MARK: - Fin de partie

struct FinDePartieView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(spacing: 12) {
            switch vm.phase {
            case .gagne(let strate):
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text("Trouvé à la strate \(strate) !")
                        .fontWeight(.semibold)
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }

            case .perdu:
                VStack(spacing: 4) {
                    Text("Défaite")
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Text("Le mot était : \(vm.mot.reponse)")
                        .font(.headline)
                }

            case .enCours:
                EmptyView()
            }

            Button(action: { vm.montrerPartage = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Partager mon résultat")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.purple)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.top, 4)
    }
}

// MARK: - Aperçu

#Preview {
    ContentView()
}
