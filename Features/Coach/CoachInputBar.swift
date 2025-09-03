import SwiftUI

struct CoachInputBar: View {
    @Binding var text: String
    let onSend: (_ text: String, _ images: [UIImage]) -> Void
    @ObservedObject private var voice = EFVoiceCapture.shared
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Plus button (attachments)
            Button(action: {}) {
                Image(systemName: "plus.circle.fill").font(.title2)
            }

            // Text field bubble
            ZStack(alignment: .trailing) {
                TextField("Message", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.regularMaterial, in: Capsule())
                    .focused($focused)

                // Send arrow appears only when there's text
                if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Button {
                        // Hook up to your send action
                        onSend(text, [])
                        text = ""                 // clear after sending
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .padding(.trailing, 8)
                    }
                }
            }

            // Mic button
            Button {
                if voice.isRecording {
                    voice.stop()
                    if !voice.transcript.isEmpty {
                        if text.isEmpty { text = voice.transcript }
                        else { text += (text.hasSuffix(" ") ? "" : " ") + voice.transcript }
                    }
                } else {
                    voice.start()
                }
            } label: {
                Image(systemName: voice.isRecording ? "waveform.circle.fill" : "mic.circle.fill")
                    .font(.title2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(DSColor.surface, in: Rectangle())
    }
}
