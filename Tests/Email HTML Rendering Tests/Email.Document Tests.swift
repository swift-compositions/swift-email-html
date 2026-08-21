import Testing

@testable import Email_HTML_Rendering

extension Email {
    @Suite
    struct `Document Test` {
        @Suite struct Unit {}
        @Suite struct Integration {}
    }
}

extension Email.`Document Test` {

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

extension Email.`Document Test`.Integration {
    @Test
    func `renders the call to action as an anchor, not a button`() throws {
        let html = try Email.`Document Test`.render()

        #expect(html.contains("https://example.com/verify"))
        #expect(!html.contains("<button"))
    }

    @Test
    func `email configuration forces important on hoisted declarations`() throws {
        let html = try Email.`Document Test`.render()

        #expect(html.contains("!important"))
    }
}
