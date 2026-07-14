//
//  Email.VStack.swift
//  swift-email-html — Email HTML Rendering
//

public import Email_Standard
public import HTML

extension Email {
    /// Email-safe vertical flow.
    ///
    /// Deliberately NOT flexbox. `display: flex` is unsupported or partially
    /// supported across the major email clients (notably Outlook's Word
    /// rendering engine), so this stacks its children with ordinary block flow
    /// inside a table cell — the one layout every client agrees on. Alignment
    /// is expressed with `text-align`, which inherits into the block children
    /// rather than requiring a cross-axis model.
    ///
    /// This is why the email components exist as their own target rather than
    /// reusing `swift-webpage`: those components are web-shaped (flexbox, grid,
    /// pseudo-selectors) and are not email-safe.
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

        /// Sets the block padding.
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
