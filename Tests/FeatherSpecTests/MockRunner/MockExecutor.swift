//
//  MockExecutor.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

@testable import FeatherSpec

/// A mock executor that returns a fixed response.
///
/// This is used to validate spec behavior without real network calls.
struct MockExecutor: SpecExecutor {

    /// The todo instance used to generate the response body.
    ///
    /// This is encoded into the returned `HTTPBody`.
    let todo: Todo
    /// The response status to return.
    ///
    /// Defaults to `.ok` when not overridden.
    let status: HTTPResponse.Status
    /// The response headers to return.
    ///
    /// These are injected into the mock response.
    let headerFields: HTTPFields

    /// Initializes a mock executor with configurable response values.
    ///
    /// This allows tests to exercise different response scenarios.
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
    ///
    /// The request input is ignored by the mock.
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
