//
//  BodyBuilderParam.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import OpenAPIRuntime
import HTTPTypes

public struct Body: SpecBuilderParameter {
    public var body: HTTPBody

    public init(_ body: HTTPBody) {
        self.body = body
    }

    public func build(_ spec: inout Spec) {
        spec.setBody(body)
    }
}
