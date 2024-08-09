import OpenAPIRuntime
import HTTPTypes

/// A struct representing an expectation to be used in building a specification.
public struct Expect: SpecBuilderParameter {
    // The expectation to be used in the specification.
    let expectation: Expectation

    /// Initializes an `Expect` instance with a block to be executed.
    ///
    /// - Parameters:
    ///   - block: A closure that takes an `HTTPResponse` and `HTTPBody` and performs an asynchronous operation.
    public init(
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.expectation = .init(block: block)
    }

    /// Builds the specification by adding the expectation.
    ///
    /// - Parameter spec: The specification to be modified.
    public func build(_ spec: inout Spec) {
        spec.addExpectation(expectation.block)
    }
}

// MARK: - convenience init

public extension Expect {

    /// Initializes an `Expect` instance with a status code to be expected.
    ///
    /// - Parameters:
    ///   - status: The HTTP response status to be expected.
    init(_ status: HTTPResponse.Status) {
        self.expectation = .status(status)
    }

    /// Initializes an `Expect` instance with a header to be expected.
    ///
    /// - Parameters:
    ///   - name: The name of the HTTP header field to be expected.
    ///   - block: An optional closure that takes a `String` and performs an asynchronous operation.
    init(
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) {
        self.expectation = .header(name: name, block: block)
    }
}
