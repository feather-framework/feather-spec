//
//  PathBuilderParam.swift
//  FeatherOpenAPISpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

public struct Path: SpecBuilderParameter {
    let path: String?

    public init(_ path: String?) {
        self.path = path
    }

    public func build(_ spec: inout Spec) {
        spec.setPath(path)
    }
}
