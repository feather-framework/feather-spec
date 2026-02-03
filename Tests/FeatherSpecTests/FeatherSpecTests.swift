//
//  FeatherSpecTests.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime
import Testing

@testable import FeatherSpec

/// Test suite for `FeatherSpec`.
///
/// Covers the fluent API, DSL builder, and executor integrations.
@Suite
struct FeatherSpecTests {

    /// Shared request path used across tests.
    ///
    /// This keeps expectations consistent across cases.
    let path = "todos"
    /// Shared todo model used across tests.
    ///
    /// The title is asserted in decoding expectations.
    let todo = Todo(title: "task01")
    /// Shared JSON request body used across tests.
    ///
    /// This is derived from the shared todo.
    let body = Todo(title: "task01").httpBody
    /// Shared content type header value used across tests.
    ///
    /// Used to validate header expectations.
    let contentType = "application/json"

    /// Asserts that decoding fails with the expected `HTTPBody.DecodeError`.
    ///
    /// This keeps decode error tests consistent and readable.
    func expectDecodeError(
        _ expected: HTTPBody.DecodeError,
        response: HTTPResponse,
        body: HTTPBody
    ) async {
        do {
            _ = try await body.decode(Todo.self, with: response)
            #expect(Bool(false))
        }
        catch let error as HTTPBody.DecodeError {
            switch (error, expected) {
            case (.missingContentLength, .missingContentLength),
                (.invalidContentLength, .invalidContentLength):
                #expect(Bool(true))
            default:
                #expect(Bool(false))
            }
        }
        catch {
            #expect(Bool(false))
        }
    }

    /// Verifies the mutating `Spec` API.
    @Test
    func testMutatingFuncSpec() async throws {
        let expectedTitle = todo.title
        var spec = Spec()
        spec.setMethod(.post)
        spec.setPath(path)
        spec.setBody(body)
        spec.setHeader(.contentType, contentType)
        spec.addExpectation(.ok)
        spec.addExpectation(.contentType) {
            #expect($0 == "application/json; charset=utf-8")
        }
        spec.addExpectation { response, body in
            let todo = try await body.decode(Todo.self, with: response)
            #expect(todo.title == expectedTitle)
        }

        #expect(spec.request.method == .post)
        #expect(spec.request.path == path)
        #expect(spec.body == body)
        #expect(spec.request.headerFields == [.contentType: contentType])

        let runner = MockRunner(todo: todo)
        try await runner.run(spec)
    }

    /// Verifies the fluent `Spec` API.
    @Test
    func testBuilderFuncSpec() async throws {
        let expectedTitle = todo.title
        let spec = Spec()
            .method(.post)
            .path(path)
            .header(.contentType, contentType)
            .body(body)
            .expect(.ok)
            .expect(.contentType) {
                #expect($0 == "application/json; charset=utf-8")
            }
            .expect { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                #expect(todo.title == expectedTitle)
            }

        #expect(spec.request.method == .post)
        #expect(spec.request.path == path)
        #expect(spec.body == body)
        #expect(spec.request.headerFields == [.contentType: contentType])

        let runner = MockRunner(todo: todo)
        try await runner.run(spec)
    }

    /// Verifies the DSL builder API.
    @Test
    func testDslSpec() async throws {
        let expectedTitle = todo.title
        let spec = SpecBuilder {
            Method(.post)
            Path(path)
            Header(.contentType, contentType)
            Body(body)
            Expect(.ok)
            Expect(.contentType) {
                #expect($0 == "application/json; charset=utf-8")
            }
            Expect { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                #expect(todo.title == expectedTitle)
            }
            Custom { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                #expect(todo.title == expectedTitle)
            }
        }
        .build()

        #expect(spec.request.method == .post)
        #expect(spec.request.path == path)
        #expect(spec.body == body)
        #expect(spec.request.headerFields == [.contentType: contentType])

        let runner = MockRunner(todo: todo)
        try await runner.run(spec)
    }

    /// Verifies building an empty spec.
    @Test
    func testEmptySpec() async throws {
        let _ = SpecBuilder {}.build()
    }

    /// Verifies custom error propagation from expectations.
    @Test
    func testExpectationError() async throws {
        let runner = MockRunner(todo: todo)
        do {
            try await runner.run {
                Custom { response, body in
                    throw CustomError.failure(-1)
                }
            }
        }
        catch CustomError.failure(let value) {
            #expect(value == -1)
        }
    }

