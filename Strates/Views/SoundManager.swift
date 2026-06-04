import AVFoundation
import AudioToolbox
import UIKit

// MARK: - SoundManager
// Sons générés en mémoire (PCM → AVAudioPlayer), zéro fichier requis.
// Fonctionne sur simulateur ET device physique.

final class SoundManager {
    static let shared = SoundManager()
    private var players: [AVAudioPlayer] = []   // garder en vie

    private init() {
        configureSession()
    }

    // MARK: - Session audio

    private func configureSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
        try? session.setActive(true)
    }

    // MARK: - API publique

    func playReveal()    { play(notes: [(523, 0.07), (659, 0.07), (784, 0.12)], volume: 0.45) }
    func playCorrect()   { play(notes: [(523, 0.08), (659, 0.08), (784, 0.08), (1047, 0.20)], volume: 0.55) }
    func playIncorrect() { play(notes: [(330, 0.10), (220, 0.22)], volume: 0.45) }
    func playHeartLost() { play(notes: [(440, 0.06), (180, 0.28)], volume: 0.50) }

    func playVictory() {
        play(notes: [
            (523,  0.08), (659,  0.08), (784,  0.08),
            (1047, 0.08), (1319, 0.30)
        ], volume: 0.65)
    }

    func playDefeat() {
        play(notes: [(440, 0.14), (370, 0.14), (311, 0.14), (262, 0.28)], volume: 0.45)
    }

    func playStreak() {
        play(notes: [
            (659,  0.07), (784,  0.07), (988,  0.07),
            (1175, 0.07), (1319, 0.25)
        ], volume: 0.60)
    }

    func playNextWord() {
        play(notes: [(784, 0.08), (988, 0.08), (1175, 0.18)], volume: 0.45)
    }

    func playCombo() {
        play(notes: [
            (784,  0.06), (988,  0.06), (1175, 0.06),
            (1568, 0.06), (1976, 0.22)
        ], volume: 0.60)
    }

    // MARK: - Haptics

    func hapticLight()   { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    func hapticMedium()  { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    func hapticHeavy()   { UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }
    func hapticSuccess() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    func hapticError()   { UINotificationFeedbackGenerator().notificationOccurred(.error) }

    // MARK: - Moteur de synthèse PCM

    /// Génère un buffer PCM pour une séquence de notes (fréquence Hz, durée s)
    private func play(notes: [(Float, Float)], volume: Float) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }

            let sampleRate: Double = 44100
            let channels: Int = 1

            // Durée totale
            let totalSamples = notes.reduce(0) { $0 + Int(Double($1.1) * sampleRate) }
            var pcm = [Float](repeating: 0, count: totalSamples)

            var offset = 0
            for (freq, dur) in notes {
                let count = Int(Double(dur) * sampleRate)
                let f = Double(freq)
                let attack  = min(0.015, Double(dur) * 0.15)
                let release = min(0.06,  Double(dur) * 0.30)

                for i in 0..<count {
                    let t = Double(i) / sampleRate
                    // Sinus pur + légère harmonique
                    let wave = sin(2 * .pi * f * t) * 0.80
                               + sin(4 * .pi * f * t) * 0.12
                               + sin(6 * .pi * f * t) * 0.05
                    // Enveloppe ADSR simplifiée
                    let env: Double
                    if t < attack {
                        env = t / attack
                    } else if t > Double(dur) - release {
                        env = max(0, (Double(dur) - t) / release)
                    } else {
                        env = 1.0
                    }
                    pcm[offset + i] = Float(wave * env * Double(volume))
                }
                offset += count
            }

            // Convertir en Data WAV
            guard let data = self.wavData(pcm: pcm, sampleRate: Int(sampleRate), channels: channels) else { return }

            DispatchQueue.main.async {
                guard let player = try? AVAudioPlayer(data: data, fileTypeHint: AVFileType.wav.rawValue) else { return }
                player.volume = 1.0
                player.prepareToPlay()
                player.play()
                // Garder le player en vie jusqu'à la fin
                self.players.append(player)
                // Nettoyage après lecture
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(player.duration) + 0.3) { [weak self] in
                    self?.players.removeAll { !$0.isPlaying }
                }
            }
        }
    }

    // MARK: - Encodage WAV en mémoire

    private func wavData(pcm: [Float], sampleRate: Int, channels: Int) -> Data? {
        let bitsPerSample = 16
        let bytesPerSample = bitsPerSample / 8
        let byteRate = sampleRate * channels * bytesPerSample
        let blockAlign = channels * bytesPerSample
        let dataSize = pcm.count * bytesPerSample
        let chunkSize = 36 + dataSize

        var data = Data()
        // RIFF header
        data.append(contentsOf: Array("RIFF".utf8))
        data.append(uint32LE(UInt32(chunkSize)))
        data.append(contentsOf: Array("WAVE".utf8))
        // fmt chunk
        data.append(contentsOf: Array("fmt ".utf8))
        data.append(uint32LE(16))                          // chunk size
        data.append(uint16LE(1))                           // PCM format
        data.append(uint16LE(UInt16(channels)))
        data.append(uint32LE(UInt32(sampleRate)))
        data.append(uint32LE(UInt32(byteRate)))
        data.append(uint16LE(UInt16(blockAlign)))
        data.append(uint16LE(UInt16(bitsPerSample)))
        // data chunk
        data.append(contentsOf: Array("data".utf8))
        data.append(uint32LE(UInt32(dataSize)))
        // samples (clamp float → int16)
        for sample in pcm {
            let s = Int16(max(-1.0, min(1.0, sample)) * Float(Int16.max))
            data.append(uint16LE(UInt16(bitPattern: s)))
        }
        return data
    }

    private func uint32LE(_ v: UInt32) -> Data {
        var val = v.littleEndian
        return Data(bytes: &val, count: 4)
    }

    private func uint16LE(_ v: UInt16) -> Data {
        var val = v.littleEndian
        return Data(bytes: &val, count: 2)
    }
}
