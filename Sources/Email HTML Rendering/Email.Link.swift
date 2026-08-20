//
//  Email.Link.swift
//  swift-email-html — Email HTML Rendering
//

public import Email_Standard
public import HTML

extension Email {
    /// A button-styled anchor — the call to action of an email.
    ///
    /// Named `Email.Link` rather than a bare `Link` deliberately: `HTML_Standard`
    /// already vends a top-level `Link` (the void `<link rel=…>` element), and
    /// the HTML umbrella re-exports it. A bare `Link` here would collide at any
    /// call site importing both surfaces — and it would collide *silently*,
    /// binding to the void element and reporting "no member 'padding'" rather
    /// than "ambiguous". The `Email` nest makes the collision impossible.
    ///
    /// Styled as an inline-block button rather than with a `button` element:
    /// email clients do not run JavaScript and only anchors reliably navigate.
    public struct Link<Label: HTML.View>: HTML.View {
        public let href: HTML.Href.Attribute?
        public let label: Label

        var _color: DarkModeColor?
        var _backgroundColor: DarkModeColor?
        var _paddingBottom: Email.Spacing?

        public init(
            href: HTML.Href.Attribute?,
            @HTML.Builder label: () -> Label
        ) {
            self.href = href
            self.label = label()
        }

        /// Sets the label colour, in both colour schemes.
        public func color(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._color = color
            return copy
        }

        /// Sets the button fill, in both colour schemes.
        public func backgroundColor(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._backgroundColor = color
            return copy
        }

        /// Sets the padding below the button.
        public func padding(bottom: Email.Spacing) -> Self {
            var copy = self
            copy._paddingBottom = bottom
            return copy
        }

        public var body: some HTML.View {
            // The anchor carries the button skin; the wrapping div carries the
            // trailing space. Padding on the anchor itself is the button's own
            // hit area, so bottom spacing cannot live there.
            div {
                a(href: href) { label }
                    .css
                    .color(_color ?? .text.primary.reverse())
                    .backgroundColor(_backgroundColor ?? .background.primary.reverse())
                    .font(.body)
                    .inlineStyle("display", "inline-block")
                    .inlineStyle("padding", "0.75rem 1.5rem")
                    .inlineStyle("border-radius", "0.375rem")
                    .inlineStyle("font-weight", "600")
                    .inlineStyle("text-decoration", "none")
            }
            .css
            .padding(bottom: _paddingBottom?.length)
            .inlineStyle("display", "block")
        }
    }
}
