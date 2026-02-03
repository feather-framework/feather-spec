//
//  SpecExecutor.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

/// A protocol defining the interface for running HTTP request specifications.
///
/// Executors turn a `Spec` into a concrete HTTP request and return a response.
public protocol SpecExecutor: Sendable {

    /// Executes an HTTP request specification asynchronously.
    ///
    /// Implementations should return the raw response and body for expectation evaluation.
    ///
    /// - Parameters:
    ///   - req: The HTTP request to execute.
    ///   - body: The HTTP request body.
    /// - Returns: A tuple containing the HTTP response and response body.
    /// - Throws: error
    ///
    @discardableResult
    func execute(
        req: HTTPRequest,
        body: HTTPBody
    ) async throws -> (
        response: HTTPResponse,
        body: HTTPBody
    )
}

/// Convenience `SpecExecutor` helpers.
///
/// These overloads wrap different spec inputs into the same execution path.
extension SpecExecutor {

    /// Executes a given `Spec` asynchronously.
    ///
    /// This is a thin wrapper around `Spec.run(using:)`.
    /// - Parameter spec: The `Spec` instance to be executed.
    /// - Throws: error
    public func execute(
        _ spec: Spec
    ) async throws {
        try await spec.run(using: self)
    }

    /// Executes a given `SpecBuilder` asynchronously.
    ///
    /// The builder is evaluated once to produce a `Spec`.
    /// - Parameter builder: The `SpecBuilder` instance to be executed.
    /// - Throws: error
    public func execute(
        _ builder: SpecBuilder
    ) async throws {
        let spec = builder.build()
        try await spec.run(using: self)
    }

    /// Executes a given `SpecBuilderParameter` asynchronously using a builder block.
    ///
    /// This enables DSL usage without explicitly creating a builder.
    /// - Parameter parameterBuilderBlock: A closure that returns a `SpecBuilderParameter`.
    /// - Throws: error
    public func execute(
        @SpecBuilder parameterBuilderBlock: () -> SpecBuilderParameter
    ) async throws {
        let spec = SpecBuilder(
            parameterBuilderBlock: parameterBuilderBlock
        )
        .build()
        try await spec.run(using: self)
    }
}
