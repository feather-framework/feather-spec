//
//  Todo.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import Foundation
import OpenAPIRuntime

@testable import FeatherSpec

/// A lightweight model used by tests.
///
/// This mirrors the payloads used by the mock executor.
struct Todo: Codable {
    /// The todo title.
    ///
    /// This value is validated in expectations.
    let title: String
}

/// Test-only helpers for `Todo`.
///
/// These helpers simplify building request bodies.
extension Todo {

    /// Encodes the todo as a JSON `HTTPBody`.
    ///
    /// Returns an empty body if encoding fails.
    var httpBody: HTTPBody {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return HTTPBody()
        }
        return HTTPBody(data)
    }
}
