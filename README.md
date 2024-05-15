# Feather Spec

The `FeatherSpec` library provides a declarative unit testing tool.

## Getting started

⚠️ This repository is a work in progress, things can break until it reaches v1.0.0. 

Use at your own risk.

### Adding the dependency

To add a dependency on the package, declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/feather-framework/feather-spec", .upToNextMinor(from: "0.3.0")),
```

and to your application target, add `FeatherService` to your dependencies:

```swift
.product(name: "FeatherSpec", package: "feather-spec")
```

Example `Package.swift` file with `FeatherService` as a dependency:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "my-application",
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-spec", .upToNextMinor(from: "0.3.0")),
    ],
    targets: [
        .target(name: "MyApplication", dependencies: [
            .product(name: "FeatherSpec", package: "feather-spec")
        ]),
        .testTarget(name: "MyApplicationTests", dependencies: [
            .target(name: "MyApplication"),
        ]),
    ]
)
```

###  Using FeatherService

See the `FeatherServiceTests` target for a basic service implementation.

[Documentation](https://feather-framework.github.io/feather-spec/documentation/featherspec)
