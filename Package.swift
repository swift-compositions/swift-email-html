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

        .library(name: "Email HTML", targets: ["Email HTML"]),

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

                .product(name: "UUIDs", package: "swift-uuids"),
            ]
        ),
        .target(
            name: "Email HTML Rendering",
            dependencies: [

                .product(name: "Email Standard", package: "swift-email-standard"),

                .product(name: "HTML", package: "swift-html"),

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
