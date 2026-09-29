# swift-email-html

![Development Status](https://img.shields.io/badge/status-active_development-blue.svg)

HTML rendering for [swift-email](https://github.com/swift-compositions/swift-email).

## Overview

`import Email_HTML` provides:

- `AppleMail.Message` — wraps an `Email` as an RFC 5322 message carrying the
  Apple-specific headers Apple Mail applications expect. `description`
  renders the complete `.eml` content. Conversion failures throw a typed
  error; a fresh RFC 4122 identifier is generated when none is supplied.

`import Email_HTML_Rendering` provides the email-safe HTML component
vocabulary — `Email.Document`, `Email.VStack`, `Email.Header`,
`Email.Paragraph`, `Email.Link`, `Email.Spacing` — built on
[swift-html](https://github.com/swift-compositions/swift-html) and the
CSS theming colors, so a message body is written as HTML views and rendered
into table-based, inline-styled markup.

The Email compose model and the RFC 5322 vocabulary are re-exported, so each
import is self-contained.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-compositions/swift-email-html.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Email HTML", package: "swift-email-html"),
        .product(name: "Email HTML Rendering", package: "swift-email-html"),
    ]
)
```

## Quick Start

```swift
import Email_HTML

let email = try Email(
    to: [EmailAddress("recipient@example.com")],
    from: EmailAddress("sender@example.com"),
    subject: "Hello",
    text: "Hello, World!",
    date: RFC_5322.DateTime(secondsSinceEpoch: 1_234_567_890)
)

let message = try AppleMail.Message(from: email)
let emlContent = message.description
```

Composing the body as HTML instead:

```swift
import Email_HTML_Rendering

let document = Email.Document(preheader: "Verify your email address") {
    tr {
        td {
            Email.VStack(alignment: .start) {
                Email.Header(3) { "Verify your email address" }

                Email.Paragraph { "Please confirm this is your email address." }
                    .padding(bottom: .extraSmall)

                Email.Link(href: .init(value: "https://example.com/verify")) {
                    "Verify email address"
                }
            }
            .padding(vertical: .small, horizontal: .medium)
        }
    }
}
```

## Error Handling

`AppleMail.Message(from:)` throws a typed `AppleMail.Message.Error`:

```
AppleMail.Message.Error
├─ conversion(Email.ConversionError)   // the email failed to convert into an RFC 5322 message
└─ identifier(Random.Error)            // the message identifier failed to generate
```

Because the initializer declares `throws(AppleMail.Message.Error)`, the catch
can be exhaustive over the enum:

```swift
import Email_HTML

do {
    let message = try AppleMail.Message(from: email)
    let emlContent = message.description
} catch .conversion(let conversionError) {
    // The email failed to convert into an RFC 5322 message.
    print("Conversion failed: \(conversionError)")
} catch .identifier(let randomError) {
    // The universally-unique message identifier failed to generate.
    print("Identifier generation failed: \(randomError)")
}
```

## License

Licensed under the [Apache License, Version 2.0](LICENSE.md).
