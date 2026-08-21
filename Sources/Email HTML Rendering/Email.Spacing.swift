public import Email_Standard
public import HTML

extension Email {

    public enum Spacing: Sendable, Hashable, CaseIterable {
        case extraSmall
        case small
        case medium
        case large
        case extraLarge

        public var length: W3C_CSS_Values.LengthPercentage {
            switch self {
            case .extraSmall: .rem(0.5)
            case .small: .rem(0.75)
            case .medium: .rem(1.5)
            case .large: .rem(3)
            case .extraLarge: .rem(6)
            }
        }
    }
}
