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
//        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.5"),
    ],
    targets: [
        .target(
            name: "Declutter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Files"
            ]),
        .testTarget(
            name: "DeclutterTests",
            dependencies: ["Declutter"]),
    ]
)
