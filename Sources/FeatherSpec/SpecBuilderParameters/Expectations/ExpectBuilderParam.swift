//
//  ExpectBuilderParam.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

/// A struct representing an expectation to be used in building a specification.
///
/// Expectations are executed after the request completes.
public struct Expect: SpecBuilderParameter {
    // The expectation to be used in the specification.
    let expectation: Expectation

    /// Initializes an `Expect` instance with a block to be executed.
    ///
    /// The block is wrapped into an `Expectation` for deferred execution.
    ///
    /// - Parameter block: A closure that takes an `HTTPResponse` and `HTTPBody` and performs an asynchronous operation.
    public init(
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.expectation = .init(block: block)
    }

    /// Builds the specification by adding the expectation.
    ///
    /// Expectations are evaluated in the order they are added.
    ///
    /// - Parameter spec: The specification to be modified.
    public func build(_ spec: inout Spec) {
        spec.addExpectation(expectation.block)
    }
}

// MARK: - convenience init

/// Convenience `Expect` initializers.
///
/// These create common expectation types without custom blocks.
extension Expect {

    /// Initializes an `Expect` instance with a status code to be expected.
    ///
    /// The expectation fails if the response status does not match.
    ///
    /// - Parameter status: The HTTP response status to be expected.
    public init(_ status: HTTPResponse.Status) {
        self.expectation = .status(status)
    }

    /// Initializes an `Expect` instance with a header to be expected.
    ///
    /// An optional validation block can inspect the header value.
    ///
    /// - Parameters:
    ///   - name: The name of the HTTP header field to be expected.
    ///   - block: An optional closure that takes a `String` and performs an asynchronous operation.
    public init(
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) {
        self.expectation = .header(name: name, block: block)
    }
}
