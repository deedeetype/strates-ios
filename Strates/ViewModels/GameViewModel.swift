import SwiftUI
import Combine

// MARK: - Phase de jeu

enum PhaseJeu: Equatable {
    case enCours
    case gagne(strate: Int)
    case perdu
}

// MARK: - Résultat d'une tentative

enum ResultatTentative {
    case correct
    case incorrect
    case motVide
}

// MARK: - GameViewModel

@MainActor
final class GameViewModel: ObservableObject {

    // État publié
    @Published private(set) var mot: MotDuJour
    @Published private(set) var stratesRevelees: Int = 0
    @Published private(set) var tentatives: [String] = []
    @Published private(set) var phase: PhaseJeu = .enCours
    @Published private(set) var dernierResultat: ResultatTentative? = nil
    @Published var champSaisie: String = ""
    @Published var montrerStats: Bool = false
    @Published var montrerPartage: Bool = false

    // Score en temps réel
    @Published private(set) var scoreActuel: Int = 1000
    @Published private(set) var scoreDelta: Int = 0       // +/- affiché en animation
    @Published private(set) var showDelta: Bool = false
    @Published private(set) var shakeTrigger: Int = 0    // incrémenté pour déclencher shake

    // Mascotte
    @Published private(set) var mascoState: MascoState = .idle

    // Score par strate disponible (decremental)
    private let scoreParStrate: [Int] = [1000, 800, 600, 400, 250, 100]
    private var penaliteTentative: Int = 50

    var stratesVisibles: [Strate] {
        Array(mot.strates.prefix(stratesRevelees + 1))
    }

    var peutRévélerSuivante: Bool {
        guard case .enCours = phase else { return false }
        return stratesRevelees < mot.strates.count - 1
    }

    var peutTenter: Bool {
        guard case .enCours = phase else { return false }
        return !champSaisie.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var strateActuelle: Int {
        mot.strates[stratesRevelees].id
    }

    var scoreMax: Int { scoreParStrate[0] }

    var scoreProgression: Double {
        Double(scoreActuel) / Double(scoreMax)
    }

    var scoreEmoji: String {
        let total = mot.strates.count
        return (0..<total).map { i in
            switch phase {
            case .gagne(let strate):
                let strateNum = mot.strates[i].id
                return strateNum > strate ? "🟫" : "⬜"
            case .perdu, .enCours:
                return "⬛"
            }
        }.joined()
    }

    var textePartage: String {
        let dateStr = EtatJournalier.dateISO()
        switch phase {
        case .gagne(let strate):
            return "STRATES 🪨 — \(dateStr)\n\(scoreEmoji)\nTrouvé à la strate \(strate) ! Score : \(scoreActuel) pts"
        case .perdu:
            return "STRATES 🪨 — \(dateStr)\n\(scoreEmoji)\nDéfaite..."
        case .enCours:
            return "STRATES 🪨 — \(dateStr)\nPartie en cours..."
        }
    }

    init() {
        self.mot = Calendrier.motDuJour()
        self.scoreActuel = scoreParStrate[0]
        chargerEtat()
    }

    // MARK: - Actions

    func révélerStrate() {
        guard peutRévélerSuivante else { return }

        SoundManager.shared.playReveal()
        SoundManager.shared.hapticLight()

        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            stratesRevelees += 1
        }

        // Pénalité score pour révélation
        let ancienScore = scoreActuel
        let nouveauScore = scoreParStrate[min(stratesRevelees, scoreParStrate.count - 1)]
        let delta = nouveauScore - ancienScore

        withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
            scoreActuel = nouveauScore
        }
        afficherDelta(delta)

        // Mascotte réagit
        withAnimation { mascoState = .curious }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            withAnimation { self?.mascoState = .idle }
        }

        sauvegarderEtat()
        clearResultat()
    }

    func tenterMot() {
        guard case .enCours = phase else { return }
        let input = champSaisie.trimmingCharacters(in: .whitespaces).uppercased()
        guard !input.isEmpty else {
            dernierResultat = .motVide
            return
        }

        champSaisie = ""

        if input == mot.reponse {
            tentatives.append(input)
            let strate = strateActuelle
            phase = .gagne(strate: strate)
            dernierResultat = .correct

            SoundManager.shared.playVictory()
            SoundManager.shared.hapticSuccess()

            // Mascotte victoire
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                mascoState = .celebrating
            }

            var stats = Statistiques.charger()
            stats.enregistrerVictoire(strate: strate)
            sauvegarderEtat()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                self?.montrerPartage = true
            }
        } else {
            tentatives.append(input)
            dernierResultat = .incorrect

            SoundManager.shared.playIncorrect()
            SoundManager.shared.hapticError()

            // Shake
            shakeTrigger += 1

            // Pénalité tentative
            let delta = -penaliteTentative
            let nouveauScore = max(0, scoreActuel + delta)
            withAnimation(.easeOut(duration: 0.4)) {
                scoreActuel = nouveauScore
            }
            afficherDelta(delta)

            // Mascotte triste
            withAnimation { mascoState = .sad }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                withAnimation { self?.mascoState = .idle }
            }

            sauvegarderEtat()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.clearResultat()
            }
        }
    }

    func déclarerDéfaite() {
        guard case .enCours = phase else { return }
        phase = .perdu
        dernierResultat = nil

        SoundManager.shared.playDefeat()
        SoundManager.shared.hapticError()

        withAnimation { mascoState = .sad }

        var stats = Statistiques.charger()
        stats.enregistrerDefaite()
        sauvegarderEtat()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.montrerPartage = true
        }
    }

    func clearResultat() {
        dernierResultat = nil
    }

    // MARK: - Score delta

    private func afficherDelta(_ delta: Int) {
        scoreDelta = delta
        withAnimation(.easeIn(duration: 0.15)) {
            showDelta = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
            withAnimation(.easeOut(duration: 0.3)) {
                self?.showDelta = false
            }
        }
    }

    // MARK: - Persistence

    private func chargerEtat() {
        guard let etat = EtatJournalier.charger(), etat.motID == mot.id else { return }
        stratesRevelees = min(etat.stratesRevelees, mot.strates.count - 1)
        tentatives = etat.tentatives
        scoreActuel = etat.score

        if etat.estGagne {
            let strateVictoire = mot.strates[stratesRevelees].id
            phase = .gagne(strate: strateVictoire)
            mascoState = .celebrating
        } else if etat.estPerdu {
            phase = .perdu
            mascoState = .sad
        }
    }

    private func sauvegarderEtat() {
        var etat = EtatJournalier(
            dateISO: EtatJournalier.dateISO(),
            motID: mot.id,
            stratesRevelees: stratesRevelees,
            tentatives: tentatives,
            estGagne: false,
            estPerdu: false,
            score: scoreActuel
        )
        switch phase {
        case .gagne: etat.estGagne = true
        case .perdu: etat.estPerdu = true
        case .enCours: break
        }
        etat.sauvegarder()
    }
}

// MARK: - État mascotte

enum MascoState: Equatable {
    case idle
    case curious
    case celebrating
    case sad
}
