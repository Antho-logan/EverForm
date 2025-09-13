import SwiftUI

struct CoachInputBar: View {
    @Binding var text: String
    let onSend: (_ text: String, _ images: [UIImage]) -> Void
    @ObservedObject private var voice = EFVoiceCapture.shared
    @FocusState private var focused: Bool

    private var hasText: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        HStack(spacing: 12) {
            // Bigger plus
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.title) // bigger
            }

            ZStack(alignment: .trailing) {
                TextField("Message", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(DSColor.inputBackground, in: Capsule())
                    .focused($focused)

                if hasText {
                    Button {
                        onSend(text, [])
                        text = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .rotationEffect(.degrees(45))
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding(.trailing, 8)
                    .transition(.scale.combined(with: .opacity))
                }
            }

            // Bigger mic, safe toggle
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
                    .font(.title) // bigger
            }
            .alert(item: Binding(
                get: {
                    voice.errorMessage.map { ErrorBox(message: $0) }
                },
                set: { _ in voice.errorMessage = nil })
            ) { eb in
                Alert(title: Text("Voice Error"), message: Text(eb.message), dismissButton: .default(Text("OK")))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(DSColor.surface, in: Rectangle())
    }
}

private struct ErrorBox: Identifiable { let id = UUID(); let message: String }
