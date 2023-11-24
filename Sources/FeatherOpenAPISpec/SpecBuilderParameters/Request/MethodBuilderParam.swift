//
//  File.swift
//
//
//  Created by Tibor Bodecs on 23/11/2023.
//

import HTTPTypes

public struct Method: SpecBuilderParameter {
    let method: HTTPRequest.Method

    public init(_ method: HTTPRequest.Method) {
        self.method = method
    }

    public func build(_ spec: inout Spec) {
        spec.setMethod(method)
    }
}
