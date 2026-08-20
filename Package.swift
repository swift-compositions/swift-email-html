// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-email-html",
    platforms: [
        .iOS(.v27),
        .macOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        // Client-facing email rendering over the Email compose model. Live
        // surface today: the Apple Mail .eml format. Carries no HTML dependency
        // — keep it that way; the HTML-email surface is a separate opt-in
        // product below.
        .library(name: "Email HTML", targets: ["Email HTML"]),

        // The email HTML document shell and its email-safe components
        // (Email.Document / VStack / Header / Paragraph / Link). Vended as its
        // own product so a consumer can take the email-HTML surface — and its
        // HTML-tower resolve closure — WITHOUT it being forced on every
        // consumer of "Email HTML".
        .library(name: "Email HTML Rendering", targets: ["Email HTML Rendering"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-standards/swift-email-standard.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-foundations/swift-uuids.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-4122.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-5322.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-html.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-css.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Email HTML",
            dependencies: [
                .product(name: "Email Standard", package: "swift-email-standard"),
                .product(name: "RFC 4122", package: "swift-rfc-4122"),
                .product(name: "RFC 5322", package: "swift-rfc-5322"),
                // L3 unifier binding the parameterless RFC_4122.UUID.v4()
                // to the platform CSPRNG.
                .product(name: "UUIDs", package: "swift-uuids"),
            ]
        ),
        .target(
            name: "Email HTML Rendering",
            dependencies: [
                // The `Email` namespace this target extends with the document
                // shell and its components.
                .product(name: "Email Standard", package: "swift-email-standard"),
                // The HTML umbrella (@_exported: CSS, CSS Theming, Color,
                // HTML Rendering, HTML Standard, Markdown HTML Rendering, SVG).
                .product(name: "HTML", package: "swift-html"),
                // Font / DarkModeColor.theme semantic tokens. Already inside the
                // HTML umbrella's closure; named directly because this target's
                // public API mentions its types.
                .product(name: "CSS Theming", package: "swift-css"),
            ]
        ),
        .testTarget(
            name: "Email HTML Tests",
            dependencies: [
                "Email HTML"
            ]
        ),
        .testTarget(
            name: "Email HTML Rendering Tests",
            dependencies: [
                "Email HTML Rendering"
            ]
        ),
    ]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        ]
}
