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
        .package(url: "https://github.com/DiscordBM/DiscordBM.git", from: "1.0.0"),
        .package(url: "https://github.com/DiscordBM/DiscordLogger.git", exact: "1.0.0-rc.2"),
        .package(url: "https://github.com/swiftpackages/DotEnv.git", from: "3.0.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.0.0"),
        .package(url: "https://github.com/Kitura/Swift-JWT.git", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "UnogBot",
            dependencies: [
                .product(name: "DiscordBM", package: "DiscordBM"),
                .product(name: "DiscordLogger", package: "DiscordLogger"),
                .product(name: "SwiftJWT", package: "Swift-JWT"),
                .product(name: "DotEnv", package: "DotEnv"),
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
            ]
        ),
    ]
)
