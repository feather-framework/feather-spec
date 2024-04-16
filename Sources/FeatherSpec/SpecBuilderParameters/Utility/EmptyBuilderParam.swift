//
//  EmptyBuilderParam.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

public struct Empty: SpecBuilderParameter {
    internal init() {}

    public func build(_ spec: inout Spec) {}
}
