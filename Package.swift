// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StaticWebsiteGenerator",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "StaticWebsiteGenerator",
            targets: ["StaticWebsiteGenerator"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", .revision("e516ca9389b64da70b71a461925bbca66f65fe61")),
        .package(url: "https://github.com/kylef/PathKit.git", from: Version(1, 0, 0))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "StaticWebsiteGenerator",
            dependencies: ["PathKit", "Stencil"]),
        .testTarget(
            name: "StaticWebsiteGeneratorTests",
            dependencies: ["StaticWebsiteGenerator"]),
    ]
)
