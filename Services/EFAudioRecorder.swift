//
//  EFAudioRecorder.swift
//  EverForm
//
//  Audio recording with live speech transcription and level monitoring
//

import Foundation
import AVFoundation
import Speech
import Combine

@MainActor
final class EFAudioRecorder: NSObject, ObservableObject {
    @Published var isRecording: Bool = false
    @Published var levels: [Float] = Array(repeating: 0.0, count: 20)
    @Published var transcript: String = ""
    
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer: SFSpeechRecognizer?
    private var levelTimer: Timer?
    private var recordingURL: URL?
    private var audioFile: AVAudioFile?
    
    override init() {
        super.init()
        setupSpeechRecognizer()
    }
    
    deinit {
        Task { @MainActor in
            let _ = stop()
        }
    }
    
    private func setupSpeechRecognizer() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        speechRecognizer?.delegate = self
    }
    
    func start() async throws {
        guard !isRecording else { return }
        
        // Request permissions
        let micPermission = await requestMicrophonePermission()
        let speechPermission = await requestSpeechPermission()
        
        // Setup audio session
        try setupAudioSession()
        
        // Setup audio engine
        try setupAudioEngine()
        
        // Setup speech recognition if permitted
        if speechPermission {
            try setupSpeechRecognition()
        }
        
        // Start recording
        try audioEngine?.start()
        isRecording = true
        
        // Start level monitoring (fallback if no mic permission)
        if !micPermission {
            startFallbackLevelAnimation()
        }
    }
    
    func stop() -> URL? {
        guard isRecording else { return nil }
        
        isRecording = false
        levelTimer?.invalidate()
        levelTimer = nil
        
        // Stop audio engine
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        
        // Stop speech recognition
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        
        // Close audio file
        audioFile = nil
        
        // Reset levels
        levels = Array(repeating: 0.0, count: 20)
        
        return recordingURL
    }
    
    private func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        }
    }
    
    private func requestSpeechPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker])
        try audioSession.setActive(true)
    }
    
    private func setupAudioEngine() throws {
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else { throw RecordingError.engineSetupFailed }
        
        inputNode = audioEngine.inputNode
        guard let inputNode = inputNode else { throw RecordingError.inputNodeUnavailable }
        
        // Setup recording file
        recordingURL = createRecordingURL()
        guard let recordingURL = recordingURL else { throw RecordingError.fileCreationFailed }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        audioFile = try AVAudioFile(forWriting: recordingURL, settings: recordingFormat.settings)
        
        // Install tap for level monitoring and file writing
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            Task { @MainActor in
                self?.processAudioBuffer(buffer)
            }
            
            // Write to file
            try? self?.audioFile?.write(from: buffer)
        }
    }
    
    private func setupSpeechRecognition() throws {
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            throw RecordingError.speechRecognitionUnavailable
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw RecordingError.speechRecognitionSetupFailed
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor in
                if let result = result {
                    self?.transcript = result.bestTranscription.formattedString
                }
            }
        }
        
        // Connect audio engine to speech recognition
        audioEngine?.inputNode.installTap(onBus: 0, bufferSize: 1024, format: audioEngine?.inputNode.outputFormat(forBus: 0)) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
    }
    
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let frameLength = Int(buffer.frameLength)
        let samples = Array(UnsafeBufferPointer(start: channelData, count: frameLength))
        
        // Calculate RMS level
        let rms = sqrt(samples.map { $0 * $0 }.reduce(0, +) / Float(samples.count))
        let level = min(max(rms * 10, 0.0), 1.0) // Scale and clamp
        
        // Update levels array (shift left and add new level)
        levels.removeFirst()
        levels.append(level)
    }
    
    private func startFallbackLevelAnimation() {
        levelTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            Task { @MainActor in
                // Generate fake levels for animation when no mic permission
                let randomLevel = Float.random(in: 0.1...0.8)
                self?.levels.removeFirst()
                self?.levels.append(randomLevel)
            }
        }
    }
    
    private func createRecordingURL() -> URL? {
        let tempDir = NSTemporaryDirectory()
        let fileName = "recording_\(Date().timeIntervalSince1970).m4a"
        return URL(fileURLWithPath: tempDir).appendingPathComponent(fileName)
    }
}

// MARK: - SFSpeechRecognizerDelegate

extension EFAudioRecorder: SFSpeechRecognizerDelegate {
    nonisolated func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // Handle availability changes if needed
    }
}

// MARK: - Errors

enum RecordingError: Error {
    case engineSetupFailed
    case inputNodeUnavailable
    case fileCreationFailed
    case speechRecognitionUnavailable
    case speechRecognitionSetupFailed
}
