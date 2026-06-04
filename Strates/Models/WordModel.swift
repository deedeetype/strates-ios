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

// MARK: - Calendrier — 50 mots

struct Calendrier {

    static let mots: [MotDuJour] = [

        // 0
        MotDuJour(id: 0, reponse: "NOSTALGIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un état émotionnel",                              estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "N _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Regret doux pour un passé révolu",               estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "N _ S T _ L G _ _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "STONAIGLE",                                       estMono: true),
        ]),

        // 1
        MotDuJour(id: 1, reponse: "MELANCOLIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un état d'âme",                                   estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "M _ _ _ _ _ _ _ _ E",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Tristesse douce et vague, spleen",               estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "M _ L _ N C _ L _ _",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "ICOLLENAME",                                      estMono: true),
        ]),

        // 2
        MotDuJour(id: 2, reponse: "EUPHORIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une émotion intense",                             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "E _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Sentiment de bonheur intense, exaltation",       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ _ P H _ R _ _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "HOUREIPE",                                        estMono: true),
        ]),

        // 3
        MotDuJour(id: 3, reponse: "ANGOISSE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une émotion négative",                            estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "A _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Peur sourde, inquiétude profonde",               estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ N G _ _ S S _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "SAONIGES",                                        estMono: true),
        ]),

        // 4
        MotDuJour(id: 4, reponse: "EMPATHIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une qualité humaine",                             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "E _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Capacité à ressentir ce que l'autre éprouve",   estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ M P _ T H _ _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "HITEPAME",                                        estMono: true),
        ]),

        // 5
        MotDuJour(id: 5, reponse: "SOLSTICE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène astronomique",                      estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Le jour le plus long ou le plus court",          estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ L S T _ C _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "CTOLSISE",                                        estMono: true),
        ]),

        // 6
        MotDuJour(id: 6, reponse: "CREPUSCULE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un moment de la journée",                        estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ _ _ _ E",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Lumière diffuse après le coucher du soleil",    estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C R _ P _ S C _ L _",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "PELCUCRUSE",                                      estMono: true),
        ]),

        // 7
        MotDuJour(id: 7, reponse: "AVALANCHE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène naturel violent",                   estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "A _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Masse de neige qui dévale une montagne",         estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ V _ L _ N C H _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "CAHNAVELA",                                       estMono: true),
        ]),

        // 8
        MotDuJour(id: 8, reponse: "TORNADE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène météorologique",                    estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "T _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Tourbillon violent, cyclone",                    estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "T _ R N _ D _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "DOTRANE",                                         estMono: true),
        ]),

        // 9
        MotDuJour(id: 9, reponse: "HORIZON", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept géographique ou métaphorique",        estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "H _ _ _ _ _ N",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Ligne où le ciel rejoint la terre ou la mer",   estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "H _ R _ Z _ N",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "ROHINZO",                                         estMono: true),
        ]),

        // 10
        MotDuJour(id: 10, reponse: "EPHEMERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un adjectif lié au temps",                       estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "E _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Fugace, passager, qui dure très peu",            estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ P H _ M _ R _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MREEPEH",                                         estMono: true),
        ]),

        // 11
        MotDuJour(id: 11, reponse: "PARADOXE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept logique",                              estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "P _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Contradiction apparente qui cache une vérité",   estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "P _ R _ D _ X _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "DOXEPARA",                                        estMono: true),
        ]),

        // 12
        MotDuJour(id: 12, reponse: "SYNERGIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept organisationnel",                     estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Effet où le tout dépasse la somme des parties",  estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ N _ R G _ _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "GERYINES",                                        estMono: true),
        ]),

        // 13
        MotDuJour(id: 13, reponse: "ALCHIMIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une pratique ancienne ou une magie",             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "A _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Art de transmuter les métaux, recherche du Grand Œuvre", estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ L C H _ M _ _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MECHILIA",                                        estMono: true),
        ]),

        // 14
        MotDuJour(id: 14, reponse: "PARADIGME", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept scientifique ou philosophique",       estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "P _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Modèle de référence, cadre de pensée dominant",  estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "P _ R _ D _ G M _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MEGADIRPA",                                       estMono: true),
        ]),

        // 15
        MotDuJour(id: 15, reponse: "SYMPHONIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une forme musicale",                              estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Grande composition orchestrale en plusieurs mouvements", estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ M P H _ N _ _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MOPYSHINE",                                       estMono: true),
        ]),

        // 16
        MotDuJour(id: 16, reponse: "CARICATURE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une forme artistique",                            estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ _ _ _ E",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Dessin qui exagère les traits pour se moquer",   estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C _ R _ C _ T _ R _",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "ATURACERICA",                                     estMono: true),
        ]),

        // 17
        MotDuJour(id: 17, reponse: "FRESQUE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une technique picturale",                         estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "F _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Peinture murale exécutée sur un enduit humide",  estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "F R _ S Q _ _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "QUEFRES",                                         estMono: true),
        ]),

        // 18
        MotDuJour(id: 18, reponse: "GROTESQUE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un adjectif artistique ou péjoratif",             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "G _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Bizarre et ridicule, difformement comique",       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "G R _ T _ S Q _ _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TOQUEGRES",                                       estMono: true),
        ]),

        // 19
        MotDuJour(id: 19, reponse: "EQUILIBRE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un état physique ou abstrait",                    estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "E _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Stabilité, juste milieu entre deux forces",      estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ Q _ _ L _ B R _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "BELIQUEER",                                       estMono: true),
        ]),

        // 20
        MotDuJour(id: 20, reponse: "MOLECULE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un terme scientifique",                           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "M _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Plus petite unité d'une substance chimique",     estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "M _ L _ C _ L _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "COULELEM",                                        estMono: true),
        ]),

        // 21
        MotDuJour(id: 21, reponse: "RESONANCE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène acoustique ou émotionnel",          estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "R _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Vibration amplifiée, écho prolongé",             estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "R _ S _ N _ N C _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "CONAENERS",                                       estMono: true),
        ]),

        // 22
        MotDuJour(id: 22, reponse: "CHROMOSOME", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un élément de biologie cellulaire",              estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ _ _ _ E",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Structure qui porte l'ADN dans le noyau",        estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C H R _ M _ S _ M _",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MORCHOSOME",                                      estMono: true),
        ]),

        // 23
        MotDuJour(id: 23, reponse: "TRAJECTOIRE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept de mouvement ou de destin",           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "11 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "T _ _ _ _ _ _ _ _ _ E",                           estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Chemin parcouru, courbe d'un projectile",        estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "T R _ J _ C T _ _ R _",                           estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "JECTRATOIRE",                                     estMono: true),
        ]),

        // 24
        MotDuJour(id: 24, reponse: "FERMENTATION", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un processus biologique ou chimique",            estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "12 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "F _ _ _ _ _ _ _ _ _ _ N",                         estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Transformation du sucre par des levures",        estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "F _ R M _ N T _ T _ _ N",                         estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "ATIONFERMNET",                                    estMono: true),
        ]),

        // 25
        MotDuJour(id: 25, reponse: "VERTIGE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une sensation physique",                          estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "V _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Impression que tout tourne, perte d'équilibre",  estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "V _ R T _ G _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TIGREVE",                                         estMono: true),
        ]),

        // 26
        MotDuJour(id: 26, reponse: "SILENCE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène sonore (ou son absence)",           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "S _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Absence totale de bruit, mutisme",               estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "S _ L _ N C _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "NELSICE",                                         estMono: true),
        ]),

        // 27
        MotDuJour(id: 27, reponse: "COURAGE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une qualité morale",                              estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Bravoure, audace face au danger",                estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C _ R _ G _",                                     estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "GRAOUCE",                                         estMono: true),
        ]),

        // 28
        MotDuJour(id: 28, reponse: "MYSTERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un concept lié à l'inconnu",                     estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "M _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Énigme, secret inexpliqué",                      estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "M _ S T _ R _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TYREEMS",                                         estMono: true),
        ]),

        // 29
        MotDuJour(id: 29, reponse: "LUMIERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène physique",                           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "L _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Clarté, rayonnement, éclat visible",             estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "L _ M _ _ R _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MIERULE",                                         estMono: true),
        ]),

        // 30
        MotDuJour(id: 30, reponse: "BRUMEUX", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un adjectif atmosphérique",                      estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "B _ _ _ _ _ X",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Voilé, vaporeux, qui manque de clarté",          estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "B R _ M _ _ X",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "REMBUXU",                                         estMono: true),
        ]),

        // 31
        MotDuJour(id: 31, reponse: "PATIENCE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une qualité humaine",                             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "P _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Capacité d'attendre sans s'impatienter",         estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "P _ T _ _ N C _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TIACEPEN",                                        estMono: true),
        ]),

        // 32
        MotDuJour(id: 32, reponse: "INTUITION", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une faculté cognitive",                           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "I _ _ _ _ _ _ _ N",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Connaissance immédiate sans raisonnement",       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ N T _ _ T _ _ N",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TIONIUNIT",                                       estMono: true),
        ]),

        // 33
        MotDuJour(id: 33, reponse: "METAMORPHOSE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un processus de transformation",                 estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "12 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "M _ _ _ _ _ _ _ _ _ _ E",                         estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Transformation profonde, comme la chenille en papillon", estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "M _ T _ M _ R P H _ S _",                         estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "MORPHOSEMETA",                                    estMono: true),
        ]),

        // 34
        MotDuJour(id: 34, reponse: "ECLIPSE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un phénomène astronomique",                      estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "7 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "E _ _ _ _ _ E",                                   estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Occultation d'un astre par un autre",            estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ C L _ P S _",                                   estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "PELISCE",                                         estMono: true),
        ]),

        // 35
        MotDuJour(id: 35, reponse: "ORCHESTRE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un ensemble musical",                             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "O _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Grand ensemble de musiciens avec chef",           estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ R C H _ S T R _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TRECORESH",                                       estMono: true),
        ]),

        // 36
        MotDuJour(id: 36, reponse: "LABYRINTHЕ", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un lieu ou une métaphore de l'égarement",        estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "L _ _ _ _ _ _ _ _ E",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Dédale, réseau de chemins où l'on se perd",      estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "L _ B _ R _ N T H _",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "BIRTHNAELY",                                      estMono: true),
        ]),

        // 37
        MotDuJour(id: 37, reponse: "AMBIANCE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une atmosphère ou sensation d'un lieu",          estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "A _ _ _ _ _ _ E",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Atmosphère, climat d'un endroit",                estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ M B _ _ N C _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "CAMBIENA",                                        estMono: true),
        ]),

        // 38
        MotDuJour(id: 38, reponse: "FRONTIERE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Une limite géographique ou abstraite",           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "F _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Limite entre deux territoires, borne",           estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "F R _ N T _ _ R _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "RENTIFREO",                                       estMono: true),
        ]),

        // 39
        MotDuJour(id: 39, reponse: "DETECTIVE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un métier ou un personnage de fiction",          estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "D _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Enquêteur qui résout des crimes",                estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "D _ T _ C T _ V _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TIVEECTED",                                       estMono: true),
        ]),

        // 40
        MotDuJour(id: 40, reponse: "TELESCOPE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un instrument scientifique",                     estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "T _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Instrument d'optique pour observer les astres",  estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "T _ L _ S C _ P _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "SCELETOPE",                                       estMono: true),
        ]),

        // 41
        MotDuJour(id: 41, reponse: "PIROUETTE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un mouvement de danse ou d'esquive",             estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "P _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Tour sur soi-même sur la pointe du pied",        estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "P _ R _ _ T T _",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TOURIPETE",                                       estMono: true),
        ]),

        // 42
        MotDuJour(id: 42, reponse: "ARCHIPEL", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un terme géographique",                           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "8 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "A _ _ _ _ _ _ L",                                 estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Groupe d'îles dispersées dans une mer",          estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "_ R C H _ P _ L",                                 estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "PELARCHI",                                        estMono: true),
        ]),

        // 43
        MotDuJour(id: 43, reponse: "TRAMPOLINE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un équipement sportif",                           estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "T _ _ _ _ _ _ _ _ E",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Toile tendue sur ressorts pour sauter",          estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "T R _ M P _ L _ N _",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "LINPOMETARE",                                     estMono: true),
        ]),

        // 44
        MotDuJour(id: 44, reponse: "BASILIQUE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un bâtiment religieux ou antique",               estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "9 lettres",                                       estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "B _ _ _ _ _ _ _ E",                               estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Grande église chrétienne à nef centrale",        estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "B _ S _ L _ Q _ _",                               estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "LIBASIQUE",                                       estMono: true),
        ]),

        // 45
        MotDuJour(id: 45, reponse: "PHOTOGRAPHIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un art visuel ou une technique",                  estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "12 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "P _ _ _ _ _ _ _ _ _ _ E",                         estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Art de fixer une image par la lumière",          estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "P H _ T _ G R _ P H _ _",                         estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "TOGRAPHOPHIE",                                    estMono: true),
        ]),

        // 46
        MotDuJour(id: 46, reponse: "CATASTROPHE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un événement désastreux",                         estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "11 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "C _ _ _ _ _ _ _ _ _ E",                           estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Désastre, événement brutal et dévastateur",      estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "C _ T _ S T R _ P H _",                           estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "STROPHECATA",                                     estMono: true),
        ]),

        // 47
        MotDuJour(id: 47, reponse: "DIPLOMATIE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un art politique ou de la négociation",          estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "D _ _ _ _ _ _ _ _ E",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Art de négocier entre nations, tact politique",  estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "D _ P L _ M _ T _ _",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "LOATIMEDIP",                                      estMono: true),
        ]),

        // 48
        MotDuJour(id: 48, reponse: "RHINOCEROS", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un animal",                                       estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "10 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "R _ _ _ _ _ _ _ _ S",                             estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Grand mammifère d'Afrique à la peau épaisse et à la corne", estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "R H _ N _ C _ R _ S",                             estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "SINORHEORC",                                      estMono: true),
        ]),

        // 49
        MotDuJour(id: 49, reponse: "KALEIDOSCOPE", strates: [
            Strate(id: 6, type: "Catégorie",           contenu: "Un jouet optique ou une métaphore",              estMono: false),
            Strate(id: 5, type: "Nombre de lettres",   contenu: "12 lettres",                                      estMono: false),
            Strate(id: 4, type: "Première / dernière", contenu: "K _ _ _ _ _ _ _ _ _ _ E",                         estMono: true),
            Strate(id: 3, type: "Synonyme",            contenu: "Tube à miroirs créant des motifs colorés",       estMono: false),
            Strate(id: 2, type: "Consonnes",           contenu: "K _ L _ _ D _ S C _ P _",                         estMono: true),
            Strate(id: 1, type: "Anagramme",           contenu: "SCOPEIKALIDE",                                    estMono: true),
        ]),
    ]

    // MARK: - Index du jour

    static func indexDuJour() -> Int {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        var c = DateComponents(); c.year = 2025; c.month = 1; c.day = 1
        let ref = cal.startOfDay(for: cal.date(from: c) ?? Date())
        let days = cal.dateComponents([.day], from: ref, to: today).day ?? 0
        return ((days % mots.count) + mots.count) % mots.count
    }

    static func motDuJour() -> MotDuJour {
        mots[indexDuJour()]
    }

    static func archiveMots(count: Int = 5) -> [(offset: Int, mot: MotDuJour)] {
        let days = Calendar.current.dateComponents([.day],
            from: Calendar.current.startOfDay(for: { var c = DateComponents(); c.year=2025; c.month=1; c.day=1; return Calendar.current.date(from: c) ?? Date() }()),
            to: Calendar.current.startOfDay(for: Date())).day ?? 0
        return (1...count).map { i in
            let idx = (((days - i) % mots.count) + mots.count) % mots.count
            return (offset: -i, mot: mots[idx])
        }
    }
}
