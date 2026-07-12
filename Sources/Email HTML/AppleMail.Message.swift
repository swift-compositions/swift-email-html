//
//  AppleMail.Message.swift
//  swift-email-html — Email HTML
//
//  Absorbed from swift-email's park (coenttb-ectomy 2026-07-12) and repaired
//  against the current RFC 5322 surface per the park's drift map: typed
//  Header.Name keys, date-before-subject initializer order, and the String
//  conversion in place of the retired render method. The universally-unique
//  identifier moved off Foundation onto RFC 4122.
//

public import Email_Standard
public import RFC_4122
public import RFC_5322

extension AppleMail {
    /// An email message in Apple Mail format.
    ///
    /// Wraps an RFC 5322 message with Apple-specific headers for
    /// compatibility with Apple Mail applications.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let email = try Email(
    ///     to: [EmailAddress("recipient@example.com")],
    ///     from: EmailAddress("sender@example.com"),
    ///     subject: "Hello",
    ///     body: "Hello, World!"
    /// )
    ///
    /// let message = try AppleMail.Message(from: email)
    /// let emlContent = message.description
    /// ```
    public struct Message {
        /// The wrapped RFC 5322 message, Apple headers included.
        let message: RFC_5322.Message

        /// The value of the `X-Universally-Unique-Identifier` header.
        let universalUUID: RFC_4122.UUID

        /// Creates an Apple Mail message from an email.
        ///
        /// Adds the Apple-specific headers to the email's standard RFC 5322
        /// message.
        ///
        /// - Parameters:
        ///   - email: The email to convert.
        ///   - universalUUID: The `X-Universally-Unique-Identifier` header value.
        /// - Throws: ``Error`` when the email fails to convert.
        public init(
            from email: Email,
            universalUUID: RFC_4122.UUID
        ) throws(AppleMail.Message.Error) {
            let base: RFC_5322.Message
            do {
                base = try RFC_5322.Message(from: email)
            } catch {
                throw .conversion(error)
            }

            var headers = base.additionalHeaders
            for header in Self.headers(universalUUID: universalUUID) {
                headers.append(header)
            }

            self.message = RFC_5322.Message(
                from: base.from,
                to: base.to,
                cc: base.cc,
                bcc: base.bcc,
                replyTo: base.replyTo,
                date: base.date,
                subject: base.subject,
                messageId: base.messageId,
                body: base.body,
                additionalHeaders: headers,
                mimeVersion: base.mimeVersion
            )
            self.universalUUID = universalUUID
        }

        /// Creates an Apple Mail message from an email, generating a fresh
        /// universally-unique identifier.
        ///
        /// - Parameter email: The email to convert.
        /// - Throws: ``Error`` when the email fails to convert or the
        ///   identifier fails to generate.
        public init(from email: Email) throws(AppleMail.Message.Error) {
            let universalUUID: RFC_4122.UUID
            do {
                universalUUID = try RFC_4122.UUID.v4()
            } catch {
                throw .identifier(error)
            }
            try self.init(from: email, universalUUID: universalUUID)
        }
    }
}

extension AppleMail.Message {
    /// The Apple-specific headers, with the given identifier.
    ///
    /// Header names and constant values are spec-constant vectors; failing
    /// to construct one is a programmer error and stops the program.
    static func headers(universalUUID: RFC_4122.UUID) -> [RFC_5322.Header] {
        [
            Self.header("Mime-Version", "1.0 (Mac OS X Mail 16.0 \\(3826.700.71\\))"),
            Self.header("X-Apple-Base-Url", "x-msg://1/"),
            Self.header("X-Universally-Unique-Identifier", String(universalUUID)),
            Self.header("X-Apple-Mail-Remote-Attachments", "YES"),
            Self.header("X-Apple-Windows-Friendly", "1"),
            Self.header("X-Apple-Mail-Signature", ""),
            Self.header("X-Uniform-Type-Identifier", "com.apple.mail-draft"),
        ]
    }

    /// Builds a header from constant tokens, stopping the program on an
    /// invalid constant.
    private static func header(_ name: String, _ value: String) -> RFC_5322.Header {
        do {
            return RFC_5322.Header(
                name: try RFC_5322.Header.Name(name),
                value: try RFC_5322.Header.Value(value)
            )
        } catch {
            preconditionFailure("AppleMail: invalid constant header '\(name)': \(error)")
        }
    }
}

extension AppleMail.Message: CustomStringConvertible {
    /// The rendered `.eml` content.
    public var description: String {
        String(message)
    }
}

extension AppleMail.Message {
    /// The underlying RFC 5322 message.
    public var rfc5322Message: RFC_5322.Message {
        message
    }
}
