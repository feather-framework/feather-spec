import OpenAPIRuntime
import HTTPTypes
@testable import FeatherSpec

struct PostTodoExecutor: SpecExecutor {

    let todo: Todo

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
