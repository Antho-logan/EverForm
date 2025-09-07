import SwiftUI

// MARK: - PainUI Design System
// Shared styles and helpers for Fix Pain flow to maintain visual parity with EverForm

struct PainUI {
    
    // MARK: - Theme Tokens
    struct Theme {
        static let appBackground = DSColor.appBackground
        static let card = DSColor.card
        static let textPrimary = DSColor.textPrimary
        static let textSecondary = DSColor.textSecondary
        static let brand = DSColor.brand
        static let actionRed = Color.efActionRed
        
        // Section accent colors matching Overview view
        static let accentTraining = DSColor.accentTraining
        static let accentNutrition = DSColor.accentNutrition
        static let accentRecovery = DSColor.accentRecovery
        static let accentMobility = DSColor.accentMobility
        
        // Risk level colors
        static let riskLow = Color.efRiskLow
        static let riskMedium = Color.efRiskMed
        static let riskHigh = Color.efRiskHigh
    }
    
    // MARK: - Layout Constants
    struct Layout {
        static let hPadding: CGFloat = 20
        static let vSpacing: CGFloat = 16
        static let cardSpacing: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 56
        static let progressBarHeight: CGFloat = 4
    }
    
    // MARK: - Card Modifier
    struct CardModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        }
    }
    
    // MARK: - Primary CTA Button Style
    struct PrimaryCTA: ButtonStyle {
        let isEnabled: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: Layout.buttonHeight)
                .background(isEnabled ? Theme.actionRed : Theme.actionRed.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Theme.actionRed.opacity(0.25), radius: 8, y: 4)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        }
    }
    
    // MARK: - Risk Level Badge
    struct RiskLevelBadge: View {
        enum PainSeverity {
            case low, medium, high
            
            var displayName: String {
                switch self {
                case .low: return "Low"
                case .medium: return "Medium"
                case .high: return "High"
                }
            }
            
            var color: Color {
                switch self {
                case .low: return Theme.riskLow
                case .medium: return Theme.riskMedium
                case .high: return Theme.riskHigh
                }
            }
        }
        
        let level: PainSeverity
        
        var body: some View {
            Text(level.displayName)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(level.color.opacity(0.18))
                .foregroundColor(level.color)
                .clipShape(Capsule())
        }
    }
    
    // MARK: - Step Progress Bar
    struct StepProgressBar: View {
        let currentStep: Int
        let totalSteps: Int
        
        var body: some View {
            VStack(spacing: 8) {
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Theme.card)
                            .frame(height: Layout.progressBarHeight)
                        
                        // Progress fill
                        Rectangle()
                            .fill(Theme.brand)
                            .frame(width: geometry.size.width * (CGFloat(currentStep) / CGFloat(totalSteps)), 
                                   height: Layout.progressBarHeight)
                            .animation(.easeInOut(duration: 0.3), value: currentStep)
                    }
                }
                .frame(height: Layout.progressBarHeight)
                
                // Step indicators
                HStack(spacing: 0) {
                    ForEach(0..<totalSteps, id: \.self) { step in
                        Circle()
                            .fill(step <= currentStep ? Theme.brand : Theme.textSecondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                        
                        if step < totalSteps - 1 {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Pain Area Tile
    struct PainAreaTile: View {
        let area: PainArea
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 12) {
                    // Icon
                    Image(systemName: area.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(isSelected ? .white : Theme.textPrimary)
                    
                    // Title
                    Text(area.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(isSelected ? .white : Theme.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius)
                        .fill(isSelected ? Theme.brand : Theme.card)
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isSelected ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
    
    // MARK: - Option Card
    struct OptionCard: View {
        let title: String
        let subtitle: String?
        let icon: String?
        let iconColor: Color?
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 16) {
                    if let icon = icon, let iconColor = iconColor {
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(iconColor)
                            .frame(width: 32, height: 32)
                            .background(iconColor.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(Theme.textPrimary)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                    
                    // Selection indicator
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Theme.brand)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius)
                        .fill(Theme.card)
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - View Extensions
extension View {
    func painCard() -> some View {
        self.modifier(PainUI.CardModifier())
    }
    
    func painCTA(isEnabled: Bool = true) -> some View {
        self.buttonStyle(PainUI.PrimaryCTA(isEnabled: isEnabled))
    }
}