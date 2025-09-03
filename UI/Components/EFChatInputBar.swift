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

    // Computed properties for send state
    private var trimmedText: String { text.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var hasSendable: Bool { !trimmedText.isEmpty || !attachments.isEmpty }
    
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
        // Idle composer content (not recording)
        ZStack(alignment: .trailing) {
            TextField("Message", text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(1...4)
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .padding(.trailing, hasSendable ? 48 : 16)   // make space for arrow when visible
                .background(DSColor.surface, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .foregroundStyle(DSColor.textPrimary)
                .onSubmit {
                    if hasSendable { send() }
                }

            // Trailing send arrow (appears only when there is text or attachments)
            if hasSendable {
                Button {
                    send()
                } label: {
                    Image(systemName: "paperplane.fill")  // rotated looks like OpenAI send
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: 28, height: 28)
                        .background(Color.accentColor, in: Circle())
                        .shadow(radius: 1, y: 1)
                        .accessibilityLabel("Send message")
                }
                .padding(.trailing, 8)
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: hasSendable)
            }
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

        send()
    }
    
    private func send() {
        guard hasSendable else { return }
        let textToSend = trimmedText
        let imagesToSend = attachments
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        onSend(textToSend, imagesToSend)
        text = ""
        attachments.removeAll()
        // End editing so return key dismisses cleanly
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
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
