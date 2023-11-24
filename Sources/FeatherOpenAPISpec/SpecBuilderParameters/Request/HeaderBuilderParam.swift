//
//  File.swift
//
//
//  Created by Tibor Bodecs on 23/11/2023.
//

import HTTPTypes

public struct Header: SpecBuilderParameter {
    let name: HTTPField.Name
    let value: String

    public init(_ name: HTTPField.Name, _ value: String) {
        self.name = name
        self.value = value
    }

    public func build(_ spec: inout Spec) {
        spec.setHeader(name, value)
    }
}
