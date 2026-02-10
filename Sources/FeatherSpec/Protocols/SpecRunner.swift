//
//  SpecRunner.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// SpecRunner.
///
/// Conforming types provide the execution environment for one or more specs.
public protocol SpecRunner: Sendable {

    /// Asynchronously tests a specification.
    ///
    /// Implementations typically bridge to a concrete `SpecExecutor`.
    ///
    /// - Parameter block: A closure that takes a `SpecExecutor` and performs asynchronous operations.
    /// - Throws: error
    func test(block: @escaping @Sendable (SpecExecutor) async throws -> Void)
        async throws
}

// NOTE: result type?
/// Default `SpecRunner` helpers.
///
/// These overloads compose common inputs into a single execution flow.
extension SpecRunner {

    /// Runs multiple `Spec` instances asynchronously.
    ///
    /// Each spec is executed in sequence using the same executor instance.
    /// - Parameter specs: A variadic list of `Spec` instances to be executed.
    /// - Throws: error
    public func run(
        _ specs: Spec...
    ) async throws {
        try await run(specs)
    }

    /// Runs an array of `Spec` instances asynchronously.
    ///
    /// Useful when specs are collected dynamically.
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
    ///
    /// This builds the spec immediately before execution.
    /// - Parameter builder: The `SpecBuilder` instance to be executed.
    /// - Throws: error
    public func run(
        _ builder: SpecBuilder
    ) async throws {
        try await run(builder.build())
    }

    /// Runs a given `SpecBuilderParameter` asynchronously using a builder block.
    ///
    /// This enables inline DSL usage without manually creating a `SpecBuilder`.
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
