import EmailAddress_Standard
import Testing

@testable import Email_HTML

extension RFC_5322.DateTime {

    static let test = Self(secondsSinceEpoch: 1_234_567_890)
}

extension AppleMail.Message {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension AppleMail.Message.Test.Unit {
    @Test
    func `message from a simple email carries RFC 5322 and Apple headers`() throws {
        let email = try Email(
            to: [try emailAddress(localPart: "recipient", domain: "example.com")],
            from: try emailAddress(localPart: "sender", domain: "example.com"),
            subject: "Test Email",
            text: "Hello, World!",
            date: .test
        )

        let message = try AppleMail.Message(from: email)
        let emlContent = message.description

        #expect(emlContent.contains("From: sender@example.com"))
        #expect(emlContent.contains("To: recipient@example.com"))
        #expect(emlContent.contains("Subject: Test Email"))
        #expect(emlContent.contains("Date: "))
        #expect(emlContent.contains("Message-ID: "))

        #expect(emlContent.contains("MIME-Version: 1.0 (Mac OS X Mail 16.0 \\(3826.700.71\\))"))
        #expect(emlContent.contains("X-Apple-Base-Url: x-msg://1/"))
        #expect(emlContent.contains("X-Universally-Unique-Identifier: "))
        #expect(emlContent.contains("X-Apple-Mail-Remote-Attachments: YES"))
        #expect(emlContent.contains("X-Apple-Windows-Friendly: 1"))
        #expect(emlContent.contains("X-Uniform-Type-Identifier: com.apple.mail-draft"))

        #expect(emlContent.contains("Hello, World!"))
    }

    @Test
    func `custom universal identifier lands in the Apple header`() throws {
        let customUUID = try RFC_4122.UUID("12345678-1234-1234-1234-123456789ABC")
        let email = try Email(
            to: [try emailAddress(localPart: "recipient", domain: "example.com")],
            from: try emailAddress(localPart: "sender", domain: "example.com"),
            subject: "Test",
            text: "Test content",
            date: .test
        )

        let message = try AppleMail.Message(from: email, universalUUID: customUUID)

        #expect(
            message.description.contains(
                "X-Universally-Unique-Identifier: \(Swift.String(customUUID))"
            )
        )
    }
}

extension AppleMail.Message.Test.`Edge Case` {
    @Test
    func `blind-carbon-copy recipients never render into the message`() throws {
        let email = try Email(
            to: [try emailAddress(localPart: "to", domain: "example.com")],
            from: try emailAddress(localPart: "sender", domain: "example.com"),
            bcc: [try emailAddress(localPart: "bcc", domain: "example.com")],
            date: .test,
            subject: "Privacy",
            body: .text("Body")
        )

        let message = try AppleMail.Message(from: email)
        #expect(!message.description.contains("Bcc:"))
    }
}

extension AppleMail.Message.Test.Integration {
    @Test
    func `HTML content renders with the text-html content type`() throws {
        let email = try Email(
            to: [try emailAddress(localPart: "recipient", domain: "example.com")],
            from: try emailAddress(localPart: "sender", domain: "example.com"),
            subject: "HTML Email",
            html: "<h1>Hello, World!</h1><p>This is a test.</p>",
            date: .test
        )

        let message = try AppleMail.Message(from: email)
        let emlContent = message.description

        #expect(emlContent.contains("Content-Type: text/html"))
        #expect(emlContent.contains("charset=UTF-8"))
        #expect(emlContent.contains("<h1>Hello, World!</h1>"))
        #expect(emlContent.contains("<p>This is a test.</p>"))
    }

    @Test
    func `text and HTML parts render as multipart alternative`() throws {
        let email = try Email(
            to: [try emailAddress(localPart: "recipient", domain: "example.com")],
            from: try emailAddress(localPart: "sender", domain: "example.com"),
            subject: "Multipart Email",
            text: "Plain text version",
            html: "<h1>HTML version</h1>",
            date: .test
        )

        let message = try AppleMail.Message(from: email)
        let emlContent = message.description

        #expect(emlContent.contains("Content-Type: multipart/alternative"))
        #expect(emlContent.contains("boundary="))
        #expect(emlContent.contains("Plain text version"))
        #expect(emlContent.contains("<h1>HTML version</h1>"))
    }

    @Test
    func `all email fields and custom headers survive the Apple wrapping`() throws {
        let email = try Email(
            to: [
                try emailAddress(localPart: "to1", domain: "example.com"),
                try emailAddress(localPart: "to2", domain: "example.com"),
            ],
            from: try emailAddress(localPart: "sender", domain: "example.com"),
            replyTo: try emailAddress(localPart: "reply", domain: "example.com"),
            cc: [try emailAddress(localPart: "cc", domain: "example.com")],
            bcc: [try emailAddress(localPart: "bcc", domain: "example.com")],
            date: .test,
            subject: "Complete Email",
            body: .text("Test body"),
            additionalHeaders: [
                try RFC_5322.Header("X-Custom-Header: custom-value"),
                try RFC_5322.Header("X-Priority: 1"),
            ]
        )

        let message = try AppleMail.Message(from: email)
        let emlContent = message.description

        #expect(emlContent.contains("To: to1@example.com"))
        #expect(emlContent.contains("to2@example.com"))
        #expect(emlContent.contains("Cc: cc@example.com"))
        #expect(emlContent.contains("Reply-To: reply@example.com"))
        #expect(!emlContent.contains("Bcc:"))
        #expect(emlContent.contains("X-Custom-Header: custom-value"))
        #expect(emlContent.contains("X-Priority: 1"))
        #expect(emlContent.contains("X-Apple-Base-Url: x-msg://1/"))
    }

    @Test
    func `rendered output is a structurally valid eml message`() throws {
        let email = try Email(
            to: [try emailAddress(localPart: "recipient", domain: "example.com")],
            from: try emailAddress(localPart: "sender", domain: "example.com"),
            subject: "Test",
            text: "Test content",
            date: .test
        )

        let message = try AppleMail.Message(from: email)
        let emlContent = message.description

        #expect(emlContent.contains("From: "))
        #expect(emlContent.contains("To: "))
        #expect(emlContent.contains("Subject: "))
        #expect(emlContent.contains("Date: "))
        #expect(emlContent.contains("Message-ID: "))
        #expect(emlContent.contains("Content-Type: "))

        #expect(emlContent.contains("\r\n\r\n"))
        #expect(emlContent.contains("\r\n"))
    }
}
