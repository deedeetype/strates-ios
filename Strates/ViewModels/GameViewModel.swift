import SwiftUI
import Combine

// MARK: - Phases

enum PhaseJeu: Equatable {
    case enCours
    case gagne(strate: Int)
    case perdu
}

enum ResultatTentative { case correct, incorrect, motVide }

// MARK: - Résultat de session (pour un mot terminé)

struct ResultatMot: Identifiable {
    let id = UUID()
    let reponse: String
    let score: Int
    let strate: Int?      // nil si perdu
    let combo: Int
    let gagne: Bool
}

// MARK: - GameViewModel

@MainActor
final class GameViewModel: ObservableObject {

    // ── Mot courant ──────────────────────────────────────────────────────
    @Published private(set) var mot: MotDuJour
    @Published private(set) var stratesRevelees: Int = 0
    @Published private(set) var tentatives: [String] = []
    @Published private(set) var phase: PhaseJeu = .enCours
    @Published private(set) var dernierResultat: ResultatTentative? = nil
    @Published var champSaisie: String = ""

    // ── Navigation ───────────────────────────────────────────────────────
    @Published var montrerStats: Bool = false
    @Published var montrerPartage: Bool = false
    @Published var montrerTransition: Bool = false   // overlay "Mot suivant"

    // ── Cœurs (reset par mot) ────────────────────────────────────────────
    @Published private(set) var coeurs: Int = 3
    @Published private(set) var montrerSansCoeurs: Bool = false
    let maxCoeurs = 3

    // ── Score mot courant ────────────────────────────────────────────────
    @Published private(set) var scoreActuel: Int = 1000
    @Published private(set) var scoreDelta: Int = 0
    @Published private(set) var showDelta: Bool = false
    @Published private(set) var shakeTrigger: Int = 0

    // ── Session (tous les mots joués aujourd'hui) ─────────────────────────
    @Published private(set) var scoreSession: Int = 0
    @Published private(set) var motsJoues: [ResultatMot] = []
    @Published private(set) var motIndexSession: Int = 0   // position dans le calendrier

    // ── Combo ────────────────────────────────────────────────────────────
    @Published private(set) var comboActuel: Int = 1       // x1, x2, x3…
    @Published private(set) var showComboPopup: Bool = false
    @Published private(set) var comboConsecutifSansReveler: Int = 0

    // ── Chrono ───────────────────────────────────────────────────────────
    @Published private(set) var secondesEcoulees: Int = 0
    @Published private(set) var chronoActif: Bool = false
    private var chronoTimer: Timer?

    // ── Personnage ───────────────────────────────────────────────────────
    @Published private(set) var characterEmotion: CharacterEmotion = .idle

    // ── Streak (jours consécutifs) ────────────────────────────────────────
    @Published private(set) var streakJours: Int = 0

    // ── Badges ───────────────────────────────────────────────────────────
    @Published private(set) var nouveauBadge: Badge? = nil

    private let scoreParStrate = [1000, 800, 600, 400, 250, 100]

    // MARK: - Computed

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

