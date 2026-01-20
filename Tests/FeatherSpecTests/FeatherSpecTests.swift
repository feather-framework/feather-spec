//
//  FeatherSpecTests.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import Testing

@testable import FeatherSpec

/// Test suite for `FeatherSpec`.
@Suite
struct FeatherSpecTests {

    /// Shared request path used across tests.
    let path = "todos"
    /// Shared todo model used across tests.
    let todo = Todo(title: "task01")
    /// Shared JSON request body used across tests.
    let body = Todo(title: "task01").httpBody
    /// Shared content type header value used across tests.
    let contentType = "application/json"

    /// Verifies the mutating `Spec` API.
    @Test
    func testMutatingFuncSpec() async throws {
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
            #expect(todo.title == self.todo.title)
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
                #expect(todo.title == self.todo.title)
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
                #expect(todo.title == self.todo.title)
            }
            Custom { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                #expect(todo.title == self.todo.title)
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
            Expect(.ok)
            Expect { response, body in
                #expect(response.status.code == 200)
            }
        }
        .build()

        let executor = MockExecutor(todo: todo)
        try await executor.execute(spec)
    }

    /// Verifies executing a spec builder via executor.
    @Test
    func testExecutorSpecBuilder() async throws {
        let specBuilder = SpecBuilder {
            Expect(.ok)
            Expect { response, body in
                #expect(response.status.code == 200)
            }
        }

        let executor = MockExecutor(todo: todo)
        try await executor.execute(specBuilder)
    }

    /// Verifies executing a builder-parameter block via executor.
    @Test
    func testExecutorSpecBuilderParameter() async throws {
        let executor = MockExecutor(todo: todo)
        try await executor.execute {
            Expect(.ok)
            Expect { response, body in
                #expect(response.status.code == 200)
            }
        }
    }
}
