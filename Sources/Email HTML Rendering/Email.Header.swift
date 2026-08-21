public import Email_Standard
public import HTML
@_spi(DynamicHTML) import HTML_Rendering_Core

extension Email {

    public struct Header<Content: HTML.View>: HTML.View {

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

        public func color(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._color = color
            return copy
        }

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
