import Foundation

// MARK: - État sauvegardé (UserDefaults)

struct EtatJournalier: Codable {
    let dateISO: String
    let motID: Int
    var stratesRevelees: Int
    var tentatives: [String]
    var estGagne: Bool
    var estPerdu: Bool
    var score: Int

    static func dateISO(for date: Date = Date()) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: date)
    }

    static func charger() -> EtatJournalier? {
        guard let data = UserDefaults.standard.data(forKey: "etatJournalier"),
              let etat = try? JSONDecoder().decode(EtatJournalier.self, from: data)
        else { return nil }
        let aujourdHui = dateISO()
        guard etat.dateISO == aujourdHui else { return nil }
        return etat
    }

    func sauvegarder() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "etatJournalier")
        }
    }
}

// MARK: - Statistiques globales

struct Statistiques: Codable {
    var partiesJouees: Int = 0
    var partiesGagnees: Int = 0
    var serieActuelle: Int = 0
    var meilleureSerieActuelle: Int = 0
    var distributionStrates: [Int: Int] = [:]
    var meilleurScore: Int = 0
    var scoreCumulatif: Int = 0

    static func charger() -> Statistiques {
        guard let data = UserDefaults.standard.data(forKey: "statistiques"),
              let stats = try? JSONDecoder().decode(Statistiques.self, from: data)
        else { return Statistiques() }
        return stats
    }

    mutating func enregistrerVictoire(strate: Int, score: Int = 0) {
        partiesJouees += 1
        partiesGagnees += 1
        serieActuelle += 1
        meilleureSerieActuelle = max(meilleureSerieActuelle, serieActuelle)
        distributionStrates[strate, default: 0] += 1
        meilleurScore = max(meilleurScore, score)
        scoreCumulatif += score
        sauvegarder()
    }

    mutating func enregistrerDefaite() {
        partiesJouees += 1
        serieActuelle = 0
        sauvegarder()
    }

    func sauvegarder() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "statistiques")
        }
    }

    var tauxVictoire: Int {
        guard partiesJouees > 0 else { return 0 }
        return Int(Double(partiesGagnees) / Double(partiesJouees) * 100)
    }

    var scoreMoyen: Int {
        guard partiesGagnees > 0 else { return 0 }
        return scoreCumulatif / partiesGagnees
    }
}
