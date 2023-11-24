//
//  File.swift
//
//
//  Created by Tibor Bodecs on 23/11/2023.
//

import XCTest
import HTTPTypes
import OpenAPIRuntime

public struct Spec {

    public private(set) var request: HTTPRequest
    public private(set) var body: HTTPBody
    private var expectations: [_Expectation]
    private var executor: SpecRunner

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

    public mutating func setPath(_ path: String?) {
        request.path = path
    }

    public mutating func setMethod(_ method: HTTPRequest.Method) {
        request.method = method
    }

    public mutating func setHeader(_ name: HTTPField.Name, _ value: String) {
        request.headerFields.append(.init(name: name, value: value))
    }

    public mutating func setBody(_ body: HTTPBody) {
        self.body = body
    }

    public mutating func addExpectation(
        file: StaticString = #file,
        line: UInt = #line,
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        expectations.append(.init(file: file, line: line, block: block))

    }

    public mutating func addExpectation(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) {
        expectations.append(
            .init(
                file: file,
                line: line,
                block: { response, body in
                    XCTAssertEqual(
                        response.status,
                        status,
                        file: file,
                        line: line
                    )
                }
            )
        )
    }

    // MARK: - modifier helper

    func modify(_ modify: (inout Self) -> Void) -> Self {
        var mutableSelf = self
        modify(&mutableSelf)
        return mutableSelf
    }

    // MARK: - modifiers

    public func method(_ method: HTTPRequest.Method) -> Self {
        modify { $0.setMethod(method) }
    }

    public func path(_ path: String) -> Self {
        modify { $0.setPath(path) }
    }

    public func on(
        method: HTTPRequest.Method,
        path: String
    ) -> Self {
        modify {
            $0.setMethod(method)
            $0.setPath(path)
        }
    }

    public func get(_ path: String) -> Self {
        on(method: .get, path: path)
    }

    public func post(_ path: String) -> Self {
        on(method: .post, path: path)
    }

    public func put(_ path: String) -> Self {
        on(method: .put, path: path)
    }

    public func patch(_ path: String) -> Self {
        on(method: .patch, path: path)
    }

    public func head(_ path: String) -> Self {
        on(method: .head, path: path)
    }

    public func delete(_ path: String) -> Self {
        on(method: .delete, path: path)
    }

    public func header(_ name: HTTPField.Name, _ value: String) -> Self {
        modify { $0.setHeader(name, value) }
    }

    public func body(_ body: HTTPBody) -> Self {
        modify { $0.setBody(body) }
    }

    public func expect(
        file: StaticString = #file,
        line: UInt = #line,
        _ block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) -> Self {
        modify { $0.addExpectation(file: file, line: line, block) }
    }

    public func expect(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) -> Self {
        modify {
            $0.addExpectation { response, body in
                XCTAssertEqual(response.status, status, file: file, line: line)
            }
        }
    }

    // MARK: - test

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
