//
//  EmptyBuilderParam.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

/// A struct that represents an empty specification builder.
public struct Empty: SpecBuilderParameter {
    
    /// Initializes a new instance of `Empty`.
    /// The initializer is marked as internal, so it can only be used within the same module.
    internal init() {}

    /// A method that conforms to the `SpecBuilderParameter` protocol but does not alter the `spec`.
    /// - Parameter spec: An inout parameter of type `Spec` that remains unchanged.
    public func build(_ spec: inout Spec) {}
}
