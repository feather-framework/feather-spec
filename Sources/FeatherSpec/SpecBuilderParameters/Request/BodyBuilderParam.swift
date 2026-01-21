//
//  BodyBuilderParam.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes
import OpenAPIRuntime

/// A struct that represents a body for an API request.
///
/// It conforms to the `SpecBuilderParameter` protocol and sets the body of the specification.
///
/// This is typically used for JSON or form-encoded request payloads.
public struct Body: SpecBuilderParameter {

    /// The body of the API request.
    ///
    /// This is applied to the spec during `build(_:)`.
    public var body: HTTPBody

    /// Initializes a new instance of `Body` with the provided `HTTPBody`.
    ///
    /// The body is stored by value until the spec is built.
    /// - Parameter body: The HTTP body to be set in the specification.
    public init(_ body: HTTPBody) {
        self.body = body
    }

    /// Sets the body of the specification to the provided `HTTPBody`.
    ///
    /// This overwrites any previously set body on the spec.
    /// - Parameter spec: An inout parameter of type `Spec` that is modified to include the body.
    public func build(_ spec: inout Spec) {
        spec.setBody(body)
    }
}
