import SwiftUI

// MARK: - Shake modifier

struct ShakeModifier: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * shakesPerUnit), y: 0))
    }
}

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var vm = GameViewModel()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {

                        // ── Header : personnage + titre + cœurs ──
                        HeaderView(vm: vm)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 12)

                        // ── Score ──
                        ScoreView(vm: vm)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                        // ── Strates ──
                        PileStratesView(vm: vm)
                            .padding(.horizontal, 16)
                            .modifier(ShakeModifier(animatableData: CGFloat(vm.shakeTrigger)))
                            .animation(vm.shakeTrigger > 0 ? .linear(duration: 0.4) : .default,
                                       value: vm.shakeTrigger)

                        // ── Feedback ──
                        FeedbackView(vm: vm)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)

                        // ── Tentatives ──
                        TentativesView(tentatives: vm.tentatives, motReponse: vm.mot.reponse, phase: vm.phase)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                        // ── Saisie ──
                        ZoneSaisieView(vm: vm)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 40)
                    }
                }

                // ── Overlay sans cœurs ──
                if vm.montrerSansCoeurs {
                    NoHeartsOverlayView { vm.fermerSansCoeurs() }
                        .transition(.opacity)
                        .zIndex(10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { vm.montrerArchive = true } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    streakBadge
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { vm.montrerStats = true } label: {
                        Image(systemName: "chart.bar.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $vm.montrerStats)   { StatsView() }
            .sheet(isPresented: $vm.montrerPartage) { PartageView(vm: vm) }
            .sheet(isPresented: $vm.montrerArchive) { ArchiveView() }
        }
    }

    // MARK: - Streak badge

    private var streakBadge: some View {
        Group {
            if vm.streakJours > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("\(vm.streakJours)")
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
                .font(.system(size: 14))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.12))
                .clipShape(Capsule())
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(red: 0.08, green: 0.07, blue: 0.14), Color(red: 0.11, green: 0.09, blue: 0.18)]
                : [Color(red: 0.96, green: 0.95, blue: 1.0),  Color(red: 0.92, green: 0.90, blue: 0.98)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
}

// MARK: - Header

struct HeaderView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        HStack(spacing: 14) {
            // Personnage interactif
            CharacterView(emotion: vm.characterEmotion, size: 100)
                .onTapGesture {
                    SoundManager.shared.hapticLight()
                    vm.tapPersonnage()
                }

            VStack(alignment: .leading, spacing: 6) {
                Text("STRATES")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .tracking(5)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(red: 0.45, green: 0.35, blue: 0.90),
                                     Color(red: 0.65, green: 0.45, blue: 1.0)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )

                // Cœurs
                HStack(spacing: 6) {
                    ForEach(0..<vm.maxCoeurs, id: \.self) { i in
                        Image(systemName: i < vm.coeurs ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(i < vm.coeurs ? Color.red : Color(.tertiaryLabel))
                            .scaleEffect(i < vm.coeurs ? 1.0 : 0.85)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: vm.coeurs)
                    }
                    Text("\(vm.coeurs) vie\(vm.coeurs > 1 ? "s" : "")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Date
                Text(dateAujourdhui())
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
        }
    }

    private func dateAujourdhui() -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "fr_FR")
        fmt.dateStyle = .medium
        return fmt.string(from: Date())
    }
}

// MARK: - Pile de strates

struct PileStratesView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.colorScheme) private var colorScheme

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
                    Divider().padding(.leading, 120).opacity(0.5)
                }
            }
        }
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(LinearGradient(colors: [Color.purple.opacity(0.3), Color.purple.opacity(0.1)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
        .shadow(color: Color.purple.opacity(colorScheme == .dark ? 0.15 : 0.08), radius: 12, x: 0, y: 4)
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: vm.stratesRevelees)
    }

    private var cardBackground: Color {
        colorScheme == .dark ? Color(red: 0.14, green: 0.12, blue: 0.22) : Color.white
    }
}

// MARK: - Ligne strate

struct StrateRowView: View {
    let strate: Strate
    let estCourante: Bool
    let phase: PhaseJeu
    @State private var appeared = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(estCourante && !estTerminee ? accentColor : Color.clear)
                .frame(width: 4).padding(.vertical, 6).padding(.leading, 4)

