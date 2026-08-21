//
//  Email.VStack.Alignment.swift
//  swift-email-html — Email HTML Rendering
//

public import Email_Standard
import HTML

extension Email.VStack {
    /// Horizontal alignment of the stacked children.
    ///
    /// Named for the writing-mode-relative edges (`start` / `end`) rather than
    /// left/right so right-to-left locales read correctly; the CSS values are
    /// the logical `start` / `end` keywords, which every current email client
    /// resolves.
    public enum Alignment: Sendable, Hashable, CaseIterable {
        case start
        case center
        case end

        /// The `text-align` value this alignment resolves to.
        public var textAlign: String {
            switch self {
            case .start: "start"
            case .center: "center"
            case .end: "end"
            }
        }
    }
}
