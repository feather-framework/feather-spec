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
    /// The response status to return.
    let status: HTTPResponse.Status
    /// The response headers to return.
    let headerFields: HTTPFields

    /// Initializes a mock executor with configurable response values.
    init(
        todo: Todo,
        status: HTTPResponse.Status = .ok,
        headerFields: HTTPFields = [
            .contentType: "application/json; charset=utf-8",
            .contentLength: "18",
        ]
    ) {
        self.todo = todo
        self.status = status
        self.headerFields = headerFields
    }

    /// Executes a request and returns a canned response.
    func execute(
        req: HTTPRequest,
        body: HTTPBody
    ) async throws -> (response: HTTPResponse, body: HTTPBody) {
        (
            response: .init(
                status: status,
                headerFields: headerFields
            ),
            body: todo.httpBody
        )
    }
}
