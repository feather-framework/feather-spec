//
//  ExpectBuilderParam.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import OpenAPIRuntime
import HTTPTypes
import XCTest

/// A struct representing an expectation to be used in building a specification.
public struct Expect: SpecBuilderParameter {
    // The expectation to be used in the specification.
    let expectation: Expectation

    /// Initializes an `Expect` instance with a block to be executed.
    ///
    /// - Parameters:
    ///   - file: The file where the expectation is defined. Defaults to the current file.
    ///   - line: The line number where the expectation is defined. Defaults to the current line.
    ///   - block: A closure that takes an `HTTPResponse` and `HTTPBody` and performs an asynchronous operation.
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

    /// Builds the specification by adding the expectation.
    ///
    /// - Parameter spec: The specification to be modified.
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

    /// Initializes an `Expect` instance with a status code to be expected.
    ///
    /// - Parameters:
    ///   - file: The file where the expectation is defined. Defaults to the current file.
    ///   - line: The line number where the expectation is defined. Defaults to the current line.
    ///   - status: The HTTP response status to be expected.
    init(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) {
        self.expectation = .status(file: file, line: line, status)
    }

    /// Initializes an `Expect` instance with a header to be expected.
    ///
    /// - Parameters:
    ///   - file: The file where the expectation is defined. Defaults to the current file.
    ///   - line: The line number where the expectation is defined. Defaults to the current line.
    ///   - name: The name of the HTTP header field to be expected.
    ///   - block: An optional closure that takes a `String` and performs an asynchronous operation.
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
