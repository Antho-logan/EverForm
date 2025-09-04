import SwiftUI
import AVFoundation
import Speech
import Combine

final class EFVoiceCapture: ObservableObject {
    static let shared = EFVoiceCapture()

    @Published var transcript: String = ""
    @Published var level: Float = 0          // 0...1 normalized
    @Published var isRecording: Bool = false
    @Published var errorMessage: String?

    private let audioEngine = AVAudioEngine()
    private var recognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    private init() {}

    // MARK: Permissions
    private enum P { case granted, denied }

    private func requestMic(_ done: @escaping (P)->Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted: done(.granted)
        case .denied: done(.denied)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { ok in
                DispatchQueue.main.async { done(ok ? .granted : .denied) }
            }
        @unknown default:
            done(.denied)
        }
    }

    private func requestSpeech(_ done: @escaping (P)->Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized: done(.granted)
                default: done(.denied)
                }
            }
        }
    }

    // MARK: Control
    func start() {
        guard !isRecording else { return }

        // Recognizer may be nil on unsupported locale; handle gracefully
        guard recognizer != nil else {
            errorMessage = "Speech recognition not available for your locale."
            return
        }

        requestMic { [weak self] mic in
            guard let self = self else { return }
            guard mic == .granted else {
                self.errorMessage = "Microphone access is required."
                return
            }
            self.requestSpeech { speech in
                guard speech == .granted else {
                    self.errorMessage = "Speech recognition access is required."
                    return
                }
                self.beginCapture()
            }
        }
    }

    func stop() {
        if audioEngine.isRunning {
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
        }
        request?.endAudio()
        task?.cancel()
        isRecording = false
    }

    private func beginCapture() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true, options: .notifyOthersOnDeactivation)

            let req = SFSpeechAudioBufferRecognitionRequest()
            req.shouldReportPartialResults = true
            request = req

            let input = audioEngine.inputNode
            let format = input.outputFormat(forBus: 0)

            input.removeTap(onBus: 0)
            input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                guard let self = self else { return }
                self.request?.append(buffer)
                self.updateLevel(with: buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            transcript = ""
            errorMessage = nil

            task = recognizer?.recognitionTask(with: req) { [weak self] result, err in
                guard let self = self else { return }
                if let r = result {
                    self.transcript = r.bestTranscription.formattedString
                }
                if err != nil || (result?.isFinal == true) {
                    self.stop()
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            stop()
        }
    }

    // Simple RMS level (no Accelerate)
    private func updateLevel(with buffer: AVAudioPCMBuffer) {
        guard let ch = buffer.floatChannelData?[0] else { return }
        let frames = Int(buffer.frameLength)
        if frames == 0 { return }
        var sum: Float = 0
        var i = 0
        while i < frames {
            let s = ch[i]
            sum += s * s
            i += 1
        }
        let rms = sqrt(sum / Float(frames))
        let db = 20 * log10f(rms + 1e-7)
        let minDb: Float = -60
        let clamped = max(minDb, db)
        let normalized = (clamped - minDb) / abs(minDb) // 0...1
        DispatchQueue.main.async { self.level = max(0, min(1, normalized)) }
    }
}
