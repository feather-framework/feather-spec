//
//  Spec.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

/// A structure representing an HTTP request specification.
public struct Spec {

    /// The HTTP request.
    public private(set) var request: HTTPRequest

    /// The HTTP request body.
    public private(set) var body: HTTPBody

    /// The list of expectations associated with the specification.
    private var expectations: [Expectation]

    /// Initializes a `Spec` instance with the given executor.
    public init() {
        self.request = .init(
            method: .get,
            scheme: nil,
            authority: nil,
            path: nil
        )
        self.body = .init()
        self.expectations = []
    }

    // MARK: - Mutating Functions

    /// Sets the path of the HTTP request.
    public mutating func setPath(_ path: String?) {
        request.path = path
    }

    /// Sets the method of the HTTP request.
    public mutating func setMethod(_ method: HTTPRequest.Method) {
        request.method = method
    }

    /// Sets a header field of the HTTP request.
    public mutating func setHeader(_ name: HTTPField.Name, _ value: String) {
        request.headerFields.append(.init(name: name, value: value))
    }

    /// Sets the body of the HTTP request.
    public mutating func setBody(_ body: HTTPBody) {
        self.body = body
    }

    /// Adds an expectation to the specification.
    public mutating func addExpectation(
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        expectations.append(.init(block: block))
    }

    // MARK: - Modifier Helper

    /// Modifies the specification with the given modifier closure.
    private func modify(_ modify: (inout Self) -> Void) -> Self {
        var mutableSelf = self
        modify(&mutableSelf)
        return mutableSelf
    }

    // MARK: - Modifiers

    /// Modifies the method of the HTTP request.
    public func method(_ method: HTTPRequest.Method) -> Self {
        modify { $0.setMethod(method) }
    }

    /// Modifies the path of the HTTP request.
    public func path(_ path: String) -> Self {
        modify { $0.setPath(path) }
    }

    /// Modifies the method and path of the HTTP request.
    public func on(
        method: HTTPRequest.Method,
        path: String
    ) -> Self {
        modify {
            $0.setMethod(method)
            $0.setPath(path)
        }
    }

    /// Modifies the HTTP request method to GET.
    public func get(_ path: String) -> Self {
        on(method: .get, path: path)
    }

    /// Modifies the HTTP request method to POST.
    public func post(_ path: String) -> Self {
        on(method: .post, path: path)
    }

    /// Modifies the HTTP request method to PUT.
    public func put(_ path: String) -> Self {
        on(method: .put, path: path)
    }

    /// Modifies the HTTP request method to PATCH.
    public func patch(_ path: String) -> Self {
        on(method: .patch, path: path)
    }

    /// Modifies the HTTP request method to HEAD.
    public func head(_ path: String) -> Self {
        on(method: .head, path: path)
    }

    /// Modifies the HTTP request method to DELETE.
    public func delete(_ path: String) -> Self {
        on(method: .delete, path: path)
    }

    /// Modifies the header of the HTTP request.
    public func header(_ name: HTTPField.Name, _ value: String) -> Self {
        modify { $0.setHeader(name, value) }
    }

    /// Modifies the body of the HTTP request.
    public func body(_ body: HTTPBody) -> Self {
        modify { $0.setBody(body) }
    }

    /// Adds an expectation to the specification.
    public func expect(
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) -> Self {
        modify { $0.addExpectation(block) }
    }

    // MARK: - Running

    /// Runs the specification asynchronously and verifies expectations.
    public func run(
        using executor: SpecExecutor
    ) async throws {
        let res = try await executor.execute(req: request, body: body)

        for expectation in expectations {
            try await expectation.block(res.response, res.body)
        }
    }
}

/// Convenience `Spec` expectation helpers.
extension Spec {

    /// Adds an expectation for verifying the HTTP response status.
    public mutating func addExpectation(
        _ status: HTTPResponse.Status
    ) {
        expectations.append(
            .status(status)
        )
    }

    /// Adds an expectation for verifying the presence of a specific HTTP header.
    public mutating func addExpectation(
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) {
        expectations.append(
            .header(name: name, block: block)
        )
    }

    // MARK: -

    /// Adds an expectation for verifying the HTTP response status.
    public func expect(
        _ status: HTTPResponse.Status
    ) -> Self {
        modify { $0.addExpectation(status) }
    }

    /// Adds an expectation for verifying the presence of a specific HTTP header.
    public func expect(
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) -> Self {
        modify { $0.addExpectation(name, block) }
    }
}
