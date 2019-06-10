// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfViewControllers",
    platforms: [
        .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "WolfViewControllers",
            targets: ["WolfViewControllers"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfCore", .branch("Swift-5.1")),
        .package(url: "https://github.com/wolfmcnally/WolfLog", .branch("Swift-5.1")),
        .package(url: "https://github.com/wolfmcnally/WolfLocale", .branch("Swift-5.1")),
        .package(url: "https://github.com/wolfmcnally/WolfViews", .branch("Swift-5.1")),
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
