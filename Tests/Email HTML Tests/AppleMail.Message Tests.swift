//
//  AppleMail.Message Tests.swift
//  swift-email-html — Email HTML Tests
//

import Testing

@testable import Email_HTML

// MARK: - Fixtures

extension RFC_5322.DateTime {
    /// 2009-02-13T23:31:30Z — a fixed, timezone-stable test timestamp.
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
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Email",
            text: "Hello, World!",
            date: .test
        )

        let message = try AppleMail.Message(from: email)
        let emlContent = message.description

        // RFC 5322 headers.
        #expect(emlContent.contains("From: sender@example.com"))
        #expect(emlContent.contains("To: recipient@example.com"))
        #expect(emlContent.contains("Subject: Test Email"))
        #expect(emlContent.contains("Date: "))
        #expect(emlContent.contains("Message-ID: "))

        // Apple-specific headers.
        #expect(emlContent.contains("Mime-Version: 1.0 (Mac OS X Mail 16.0 \\(3826.700.71\\))"))
        #expect(emlContent.contains("X-Apple-Base-Url: x-msg://1/"))
        #expect(emlContent.contains("X-Universally-Unique-Identifier: "))
        #expect(emlContent.contains("X-Apple-Mail-Remote-Attachments: YES"))
        #expect(emlContent.contains("X-Apple-Windows-Friendly: 1"))
        #expect(emlContent.contains("X-Uniform-Type-Identifier: com.apple.mail-draft"))

        // Body content.
        #expect(emlContent.contains("Hello, World!"))
    }

    @Test
    func `custom universal identifier lands in the Apple header`() throws {
        let customUUID = try RFC_4122.UUID("12345678-1234-1234-1234-123456789ABC")
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
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
            to: [EmailAddress("to@example.com")],
            from: EmailAddress("sender@example.com"),
            bcc: [EmailAddress("bcc@example.com")],
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
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
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
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
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
                EmailAddress("to1@example.com"),
                EmailAddress("to2@example.com"),
            ],
            from: EmailAddress("sender@example.com"),
            replyTo: EmailAddress("reply@example.com"),
            cc: [EmailAddress("cc@example.com")],
            bcc: [EmailAddress("bcc@example.com")],
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
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
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
        // Headers/body separator and CRLF line endings.
        #expect(emlContent.contains("\r\n\r\n"))
        #expect(emlContent.contains("\r\n"))
    }
}
