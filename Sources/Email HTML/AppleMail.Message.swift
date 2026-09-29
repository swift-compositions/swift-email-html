public import Email_Standard
public import RFC_4122
public import RFC_5322
import Binary
import RFC_5322_Coder
import UUIDs

extension AppleMail {

    public struct Message {

        let message: RFC_5322.Message

        let universalUUID: RFC_4122.UUID

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

            let composed: RFC_5322.Message
            do throws(RFC_5322.Message.Error) {
                composed = try RFC_5322.Message(
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
                    mimeVersion: Self.mimeVersion
                )
            } catch {
                throw .conversion(.message(error))
            }

            self.message = composed
            self.universalUUID = universalUUID
        }

        public init(from email: Email) throws(AppleMail.Message.Error) {

            let generate: () throws(Random.Error) -> RFC_4122.UUID = RFC_4122.UUID.v4
            let universalUUID: RFC_4122.UUID
            do {
                universalUUID = try generate()
            } catch {
                throw .identifier(error)
            }
            try self.init(from: email, universalUUID: universalUUID)
        }
    }
}

extension AppleMail.Message {

    static let mimeVersion: Swift.String = "1.0 (Mac OS X Mail 16.0 \\(3826.700.71\\))"

    static func headers(universalUUID: RFC_4122.UUID) -> [RFC_5322.Header] {
        [
            Self.header("X-Apple-Base-Url", "x-msg://1/"),
            Self.header("X-Universally-Unique-Identifier", Swift.String(universalUUID)),
            Self.header("X-Apple-Mail-Remote-Attachments", "YES"),
            Self.header("X-Apple-Windows-Friendly", "1"),
            Self.header("X-Apple-Mail-Signature", ""),
            Self.header("X-Uniform-Type-Identifier", "com.apple.mail-draft"),
        ]
    }

    private static func header(_ name: Swift.String, _ value: Swift.String) -> RFC_5322.Header {
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

    public var description: Swift.String {
        Swift.String(message)
    }
}

extension AppleMail.Message {

    public var rfc5322Message: RFC_5322.Message {
        message
    }
}
