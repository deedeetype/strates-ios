import SwiftUI
import Combine

// MARK: - Phase de jeu

enum PhaseJeu {
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
    @Published private(set) var stratesRevelees: Int = 0   // 0 = seulement strate 6 visible
    @Published private(set) var tentatives: [String] = []
    @Published private(set) var phase: PhaseJeu = .enCours
    @Published private(set) var dernierResultat: ResultatTentative? = nil
    @Published var champSaisie: String = ""
    @Published var montrerStats: Bool = false
    @Published var montrerPartage: Bool = false

    // Propriétés calculées
    var stratesVisibles: [Strate] {
        // strates[0] = strate 6 (plus vague), strates[5] = strate 1 (plus précise)
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
        // Numéro de strate courante (6 → 1)
        mot.strates[stratesRevelees].id
    }

    var scoreEmoji: String {
        let total = mot.strates.count  // 6
        return (0..<total).map { i in
            switch phase {
            case .gagne(let strate):
                // La strate à laquelle on a trouvé
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
            return "STRATES 🪨 — \(dateStr)\n\(scoreEmoji)\nTrouvé à la strate \(strate) !"
        case .perdu:
            return "STRATES 🪨 — \(dateStr)\n\(scoreEmoji)\nDéfaite..."
        case .enCours:
            return "STRATES 🪨 — \(dateStr)\nPartie en cours..."
        }
    }

    // MARK: - Init

    init() {
        self.mot = Calendrier.motDuJour()
        chargerEtat()
    }

    // MARK: - Actions

    func révélerStrate() {
        guard peutRévélerSuivante else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            stratesRevelees += 1
        }

        // Dernière strate révélée → défaite automatique si aucune tentative correcte
        if stratesRevelees == mot.strates.count - 1 {
            // Le joueur voit la strate 1, il peut encore tenter
        }

        sauvegarderEtat()
        clearResultat()
    }

    func tenterMot() {
        guard case .enCours = phase else { return }
        let mot = champSaisie.trimmingCharacters(in: .whitespaces).uppercased()
        guard !mot.isEmpty else {
            dernierResultat = .motVide
            return
        }

        champSaisie = ""

        if mot == self.mot.reponse {
            tentatives.append(mot)
            let strate = strateActuelle
            phase = .gagne(strate: strate)
            dernierResultat = .correct

            var stats = Statistiques.charger()
            stats.enregistrerVictoire(strate: strate)

            sauvegarderEtat()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.montrerPartage = true
            }
        } else {
            tentatives.append(mot)
            dernierResultat = .incorrect

            // Si c'était la dernière strate et mauvaise tentative → possibilité de défaite
            // (la défaite est déclarée uniquement par le bouton "révéler" quand plus de strates)
            sauvegarderEtat()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.clearResultat()
            }
        }
    }

    func déclarerDéfaite() {
        guard case .enCours = phase else { return }
        phase = .perdu
        dernierResultat = nil

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

    // MARK: - Persistence

    private func chargerEtat() {
        guard let etat = EtatJournalier.charger(), etat.motID == mot.id else { return }

        stratesRevelees = min(etat.stratesRevelees, mot.strates.count - 1)
        tentatives = etat.tentatives

        if etat.estGagne {
            // Retrouver à quelle strate on a gagné
            let strateVictoire = mot.strates[stratesRevelees].id
            phase = .gagne(strate: strateVictoire)
        } else if etat.estPerdu {
            phase = .perdu
        }
    }

    private func sauvegarderEtat() {
        var etat = EtatJournalier(
            dateISO: EtatJournalier.dateISO(),
            motID: mot.id,
            stratesRevelees: stratesRevelees,
            tentatives: tentatives,
            estGagne: false,
            estPerdu: false
        )

        switch phase {
        case .gagne: etat.estGagne = true
        case .perdu: etat.estPerdu = true
        case .enCours: break
        }

        etat.sauvegarder()
    }
}
