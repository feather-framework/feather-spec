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
    ///
    public func execute(
        _ spec: Spec
    ) async throws {
        try await self.execute(
            req: spec.request,
            body: spec.body
        )
    }

    /// Executes a given `SpecBuilder` asynchronously.
    /// - Parameter builder: The `SpecBuilder` instance to be executed.
    ///
    public func execute(
        _ builder: SpecBuilder
    ) async throws {
        try await execute(builder.build())
    }

    /// Executes a given `SpecBuilderParameter` asynchronously using a builder block.
    /// - Parameter parameterBuilderBlock: A closure that returns a `SpecBuilderParameter`.
    ///
    public func execute(
        @SpecBuilder parameterBuilderBlock: () -> SpecBuilderParameter
    ) async throws {
        try await execute(
            .init(
                parameterBuilderBlock: parameterBuilderBlock
            )
        )
    }
}