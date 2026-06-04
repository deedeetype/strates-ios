import SwiftUI
import Combine

// MARK: - Phases

enum PhaseJeu: Equatable {
    case enCours
    case gagne(strate: Int)
    case perdu
}

enum ResultatTentative { case correct, incorrect, motVide }

// MARK: - GameViewModel

@MainActor
final class GameViewModel: ObservableObject {

    // Jeu
    @Published private(set) var mot: MotDuJour
    @Published private(set) var stratesRevelees: Int = 0
    @Published private(set) var tentatives: [String] = []
    @Published private(set) var phase: PhaseJeu = .enCours
    @Published private(set) var dernierResultat: ResultatTentative? = nil
    @Published var champSaisie: String = ""
    @Published var montrerStats: Bool = false
    @Published var montrerPartage: Bool = false
    @Published var montrerArchive: Bool = false

    // Cœurs
    @Published private(set) var coeurs: Int = 3
    @Published private(set) var montrerSansCoeurs: Bool = false
    let maxCoeurs = 3

    // Score
    @Published private(set) var scoreActuel: Int = 1000
    @Published private(set) var scoreDelta: Int = 0
    @Published private(set) var showDelta: Bool = false
    @Published private(set) var shakeTrigger: Int = 0

    // Personnage
    @Published private(set) var characterEmotion: CharacterEmotion = .idle

    // Streak
    @Published private(set) var streakJours: Int = 0

    private let scoreParStrate = [1000, 800, 600, 400, 250, 100]

    var stratesVisibles: [Strate] { Array(mot.strates.prefix(stratesRevelees + 1)) }

    var peutRévélerSuivante: Bool {
        guard case .enCours = phase else { return false }
        return stratesRevelees < mot.strates.count - 1
    }

