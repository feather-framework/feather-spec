# Feather Spec

Declarative HTTP specification testing for Swift, providing a shared API surface for runners and executors.

[![Release: 1.0.0-beta.2](https://img.shields.io/badge/Release-1.0.0--beta.2-F05138)]( https://github.com/feather-framework/feather-spec/releases/tag/1.0.0-beta.2)

## Features

- Declarative, fluent spec builder API
- Designed for modern Swift concurrency
- Extensible runner and executor protocols
- Unit tests and code coverage

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: Linux, macOS, iOS, tvOS, watchOS, visionOS](https://img.shields.io/badge/Platforms-Linux_%7C_macOS_%7C_iOS_%7C_tvOS_%7C_watchOS_%7C_visionOS-F05138)

- Swift 6.1+
- Platforms:
  - Linux
  - macOS 15+
  - iOS 18+
  - tvOS 18+
  - watchOS 11+
  - visionOS 2+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-spec", exact: "1.0.0-beta.2"),
```

Then add `FeatherSpec` to your target dependencies:

```swift
.product(name: "FeatherSpec", package: "feather-spec"),
```

## Usage

[![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)](https://feather-framework.github.io/feather-spec/)

API documentation is available at the following link. Refer to the mock objects in the Tests directory if you want to build a custom runner or executor implementation.

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Server-side runtimes

The following Swift server-side runtime integrations are available:

- [Feather Vapor Spec](https://github.com/feather-framework/feather-vapor-spec)
- [Feather Hummingbird Spec](https://github.com/feather-framework/feather-hummingbird-spec)

## Development

- Build: `swift build`
- Test:
  - local: `make test`
  - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-spec/pulls) are welcome. Please keep changes focused and include tests for new logic.
