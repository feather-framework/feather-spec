//
//  SpecBuilderParameter.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

/// SpecBuilderParameter protocol
public protocol SpecBuilderParameter {
    
    /// build
    /// - Parameter spec: Spec
    func build(_ spec: inout Spec)
    
}
