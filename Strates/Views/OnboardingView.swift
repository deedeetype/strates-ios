import SwiftUI

// MARK: - Onboarding (affiché une seule fois au premier lancement)

struct OnboardingView: View {
    @State private var pageIndex = 0
    @State private var appeared = false
    var onTerminé: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            emotion: .idle,
            titre: "Bienvenue dans STRATES",
            sousTitre: "Un jeu de déduction lexicale",
            description: "Un mot est enfoui sous 6 couches d'indices. À toi de le trouver en révélant le moins de strates possible.",
            accentColor: Color(red: 0.55, green: 0.40, blue: 0.95)
        ),
        OnboardingPage(
            emotion: .thinking,
            titre: "6 strates, 6 natures",
            sousTitre: "De la plus vague à la plus précise",
            description: "Catégorie → Nb. de lettres → Première/Dernière → Synonyme → Consonnes → Anagramme. Chaque strate révélée coûte des points.",
            accentColor: Color(red: 0.30, green: 0.60, blue: 1.0)
        ),
        OnboardingPage(
            emotion: .scared,
            titre: "3 cœurs par mot",
            sousTitre: "Chaque erreur coûte une vie",
            description: "Tu as 3 tentatives par mot. Si tu perds tes 3 cœurs, le mot est perdu — mais tu peux toujours passer au suivant !",
            accentColor: Color.red
        ),
        OnboardingPage(
            emotion: .celebrating,
            titre: "Score, Combo & Streak",
            sousTitre: "Plus tu es rapide et précis, mieux c'est",
            description: "Trouve sans révéler pour cumuler un combo x3. Joue vite pour un bonus de temps. Reviens chaque jour pour garder ta série 🔥",
            accentColor: Color.orange
        ),
    ]

    var body: some View {
        ZStack {
            // Fond
            backgroundFor(pages[pageIndex].accentColor)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: pageIndex)

            VStack(spacing: 0) {
                // Points de pagination
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(i == pageIndex ? Color.white : Color.white.opacity(0.35))
                            .frame(width: i == pageIndex ? 24 : 8, height: 6)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: pageIndex)
                    }
                }
                .padding(.top, 60)

                Spacer()

                // Personnage
                CharacterView(emotion: pages[pageIndex].emotion, size: 120)
                    .id(pageIndex) // force re-render à chaque page
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

                Spacer().frame(height: 32)

                // Contenu texte
                VStack(spacing: 14) {
                    Text(pages[pageIndex].titre)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(pages[pageIndex].sousTitre)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.70))
                        .multilineTextAlignment(.center)

                    Text(pages[pageIndex].description)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 28)
                .id("text-\(pageIndex)")
                .transition(.opacity)

                // Strates preview sur page 2
                if pageIndex == 1 {
                    stratesPreview
                        .padding(.top, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Cœurs preview sur page 3
                if pageIndex == 2 {
                    coeursPreview
                        .padding(.top, 28)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()

                // Bouton suivant / commencer
                Button(action: avancer) {
                    HStack(spacing: 10) {
                        Text(pageIndex == pages.count - 1 ? "C'est parti !" : "Suivant")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                        Image(systemName: pageIndex == pages.count - 1 ? "arrow.right.circle.fill" : "chevron.right")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundStyle(pages[pageIndex].accentColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 50)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: pageIndex)
        .gesture(
            DragGesture()
                .onEnded { val in
                    if val.translation.width < -50 { avancer() }
                    else if val.translation.width > 50 && pageIndex > 0 {
                        withAnimation { pageIndex -= 1 }
                    }
                }
        )
    }

    // MARK: - Strates mini-preview

    private var stratesPreview: some View {
        VStack(spacing: 5) {
            ForEach([
                ("tag.fill",          "Strate 6", "Catégorie",           Color(red:0.55,green:0.40,blue:0.95)),
                ("number",            "Strate 5", "Nombre de lettres",   Color(red:0.30,green:0.60,blue:1.0)),
                ("shuffle",           "Strate 1", "Anagramme",           Color(red:0.95,green:0.35,blue:0.35)),
            ], id: \.1) { icon, label, type, color in
                HStack(spacing: 10) {
                    ZStack {
                        Circle().fill(Color.white.opacity(0.15)).frame(width: 28, height: 28)
                        Image(systemName: icon).font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                    }
                    Text("\(label) · \(type)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                    Spacer()
                }
                .padding(.horizontal, 28)
            }
        }
    }

    // MARK: - Cœurs preview

    private var coeursPreview: some View {
        HStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { i in
                VStack(spacing: 6) {
                    Image(systemName: i < 2 ? "heart.fill" : "heart")
                        .font(.system(size: 32))
                        .foregroundStyle(i < 2 ? Color.white : Color.white.opacity(0.3))
                    Text(i == 0 ? "Vie 1" : i == 1 ? "Vie 2" : "Perdue")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
    }

    // MARK: - Actions

    private func avancer() {
        SoundManager.shared.hapticLight()
        if pageIndex < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.35)) { pageIndex += 1 }
        } else {
            SoundManager.shared.playCorrect()
            SoundManager.shared.hapticSuccess()
            UserDefaults.standard.set(true, forKey: "onboardingFait")
            onTerminé()
        }
    }

    private func backgroundFor(_ color: Color) -> some View {
        LinearGradient(
            colors: [color.opacity(0.85), color.opacity(0.55).mix(with: .black, by: 0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Modèle de page

struct OnboardingPage {
    let emotion: CharacterEmotion
    let titre: String
    let sousTitre: String
    let description: String
    let accentColor: Color
}

// MARK: - Extension Color mix (iOS 17+)

extension Color {
    func mix(with other: Color, by amount: Double) -> Color {
        // Simple blend via opacity
        return self.opacity(1 - amount)
    }
}

#Preview {
    OnboardingView { }
}
