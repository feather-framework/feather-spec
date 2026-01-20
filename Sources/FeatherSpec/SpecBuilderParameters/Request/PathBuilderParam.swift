//
//  PathBuilderParam.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// A struct representing a URL path to be used in building a specification.
public struct Path: SpecBuilderParameter {
    // The URL path as an optional string.
    let path: String?

    /// Initializes a `Path` instance with the specified URL path.
    ///
    /// - Parameter path: The URL path to use. This can be `nil`.
    public init(_ path: String?) {
        self.path = path
    }

    /// Builds the specification by setting the URL path.
    ///
    /// - Parameter spec: The specification to be modified.
    public func build(_ spec: inout Spec) {
        spec.setPath(path)
    }
}
