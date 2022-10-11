// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MRInAppPurchaseView",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "MRInAppPurchaseView", targets: ["MRInAppPurchaseView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwifterSwift/SwifterSwift.git", from: "5.1.0"),
    ],
    targets: [
        .target(name: "MRInAppPurchaseView", dependencies: [
            .byName(name: "MRInAppPurchaseButton"),
            .product(name: "SwifterSwift", package: "SwifterSwift"),
        ], resources: [.process("Resources")]),
        .binaryTarget(name: "MRInAppPurchaseButton", path: "MRInAppPurchaseButton/build/MRInAppPurchaseButton.xcframework"),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
