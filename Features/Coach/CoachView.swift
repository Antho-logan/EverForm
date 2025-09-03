import SwiftUI

fileprivate struct CoachChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isBot: Bool
}

final class CoachViewModel: ObservableObject {
    @Published var input: String = ""
    @Published fileprivate var messages: [CoachChatMessage] = [
        .init(text: "Hi! I'm your EverForm coach. How can I help you today?", isBot: true)
    ]

    func send() {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        input = ""
        messages.append(.init(text: trimmed, isBot: false))

        // TEMP echo until backend wires in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.messages.append(.init(text: "Got it! (demo) — we'll handle this soon.", isBot: true))
        }
    }
}

struct CoachView: View {
    @StateObject private var vm = CoachViewModel()
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 0) {
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
                    .padding(.bottom, 8)
                }
                .onChange(of: vm.messages.count) {
                    if let last = vm.messages.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } }
                }
            }

            // Input bar
            HStack(spacing: 10) {
                TextField("Message", text: $vm.input, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(DSColor.textPrimary)

                Button {
                    vm.send()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(DSColor.brand, in: Capsule())
                }
                .disabled(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(12)
            .background(DSColor.surface)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationTitle("Coach")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(DSColor.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
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
