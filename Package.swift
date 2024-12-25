// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRAppBaseFrameworks",
    platforms: [
        .iOS(.v15)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RRAppNetwork",
            targets: ["RRAppNetwork"]
        ),
        .library(
            name: "RRAppTheme",
            targets: ["RRAppTheme"]
        ),
        .library(
            name: "RRAppUtils",
            targets: ["RRAppUtils"]
        ),
        .library(
            name: "RRAppExtension",
            targets: ["RRAppExtension"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RRAppNetwork",
            dependencies: [
                "RRAppUtils"
            ]
        ),
        .target(
            name: "RRAppTheme"
        ),
        .target(
            name: "RRAppUtils",
            dependencies: [
                "RRAppExtension"
            ]
        ),
        .target(
            name: "RRAppExtension"
        ),
    ]
)
