public import CSS_Theming
public import Email_Standard
import HTML

extension Email {

    public struct Paragraph<Content: HTML.View>: HTML.View {
        public let size: Size
        public let content: Content

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

        public func font(_ font: CSS_Theming.Font) -> Self {
            var copy = self
            copy._font = font
            return copy
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
            p { content }
                .css
                .font(_font ?? size.font)
                .color(_color ?? .text.primary)
                .padding(bottom: _paddingBottom?.length)
                .inlineStyle("margin", "0")
        }
    }
}
