public import Email_Standard
public import UUIDs

extension AppleMail.Message {

    public enum Error: Swift.Error {

        case conversion(Email.ConversionError)

        case identifier(Random.Error)
    }
}
