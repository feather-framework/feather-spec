//
//  MockRunner.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

@testable import FeatherSpec

/// MockRunner.
public struct MockRunner: SpecRunner {

    /// The todo instance returned by the mock executor.
    let todo: Todo

    /// Execute a request.
    public func test(
        block: @escaping (SpecExecutor) async throws -> Void
    ) async throws {
        try await block(MockExecutor(todo: todo))
    }
}
