//
//  MockRunner.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

@testable import FeatherSpec

/// MockRunner.
///
/// This runner wires tests to a `MockExecutor`.
public struct MockRunner: SpecRunner {

    /// The todo instance returned by the mock executor.
    ///
    /// This is passed into the executor for response generation.
    let todo: Todo

    /// Execute a request.
    ///
    /// This provides a test executor to the supplied block.
    public func test(
        block: @escaping (SpecExecutor) async throws -> Void
    ) async throws {
        try await block(MockExecutor(todo: todo))
    }
}
