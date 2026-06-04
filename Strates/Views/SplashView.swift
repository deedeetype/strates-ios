import SwiftUI

// MARK: - Écran de lancement

struct SplashView: View {
    @State private var phase: SplashPhase = .initial
    @State private var particules: [Particule] = []
    var onTerminé: () -> Void

    // ── Timings ──────────────────────────────────────────────────────────
    // initial → logoAppear (0.3s) → taglineAppear (0.9s)
    // → stratesReveal (1.5s) → ready (2.8s) → fade out (3.2s)

    var body: some View {
        ZStack {
            // Fond dégradé violet profond
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.08, blue: 0.28),
                    Color(red: 0.06, green: 0.04, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Particules de fond
            ForEach(particules) { p in
                Circle()
                    .fill(Color.white.opacity(p.opacite))
                    .frame(width: p.taille, height: p.taille)
                    .position(x: p.x, y: p.y)
                    .blur(radius: p.taille > 3 ? 1 : 0)
            }

            VStack(spacing: 0) {
                Spacer()

                // ── Personnage ──────────────────────────────────────────
                CharacterView(
                    emotion: phase == .ready ? .celebrating : (phase.rawValue >= SplashPhase.stratesReveal.rawValue ? .happy : .idle),
                    size: 130
                )
                .scaleEffect(phase.rawValue >= SplashPhase.logoAppear.rawValue ? 1.0 : 0.4)
                .opacity(phase.rawValue >= SplashPhase.logoAppear.rawValue ? 1.0 : 0)
                .animation(.spring(response: 0.55, dampingFraction: 0.62), value: phase)

                Spacer().frame(height: 32)

                // ── Logo STRATES ────────────────────────────────────────
                VStack(spacing: 8) {
                    // Lettres qui tombent une par une
                    HStack(spacing: 4) {
                        ForEach(Array("STRATES".enumerated()), id: \.offset) { i, lettre in
                            Text(String(lettre))
                                .font(.system(size: 52, weight: .black, design: .rounded))
                                .foregroundStyle(Color.white)
                                .tracking(2)
                                .offset(y: phase.rawValue >= SplashPhase.logoAppear.rawValue ? 0 : -40)
                                .opacity(phase.rawValue >= SplashPhase.logoAppear.rawValue ? 1 : 0)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.65)
                                    .delay(0.04 * Double(i)),
                                    value: phase
                                )
                        }
                    }

                    // Tagline
                    Text("Creuse jusqu'au mot")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.65))
                        .tracking(1.5)
                        .offset(y: phase.rawValue >= SplashPhase.taglineAppear.rawValue ? 0 : 12)
                        .opacity(phase.rawValue >= SplashPhase.taglineAppear.rawValue ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: phase)
                }

                Spacer().frame(height: 48)

                // ── Strates animées ─────────────────────────────────────
                StratesAniméesView(visible: phase.rawValue >= SplashPhase.stratesReveal.rawValue)

                Spacer()

                // ── Bouton jouer ────────────────────────────────────────
                if phase == .ready {
                    Button(action: {
                        SoundManager.shared.playVictory()
                        SoundManager.shared.hapticMedium()
                        withAnimation(.easeIn(duration: 0.3)) {
                            phase = .fadingOut
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            onTerminé()
                        }
                    }) {
                        HStack(spacing: 10) {
                            Text("Jouer")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20))
                        }
                        .foregroundStyle(Color(red: 0.45, green: 0.35, blue: 0.90))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.white.opacity(0.2), radius: 16, x: 0, y: 6)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 52)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .opacity(phase == .fadingOut ? 0 : 1)
        .animation(.easeIn(duration: 0.35), value: phase == .fadingOut)
        .onAppear {
            genererParticules()
            demarrerSequence()
        }
    }

    // MARK: - Séquence d'animation

    private func demarrerSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation { phase = .logoAppear }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation { phase = .taglineAppear }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { phase = .stratesReveal }
            SoundManager.shared.playReveal()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                phase = .ready
            }
            SoundManager.shared.playCorrect()
            SoundManager.shared.hapticSuccess()
        }
    }

    // MARK: - Particules étoilées

    private func genererParticules() {
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        particules = (0..<55).map { _ in
            Particule(
                x: CGFloat.random(in: 0...screenW),
                y: CGFloat.random(in: 0...screenH),
                taille: CGFloat.random(in: 1...5),
                opacite: Double.random(in: 0.05...0.30)
            )
        }
    }
}

// MARK: - Phase enum

enum SplashPhase: Int, Equatable {
    case initial       = 0
    case logoAppear    = 1
    case taglineAppear = 2
    case stratesReveal = 3
    case ready         = 4
    case fadingOut     = 5
}

// MARK: - Strates défilantes

struct StratesAniméesView: View {
    let visible: Bool

    private let infos: [(icone: String, label: String, couleur: Color)] = [
        ("tag.fill",             "Catégorie",           Color(red: 0.55, green: 0.40, blue: 0.95)),
        ("number",               "Nombre de lettres",   Color(red: 0.30, green: 0.60, blue: 1.0)),
        ("textformat.abc",       "Première / dernière", Color(red: 0.20, green: 0.75, blue: 0.85)),
        ("quote.bubble.fill",    "Synonyme",            Color(red: 0.25, green: 0.80, blue: 0.55)),
        ("character",            "Consonnes",           Color(red: 0.95, green: 0.65, blue: 0.15)),
        ("shuffle",              "Anagramme",           Color(red: 0.95, green: 0.35, blue: 0.35)),
    ]

    var body: some View {
        VStack(spacing: 6) {
            ForEach(Array(infos.enumerated()), id: \.offset) { i, info in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(info.couleur.opacity(0.20))
                            .frame(width: 34, height: 34)
                        Image(systemName: info.icone)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(info.couleur)
                    }
                    Text("Strate \(6 - i)  ·  \(info.label)")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.80))
                    Spacer()
                    Image(systemName: "lock\(visible && i < 1 ? ".open" : "").fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white.opacity(visible && i < 1 ? 0.90 : 0.25))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 24)
                .offset(x: visible ? 0 : 60)
                .opacity(visible ? 1 : 0)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.72)
                    .delay(Double(i) * 0.09),
                    value: visible
                )
            }
        }
    }
}

// MARK: - Particule

struct Particule: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let taille: CGFloat
    let opacite: Double
}

#Preview {
    SplashView { }
}
