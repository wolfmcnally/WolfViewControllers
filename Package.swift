// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfViewControllers",
    platforms: [
        .iOS(.v12), .macOS(.v10_13), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "WolfViewControllers",
            type: .dynamic,
            targets: ["WolfViewControllers"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfLog", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLocale", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfViews", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNesting", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfConcurrency", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfStrings", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfGeometry", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfAutolayout", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "WolfViewControllers",
            dependencies: [
                "WolfLog",
                "WolfLocale",
                "WolfViews",
                "WolfNesting",
                "WolfConcurrency",
                "WolfFoundation",
                "WolfStrings",
                "WolfGeometry",
                "WolfAutolayout"
            ])
        ]
)
