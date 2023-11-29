//
//  ExpectBuilderParam.swift
//  FeatherOpenAPISpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import OpenAPIRuntime
import HTTPTypes
import XCTest

public struct Expect: SpecBuilderParameter {
    let expectation: Expectation

    public init(
        file: StaticString = #file,
        line: UInt = #line,
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.expectation = .init(
            file: file,
            line: line,
            block: block
        )
    }

    public func build(_ spec: inout Spec) {
        spec.addExpectation(
            file: expectation.file,
            line: expectation.line,
            expectation.block
        )
    }
}

// MARK: - convenience init

public extension Expect {

    init(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) {
        self.expectation = .status(file: file, line: line, status)
    }

    init(
        file: StaticString = #file,
        line: UInt = #line,
        _ name: HTTPField.Name,
        _ block: ((String) async throws -> Void)? = nil
    ) {
        self.expectation = .header(
            file: file,
            line: line,
            name: name,
            block: block
        )
    }
}
