import SwiftUI

fileprivate struct CoachChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isBot: Bool
}

final class CoachViewModel: ObservableObject {
    @Published fileprivate var messages: [CoachChatMessage] = [
        .init(text: "Hi! I'm your EverForm coach. How can I help you today?", isBot: true)
    ]

    func send(text: String, images: [UIImage]) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty || !images.isEmpty else { return }

        // Add user message
        let messageText = trimmed.isEmpty ? "Sent \(images.count) image(s)" : trimmed
        messages.append(.init(text: messageText, isBot: false))

        // TEMP echo until backend wires in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.messages.append(.init(text: "Got it! (demo) — we'll handle this soon.", isBot: true))
        }
    }
}

struct CoachView: View {
    @StateObject private var vm = CoachViewModel()
    @Environment(\.colorScheme) private var scheme
    @State private var messageText: String = ""
    @ObservedObject private var voice = EFVoiceCapture.shared
    
    private var isDark: Bool { scheme == .dark }

    var body: some View {
        VStack(spacing: 0) {
            Text("Coach")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)

            // Conversation area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(vm.messages) { msg in
                            HStack {
                                if msg.isBot {
                                    bubble(text: msg.text, isBot: true)
                                    Spacer(minLength: 30)
                                } else {
                                    Spacer(minLength: 30)
                                    bubble(text: msg.text, isBot: false)
                                }
                            }
                            .id(msg.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24) // Space for input bar
                }
                .onChange(of: vm.messages.count) {
                    if let last = vm.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Voice HUD while listening
            if voice.isRecording {
                VoiceHUD()
                    .padding(.bottom, 8)
            }

            CoachInputBar(text: $messageText) { text, images in
                vm.send(text: text, images: images)
            }
        }
        .background(isDark ? AnyView(Color.clear.ignoresSafeArea()) : AnyView(DSColor.appBackground.ignoresSafeArea()))
        .efDarkCanvas()
    }

    @ViewBuilder private func bubble(text: String, isBot: Bool) -> some View {
        let bg: Color = {
            if isBot {
                // Green in LIGHT mode, dark bubble in DARK mode
                return scheme == .light ? DSColor.chatBot : DSColor.card
            } else {
                return scheme == .light ? DSColor.chatUser : DSColor.cardElevated
            }
        }()
        let fg: Color = (scheme == .light && isBot) ? .white : DSColor.textPrimary

        Text(text)
            .font(.body)
            .foregroundStyle(fg)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(bg, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(DSColor.surface.opacity(0.12))
            )
    }
}
