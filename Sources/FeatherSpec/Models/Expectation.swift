import HTTPTypes
import OpenAPIRuntime

/// A structure representing an expectation to be used in building specifications.
public struct Expectation {

    /// A closure representing the expectation block.
    public let block: ((HTTPResponse, HTTPBody) async throws -> Void)

    /// Initializes an `Expectation` instance with the specified parameters.
    ///
    /// - Parameter block: The closure representing the expectation block.
    public init(
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.block = block
    }
}

public extension Expectation {

    /// Creates an `Expectation` instance for verifying the HTTP response status.
    ///
    /// - Parameter status: The expected HTTP response status.
    /// - Returns: An `Expectation` instance for verifying the HTTP response status.
    static func status(
        _ status: HTTPResponse.Status
    ) -> Self {
        .init(
            block: { response, _ in
                guard response.status == status else {
                    throw Spec.Failure.status(response.status)
                }
            }
        )
    }

    /// Creates an `Expectation` instance for verifying the presence of a specific HTTP header.
    ///
    /// - Parameters:
    ///   - name: The name of the HTTP header field to verify.
    ///   - block: An optional closure to further verify the header value.
    /// - Returns: An `Expectation` instance for verifying the presence of a specific HTTP header.
    static func header(
        name: HTTPField.Name,
        block: ((String) async throws -> Void)? = nil
    ) -> Self {
        .init(
            block: { response, _ in
                let header = response.headerFields.first {
                    $0.name == name
                }
                guard let header else {
                    throw Spec.Failure.header(name)
                }
                try await block?(header.value)
            }
        )
    }
}
