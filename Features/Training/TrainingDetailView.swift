import SwiftUI

struct TrainingDetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header("Training", color: DSColor.accentTraining, symbol: "dumbbell.fill")
                metric(title: "This Week", value: "3 sessions", color: DSColor.accentTraining)
                metric(title: "Average Duration", value: "42 min", color: DSColor.accentTraining)
                primaryButton(title: "Start Workout", color: DSColor.accentTraining) {
                    // TODO: hook real flow later
                }
            }
            .padding(20)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationTitle("Training")
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension TrainingDetailView {
    func header(_ title: String, color: Color, symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol).font(.title2.weight(.bold)).foregroundStyle(color)
            Text(title).font(.largeTitle.bold()).foregroundStyle(DSColor.textPrimary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(DSColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: DSColor.card.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    func metric(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(DSColor.textSecondary)
            Text(value).font(.title3.bold()).foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(DSColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: DSColor.card.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    func primaryButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.headline)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
