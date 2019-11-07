// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "WolfViewControllers",
    platforms: [
        .iOS(.v12), .macOS(.v10_13), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "WolfViewControllers",
            targets: ["WolfViewControllers"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfCore", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLog", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLocale", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfViews", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "WolfViewControllers",
            dependencies: [
                "WolfCore",
                "WolfLog",
                "WolfLocale",
                "WolfViews",
            ])
        ]
)
