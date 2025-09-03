//
//  EFChatInputBar.swift
//  EverForm
//
//  OpenAI-style chat input bar with voice recording and attachments
//

import SwiftUI

struct EFChatInputBar: View {
    @Binding var text: String
    let onSend: (_ text: String, _ attachments: [UIImage]) -> Void
    
    @State private var attachments: [UIImage] = []
    @StateObject private var recorder = EFAudioRecorder()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            // Attachment preview
            ImageAttachmentPreview(images: attachments) { index in
                attachments.remove(at: index)
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            }
            
            // Main input bar
            HStack(spacing: 12) {
                // Plus button for attachments
                EFPhotoPicker(selectedImages: $attachments) {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                
                // Center content (text field or recording view)
                centerContent
                
                // Microphone button
                microphoneButton
            }
            .frame(height: 56)
        }
    }
    
    @ViewBuilder
    private var centerContent: some View {
        if recorder.isRecording {
            recordingView
        } else {
            textInputView
        }
    }
    
    private var textInputView: some View {
        TextField("Message", text: $text, axis: .vertical)
            .focused($isTextFieldFocused)
            .font(.body)
            .foregroundStyle(DSColor.textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .lineLimit(1...4)
            .onSubmit {
                sendMessage()
            }
    }
    
    private var recordingView: some View {
        HStack(spacing: 12) {
            // Stop button
            Button(action: stopRecording) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(DSColor.textSecondary)
                    .frame(width: 14, height: 14)
            }
            .frame(width: 28, height: 28)
            .accessibilityLabel("Stop recording")
            
            // Level meter with transcript overlay
            ZStack {
                EFLevelMeterView(levels: recorder.levels)
                
                if !recorder.transcript.isEmpty {
                    Text(recorder.transcript)
                        .font(.caption)
                        .foregroundStyle(DSColor.textSecondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.horizontal, 8)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Send button
            Button(action: sendRecording) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 28, height: 28)
            .accessibilityLabel("Send message")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
    
    private var microphoneButton: some View {
        Button(action: toggleRecording) {
            Image(systemName: recorder.isRecording ? "waveform" : "mic.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(recorder.isRecording ? DSColor.textSecondary.opacity(0.5) : DSColor.textSecondary)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial, in: Circle())
        }
        .disabled(recorder.isRecording) // Disabled when recording (controls are in the pill)
        .accessibilityLabel(recorder.isRecording ? "Recording in progress" : "Start recording")
    }
    
    private func toggleRecording() {
        if recorder.isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        isTextFieldFocused = false
        
        Task {
            do {
                try await recorder.start()
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            } catch {
                print("Failed to start recording: \(error)")
            }
        }
    }
    
    private func stopRecording() {
        let _ = recorder.stop()
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func sendRecording() {
        let transcript = recorder.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        let _ = recorder.stop()
        
        if !transcript.isEmpty {
            text = transcript
        }
        
        sendMessage()
    }
    
    private func sendMessage() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty || !attachments.isEmpty else { return }
        
        onSend(trimmedText, attachments)
        
        // Clear inputs
        text = ""
        attachments = []
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

#Preview {
    VStack {
        Spacer()
        
        EFChatInputBar(text: .constant("")) { text, images in
            print("Send: \(text), Images: \(images.count)")
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .background(DSColor.appBackground.ignoresSafeArea(edges: .bottom))
    }
    .background(DSColor.appBackground)
}
