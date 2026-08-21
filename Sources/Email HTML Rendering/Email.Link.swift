public import Email_Standard
public import HTML

extension Email {

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

        public func color(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._color = color
            return copy
        }

        public func backgroundColor(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._backgroundColor = color
            return copy
        }

        public func padding(bottom: Email.Spacing) -> Self {
            var copy = self
            copy._paddingBottom = bottom
            return copy
        }

        public var body: some HTML.View {

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
