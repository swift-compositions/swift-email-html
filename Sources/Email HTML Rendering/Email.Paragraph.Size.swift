//
//  Email.Paragraph.Size.swift
//  swift-email-html — Email HTML Rendering
//

public import CSS_Theming
public import Email_Standard
public import HTML

extension Email.Paragraph {
    /// The paragraph size variant.
    ///
    /// The variant carries a font rather than a raw size so a paragraph picks up
    /// the whole type ramp (family, weight, line-height) from the theme's
    /// `Font.Defaults`, not just a `font-size`.
    public enum Size: Sendable, Hashable, CaseIterable {
        /// Body copy.
        case regular
        /// Fine print — legal notices, expiry warnings, support footers.
        case small

        /// The theme font this size resolves to.
        ///
        /// Qualified: bare `Font` is ambiguous through the HTML umbrella, which
        /// re-exports both `CSS_Theming.Font` (this one — the semantic type
        /// ramp carrying family/size/weight/line-height) and
        /// `W3C_CSS_Fonts.Font` (the CSS `font` shorthand property).
        public var font: CSS_Theming.Font {
            switch self {
            case .regular: .body
            case .small: .footnote
            }
        }
    }
}
