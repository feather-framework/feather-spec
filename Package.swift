// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-openapi-spec",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FeatherOpenAPISpec", targets: ["FeatherOpenAPISpec"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0-alpha.1"),
        
    ],
    targets: [
        .target(name: "FeatherOpenAPISpec", dependencies: [
            .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        ]),
        .testTarget(name: "FeatherOpenAPISpecTests", dependencies: [
            .target(name: "FeatherOpenAPISpec"),
        ]),
    ]
)