            ZStack {
                Circle().fill(accentColor.opacity(0.15)).frame(width: 32, height: 32)
                Image(systemName: iconeStrate(strate.id)).font(.system(size: 14, weight: .semibold)).foregroundStyle(accentColor)
            }
            .padding(.horizontal, 10)

            VStack(alignment: .leading, spacing: 1) {
                Text("Strate \(strate.id)").font(.system(size: 10, weight: .bold)).foregroundStyle(.tertiary).tracking(0.8)
                Text(strate.type).font(.system(size: 12, weight: .semibold)).foregroundStyle(.secondary)
            }
            .frame(width: 90, alignment: .leading)

            Rectangle().fill(Color(.separator).opacity(0.35)).frame(width: 0.5).padding(.vertical, 10)

            Text(strate.contenu)
                .font(strate.estMono ? .system(.callout, design: .monospaced).weight(.bold) : .callout)
                .foregroundStyle(strate.estMono ? accentColor : Color.primary)
                .padding(.horizontal, 14).padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(appeared ? 1 : 0).offset(x: appeared ? 0 : 10)
        }
        .frame(minHeight: 62)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.05)) { appeared = true }
        }
    }

    private var accentColor: Color {
        [6: Color(red: 0.55, green: 0.40, blue: 0.95),
         5: Color(red: 0.30, green: 0.60, blue: 1.0),
         4: Color(red: 0.20, green: 0.75, blue: 0.85),
         3: Color(red: 0.25, green: 0.80, blue: 0.55),
         2: Color(red: 0.95, green: 0.65, blue: 0.15),
         1: Color(red: 0.95, green: 0.35, blue: 0.35)][strate.id] ?? .purple
    }

    private func iconeStrate(_ id: Int) -> String {
        ["tag.fill","shuffle","character","quote.bubble.fill","textformat.abc","number","tag.fill"][max(0,min(6,id))]
    }

    private var estTerminee: Bool { if case .enCours = phase { return false }; return true }
}

// MARK: - Feedback

struct FeedbackView: View {
    @ObservedObject var vm: GameViewModel
    var body: some View {
        Group {
            if let r = vm.dernierResultat {
                switch r {
                case .incorrect:
                    banner("Pas tout à fait… il te reste \(vm.coeurs) ❤️", icon: "xmark.circle.fill", color: .red)
                case .correct:
                    banner("Bravo ! Mot trouvé ! 🎉", icon: "checkmark.circle.fill", color: .green)
                case .motVide: EmptyView()
                }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: vm.dernierResultat != nil)
    }

    private func banner(_ text: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 16, weight: .semibold))
            Text(text).font(.subheadline).fontWeight(.semibold)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
        .frame(maxWidth: .infinity, alignment: .leading)
        .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)))
    }
}

// MARK: - Tentatives

struct TentativesView: View {
    let tentatives: [String]; let motReponse: String; let phase: PhaseJeu
    var body: some View {
        if !tentatives.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Array(tentatives.enumerated()), id: \.offset) { _, t in
                        let ok = t == motReponse
                        HStack(spacing: 4) {
                            Image(systemName: ok ? "checkmark" : "xmark").font(.system(size: 9, weight: .bold))
                            Text(t).font(.system(size: 12, weight: .semibold, design: .rounded))
                        }
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(ok ? Color.green.opacity(0.15) : Color.red.opacity(0.1))
                        .foregroundStyle(ok ? Color.green : Color.red)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(ok ? Color.green.opacity(0.35) : Color.red.opacity(0.25), lineWidth: 1))
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: tentatives.count)
            }
        }
    }
}

// MARK: - Zone saisie

struct ZoneSaisieView: View {
    @ObservedObject var vm: GameViewModel
    @FocusState private var inputFocus: Bool
    @Environment(\.colorScheme) private var colorScheme

    private var estTerminee: Bool { if case .enCours = vm.phase { return false }; return true }

