//
//  CombinedBuilderParam.swift
//  FeatherOpenAPISpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

struct Combined: SpecBuilderParameter {
    let params: [SpecBuilderParameter]

    func build(_ spec: inout Spec) {
        params.forEach { $0.build(&spec) }
    }
}
