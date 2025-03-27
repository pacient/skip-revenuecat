// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package,
// containing a Swift Package Manager project
// that will use the Skip build plugin to transpile the
// Swift Package, Sources, and Tests into an
// Android Gradle Project with Kotlin sources and JUnit tests.
import PackageDescription

let package = Package(
    name: "skip-revenuecat",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "SkipRevenueCat", targets: [
            "SkipRevenueCat",
            "SkipRevenueCatLibrary"
        ]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.1.6"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0"),
        .package(url: "https://github.com/RevenueCat/purchases-hybrid-common.git", exact: "13.13.0")
    ],
    targets: [
        .target(
            name: "SkipRevenueCat",
            dependencies: [
                .product(name: "SkipFoundation", package: "skip-foundation"),
                .product(name: "PurchasesHybridCommon", package: "purchases-hybrid-common"),
                .product(name: "PurchasesHybridCommonUI", package: "purchases-hybrid-common"),
                "SkipRevenueCatLibrary"
            ],
            exclude: [
                "../../skip-revenuecat-library/",
                "../../skip-revenuecat-app/"
            ],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        ),
        // .binaryTarget(
        //     name: "SkipRevenueCatLibrary",
        //     path: "./skip-revenuecat-library/skip-revenuecat-library/build/XCFrameworks/release/SkipRevenueCatLibrary.xcframework"
        // ),
            .binaryTarget(
                name: "SkipRevenueCatLibrary",
                url: "https://api.github.com/repos/pacient/skip-revenuecat/releases/assets/241362659.zip",
                checksum: "2d2dc5913cc03d028d4b2cdf3bc9b8302abbdae323df69533d8ee50c02114ced"
            ),

        .testTarget(
            name: "SkipRevenueCatTests",
            dependencies: [
                "SkipRevenueCat",
                .product(name: "SkipTest", package: "skip")
            ],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        )
    ]
)