    var bonusTemps: Int {
        // Bonus si trouvé rapidement : max 300 pts en moins de 30s
        guard secondesEcoulees > 0 else { return 0 }
        return max(0, 300 - secondesEcoulees * 10)
    }

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
        let mots = motsJoues.count
        let gagnes = motsJoues.filter { $0.gagne }.count
        return """
        STRATES 🪨 — \(d)
        Session : \(gagnes)/\(mots) mots · \(scoreSession) pts
        Meilleur combo : x\(motsJoues.map(\.combo).max() ?? 1)
        🔥 \(streakJours) jours
        """
    }

    // MARK: - Init

    init() {
        self.mot = Calendrier.motDuJour()
        self.motIndexSession = Calendrier.indexDuJour()
        chargerStreak()
        chargerSessionDuJour()
        scoreActuel = scoreParStrate[0]
        demarrerChrono()
    }

    // MARK: - Actions principales

    func révélerStrate() {
        guard peutRévélerSuivante else { return }
        SoundManager.shared.playReveal()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) { stratesRevelees += 1 }

        // Reset combo si on révèle
        if comboConsecutifSansReveler > 0 {
            withAnimation { comboConsecutifSansReveler = 0 }
        }

        let nouveau = scoreParStrate[min(stratesRevelees, scoreParStrate.count - 1)]
        let delta = nouveau - scoreActuel
        withAnimation(.easeOut(duration: 0.4).delay(0.15)) { scoreActuel = nouveau }
        afficherDelta(delta)

        withAnimation { characterEmotion = .thinking }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            withAnimation { self?.characterEmotion = .idle }
        }
        clearResultat()
    }

    func tenterMot() {
        guard case .enCours = phase else { return }
        let input = champSaisie.trimmingCharacters(in: .whitespaces).uppercased()
        guard !input.isEmpty else { dernierResultat = .motVide; return }
        champSaisie = ""

        if input == mot.reponse {
            arrêterChrono()
            tentatives.append(input)
            let strate = strateActuelle

            // ── Calcul score final avec combo + temps ──
            let bonusT = bonusTemps
            let scoreBase = scoreActuel
            let scoreAvecCombo = Int(Double(scoreBase) * Double(comboActuel))
            let scoreFinal = scoreAvecCombo + bonusT

            withAnimation { scoreActuel = scoreFinal }
            if bonusT > 0 { afficherDelta(bonusT) }

            phase = .gagne(strate: strate)
            dernierResultat = .correct
            SoundManager.shared.playVictory()

            // ── Combo ──
            comboConsecutifSansReveler += 1
            let nouveauCombo = min(3, 1 + comboConsecutifSansReveler / 2)
            if nouveauCombo > comboActuel {
                comboActuel = nouveauCombo
                withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) { showComboPopup = true }
                SoundManager.shared.playStreak()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    withAnimation { self?.showComboPopup = false }
                }
            }

            // ── Enregistrer résultat ──
            let resultat = ResultatMot(reponse: mot.reponse, score: scoreFinal, strate: strate, combo: comboActuel, gagne: true)
            motsJoues.append(resultat)
            scoreSession += scoreFinal
            sauvegarderSession()

            // ── Streak ──
            incrementerStreak()

            // ── Stats ──
            var stats = Statistiques.charger()
            stats.enregistrerVictoire(strate: strate, score: scoreFinal)

            // ── Badges ──
            verifierBadges(stats: stats, strate: strate, score: scoreFinal)

            withAnimation(.spring(response: 0.3, dampingFraction: 0.45)) {
                characterEmotion = .celebrating
            }

            // Pas de sheet automatique — on affiche le bouton "Mot suivant"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    self?.montrerTransition = true
                }
            }

        } else {
            tentatives.append(input)
            dernierResultat = .incorrect
            shakeTrigger += 1
            SoundManager.shared.playHeartLost()

            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                coeurs = max(0, coeurs - 1)
                characterEmotion = .scared
            }
            afficherDelta(-100)

            if coeurs == 0 {
                arrêterChrono()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                    withAnimation { self?.characterEmotion = .sad }
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        self?.montrerSansCoeurs = true
                    }
                    self?.phase = .perdu
                    let resultat = ResultatMot(reponse: self?.mot.reponse ?? "", score: 0, strate: nil, combo: self?.comboActuel ?? 1, gagne: false)
                    self?.motsJoues.append(resultat)
                    self?.sauvegarderSession()
                    self?.resetCombo()
                    var stats = Statistiques.charger()
                    stats.enregistrerDefaite()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { [weak self] in
                    withAnimation { self?.characterEmotion = .idle }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
                    self?.clearResultat()
                }
            }
        }
    }

    func abandonner() {
        guard case .enCours = phase else { return }
        arrêterChrono()
        phase = .perdu
        SoundManager.shared.playDefeat()
        withAnimation { characterEmotion = .sad }

        let resultat = ResultatMot(reponse: mot.reponse, score: 0, strate: nil, combo: comboActuel, gagne: false)
        motsJoues.append(resultat)
        sauvegarderSession()
        resetCombo()

        var stats = Statistiques.charger()
        stats.enregistrerDefaite()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            montrerSansCoeurs = false
            montrerTransition = true
        }
    }

    /// Passer au mot suivant (appelé depuis l'overlay de transition)
    func motSuivant() {
        withAnimation(.easeOut(duration: 0.3)) { montrerTransition = false; montrerSansCoeurs = false }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self else { return }

            // Avancer dans le calendrier
            self.motIndexSession += 1
            let mots = Calendrier.mots
            let nouvelIndex = self.motIndexSession % mots.count
            self.mot = mots[nouvelIndex]

            // Reset état du mot
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                self.stratesRevelees = 0
                self.tentatives = []
                self.phase = .enCours
                self.dernierResultat = nil
                self.champSaisie = ""
                self.coeurs = self.maxCoeurs          // reset cœurs
                self.scoreActuel = self.scoreParStrate[0]
                self.secondesEcoulees = 0
                self.characterEmotion = .happy
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                withAnimation { self?.characterEmotion = .idle }
                self?.demarrerChrono()
            }
        }
    }

    func fermerSansCoeurs() {
        montrerSansCoeurs = false
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { montrerTransition = true }
    }

    func tapPersonnage() {
        withAnimation { characterEmotion = .winking }
        SoundManager.shared.hapticLight()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            withAnimation { self?.characterEmotion = .idle }
        }
    }

    func clearResultat() { dernierResultat = nil }

    // MARK: - Chrono

    private func demarrerChrono() {
        chronoActif = true
        secondesEcoulees = 0
        chronoTimer?.invalidate()
        chronoTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self, self.chronoActif else { return }
            self.secondesEcoulees += 1
        }
    }

    private func arrêterChrono() {
        chronoActif = false
        chronoTimer?.invalidate()
    }

    // MARK: - Combo

    private func resetCombo() {
        comboConsecutifSansReveler = 0
        comboActuel = 1
    }

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

    // MARK: - Badges

    private func verifierBadges(stats: Statistiques, strate: Int, score: Int) {
        var badge: Badge? = nil

        if score >= 1000 && strate == 6 { badge = .parfait }
        else if stats.partiesGagnees == 1 { badge = .premierMot }
        else if stats.serieActuelle >= 7 { badge = .semaine }
        else if strate == 6 { badge = .strateSix }
        else if comboActuel >= 3 { badge = .combo3 }

        if let b = badge {
            nouveauBadge = b
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                withAnimation { self?.nouveauBadge = nil }
            }
        }
    }

    // MARK: - Persistence session

    private func chargerStreak() {
        streakJours = Statistiques.charger().serieActuelle
    }

    private func chargerSessionDuJour() {
        // Session reset chaque jour
        let dateKey = "sessionDate"
        let scoreKey = "sessionScore"
        let indexKey = "sessionMotIndex"
        let today = EtatJournalier.dateISO()

        if UserDefaults.standard.string(forKey: dateKey) == today {
            scoreSession = UserDefaults.standard.integer(forKey: scoreKey)
            motIndexSession = UserDefaults.standard.integer(forKey: indexKey)
        } else {
            scoreSession = 0
            motIndexSession = Calendrier.indexDuJour()
            UserDefaults.standard.set(today, forKey: dateKey)
            UserDefaults.standard.set(0, forKey: scoreKey)
            UserDefaults.standard.set(motIndexSession, forKey: indexKey)
        }

        // Charger le bon mot
        mot = Calendrier.mots[motIndexSession % Calendrier.mots.count]
    }

    private func sauvegarderSession() {
        UserDefaults.standard.set(scoreSession, forKey: "sessionScore")
        UserDefaults.standard.set(motIndexSession, forKey: "sessionMotIndex")
    }
}

// MARK: - Badge

enum Badge: String, CaseIterable {
    case premierMot  = "Première victoire ! 🎉"
    case strateSix   = "Trouvé dès la strate 6 ! 🧠"
    case parfait     = "Score parfait ! ⭐"
    case semaine     = "7 jours de suite ! 🔥"
    case combo3      = "Combo x3 ! ⚡"

    var icone: String {
        switch self {
        case .premierMot: return "star.circle.fill"
        case .strateSix:  return "brain.head.profile"
        case .parfait:    return "crown.fill"
        case .semaine:    return "flame.fill"
        case .combo3:     return "bolt.circle.fill"
        }
    }

    var couleur: Color {
        switch self {
        case .premierMot: return .purple
        case .strateSix:  return .blue
        case .parfait:    return .yellow
        case .semaine:    return .orange
        case .combo3:     return .green
        }
    }
}
