//
//  MockExecutor.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

@testable import FeatherSpec

/// A mock executor that returns a fixed response.
struct MockExecutor: SpecExecutor {

    /// The todo instance used to generate the response body.
    let todo: Todo

    /// Executes a request and returns a canned response.
    func execute(
        req: HTTPRequest,
        body: HTTPBody
    ) async throws -> (response: HTTPResponse, body: HTTPBody) {
        (
            response: .init(
                status: .ok,
                headerFields: [
                    .contentType: "application/json; charset=utf-8",
                    .contentLength: "18",
                ]
            ),
            body: todo.httpBody
        )
    }
}
