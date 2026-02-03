//
//  Expectation.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

/// A structure representing an expectation to be used in building specifications.
///
/// Expectations encapsulate async validation logic for responses.
public struct Expectation: Sendable {

    /// A closure representing the expectation block.
    ///
    /// The block receives the response and body produced by the executor.
    public let block: (@Sendable (HTTPResponse, HTTPBody) async throws -> Void)

    /// Initializes an `Expectation` instance with the specified parameters.
    ///
    /// The provided block is stored for deferred execution.
    ///
    /// - Parameter block: The closure representing the expectation block.
    public init(
        block: @escaping @Sendable (HTTPResponse, HTTPBody) async throws -> Void
    ) {
        self.block = block
    }
}

/// Convenience `Expectation` factories.
///
/// These helpers build common expectations without custom code.
extension Expectation {

    /// Creates an `Expectation` instance for verifying the HTTP response status.
    ///
    /// The expectation throws `Spec.Failure.status` on mismatch.
    ///
    /// - Parameter status: The expected HTTP response status.
    /// - Returns: An `Expectation` instance for verifying the HTTP response status.
    public static func status(
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
    /// The optional block can validate the header value.
    ///
    /// - Parameters:
    ///   - name: The name of the HTTP header field to verify.
    ///   - block: An optional closure to further verify the header value.
    /// - Returns: An `Expectation` instance for verifying the presence of a specific HTTP header.
    public static func header(
        name: HTTPField.Name,
        block: (@Sendable (String) async throws -> Void)? = nil
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
