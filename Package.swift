// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-email-html",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
    ],
    products: [
        // Client-facing email rendering over the Email compose model. Live
        // surface today: the Apple Mail .eml format. The HTML rendering
        // pipeline is staged under Parked/ pending the HTML-email story.
        .library(name: "Email HTML", targets: ["Email HTML"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-email-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-4122.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-5322.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Email HTML",
            dependencies: [
                .product(name: "Email Standard", package: "swift-email-standard"),
                .product(name: "RFC 4122", package: "swift-rfc-4122"),
                .product(name: "RFC 5322", package: "swift-rfc-5322"),
            ]
        ),
        .testTarget(
            name: "Email HTML Tests",
            dependencies: [
                "Email HTML"
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
