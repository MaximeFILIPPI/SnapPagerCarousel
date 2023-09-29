// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SnapPagerCarousel",
    platforms: [
        .macOS(.v14), .iOS(.v17), .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SnapPagerCarousel",
            targets: ["SnapPagerCarousel"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SnapPagerCarousel"),
        .testTarget(
            name: "SnapPagerCarouselTests",
            dependencies: ["SnapPagerCarousel"]),
    ]
)
