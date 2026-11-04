# swift-email-html

Use this package when you write the HTML body of an email as Swift views, or want to save an `Email` as an .eml file that Apple Mail opens as a draft. For the body, start from `Email.Document` and fill it with `Email.VStack`, `Email.Header`, `Email.Paragraph` and `Email.Link`. For the file, start from `AppleMail.Message`. If you want to compose and send emails, use swift-email.

## Laws

- `AppleMail.Message` is the email as an RFC 5322 message with six Apple Mail headers appended after the email's own headers, and an Apple Mail `MIME-Version` value. Its `description` is the .eml text, with CRLF line endings.
- Bcc recipients never appear in an `AppleMail.Message`.
- Without a `universalUUID`, each `AppleMail.Message` gets a fresh random version 4 UUID in its `X-Universally-Unique-Identifier` header.
- `Email.Document` puts the preheader first in the body as hidden text, so mail clients show it in the inbox preview but not in the message. The content goes inside a full-width table with role presentation, so your content must be table rows.
- `Email.Document` uses the primary background color unless you set one. In dark mode a media query sets the dark variant on the body and every table, cell and div, with `!important`.
- `Email.Header` clamps its level to 1 through 6, and sizes each level like a browser's default heading.
- `Email.Link` renders as an anchor styled as a button, never as a `<button>`. By default its colors are the primary text and background colors reversed.
- `Email.VStack` is a block, not a flex container. Its alignment sets the text alignment of its content.
