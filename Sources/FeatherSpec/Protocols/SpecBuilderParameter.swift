//
//  SpecBuilderParameter.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// A protocol defining the interface for building specifications.
///
/// Conforming types mutate a `Spec` by applying a single concern or expectation.
public protocol SpecBuilderParameter {

    /// Builds the specification by modifying it.
    ///
    /// Implementations should be deterministic and avoid side effects beyond updating `spec`.
    ///
    /// - Parameter spec: The specification to be modified.
    func build(_ spec: inout Spec)
}
