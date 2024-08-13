import HTTPTypes
import OpenAPIRuntime

/// A protocol defining the interface for running HTTP request specifications.
public protocol SpecExecutor {

    /// Executes an HTTP request specification asynchronously.
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

extension SpecExecutor {

    /// Executes a given `Spec` asynchronously.
    /// - Parameter spec: The `Spec` instance to be executed.
    /// - Throws: error
    public func execute(
        _ spec: Spec
    ) async throws {
        try await spec.run(using: self)
    }

    /// Executes a given `SpecBuilder` asynchronously.
    /// - Parameter builder: The `SpecBuilder` instance to be executed.
    /// - Throws: error
    public func execute(
        _ builder: SpecBuilder
    ) async throws {
        let spec = builder.build()
        try await spec.run(using: self)
    }

    /// Executes a given `SpecBuilderParameter` asynchronously using a builder block.
    /// - Parameter parameterBuilderBlock: A closure that returns a `SpecBuilderParameter`.
    /// - Throws: error
    public func execute(
        @SpecBuilder parameterBuilderBlock: () -> SpecBuilderParameter
    ) async throws {
        let spec = SpecBuilder(
            parameterBuilderBlock: parameterBuilderBlock
        ).build()
        try await spec.run(using: self)
    }
}
