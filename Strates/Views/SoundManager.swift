import AVFoundation
import AudioToolbox
import UIKit

// MARK: - Sons synthétiques via AVAudioEngine (zéro fichier requis)

final class SoundManager {
    static let shared = SoundManager()
    private let engine = AVAudioEngine()
    private let mixer: AVAudioMixerNode

    private init() {
        mixer = engine.mainMixerNode
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        try? engine.start()
    }

    // MARK: - Sons synthétiques

    /// Joue une séquence de tonalités
    func playTones(_ notes: [(frequency: Float, duration: Float, volume: Float)]) {
        let sampleRate: Double = 44100
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!

        var offsetTime: AVAudioTime? = nil
        let startTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.01 * Double(NSEC_PER_SEC)))

        for (i, note) in notes.enumerated() {
            let frameCount = AVAudioFrameCount(Double(note.duration) * sampleRate)
            guard let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { continue }
            buf.frameLength = frameCount

            let channelData = buf.floatChannelData![0]
            let freq = Double(note.frequency)
            let vol = Double(note.volume)

            for frame in 0..<Int(frameCount) {
                let t = Double(frame) / sampleRate
                // Onde sinusoïdale + enveloppe ADSR simple
                let envelope: Double
                let attack = 0.02, decay = 0.05, release = 0.08
                let sustain = max(0, Double(note.duration) - attack - decay - release)
                if t < attack {
                    envelope = t / attack
                } else if t < attack + decay {
                    envelope = 1.0 - 0.2 * ((t - attack) / decay)
                } else if t < attack + decay + sustain {
                    envelope = 0.8
                } else {
                    let rel = t - attack - decay - sustain
                    envelope = 0.8 * max(0, 1.0 - rel / release)
                }
                channelData[frame] = Float(sin(2.0 * .pi * freq * t) * vol * envelope)
            }

            let player = AVAudioPlayerNode()
            engine.attach(player)
            engine.connect(player, to: mixer, format: format)
            player.scheduleBuffer(buf, completionHandler: nil)

            let delay = notes.prefix(i).reduce(0.0) { $0 + Double($1.duration) }
            let playTime = AVAudioTime(
                hostTime: startTime.hostTime + UInt64(delay * Double(NSEC_PER_SEC))
            )
            player.play(at: playTime)

            DispatchQueue.main.asyncAfter(deadline: .now() + delay + Double(note.duration) + 0.1) {
                self.engine.detach(player)
            }
        }
    }

    // MARK: - Sons de jeu

    func playReveal() {
        // Swoosh montant doux
        playTones([
            (frequency: 440, duration: 0.07, volume: 0.3),
            (frequency: 550, duration: 0.07, volume: 0.35),
            (frequency: 660, duration: 0.10, volume: 0.4),
        ])
        hapticLight()
    }

    func playCorrect() {
        // Ding ding ascendant — victoire partielle
        playTones([
            (frequency: 523, duration: 0.10, volume: 0.5),
            (frequency: 659, duration: 0.10, volume: 0.5),
            (frequency: 784, duration: 0.18, volume: 0.55),
        ])
        hapticSuccess()
    }

    func playIncorrect() {
        // Buzz grave descendant
        playTones([
            (frequency: 300, duration: 0.12, volume: 0.45),
            (frequency: 220, duration: 0.18, volume: 0.4),
        ])
        hapticError()
    }

    func playHeartLost() {
        // Son dramatique — cœur perdu
        playTones([
            (frequency: 400, duration: 0.08, volume: 0.5),
            (frequency: 180, duration: 0.30, volume: 0.45),
        ])
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    func playVictory() {
        // Fanfare montante
        playTones([
            (frequency: 523, duration: 0.10, volume: 0.55),
            (frequency: 659, duration: 0.10, volume: 0.55),
            (frequency: 784, duration: 0.10, volume: 0.55),
            (frequency: 1047, duration: 0.35, volume: 0.65),
        ])
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func playDefeat() {
        // Descente triste
        playTones([
            (frequency: 440, duration: 0.15, volume: 0.45),
            (frequency: 370, duration: 0.15, volume: 0.42),
            (frequency: 311, duration: 0.25, volume: 0.38),
        ])
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    func playStreak() {
        // Montée joyeuse — série active
        playTones([
            (frequency: 659, duration: 0.08, volume: 0.5),
            (frequency: 784, duration: 0.08, volume: 0.5),
            (frequency: 988, duration: 0.08, volume: 0.5),
            (frequency: 1175, duration: 0.20, volume: 0.6),
        ])
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    // MARK: - Haptics

    func hapticLight()   { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    func hapticMedium()  { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    func hapticHeavy()   { UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }
    func hapticSuccess() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    func hapticError()   { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}
