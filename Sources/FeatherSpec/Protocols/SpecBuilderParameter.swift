//
//  SpecBuilderParameter.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

public protocol SpecBuilderParameter {
    func build(_ spec: inout Spec)
}
