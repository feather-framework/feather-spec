import XCTest
@testable import FeatherSpec

final class FeatherSpecTests: XCTestCase {

    let path = "todos"
    let todo = Todo(title: "task01")
    let body = Todo(title: "task01").httpBody
    let contentType = "application/json"

    func testMutatingFuncSpec() async throws {
        var spec = Spec()
        spec.setMethod(.post)
        spec.setPath(path)
        spec.setBody(body)
        spec.setHeader(.contentType, contentType)
        spec.addExpectation(.ok)
        spec.addExpectation(.contentType) {
            XCTAssertEqual($0, "application/json; charset=utf-8")
        }
        spec.addExpectation { response, body in
            let todo = try await body.decode(Todo.self, with: response)
            XCTAssertEqual(todo.title, self.todo.title)
        }

        XCTAssertEqual(spec.request.method, .post)
        XCTAssertEqual(spec.request.path, path)
        XCTAssertEqual(spec.body, body)
        XCTAssertEqual(spec.request.headerFields, [.contentType: contentType])

        let runner = PostTodoRunner(todo: todo)
        try await runner.run(spec)
    }

    func testBuilderFuncSpec() async throws {
        let spec = Spec()
            .method(.post)
            .path(path)
            .header(.contentType, contentType)
            .body(body)
            .expect(.ok)
            .expect(.contentType) {
                XCTAssertEqual($0, "application/json; charset=utf-8")
            }
            .expect { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                XCTAssertEqual(todo.title, self.todo.title)
            }

        XCTAssertEqual(spec.request.method, .post)
        XCTAssertEqual(spec.request.path, path)
        XCTAssertEqual(spec.body, body)
        XCTAssertEqual(spec.request.headerFields, [.contentType: contentType])

        let runner = PostTodoRunner(todo: todo)
        try await runner.run(spec)
    }

    func testDslSpec() async throws {
        let spec = SpecBuilder {
            Method(.post)
            Path(path)
            Header(.contentType, contentType)
            Body(body)
            Expect(.ok)
            Expect(.contentType) {
                XCTAssertEqual($0, "application/json; charset=utf-8")
            }
            Expect { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                XCTAssertEqual(todo.title, self.todo.title)
            }
            Custom { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                XCTAssertEqual(todo.title, self.todo.title)
            }
        }
        .build()

        XCTAssertEqual(spec.request.method, .post)
        XCTAssertEqual(spec.request.path, path)
        XCTAssertEqual(spec.body, body)
        XCTAssertEqual(spec.request.headerFields, [.contentType: contentType])

        let runner = PostTodoRunner(todo: todo)
        try await runner.run(spec)
    }

    func testEmptySpec() async throws {
        let _ = SpecBuilder {}.build()
    }

    func testExpectationError() async throws {
        let runner = PostTodoRunner(todo: todo)
        do {
            try await runner.run {
                Custom { response, body in
                    throw CustomError.failure(-1)
                }
            }
        }
        catch CustomError.failure(let value) {
            XCTAssertEqual(value, -1)
        }
    }

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

    func testBuilderSpecHelpers() async throws {
        let specGet = Spec().get(path)
        XCTAssertEqual(specGet.request.method, .get)
        XCTAssertEqual(specGet.request.path, path)

        let specPost = Spec().post(path)
        XCTAssertEqual(specPost.request.method, .post)
        XCTAssertEqual(specPost.request.path, path)

        let specPut = Spec().put(path)
        XCTAssertEqual(specPut.request.method, .put)
        XCTAssertEqual(specPut.request.path, path)

        let specPatch = Spec().patch(path)
        XCTAssertEqual(specPatch.request.method, .patch)
        XCTAssertEqual(specPatch.request.path, path)

        let specHead = Spec().head(path)
        XCTAssertEqual(specHead.request.method, .head)
        XCTAssertEqual(specHead.request.path, path)

        let specDelete = Spec().delete(path)
        XCTAssertEqual(specDelete.request.method, .delete)
        XCTAssertEqual(specDelete.request.path, path)
    }

    func testStatusError() async throws {
        let runner = PostTodoRunner(todo: todo)
        do {
            try await runner.run(
                SpecBuilder {
                    Expect(.notFound)
                }
            )
        }
        catch Spec.Failure.status(let value) {
            XCTAssertEqual(value, .ok)
        }
    }

    func testHeaderError() async throws {
        let runner = PostTodoRunner(todo: todo)
        do {
            try await runner.run(
                SpecBuilder {
                    Expect(.authorization) {
                        XCTAssertEqual($0, "application/json; charset=utf-8")
                    }
                }
            )
        }
        catch Spec.Failure.header(let value) {
            XCTAssertEqual(value, .authorization)
        }
    }

    func testExecutorSpec() async throws {
        let spec = SpecBuilder {
            Expect(.ok)
            Expect { response, body in
                XCTAssertEqual(response.status.code, 200)
            }
        }
        .build()

        let executor = PostTodoExecutor(todo: todo)
        try await executor.execute(spec)
    }

    func testExecutorSpecBuilder() async throws {
        let specBuilder = SpecBuilder {
            Expect(.ok)
            Expect { response, body in
                XCTAssertEqual(response.status.code, 200)
            }
        }

        let executor = PostTodoExecutor(todo: todo)
        try await executor.execute(specBuilder)
    }

    func testExecutorSpecBuilderParameter() async throws {
        let executor = PostTodoExecutor(todo: todo)
        try await executor.execute {
            Expect(.ok)
            Expect { response, body in
                XCTAssertEqual(response.status.code, 200)
            }
        }
    }
}
