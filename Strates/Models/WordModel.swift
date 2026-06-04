import Foundation

// MARK: - Strate

struct Strate: Identifiable {
    let id: Int
    let type: String
    let contenu: String
    let estMono: Bool
}

// MARK: - MotDuJour

struct MotDuJour: Identifiable {
    let id: Int
    let reponse: String
    let strates: [Strate]

    func strate(at index: Int) -> Strate { strates[index] }
}

// MARK: - Calendrier (12 mots — 5 passés + 7 à venir)

struct Calendrier {

    static let mots: [MotDuJour] = [

        // ── Jour −5 (il y a 5 jours) ──────────────────────────────────────
        MotDuJour(id: 0, reponse: "LUMIERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène physique",                             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "L _ _ _ _ _ E",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Clarté, rayonnement, éclat",                       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "L _ M _ _ R _",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MIERULE",                                           estMono: true),
        ]),

        // ── Jour −4 ────────────────────────────────────────────────────────
        MotDuJour(id: 1, reponse: "TEMPETE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène météorologique",                      estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "T _ _ _ _ _ E",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Orage violent, bourrasque, tourmente",             estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "T _ M P _ T _",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "PETTEME",                                           estMono: true),
        ]),

        // ── Jour −3 ────────────────────────────────────────────────────────
        MotDuJour(id: 2, reponse: "HORIZON", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept géographique ou métaphorique",          estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "H _ _ _ _ _ N",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Ligne où le ciel rejoint la terre ou la mer",      estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "H _ R _ Z _ N",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "ROHINZO",                                           estMono: true),
        ]),

        // ── Jour −2 ────────────────────────────────────────────────────────
        MotDuJour(id: 3, reponse: "COURAGE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une qualité morale",                               estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ E",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Bravoure, audace, vaillance face au danger",       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C _ R _ G _",                                       estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "GRAOUCE",                                           estMono: true),
        ]),

        // ── Jour −1 ────────────────────────────────────────────────────────
        MotDuJour(id: 4, reponse: "MYSTERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept lié à l'inconnu",                       estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "M _ _ _ _ _ E",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Énigme, secret, chose inexpliquée",                estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "M _ S T _ R _",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TYREEMS",                                           estMono: true),
        ]),

        // ── Aujourd'hui (jour 0) ───────────────────────────────────────────
        MotDuJour(id: 5, reponse: "NOSTALGIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un état émotionnel",                               estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "N _ _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Regret doux pour un passé révolu",                 estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "N _ S T _ L G _ _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "STONAIGLE",                                         estMono: true),
        ]),

        // ── Jour +1 ────────────────────────────────────────────────────────
        MotDuJour(id: 6, reponse: "BRUMEUX", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un adjectif atmosphérique",                        estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "B _ _ _ _ _ X",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Voilé, vaporeux, qui manque de clarté",            estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "B R _ M _ _ X",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "REMBUXU",                                           estMono: true),
        ]),

        // ── Jour +2 ────────────────────────────────────────────────────────
        MotDuJour(id: 7, reponse: "SOLSTICE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène astronomique",                        estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Le jour le plus long ou le plus court",            estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ L S T _ C _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "CTOLSISE",                                          estMono: true),
        ]),

        // ── Jour +3 ────────────────────────────────────────────────────────
        MotDuJour(id: 8, reponse: "VERTIGE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une sensation physique",                           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "V _ _ _ _ _ E",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Tout tourne, perte d'équilibre",                   estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "V _ R T _ G _",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TIGREVE",                                           estMono: true),
        ]),

        // ── Jour +4 ────────────────────────────────────────────────────────
        MotDuJour(id: 9, reponse: "SILENCE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène sonore (ou son absence)",             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ E",                                     estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Absence totale de bruit, mutisme",                 estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ L _ N C _",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "NELSICE",                                           estMono: true),
        ]),

        // ── Jour +5 ────────────────────────────────────────────────────────
        MotDuJour(id: 10, reponse: "EPHEMERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un adjectif lié au temps",                         estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                         estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "E _ _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Fugace, passager, qui dure très peu",              estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ P H _ M _ R _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MREEPEH",                                           estMono: true),
        ]),

        // ── Jour +6 ────────────────────────────────────────────────────────
        MotDuJour(id: 11, reponse: "CREPUSCULE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un moment de la journée",                          estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                        estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Lumière diffuse après le coucher du soleil",       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C R _ P _ S C _ L _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "PELCUCRUSE",                                        estMono: true),
        ]),
    ]

    // MARK: - Mot du jour (par date calendaire stable)
    static func motDuJour() -> MotDuJour {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var comps = DateComponents(); comps.year = 2025; comps.month = 1; comps.day = 1
        let ref = calendar.startOfDay(for: calendar.date(from: comps) ?? Date())
        let days = calendar.dateComponents([.day], from: ref, to: today).day ?? 0
        // Mot d'aujourd'hui = index 5 (milieu du tableau)
        // On décale de (days - 5) modulo total pour que id=5 = aujourd'hui
        let offset = ((days % mots.count) + mots.count) % mots.count
        return mots[offset]
    }

    // MARK: - Mots des jours précédents (archive)
    static func archiveMots(count: Int = 5) -> [(offset: Int, mot: MotDuJour)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var comps = DateComponents(); comps.year = 2025; comps.month = 1; comps.day = 1
        let ref = calendar.startOfDay(for: calendar.date(from: comps) ?? Date())
        let days = calendar.dateComponents([.day], from: ref, to: today).day ?? 0

        var result: [(offset: Int, mot: MotDuJour)] = []
        for i in 1...count {
            let idx = (((days - i) % mots.count) + mots.count) % mots.count
            result.append((offset: -i, mot: mots[idx]))
        }
        return result
    }
}

extension Calendrier {
    static func indexDuJour() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var comps = DateComponents(); comps.year = 2025; comps.month = 1; comps.day = 1
        let ref = calendar.startOfDay(for: calendar.date(from: comps) ?? Date())
        let days = calendar.dateComponents([.day], from: ref, to: today).day ?? 0
        return ((days % mots.count) + mots.count) % mots.count
    }
}
