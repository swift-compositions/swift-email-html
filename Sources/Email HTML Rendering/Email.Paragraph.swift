//
//  Email.Paragraph.swift
//  swift-email-html — Email HTML Rendering
//

public import CSS_Theming
public import Email_Standard
import HTML

extension Email {
    /// A paragraph with email-safe styling and a size variant.
    ///
    /// ```swift
    /// Email.Paragraph { "Body copy." }
    ///     .padding(bottom: .extraSmall)
    ///     .font(.body)
    ///
    /// Email.Paragraph(.small) { "Fine print." }
    ///     .font(.footnote)
    ///     .color(.text.secondary)
    /// ```
    public struct Paragraph<Content: HTML.View>: HTML.View {
        public let size: Size
        public let content: Content

        // Qualified: bare `Font` is ambiguous through the HTML umbrella, which
        // re-exports both `CSS_Theming.Font` (the semantic type ramp) and
        // `W3C_CSS_Fonts.Font` (the CSS `font` shorthand property).
        var _font: CSS_Theming.Font?
        var _color: DarkModeColor?
        var _paddingBottom: Email.Spacing?

        public init(
            _ size: Size = .regular,
            @HTML.Builder content: () -> Content
        ) {
            self.size = size
            self.content = content()
        }

        /// Overrides the font for this paragraph.
        ///
        /// Without this, the paragraph uses the font its ``Email/Paragraph/Size``
        /// implies.
        public func font(_ font: CSS_Theming.Font) -> Self {
            var copy = self
            copy._font = font
            return copy
        }

        /// Sets the text colour, in both colour schemes.
        public func color(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._color = color
            return copy
        }

        /// Sets the padding below the paragraph.
        public func padding(bottom: Email.Spacing) -> Self {
            var copy = self
            copy._paddingBottom = bottom
            return copy
        }

        public var body: some HTML.View {
            p { content }
                .css
                .font(_font ?? size.font)
                .color(_color ?? .text.primary)
                .padding(bottom: _paddingBottom?.length)
                .inlineStyle("margin", "0")
        }
    }
}