    /// Verifies `SpecBuilder` control-flow support.
    @Test
    func testSpecBuilderFunctions() {
        let _ = SpecBuilder {
            let value = Bool.random()
            /// Empty.
            if value {

            }
            /// Empty.
            if !value {

            }
            /// First.
            if value {
                Expect(.ok)
            }
            else {
                Expect(.ok)
            }
            /// Second.
            if !value {
                Expect(.ok)
            }
            else {
                Expect(.ok)
            }
        }
        .build()
    }

    /// Verifies convenience HTTP method helpers.
    @Test
    func testBuilderSpecHelpers() async throws {
        let specGet = Spec().get(path)
        #expect(specGet.request.method == .get)
        #expect(specGet.request.path == path)

        let specPost = Spec().post(path)
        #expect(specPost.request.method == .post)
        #expect(specPost.request.path == path)

        let specPut = Spec().put(path)
        #expect(specPut.request.method == .put)
        #expect(specPut.request.path == path)

        let specPatch = Spec().patch(path)
        #expect(specPatch.request.method == .patch)
        #expect(specPatch.request.path == path)

        let specHead = Spec().head(path)
        #expect(specHead.request.method == .head)
        #expect(specHead.request.path == path)

        let specDelete = Spec().delete(path)
        #expect(specDelete.request.method == .delete)
        #expect(specDelete.request.path == path)
    }

    /// Verifies status expectation errors.
    @Test
    func testStatusError() async throws {
        let runner = MockRunner(todo: todo)
        do {
            try await runner.run(
                SpecBuilder {
                    Expect(.notFound)
                }
            )
        }
        catch Spec.Failure.status(let value) {
            #expect(value == .ok)
        }
    }

    /// Verifies header expectation errors.
    @Test
    func testHeaderError() async throws {
        let runner = MockRunner(todo: todo)
        do {
            try await runner.run(
                SpecBuilder {
                    Expect(.authorization) {
                        #expect($0 == "application/json; charset=utf-8")
                    }
                }
            )
        }
        catch Spec.Failure.header(let value) {
            #expect(value == .authorization)
        }
    }

    /// Verifies executing a built spec via executor.
    @Test
    func testExecutorSpec() async throws {
        let spec = SpecBuilder {
            Expect(.created)
            Expect { response, body in
                #expect(response.status.code == 201)
            }
        }
        .build()

        let executor = MockExecutor(
            todo: todo,
            status: .created
        )
        try await executor.execute(spec)
    }

    /// Verifies executing a spec builder via executor.
    @Test
    func testExecutorSpecBuilder() async throws {
        let specBuilder = SpecBuilder {
            Expect(.created)
            Expect { response, body in
                #expect(response.status.code == 201)
            }
        }

        let executor = MockExecutor(
            todo: todo,
            status: .created
        )
        try await executor.execute(specBuilder)
    }

    /// Verifies executing a builder-parameter block via executor.
    @Test
    func testExecutorSpecBuilderParameter() async throws {
        let executor = MockExecutor(
            todo: todo,
            status: .created
        )
        try await executor.execute {
            Expect(.created)
            Expect { response, body in
                #expect(response.status.code == 201)
            }
        }
    }

    /// Verifies decode error when `Content-Length` is missing.
    @Test
    func testDecodeMissingContentLength() async throws {
        let spec = SpecBuilder {
            Expect { response, body in
                await expectDecodeError(
                    .missingContentLength,
                    response: response,
                    body: body
                )
            }
        }
        .build()

        let executor = MockExecutor(
            todo: todo,
            headerFields: [
                .contentType: "application/json; charset=utf-8"
            ]
        )
        try await executor.execute(spec)
    }

    /// Verifies decode error when `Content-Length` is invalid.
    @Test
    func testDecodeInvalidContentLength() async throws {
        let spec = SpecBuilder {
            Expect { response, body in
                await expectDecodeError(
                    .invalidContentLength,
                    response: response,
                    body: body
                )
            }
        }
        .build()

        let executor = MockExecutor(
            todo: todo,
            headerFields: [
                .contentType: "application/json; charset=utf-8",
                .contentLength: "nope",
            ]
        )
        try await executor.execute(spec)
    }

    /// Verifies custom headers are passed through the mock executor.
    @Test
    func testExecutorCustomHeaders() async throws {
        let spec = SpecBuilder {
            Expect(.contentType) {
                #expect($0 == "text/plain")
            }
        }
        .build()

        let executor = MockExecutor(
            todo: todo,
            headerFields: [
                .contentType: "text/plain",
                .contentLength: "18",
            ]
        )
        try await executor.execute(spec)
    }
}
