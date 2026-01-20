//
//  SpecRunner.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// SpecRunner.
public protocol SpecRunner {

    /// Asynchronously tests a specification.
    ///
    /// - Parameter block: A closure that takes a `SpecExecutor` and performs asynchronous operations.
    /// - Throws: error
    func test(
        block: @escaping (SpecExecutor) async throws -> Void
    ) async throws
}

// NOTE: result type?
/// Default `SpecRunner` helpers.
extension SpecRunner {

    /// Runs multiple `Spec` instances asynchronously.
    /// - Parameter specs: A variadic list of `Spec` instances to be executed.
    /// - Throws: error
    public func run(
        _ specs: Spec...
    ) async throws {
        try await run(specs)
    }

    /// Runs an array of `Spec` instances asynchronously.
    /// - Parameter specs: An array of `Spec` instances to be executed.
    /// - Throws: error
    public func run(
        _ specs: [Spec]
    ) async throws {
        try await test { executor in
            for spec in specs {
                try await spec.run(using: executor)
            }
        }
    }

    /// Runs a `SpecBuilder` instance asynchronously.
    /// - Parameter builder: The `SpecBuilder` instance to be executed.
    /// - Throws: error
    public func run(
        _ builder: SpecBuilder
    ) async throws {
        try await run(builder.build())
    }

    /// Runs a given `SpecBuilderParameter` asynchronously using a builder block.
    /// - Parameter parameterBuilderBlock: A closure that returns a `SpecBuilderParameter`.
    /// - Throws: error
    public func run(
        @SpecBuilder parameterBuilderBlock: () -> SpecBuilderParameter
    ) async throws {
        var spec = Spec()
        parameterBuilderBlock().build(&spec)
        try await run(spec)
    }
}
