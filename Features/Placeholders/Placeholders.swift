import SwiftUI

struct PlaceholderScreen: View {
    let title: String
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text(title)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("This screen is a placeholder. Hook up real content later.")
                    .foregroundStyle(DSColor.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .toolbarBackground(DSColor.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// Convenience wrappers - only for views that don't exist yet
struct TrainingStartView: View { var body: some View { PlaceholderScreen(title: "Training") } }
struct NutritionLogView: View { var body: some View { PlaceholderScreen(title: "Nutrition") } }
struct RecoveryPlanView: View { var body: some View { PlaceholderScreen(title: "Recovery") } }
struct MobilityPlanView: View { var body: some View { PlaceholderScreen(title: "Mobility") } }
struct AddWaterView: View { var body: some View { PlaceholderScreen(title: "Add Water") } }

struct ProfileView: View { var body: some View { PlaceholderScreen(title: "Profile") } }
