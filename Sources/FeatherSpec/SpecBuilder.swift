//
//  SpecBuilder.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// A result builder for building HTTP request specifications.
@resultBuilder
public struct SpecBuilder {

    /// The root builder parameter.
    var root: SpecBuilderParameter

    /// Initializes a `SpecBuilder` instance with the specified builder closure.
    ///
    /// - Parameter parameterBuilderBlock: The closure containing the specification building code.
    public init(
        @SpecBuilder parameterBuilderBlock: () -> SpecBuilderParameter
    ) {
        root = parameterBuilderBlock()
    }

    /// Builds a specification using the provided runner.
    ///
    /// - Returns: The built specification.
    public func build() -> Spec {
        var spec = Spec()
        root.build(&spec)
        return spec
    }

    // MARK: - Builders

    /// Creates a combined builder from multiple builder parameters.
    public static func buildBlock(
        _ params: SpecBuilderParameter...
    ) -> SpecBuilderParameter {
        Combined(params: params)
    }

    /// Creates a builder from a single builder parameter.
    public static func buildBlock(
        _ param: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        param
    }

    /// Creates an empty builder.
    public static func buildBlock() -> Empty {
        Empty()
    }

    /// Creates a builder from an optional builder parameter.
    public static func buildIf(
        _ param: SpecBuilderParameter?
    ) -> SpecBuilderParameter {
        param ?? Empty()
    }

    /// Creates a builder from either the first or second builder parameter.
    public static func buildEither(
        first: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        first
    }

    /// Creates a builder from either the first or second builder parameter.
    public static func buildEither(
        second: SpecBuilderParameter
    ) -> SpecBuilderParameter {
        second
    }
}
