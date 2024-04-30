//
//  Spec.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import XCTest
import HTTPTypes
import OpenAPIRuntime

/// Spec
public struct Spec {
    
    /// HTTPRequest
    public private(set) var request: HTTPRequest
    /// HTTPBody
    public private(set) var body: HTTPBody
    /// expectations
    private var expectations: [Expectation]
    /// executor
    private var executor: SpecRunner
    
    /// init a Spec
    /// - Parameter runner: SpecRunner
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

    // MARK: - mutating functions
    
    /// set request path
    /// - Parameter path: request path
    public mutating func setPath(_ path: String?) {
        request.path = path
    }
    
    /// set request method
    /// - Parameter method: request method
    public mutating func setMethod(_ method: HTTPRequest.Method) {
        request.method = method
    }
    
    /// add a request header
    /// - Parameters:
    ///   - name: header name
    ///   - value: header vakue
    public mutating func setHeader(_ name: HTTPField.Name, _ value: String) {
        request.headerFields.append(.init(name: name, value: value))
    }
    
    /// add a request body
    /// - Parameter body: request body
    public mutating func setBody(_ body: HTTPBody) {
        self.body = body
    }
    
    /// add an expectation
    /// - Parameters:
    ///   - file: file
    ///   - line: line
    ///   - block: Closure
    public mutating func addExpectation(
        file: StaticString = #file,
        line: UInt = #line,
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        expectations.append(.init(file: file, line: line, block: block))

    }

    // MARK: - modifier helper
    
    /// modify self
    /// - Parameter modify:Spec
    /// - Returns: Spec
    func modify(_ modify: (inout Self) -> Void) -> Self {
        var mutableSelf = self
        modify(&mutableSelf)
        return mutableSelf
    }

    // MARK: - modifiers
    
    /// set method
    /// - Parameter method HTTPRequest.Method
    /// - Returns: Spec
    public func method(_ method: HTTPRequest.Method) -> Self {
        modify { $0.setMethod(method) }
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: Spec
    public func path(_ path: String) -> Self {
        modify { $0.setPath(path) }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - method: <#method description#>
    ///   - path: <#path description#>
    /// - Returns: Spec
    public func on(
        method: HTTPRequest.Method,
        path: String
    ) -> Self {
        modify {
            $0.setMethod(method)
            $0.setPath(path)
        }
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: Spec
    public func get(_ path: String) -> Self {
        on(method: .get, path: path)
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: Spec
    public func post(_ path: String) -> Self {
        on(method: .post, path: path)
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: Spec
    public func put(_ path: String) -> Self {
        on(method: .put, path: path)
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: Spec
    public func patch(_ path: String) -> Self {
        on(method: .patch, path: path)
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: Spec
    public func head(_ path: String) -> Self {
        on(method: .head, path: path)
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: Spec
    public func delete(_ path: String) -> Self {
        on(method: .delete, path: path)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - value: <#value description#>
    /// - Returns: <#description#>
    public func header(_ name: HTTPField.Name, _ value: String) -> Self {
        modify { $0.setHeader(name, value) }
    }
    
    /// <#Description#>
    /// - Parameter body: <#body description#>
    /// - Returns: <#description#>
    public func body(_ body: HTTPBody) -> Self {
        modify { $0.setBody(body) }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    ///   - block: <#block description#>
    /// - Returns: <#description#>
    public func expect(
        file: StaticString = #file,
        line: UInt = #line,
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) -> Self {
        modify { $0.addExpectation(file: file, line: line, block) }
    }

    // MARK: - test
    
    /// <#Description#>
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    ///   - status: <#status description#>
    mutating func addExpectation(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) {
        expectations.append(
            .status(file: file, line: line, status)
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    ///   - name: <#name description#>
    ///   - block: <#block description#>
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    ///   - status: <#status description#>
    /// - Returns: <#description#>
    func expect(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) -> Self {
        modify { $0.addExpectation(file: file, line: line, status) }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    ///   - name: <#name description#>
    ///   - block: <#block description#>
    /// - Returns: <#description#>
    func expect(
        file: StaticString = #file,
        line: UInt = #line,
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) -> Self {
        modify { $0.addExpectation(file: file, line: line, name, block) }
    }

}
