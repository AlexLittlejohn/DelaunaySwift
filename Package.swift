// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "DelaunayTriangulation",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v10),
        .tvOS(.v12),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "DelaunayTriangulation",
            targets: ["DelaunayTriangulation"]),
    ],
    targets: [
        .target(
            name: "DelaunayTriangulation",
            dependencies: [],
            path: "DelaunayTriangulation"),
    ]
)
