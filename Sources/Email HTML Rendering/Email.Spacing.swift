//
//  Email.Spacing.swift
//  swift-email-html — Email HTML Rendering
//

public import Email_Standard
public import HTML

extension Email {
    /// The semantic spacing scale used by the email components.
    ///
    /// Email layout is deliberately coarse: the scale exists so templates say
    /// *how much* space they mean rather than naming a length, and so the same
    /// step renders identically across every component.
    ///
    /// The scale is declared here rather than as static members on
    /// `W3C_CSS_Values.LengthPercentage` on purpose. `swift-webpage` already
    /// extends that CSS type with an identically-named `.extraSmall` / `.small`
    /// / `.medium` scale; a second set of static members on the same type would
    /// be ambiguous at any call site importing both surfaces. A distinct
    /// `Email.Spacing` type keeps the token set collision-free.
    public enum Spacing: Sendable, Hashable, CaseIterable {
        case extraSmall
        case small
        case medium
        case large
        case extraLarge

        /// The CSS length this step resolves to.
        ///
        /// Values match the `swift-webpage` scale so an email and a web page
        /// rendered from the same design read as one system.
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