    var body: some View {
        VStack(spacing: 12) {
            if estTerminee {
                FinDePartieView(vm: vm)
            } else {
                HStack(spacing: 10) {
                    TextField("Votre mot...", text: $vm.champSaisie)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .submitLabel(.go)
                        .focused($inputFocus)
                        .onSubmit { vm.tenterMot() }
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 16).frame(height: 52)
                        .background(colorScheme == .dark ? Color(red: 0.14, green: 0.12, blue: 0.22) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.purple.opacity(0.35), lineWidth: 1))

                    Button(action: { SoundManager.shared.hapticMedium(); vm.tenterMot() }) {
                        Text("Tenter").font(.system(size: 16, weight: .bold, design: .rounded))
                            .padding(.horizontal, 22).frame(height: 52)
                            .background(vm.peutTenter
                                ? LinearGradient(colors: [Color(red:0.55,green:0.40,blue:0.95), Color(red:0.40,green:0.25,blue:0.85)], startPoint:.topLeading, endPoint:.bottomTrailing)
                                : LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)], startPoint:.topLeading, endPoint:.bottomTrailing))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: vm.peutTenter ? Color.purple.opacity(0.35) : .clear, radius: 8, x: 0, y: 4)
                    }
                    .disabled(!vm.peutTenter)
                    .scaleEffect(vm.peutTenter ? 1.0 : 0.97)
                    .animation(.spring(response: 0.3), value: vm.peutTenter)
                }

                if vm.peutRévélerSuivante {
                    Button(action: { SoundManager.shared.hapticLight(); vm.révélerStrate() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill").font(.system(size: 16))
                            Text("Révéler la strate suivante").fontWeight(.semibold)
                            Spacer()
                            Text("−pts").font(.caption).fontWeight(.bold)
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(Color.orange.opacity(0.15)).foregroundStyle(.orange).clipShape(Capsule())
                        }
                        .font(.subheadline).foregroundStyle(.secondary).padding(.horizontal, 16).frame(height: 50)
                        .background(colorScheme == .dark ? Color(red:0.14,green:0.12,blue:0.22) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.4), lineWidth: 1))
                    }
                } else if case .enCours = vm.phase {
                    Button(action: { vm.déclarerDéfaite() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "flag.fill")
                            Text("Abandonner").fontWeight(.semibold)
                        }
                        .font(.subheadline).foregroundStyle(.red.opacity(0.8))
                        .frame(maxWidth: .infinity).frame(height: 48)
                        .background(Color.red.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
        }
    }
}

// MARK: - Fin de partie

struct FinDePartieView: View {
    @ObservedObject var vm: GameViewModel
    @State private var starsVisible = false

    var body: some View {
        VStack(spacing: 16) {
            switch vm.phase {
            case .gagne(let strate):
                HStack(spacing: 4) {
                    ForEach(0..<starsCount(strate), id: \.self) { i in
                        Image(systemName: "star.fill").font(.system(size: 28)).foregroundStyle(.yellow)
                            .scaleEffect(starsVisible ? 1.0 : 0.01)
                            .animation(.spring(response: 0.4, dampingFraction: 0.45).delay(Double(i)*0.12), value: starsVisible)
                    }
                    ForEach(starsCount(strate)..<3, id: \.self) { _ in
                        Image(systemName: "star").font(.system(size: 28)).foregroundStyle(Color(.tertiaryLabel))
                    }
                }
                VStack(spacing: 4) {
                    Text("Trouvé à la strate \(strate) !").font(.system(size: 20, weight: .bold, design: .rounded))
                    Text("\(vm.scoreActuel) points")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [Color(red:0.45,green:0.35,blue:0.90), Color(red:0.65,green:0.45,blue:1.0)], startPoint:.leading, endPoint:.trailing))
                }

            case .perdu:
                VStack(spacing: 8) {
                    Image(systemName: "cloud.rain.fill").font(.system(size: 40)).foregroundStyle(.secondary)
                    Text("Défaite").font(.system(size: 20, weight: .bold, design: .rounded)).foregroundStyle(.secondary)
                    Text("Le mot était : \(vm.mot.reponse)").font(.system(size: 18, weight: .semibold, design: .rounded))
                }

            case .enCours: EmptyView()
            }

            Button(action: { vm.montrerPartage = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "square.and.arrow.up").font(.system(size: 16, weight: .bold))
                    Text("Partager mon résultat").font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .frame(maxWidth: .infinity).frame(height: 54)
                .background(LinearGradient(colors: [Color(red:0.55,green:0.40,blue:0.95), Color(red:0.40,green:0.25,blue:0.85)], startPoint:.topLeading, endPoint:.bottomTrailing))
                .foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.purple.opacity(0.4), radius: 10, x: 0, y: 5)
            }
        }
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { starsVisible = true } }
    }

    private func starsCount(_ strate: Int) -> Int {
        strate >= 5 ? 3 : strate >= 3 ? 2 : 1
    }
}

#Preview { ContentView() }
