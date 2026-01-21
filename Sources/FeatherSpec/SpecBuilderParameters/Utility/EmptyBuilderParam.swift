//
//  EmptyBuilderParam.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// A struct that represents an empty specification builder.
///
/// This is used to satisfy builder control-flow branches with no output.
public struct Empty: SpecBuilderParameter {

    /// A method that conforms to the `SpecBuilderParameter` protocol but does not alter the `spec`.
    ///
    /// This is intentionally a no-op.
    /// - Parameter spec: An inout parameter of type `Spec` that remains unchanged.
    public func build(_ spec: inout Spec) {}
}
