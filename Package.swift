// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-spec",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FeatherSpec", targets: ["FeatherSpec"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0-alpha.1"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "FeatherSpec", dependencies: [
            .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        ]),
        .testTarget(name: "FeatherSpecTests", dependencies: [
            .target(name: "FeatherSpec"),
        ]),
    ]
    
    // https://rryam.github.io/MusadoraKit/documentation/musadorakit/
    
    // https://feather-framework.github.io/feather-spec/documentation/
    
    // https://feather-framework.github.io/feather-spec/documentation/
    // https://feather-framework.github.io/feather-spec/documentation/
    // https://feather-framework.github.io/feather-spec/documentation/feather-spec
    
    // https://docs.hummingbird.codes/1.0/documentation/hummingbird/
)
