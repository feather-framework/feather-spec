//
//  MethodBuilderParam.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes

/// A struct representing an HTTP request method to be used in building a specification.
public struct Method: SpecBuilderParameter {
    // The HTTP request method (e.g., GET, POST, etc.)
    let method: HTTPRequest.Method

    /// Initializes a `Method` instance with the specified HTTP request method.
    ///
    /// - Parameter method: The HTTP request method to use.
    public init(_ method: HTTPRequest.Method) {
        self.method = method
    }

    /// Builds the specification by setting the HTTP request method.
    ///
    /// - Parameter spec: The specification to be modified.
    public func build(_ spec: inout Spec) {
        spec.setMethod(method)
    }
}
