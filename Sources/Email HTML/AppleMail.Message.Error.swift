//
//  AppleMail.Message.Error.swift
//  swift-email-html — Email HTML
//

public import Email_Standard
public import RFC_4122

extension AppleMail.Message {
    /// A failure composing an Apple Mail message.
    public enum Error: Swift.Error {
        /// The email failed to convert into an RFC 5322 message.
        case conversion(Email.ConversionError)

        /// The universally-unique message identifier failed to generate.
        case identifier(RFC_4122.Random.Error)
    }
}
