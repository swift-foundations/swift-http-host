// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-http-host",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27")
    ],
    products: [
        .library(name: "HTTP Host", targets: ["HTTP Host"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-server.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-http-standard.git", branch: "main")
    ],
    targets: [
        .target(
            name: "HTTP Host",
            dependencies: [
                .product(name: "Server", package: "swift-server"),
                .product(name: "HTTP Standard", package: "swift-http-standard")
            ]
        ),
        .testTarget(
            name: "HTTP Host Tests",
            dependencies: ["HTTP Host"]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes")
    ]
}
