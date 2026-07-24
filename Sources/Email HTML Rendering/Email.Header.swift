//
//  Email.Header.swift
//  swift-email-html — Email HTML Rendering
//

public import Email_Standard
public import HTML

@_spi(DynamicHTML) import HTML_Rendering_Core

extension Email {
    /// A heading (`h1`–`h6`) with email-safe styling.
    ///
    /// The margin collapse and `:not(:first-child)` pseudo-selector spacing the
    /// web heading relies on are not dependable in email clients, so the
    /// margins are stated flatly and spacing is left to the enclosing
    /// ``Email/VStack`` and explicit padding.
    public struct Header<Content: HTML.View>: HTML.View {
        /// The heading level, clamped to 1...6.
        public let level: Int
        public let content: Content

        var _color: DarkModeColor?
        var _paddingBottom: Email.Spacing?

        public init(
            _ level: Int = 3,
            @HTML.Builder content: () -> Content
        ) {
            self.level = min(max(level, 1), 6)
            self.content = content()
        }

        /// Sets the heading colour, in both colour schemes.
        public func color(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._color = color
            return copy
        }

        /// Sets the padding below the heading.
        public func padding(bottom: Email.Spacing) -> Self {
            var copy = self
            copy._paddingBottom = bottom
            return copy
        }

        public var body: some HTML.View {
            tag("h\(level)") { content }
                .css
                .color(_color ?? .text.primary)
                .padding(bottom: _paddingBottom?.length)
                .inlineStyle("margin", "0")
                .inlineStyle(
                    "font-family",
                    "ui-sans-serif, -apple-system, Helvetica, Arial, sans-serif"
                )
                .inlineStyle("font-size", fontSize)
                .inlineStyle("font-weight", "700")
                .inlineStyle("line-height", "1.2")
        }

        /// The `em`-relative size for the heading level.
        ///
        /// Stated explicitly rather than left to the client's user-agent
        /// stylesheet, which varies widely across email clients.
        var fontSize: String {
            switch level {
            case 1: "2em"
            case 2: "1.5em"
            case 3: "1.17em"
            case 4: "1em"
            case 5: "0.83em"
            default: "0.67em"
            }
        }
    }
}
