import Foundation

// MARK: - Strate

struct Strate: Identifiable {
    let id: Int          // 6 = plus vague, 1 = plus précise
    let type: String
    let contenu: String
    let estMono: Bool    // affichage monospace (lettres, anagramme)
}

// MARK: - MotDuJour

struct MotDuJour: Identifiable {
    let id: Int
    let reponse: String
    let strates: [Strate]  // ordonnées de 6 → 1

    /// Strate visible à partir de l'index donné (0 = strate 6, 5 = strate 1)
    func strate(at index: Int) -> Strate {
        strates[index]
    }
}

// MARK: - Calendrier de mots

struct Calendrier {

    static let mots: [MotDuJour] = [

        MotDuJour(id: 0, reponse: "NOSTALGIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un état émotionnel",                                    estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                             estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "N _ _ _ _ _ _ _ E",                                    estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Un regret doux, une douleur tendre pour le passé",     estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "N _ S T _ L G _ _",                                    estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "STONAIGLE",                                             estMono: true),
        ]),

        MotDuJour(id: 1, reponse: "BRUMEUX", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un adjectif atmosphérique",                            estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                            estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "B _ _ _ _ _ X",                                        estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Voilé, vaporeux, qui manque de clarté",               estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "B R _ M _ _ X",                                        estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "REMBUXU",                                              estMono: true),
        ]),

        MotDuJour(id: 2, reponse: "SOLSTICE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène astronomique",                            estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                            estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ _ E",                                      estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Le jour le plus long ou le plus court de l'année",    estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ L S T _ C _",                                      estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "CTOLSISE",                                             estMono: true),
        ]),

        MotDuJour(id: 3, reponse: "VERTIGE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une sensation physique",                               estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                            estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "V _ _ _ _ _ E",                                        estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Impression que tout tourne, perte d'équilibre",       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "V _ R T _ G _",                                        estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TIGREVE",                                              estMono: true),
        ]),

        MotDuJour(id: 4, reponse: "EPHEMERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un adjectif lié au temps",                            estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                            estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "E _ _ _ _ _ _ E",                                      estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Qui dure très peu de temps, fugace, passager",        estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ P H _ M _ R _",                                      estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "EREHMEP E",                                            estMono: true),
        ]),

        MotDuJour(id: 5, reponse: "SILENCE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène sonore (ou son absence)",                estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                            estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ E",                                        estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Absence de bruit, calme total, mutisme",              estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ L _ N C _",                                        estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "NELSICE",                                              estMono: true),
        ]),

        MotDuJour(id: 6, reponse: "CRÉPUSCULE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un moment de la journée",                             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                           estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ _ _ _ E",                                  estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "La lumière diffuse entre le coucher du soleil et la nuit", estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C R _ P _ S C _ L _",                                  estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "PELCUCRUSE",                                           estMono: true),
        ]),

    ]

    /// Retourne le mot du jour basé sur la date (stable pour la journée entière)
    static func motDuJour() -> MotDuJour {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let reference = calendar.startOfDay(for: DateComponents(calendar: calendar, year: 2025, month: 1, day: 1).date!)
        let daysSinceReference = calendar.dateComponents([.day], from: reference!, to: today).day ?? 0
        let index = ((daysSinceReference % mots.count) + mots.count) % mots.count
        return mots[index]
    }
}
