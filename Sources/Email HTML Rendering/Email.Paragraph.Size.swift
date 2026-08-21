public import CSS_Theming
public import Email_Standard
import HTML

extension Email.Paragraph {

    public enum Size: Sendable, Hashable, CaseIterable {

        case regular

        case small

        public var font: CSS_Theming.Font {
            switch self {
            case .regular: .body
            case .small: .footnote
            }
        }
    }
}
