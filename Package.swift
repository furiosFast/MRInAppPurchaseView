// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MRInAppPurchaseList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "MRInAppPurchaseList", targets: ["MRInAppPurchaseList"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwifterSwift/SwifterSwift.git", from: "5.1.0"),
    ],
    targets: [
        .target(name: "MRInAppPurchaseList", dependencies: [
            .byName(name: "MRPurchaseButton"),
            .product(name: "SwifterSwift", package: "SwifterSwift"),
        ], resources: [.process("Resources")]),
        .binaryTarget(name: "MRPurchaseButton", path: "MRPurchaseButton/build/MRPurchaseButton.xcframework"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
