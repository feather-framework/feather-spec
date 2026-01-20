//
//  Todo.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import Foundation
import OpenAPIRuntime

@testable import FeatherSpec

/// A lightweight model used by tests.
struct Todo: Codable {
    /// The todo title.
    let title: String
}

/// Test-only helpers for `Todo`.
extension Todo {

    /// Encodes the todo as a JSON `HTTPBody`.
    var httpBody: HTTPBody {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return HTTPBody()
        }
        return HTTPBody(data)
    }
}
