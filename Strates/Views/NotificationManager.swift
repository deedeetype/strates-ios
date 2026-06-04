import UserNotifications
import UIKit

// MARK: - Gestionnaire de notifications quotidiennes

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    // Messages variés pour éviter la lassitude
    private let messages: [(titre: String, corps: String)] = [
        ("STRATES 🪨",          "Ton mot du jour t'attend. Sauras-tu le trouver en strate 6 ?"),
        ("Un mot est enfoui… 🔍", "6 indices, 1 mot. Tu as 3 cœurs. Bonne chance !"),
        ("Nouvelle strate 🪨",   "Un mot mystère se cache sous tes doigts. À toi de creuser !"),
        ("STRATES t'attend 🔥",  "Ta série est en jeu. Ne la laisse pas s'arrêter aujourd'hui !"),
        ("Creuse encore 💡",     "Le mot du jour est là. Combien de strates te faudra-t-il ?"),
        ("C'est l'heure 🧠",     "Un nouveau défi lexical t'attend. Seras-tu aussi fort qu'hier ?"),
        ("Mot du jour ✨",       "Ton vocabulaire est prêt ? Le jeu commence maintenant."),
    ]

    // MARK: - Demander la permission

    func demanderPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            DispatchQueue.main.async {
                if granted { self.planifierNotificationsQuotidiennes() }
                completion(granted)
            }
        }
    }

    // MARK: - Planifier 7 notifications (une par jour, 9h00)

    func planifierNotificationsQuotidiennes(heure: Int = 9, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: messages.indices.map { "strates-daily-\($0)" })

        for (i, msg) in messages.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = msg.titre
            content.body  = msg.corps
            content.sound = .default
            content.badge = 1

            var dateComponents = DateComponents()
            dateComponents.hour   = heure
            dateComponents.minute = minute
            dateComponents.weekday = (i % 7) + 1   // lundi → dimanche

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )

            let request = UNNotificationRequest(
                identifier: "strates-daily-\(i)",
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }

    // MARK: - Vérifier le statut

    func statutAutorisation(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { completion(settings.authorizationStatus) }
        }
    }

    // MARK: - Réinitialiser le badge

    func reinitialiserBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
