# swift-email-html

![Development Status](https://img.shields.io/badge/status-pre--cutover_integration_package-orange.svg)

HTML rendering for [swift-email](https://github.com/swift-foundations/swift-email).

> **Status: pre-cutover integration package.** This package is the home for
> swift-email's client-facing rendering surface. The live surface today is
> the Apple Mail `.eml` format; the HTML rendering pipeline itself is staged
> under `Parked/` and does not compile until its dependencies exist in the
> institute HTML stack (see `Parked/Email/README.md`).

## Overview

`import Email_HTML` provides:

- `AppleMail.Message` — wraps an `Email` as an RFC 5322 message carrying the
  Apple-specific headers Apple Mail applications expect. `description`
  renders the complete `.eml` content. Conversion failures throw a typed
  error; a fresh RFC 4122 identifier is generated when none is supplied.

The Email compose model and the RFC 5322 vocabulary are re-exported, so the
import is self-contained.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-email-html.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Email HTML", package: "swift-email-html")
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
    body: "Hello, World!"
)

let message = try AppleMail.Message(from: email)
let emlContent = message.description
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
