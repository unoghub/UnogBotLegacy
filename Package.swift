// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "UnogBot",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "UnogBot",
            targets: ["UnogBot"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/DiscordBM/DiscordBM", branch: "main"),
        .package(url: "https://github.com/DiscordBM/DiscordLogger", from: "1.0.0-beta.1"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.1.0"),
        .package(url: "https://github.com/swiftpackages/DotEnv.git", from: "3.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "UnogBot",
            dependencies: [
                .product(name: "DiscordBM", package: "DiscordBM"),
                .product(name: "DiscordLogger", package: "DiscordLogger"),
                .product(name: "DotEnv", package: "DotEnv"),
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
            ]
        ),
    ]
)
