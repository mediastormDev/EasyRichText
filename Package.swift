// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyRichText",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v15),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EasyRichText",
            targets: ["EasyRichText"]),
        .library(
            name: "EasyRichTextUI",
            targets: ["EasyRichTextUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EasyRichText",
            dependencies: []),
        .target(
            name: "EasyRichTextUI",
            dependencies: ["EasyRichText"]),
        .testTarget(
            name: "EasyRichTextTests",
            dependencies: ["EasyRichText"]),
    ]
)
