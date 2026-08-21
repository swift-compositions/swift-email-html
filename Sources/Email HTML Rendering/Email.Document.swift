public import Email_Standard
public import HTML

extension Email {

    public struct Document<Content: HTML.View>: HTML.Document.`Protocol` {

        public let preheader: String

        public let content: Content

        var _backgroundColor: DarkModeColor?

        public init(
            preheader: String = "",
            @HTML.Builder content: () -> Content
        ) {
            self.preheader = preheader
            self.content = content()
        }

        public func backgroundColor(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._backgroundColor = color
            return copy
        }

        var background: DarkModeColor {
            _backgroundColor ?? .background.primary
        }

        public var head: some HTML.View {
            HTML.Group {
                meta(charset: .utf8)
                meta(
                    name: .viewport,
                    content: "width=device-width, initial-scale=1.0, viewport-fit=cover"
                )
                HTML.Style.Element { stylesheet }
            }
        }

        public var body: some HTML.View {
            HTML.Group {

                span { HTML.Text(preheader) }
                    .css
                    .inlineStyle("display", "none")
                    .inlineStyle("opacity", "0")
                    .inlineStyle("visibility", "hidden")
                    .inlineStyle("width", "0")
                    .inlineStyle("height", "0")
                    .inlineStyle("max-width", "0")
                    .inlineStyle("max-height", "0")
                    .inlineStyle("overflow", "hidden")
                    .inlineStyle("mso-hide", "all")

                table { content }
                    .attribute("role", "presentation")
                    .attribute("width", "100%")
                    .attribute("align", "center")
                    .attribute("cellpadding", "0")
                    .attribute("cellspacing", "0")
                    .attribute("border", "0")
                    .css
                    .backgroundColor(background)
                    .inlineStyle("width", "100%")
                    .inlineStyle("max-width", "100%")
                    .inlineStyle("margin", "0 auto")
                    .inlineStyle("border-collapse", "collapse")
            }
        }

        var stylesheet: String {
            """
            body, table, td, div, p, a {
                -webkit-text-size-adjust: 100%;
                -ms-text-size-adjust: 100%;
                margin: 0;
                padding: 0;
            }

            body {
                width: 100% !important;
                background-color: \(background.light.description);
            }

            table {
                border-collapse: collapse;
            }

            @media (prefers-color-scheme: dark) {
                body, table, td, div {
                    background-color: \(background.dark.description) !important;
                }
            }
            """
        }
    }
}
