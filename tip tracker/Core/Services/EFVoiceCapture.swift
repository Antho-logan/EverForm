import SwiftUI
import AVFoundation
import Speech
import Combine
import Accelerate

final class EFVoiceCapture: ObservableObject {
    static let shared = EFVoiceCapture()

    @Published var transcript: String = ""
    @Published var level: Float = 0            // 0...1 normalized
    @Published var isRecording: Bool = false
    @Published var errorMessage: String?

    private let audioEngine = AVAudioEngine()
    private let recognizer = SFSpeechRecognizer()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var cancellables = Set<AnyCancellable>()

    private init() {}

    enum PermissionState { case granted, denied, undetermined }

    private func micPermission(completion: @escaping (PermissionState) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted: completion(.granted)
        case .denied: completion(.denied)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { ok in
                DispatchQueue.main.async { completion(ok ? .granted : .denied) }
            }
        @unknown default:
            completion(.denied)
        }
    }

    private func speechPermission(completion: @escaping (PermissionState) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized: completion(.granted)
                case .denied, .restricted: completion(.denied)
                case .notDetermined: completion(.undetermined)
                @unknown default: completion(.denied)
                }
            }
        }
    }

    func start() {
        guard !isRecording else { return }

        micPermission { [weak self] mic in
            guard let self = self else { return }
            guard mic == .granted else {
                self.errorMessage = "Microphone access is required."
                return
            }
            self.speechPermission { speech in
                guard speech == .granted else {
                    self.errorMessage = "Speech recognition access is required."
                    return
                }
                self.beginCapture()
            }
        }
    }

    private func beginCapture() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true, options: .notifyOthersOnDeactivation)

            request = SFSpeechAudioBufferRecognitionRequest()
            request?.shouldReportPartialResults = true

            let input = audioEngine.inputNode
            let format = input.outputFormat(forBus: 0)

            input.removeTap(onBus: 0)
            input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                guard let self = self else { return }
                self.request?.append(buffer)
                self.updateLevel(buffer: buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()

            isRecording = true
            transcript = ""
            errorMessage = nil

            task = recognizer?.recognitionTask(with: request!) { [weak self] result, error in
                guard let self = self else { return }
                if let r = result {
                    self.transcript = r.bestTranscription.formattedString
                }
                if error != nil || (result?.isFinal == true) {
                    self.stop()
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            stop()
        }
    }

    private func updateLevel(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameCount = Int(buffer.frameLength)
        var rms: Float = 0
        vDSP_measqv(channelData, 1, &rms, vDSP_Length(frameCount))
        let avg = 20 * log10f(sqrtf(rms) + 1e-7)
        let minDb: Float = -60
        let clamped = max(minDb, avg)
        let normalized = (clamped - minDb) / abs(minDb)  // 0...1
        DispatchQueue.main.async { self.level = normalized }
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
}
