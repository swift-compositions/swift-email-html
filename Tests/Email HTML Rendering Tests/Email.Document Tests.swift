//
//  Email.Document Tests.swift
//  swift-email-html — Email HTML Rendering Tests
//

import Testing

@testable import Email_HTML_Rendering

// The suites anchor on `Email` — the non-generic namespace — rather than on
// `Email.Document`, which is generic (`Document<Content>`). The `@Suite` macro
// synthesizes static stored properties, and Swift does not permit those in a
// generic context ("static stored properties not supported in generic types").
extension Email {
    @Suite
    struct `Document Test` {
        @Suite struct Unit {}
        @Suite struct Integration {}
    }
}

// MARK: - Fixture

extension Email.`Document Test` {
    /// The verification email, rendered exactly as the templates render it.
    static func render() throws -> String {
        let document = Email.Document(preheader: "Verify your email address") {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) { "Verify your email address" }

                        Email.Paragraph { "Please confirm this is your email address." }
                            .padding(bottom: .extraSmall)
                            .font(.body)

                        Email.Link(href: .init(value: "https://example.com/verify")) {
                            "Verify email address"
                        }
                        .color(.text.primary.reverse())
                        .padding(bottom: .medium)

                        Email.Paragraph(.small) { "This link expires in 24 hours." }
                            .font(.footnote)
                            .color(.text.secondary)
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
        .backgroundColor(.background.primary.reverse())

        return try String(document, configuration: .email)
    }
}

// MARK: - Unit

extension Email.`Document Test`.Unit {
    @Test
    func `emits a full document shell`() throws {
        let html = try Email.`Document Test`.render()

        #expect(html.contains("<!doctype html>"))
        #expect(html.contains("<html>"))
        #expect(html.contains("<head>"))
        #expect(html.contains("<body>"))
    }

    @Test
    func `hoists collected styles into a head style block`() throws {
        let html = try Email.`Document Test`.render()

        // The two-phase hoist inherited from HTML.Document.Protocol: the styles
        // the body's `.css` chains register must land in <head>. Assert the
        // ORDER — that is what makes it a hoist rather than an inline style.
        let style = try #require(html.firstRange(of: "<style>"))
        let headClose = try #require(html.firstRange(of: "</head>"))
        let bodyOpen = try #require(html.firstRange(of: "<body>"))

        #expect(style.lowerBound < headClose.lowerBound, "style block must precede </head>")
        #expect(headClose.lowerBound < bodyOpen.lowerBound, "head must precede body")
    }

    @Test
    func `carries the preheader and the email reset`() throws {
        let html = try Email.`Document Test`.render()

        #expect(html.contains("Verify your email address"))
        #expect(html.contains("-webkit-text-size-adjust"))
        #expect(html.contains("prefers-color-scheme: dark"))
    }

    @Test
    func `wraps content in a presentation-role table`() throws {
        let html = try Email.`Document Test`.render()

        #expect(html.contains(#"role="presentation""#))
        #expect(html.contains("<table"))
        #expect(html.contains("<tr>"))
        #expect(html.contains("<td>"))
    }
}

// MARK: - Integration

extension Email.`Document Test`.Integration {
    @Test
    func `renders the call to action as an anchor, not a button`() throws {
        let html = try Email.`Document Test`.render()

        // Email clients do not run JavaScript; only anchors reliably navigate.
        #expect(html.contains("https://example.com/verify"))
        #expect(!html.contains("<button"))
    }

    @Test
    func `email configuration forces important on hoisted declarations`() throws {
        let html = try Email.`Document Test`.render()

        // HTML.Context.Configuration.email sets forceImportant, so a client
        // stylesheet cannot outrank the hoisted rules.
        #expect(html.contains("!important"))
    }
}
