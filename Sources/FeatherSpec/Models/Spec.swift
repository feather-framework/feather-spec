//
//  Spec.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import XCTest
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
    
    /// The executor responsible for running the specification.
    private var executor: SpecRunner
    
    /// Initializes a `Spec` instance with the given executor.
    ///
    /// - Parameter runner: The executor responsible for running the specification.
    public init(runner: SpecRunner) {
        self.request = .init(
            method: .get,
            scheme: nil,
            authority: nil,
            path: nil
        )
        self.body = .init()
        self.expectations = []
        self.executor = runner
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
        file: StaticString = #file,
        line: UInt = #line,
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        expectations.append(.init(file: file, line: line, block: block))
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
        file: StaticString = #file,
        line: UInt = #line,
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) -> Self {
        modify { $0.addExpectation(file: file, line: line, block) }
    }

    // MARK: - Test
    
    /// Runs the specification asynchronously and verifies expectations.
    public func test() async throws {
        let res = try await executor.execute(req: request, body: body)

        for expectation in expectations {
            do {
                try await expectation.block(res.response, res.body)
            }
            catch {
                XCTFail(
                    "exception: \(error)",
                    file: expectation.file,
                    line: expectation.line
                )
            }
        }
    }
}

public extension Spec {
    
    /// Adds an expectation for verifying the HTTP response status.
    mutating func addExpectation(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) {
        expectations.append(
            .status(file: file, line: line, status)
        )
    }
    
    /// Adds an expectation for verifying the presence of a specific HTTP header.
    mutating func addExpectation(
        file: StaticString = #file,
        line: UInt = #line,
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) {
        expectations.append(
            .header(file: file, line: line, name: name, block: block)
        )
    }

    // MARK: - 
    
    /// Adds an expectation for verifying the HTTP response status.
    func expect(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) -> Self {
        modify { $0.addExpectation(file: file, line: line, status) }
    }
    
    /// Adds an expectation for verifying the presence of a specific HTTP header.
    func expect(
        file: StaticString = #file,
        line: UInt = #line,
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) -> Self {
        modify { $0.addExpectation(file: file, line: line, name, block) }
    }

}
