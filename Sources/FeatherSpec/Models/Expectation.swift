//
//  Expectation.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import HTTPTypes
import OpenAPIRuntime
import XCTest

/// Spec Expectation
public struct Expectation {
    
    /// file
    public let file: StaticString
    /// line
    public let line: UInt
    /// block
    public let block: ((HTTPResponse, HTTPBody) async throws -> Void)
    
    /// init an Expectation
    /// - Parameters:
    ///   - file: file
    ///   - line: line
    ///   - block: Closure
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
    
    /// Expectation for a HTTPResponse.Status
    /// - Parameters:
    ///   - file: file
    ///   - line: line
    ///   - status: HTTPResponse.Status
    /// - Returns: Expectation
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
    
    /// Expectation for a HTTP header, with a HTTPField.Name
    /// - Parameters:
    ///   - file: file
    ///   - line: line
    ///   - name: HTTPField.Name
    ///   - block: Closure
    /// - Returns: Expectation
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
