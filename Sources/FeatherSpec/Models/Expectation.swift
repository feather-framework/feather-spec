//
//  Expectation.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import HTTPTypes
import OpenAPIRuntime
import XCTest

/// A structure representing an expectation to be used in building specifications.
public struct Expectation {
    
    /// The file where the expectation is defined.
    public let file: StaticString
    
    /// The line number where the expectation is defined.
    public let line: UInt
    
    /// A closure representing the expectation block.
    public let block: ((HTTPResponse, HTTPBody) async throws -> Void)
    
    /// Initializes an `Expectation` instance with the specified parameters.
    ///
    /// - Parameters:
    ///   - file: The file where the expectation is defined.
    ///   - line: The line number where the expectation is defined.
    ///   - block: The closure representing the expectation block.
    public init(
        file: StaticString,
        line: UInt,
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.file = file
        self.line = line
        self.block = block
    }
}

public extension Expectation {
    
    /// Creates an `Expectation` instance for verifying the HTTP response status.
    ///
    /// - Parameters:
    ///   - file: The file where the expectation is defined.
    ///   - line: The line number where the expectation is defined.
    ///   - status: The expected HTTP response status.
    /// - Returns: An `Expectation` instance for verifying the HTTP response status.
    static func status(
        file: StaticString = #file,
        line: UInt = #line,
        _ status: HTTPResponse.Status
    ) -> Self {
        .init(
            file: file,
            line: line,
            block: { response, _ in
                XCTAssertEqual(
                    response.status,
                    status,
                    file: file,
                    line: line
                )
            }
        )
    }
    
    /// Creates an `Expectation` instance for verifying the presence of a specific HTTP header.
    ///
    /// - Parameters:
    ///   - file: The file where the expectation is defined.
    ///   - line: The line number where the expectation is defined.
    ///   - name: The name of the HTTP header field to verify.
    ///   - block: An optional closure to further verify the header value.
    /// - Returns: An `Expectation` instance for verifying the presence of a specific HTTP header.
    static func header(
        file: StaticString = #file,
        line: UInt = #line,
        name: HTTPField.Name,
        block: ((String) async throws -> Void)? = nil
    ) -> Self {
        .init(
            file: file,
            line: line,
            block: { response, _ in
                let header = response.headerFields.first {
                    $0.name == name
                }
                let headerField = try XCTUnwrap(
                    header,
                    file: file,
                    line: line
                )
                try await block?(headerField.value)
            }
        )
    }
}
