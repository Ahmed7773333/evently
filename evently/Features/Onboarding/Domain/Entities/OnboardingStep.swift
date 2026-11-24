import Foundation

struct OnboardingStep: Identifiable, Equatable, Sendable {
    let id: Int
    let titleKey: String
    let subtitleKey: String
    let symbolName: String
    let accentColorToken: String // Maps to your Asset Catalog or DesignSystem color
}
