//
//  Custom.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

@testable import FeatherSpec

/// A custom expectation wrapper used in tests.
///
/// This lets tests supply arbitrary validation logic.
struct Custom: SpecBuilderParameter {
    /// The wrapped expectation.
    ///
    /// Stored for later application to a `Spec`.
    var expectation: Expectation

    /// Initializes a custom expectation with a test block.
    ///
    /// The block is wrapped into an `Expectation`.
    init(
        block: @escaping ((HTTPResponse, HTTPBody) async throws -> Void)
    ) {
        self.expectation = .init(block: block)
    }

    /// build.
    ///
    /// This appends the expectation to the provided spec.
    public func build(_ spec: inout Spec) {
        spec.addExpectation(expectation.block)
    }
}
