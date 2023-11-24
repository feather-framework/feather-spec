//
//  File.swift
//
//
//  Created by Tibor Bodecs on 23/11/2023.
//

import HTTPTypes
import OpenAPIRuntime

struct _Expectation {
    let file: StaticString
    let line: UInt
    let block: ((HTTPResponse, HTTPBody) async throws -> Void)
}
