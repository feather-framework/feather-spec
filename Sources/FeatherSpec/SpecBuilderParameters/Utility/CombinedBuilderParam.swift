//
//  CombinedBuilderParam.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// A struct that combines multiple `SpecBuilderParameter` instances.
///
/// This lets the builder apply a sequence of parameters as a single unit.
struct Combined: SpecBuilderParameter {

    /// An array of parameters that conform to `SpecBuilderParameter`.
    ///
    /// The order of this array determines the order of mutations.
    let params: [SpecBuilderParameter]

    /// Builds the specification by invoking the `build` method of each parameter in the `params` array.
    ///
    /// Each parameter receives the same mutable `Spec` instance.
    /// - Parameter spec: An inout parameter of type `Spec` that is modified by the `build` methods of the contained parameters.
    func build(_ spec: inout Spec) {
        // Iterate over each parameter and call its build method, modifying the passed spec.
        for param in params {
            param.build(&spec)
        }
    }
}
