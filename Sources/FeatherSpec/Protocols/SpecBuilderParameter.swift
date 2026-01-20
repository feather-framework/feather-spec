//
//  SpecBuilderParameter.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// A protocol defining the interface for building specifications.
public protocol SpecBuilderParameter {

    /// Builds the specification by modifying it.
    ///
    /// - Parameter spec: The specification to be modified.
    func build(_ spec: inout Spec)
}
