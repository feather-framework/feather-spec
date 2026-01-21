//
//  SpecBuilder.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// A result builder for building HTTP request specifications.
///
/// This powers the DSL syntax used to compose request parameters and expectations.
@resultBuilder
public struct SpecBuilder {

    /// The root builder parameter.
    ///
    /// This is produced by the builder closure and applied during `build()`.
    var root: SpecBuilderParameter

    /// Initializes a `SpecBuilder` instance with the specified builder closure.
    ///
    /// The closure is evaluated immediately to capture the root parameter.
    ///
    /// - Parameter parameterBuilderBlock: The closure containing the specification building code.
    public init(
        @SpecBuilder parameterBuilderBlock: () -> SpecBuilderParameter
    ) {
        root = parameterBuilderBlock()
    }

    /// Builds a specification using the provided runner.
    ///
    /// The returned spec is ready to be executed by a `SpecExecutor`.
    ///
    /// - Returns: The built specification.
    public func build() -> Spec {
        var spec = Spec()
        root.build(&spec)
        return spec
    }

    // MARK: - Builders

    /// Creates a combined builder from multiple builder parameters.
    ///
    /// Parameters are applied in the order they appear in the DSL.
    public static func buildBlock(
        _ params: SpecBuilderParameter...
    ) -> SpecBuilderParameter {
        Combined(params: params)
    }

    /// Creates a builder from a single builder parameter.
    ///
    /// This supports single-expression builder blocks.
    public static func buildBlock(
        _ param: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        param
    }

    /// Creates an empty builder.
    ///
    /// Used for empty branches in control flow.
    public static func buildBlock() -> Empty {
        Empty()
    }

    /// Creates a builder from an optional builder parameter.
    ///
    /// A `nil` parameter results in an empty builder.
    public static func buildIf(
        _ param: SpecBuilderParameter?
    ) -> SpecBuilderParameter {
        param ?? Empty()
    }

    /// Creates a builder from either the first or second builder parameter.
    ///
    /// Used to support `if/else` branching in the DSL.
    public static func buildEither(
        first: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        first
    }

    /// Creates a builder from either the first or second builder parameter.
    ///
    /// Used to support `if/else` branching in the DSL.
    public static func buildEither(
        second: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        second
    }
}
