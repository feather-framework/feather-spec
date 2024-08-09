@testable import FeatherSpec

public struct PostTodoRunner: SpecRunner {

    let todo: Todo

    /// Execute a request
    public func test(
        block: @escaping (SpecExecutor) async throws -> Void
    ) async throws {
        try await block(PostTodoExecutor(todo: todo))
    }
}
