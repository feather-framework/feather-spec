//
//  File.swift
//
//
//  Created by Tibor Bodecs on 23/11/2023.
//

import OpenAPIRuntime
import HTTPTypes
import XCTest

public struct Expectation: SpecBuilderParameter {
    let file: StaticString
    let line: UInt
    let block: ((HTTPResponse, HTTPBody) async throws -> Void)

    public init(
        file: StaticString = #file,
        line: UInt = #line,
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.file = file
        self.line = line
        self.block = block
    }

    public init(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) {
        self.init { response, _ in
            XCTAssertEqual(response.status, status, file: file, line: line)
        }
    }

    public func build(_ spec: inout Spec) {
        spec.addExpectation(file: file, line: line, block)
    }
}
