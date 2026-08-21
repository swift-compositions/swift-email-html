public import Email_Standard
public import HTML

extension Email {

    public struct VStack<Content: HTML.View>: HTML.View {
        public let alignment: Alignment
        public let content: Content

        var _paddingVertical: Email.Spacing?
        var _paddingHorizontal: Email.Spacing?

        public init(
            alignment: Alignment = .start,
            @HTML.Builder content: () -> Content
        ) {
            self.alignment = alignment
            self.content = content()
        }

        public func padding(
            vertical: Email.Spacing? = nil,
            horizontal: Email.Spacing? = nil
        ) -> Self {
            var copy = self
            if let vertical { copy._paddingVertical = vertical }
            if let horizontal { copy._paddingHorizontal = horizontal }
            return copy
        }

        public var body: some HTML.View {
            div { content }
                .css
                .padding(
                    vertical: _paddingVertical?.length,
                    horizontal: _paddingHorizontal?.length
                )
                .inlineStyle("display", "block")
                .inlineStyle("text-align", alignment.textAlign)
        }
    }
}
