//
//  Custom.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

@testable import FeatherSpec

/// A custom expectation wrapper used in tests.
struct Custom: SpecBuilderParameter {
    /// The wrapped expectation.
    var expectation: Expectation

    /// Initializes a custom expectation with a test block.
    init(
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.expectation = .init(block: block)
    }

    /// build.
    public func build(_ spec: inout Spec) {
        spec.addExpectation(expectation.block)
    }
}
