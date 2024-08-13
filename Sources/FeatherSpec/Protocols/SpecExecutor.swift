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