    var peutTenter: Bool {
        guard case .enCours = phase else { return false }
        return !champSaisie.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var strateActuelle: Int { mot.strates[stratesRevelees].id }
    var scoreMax: Int { scoreParStrate[0] }
    var scoreProgression: Double { Double(scoreActuel) / Double(scoreMax) }

    var scoreEmoji: String {
        (0..<mot.strates.count).map { i in
            switch phase {
            case .gagne(let s): return mot.strates[i].id > s ? "🟫" : "⬜"
            case .perdu, .enCours: return "⬛"
            }
        }.joined()
    }

    var textePartage: String {
        let d = EtatJournalier.dateISO()
        switch phase {
        case .gagne(let s): return "STRATES 🪨 — \(d)\n\(scoreEmoji)\nStrate \(s) · \(scoreActuel) pts 🔥\(streakJours)"
        case .perdu:        return "STRATES 🪨 — \(d)\n\(scoreEmoji)\nDéfaite..."
        case .enCours:      return "STRATES 🪨 — \(d)\nPartie en cours..."
        }
    }

    init() {
        self.mot = Calendrier.motDuJour()
        self.scoreActuel = scoreParStrate[0]
        chargerStreakEtCoeurs()
        chargerEtat()
    }

    // MARK: - Actions

    func révélerStrate() {
        guard peutRévélerSuivante else { return }
        SoundManager.shared.playReveal()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) { stratesRevelees += 1 }

        let nouveau = scoreParStrate[min(stratesRevelees, scoreParStrate.count - 1)]
        let delta = nouveau - scoreActuel
        withAnimation(.easeOut(duration: 0.4).delay(0.15)) { scoreActuel = nouveau }
        afficherDelta(delta)

        withAnimation { characterEmotion = .thinking }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            withAnimation { self?.characterEmotion = .idle }
        }
        sauvegarderEtat(); clearResultat()
    }

    func tenterMot() {
        guard case .enCours = phase else { return }
        let input = champSaisie.trimmingCharacters(in: .whitespaces).uppercased()
        guard !input.isEmpty else { dernierResultat = .motVide; return }
        champSaisie = ""

        if input == mot.reponse {
            tentatives.append(input)
            let strate = strateActuelle
            phase = .gagne(strate: strate)
            dernierResultat = .correct
            SoundManager.shared.playVictory()

            // Streak
            incrementerStreak()

            withAnimation(.spring(response: 0.3, dampingFraction: 0.45)) {
                characterEmotion = .celebrating
            }

            var stats = Statistiques.charger()
            stats.enregistrerVictoire(strate: strate, score: scoreActuel)
            sauvegarderEtat()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                self?.montrerPartage = true
            }

        } else {
            tentatives.append(input)
            dernierResultat = .incorrect
            shakeTrigger += 1

            // Perdre un cœur
            SoundManager.shared.playHeartLost()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                coeurs = max(0, coeurs - 1)
                characterEmotion = .scared
            }
            afficherDelta(-100)

            if coeurs == 0 {
                // Plus de cœurs = défaite
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                    withAnimation { self?.characterEmotion = .sad }
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        self?.montrerSansCoeurs = true
                    }
                    self?.phase = .perdu
                    var stats = Statistiques.charger()
                    stats.enregistrerDefaite()
                    self?.sauvegarderEtat()
                    self?.resetStreakSiNecessaire()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { [weak self] in
                    withAnimation { self?.characterEmotion = .idle }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
                    self?.clearResultat()
                }
            }
            sauvegarderEtat()
        }
    }

    func déclarerDéfaite() {
        guard case .enCours = phase else { return }
        phase = .perdu
        SoundManager.shared.playDefeat()
        withAnimation { characterEmotion = .sad }
        var stats = Statistiques.charger()
        stats.enregistrerDefaite()
        resetStreakSiNecessaire()
        sauvegarderEtat()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.montrerPartage = true
        }
    }

    func fermerSansCoeurs() {
        montrerSansCoeurs = false
        montrerPartage = true
    }

    func clearResultat() { dernierResultat = nil }

    // MARK: - Score delta

    private func afficherDelta(_ delta: Int) {
        scoreDelta = delta
        withAnimation(.easeIn(duration: 0.15)) { showDelta = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
            withAnimation(.easeOut(duration: 0.3)) { self?.showDelta = false }
        }
    }

    // MARK: - Streak

    private func incrementerStreak() {
        var stats = Statistiques.charger()
        streakJours = stats.serieActuelle + 1
        if streakJours >= 3 { SoundManager.shared.playStreak() }
    }

    private func resetStreakSiNecessaire() {
        streakJours = 0
    }

    // MARK: - Persistence

    private func chargerStreakEtCoeurs() {
        let stats = Statistiques.charger()
        streakJours = stats.serieActuelle

        // Cœurs rechargés chaque nouveau jour
        if let dateStr = UserDefaults.standard.string(forKey: "coeurDate") {
            if dateStr == EtatJournalier.dateISO() {
                coeurs = UserDefaults.standard.integer(forKey: "coeurs")
                if coeurs == 0 { coeurs = maxCoeurs } // sécurité
            } else {
                // Nouveau jour → recharge
                coeurs = maxCoeurs
                sauvegarderCoeurs()
            }
        } else {
            coeurs = maxCoeurs
            sauvegarderCoeurs()
        }
    }

    private func sauvegarderCoeurs() {
        UserDefaults.standard.set(coeurs, forKey: "coeurs")
        UserDefaults.standard.set(EtatJournalier.dateISO(), forKey: "coeurDate")
    }

    private func chargerEtat() {
        guard let etat = EtatJournalier.charger(), etat.motID == mot.id else { return }
        stratesRevelees = min(etat.stratesRevelees, mot.strates.count - 1)
        tentatives = etat.tentatives
        scoreActuel = etat.score

        if etat.estGagne {
            phase = .gagne(strate: mot.strates[stratesRevelees].id)
            characterEmotion = .celebrating
        } else if etat.estPerdu {
            phase = .perdu
            characterEmotion = .sad
        }
    }

    private func sauvegarderEtat() {
        sauvegarderCoeurs()
        var etat = EtatJournalier(
            dateISO: EtatJournalier.dateISO(), motID: mot.id,
            stratesRevelees: stratesRevelees, tentatives: tentatives,
            estGagne: false, estPerdu: false, score: scoreActuel
        )
        switch phase {
        case .gagne: etat.estGagne = true
        case .perdu: etat.estPerdu = true
        case .enCours: break
        }
        etat.sauvegarder()
    }
}
