import AVFoundation
import AudioToolbox
import UIKit

// MARK: - Gestionnaire de sons (AVFoundation, zero asset requis)

final class SoundManager {
    static let shared = SoundManager()
    private var players: [String: AVAudioPlayer] = [:]

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    // Sons système via AudioServicesPlaySystemSound
    func playCorrect() {
        AudioServicesPlaySystemSound(1025) // SMS received
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            AudioServicesPlaySystemSound(1025)
        }
    }

    func playIncorrect() {
        AudioServicesPlaySystemSound(1053) // shake
    }

    func playReveal() {
        AudioServicesPlaySystemSound(1104) // key press
    }

    func playVictory() {
        AudioServicesPlaySystemSound(1407) // fanfare-like
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            AudioServicesPlaySystemSound(1407)
        }
    }

    func playDefeat() {
        AudioServicesPlaySystemSound(1006) // low tone
    }

    // Haptics
    func hapticSuccess() {
        let gen = UINotificationFeedbackGenerator()
        gen.notificationOccurred(.success)
    }

    func hapticError() {
        let gen = UINotificationFeedbackGenerator()
        gen.notificationOccurred(.error)
    }

    func hapticLight() {
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.impactOccurred()
    }

    func hapticMedium() {
        let gen = UIImpactFeedbackGenerator(style: .medium)
        gen.impactOccurred()
    }

    func hapticHeavy() {
        let gen = UIImpactFeedbackGenerator(style: .heavy)
        gen.impactOccurred()
    }
}
