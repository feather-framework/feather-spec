//
//  FeatherOpenAPISpecTests.swift
//  FeatherOpenAPISpecTests
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import Foundation
import XCTest
import OpenAPIRuntime
import HTTPTypes
import FeatherOpenAPISpec

enum SomeError: Error {
    case foo
}

struct Todo: Codable {
    let title: String
}

public struct Custom: SpecBuilderParameter {
    var expectation: Expectation

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


final class FeatherOpenAPISpecTests: XCTestCase {

    func test(using runner: SpecRunner) async throws {
        let body = HTTPBody()

        try await SpecBuilder {
            Method(.post)
            Path("todos")
            Header(.contentType, "application/json")
            Body(body)
            Expect(.ok)
            Expect(.contentType) {
                XCTAssertEqual($0, "application/json; charset=utf-8")
            }
            Expect { response, body in

            }
            Custom { _, _ in
                
            }
        }
        .build(using: runner)
        .test()

        var spec = Spec(runner: runner)
        spec.setMethod(.post)
        spec.setPath("todos")
        spec.setBody(body)
        spec.setHeader(.contentType, "application/json")
        spec.addExpectation(.ok)
        spec.addExpectation(.contentType) {
            XCTAssertEqual($0, "application/json; charset=utf-8")
        }
        spec.addExpectation { response, body in

        }
        try await spec.test()

        try await Spec(runner: runner)
            .post("todos")
            .header(.contentType, "application/json")
            .body(body)
            .expect(.ok)
            .expect(.contentType) {
                XCTAssertEqual($0, "application/json; charset=utf-8")
            }
            .expect { response, body in

            }
            .test()
    }
}
