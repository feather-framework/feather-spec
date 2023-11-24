//
//  File.swift
//
//
//  Created by Tibor Bodecs on 23/11/2023.
//

public protocol SpecBuilderParameter {
    func build(_ spec: inout Spec)
}
