// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Declutter",
    products: [
        .executable(name: "declutter", targets: ["Declutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files.git", from: "3.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.5"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/mxcl/Chalk.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "DeclutterLib",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "Files",
            ]),
        .target(
            name: "Declutter",
            dependencies: [
                "DeclutterLib",
                "Chalk",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "DeclutterLibTests",
            dependencies: ["DeclutterLib"]),
        .testTarget(
            name: "DeclutterTests",
            dependencies: ["Declutter"]),
        
    ]
)
