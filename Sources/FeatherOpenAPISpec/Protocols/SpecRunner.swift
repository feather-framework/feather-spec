//
//  SpecRunner.swift
//  FeatherOpenAPISpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import HTTPTypes
import OpenAPIRuntime

public protocol SpecRunner {

    func execute(
        req: HTTPRequest,
        body: HTTPBody
    ) async throws -> (
        response: HTTPResponse,
        body: HTTPBody
    )
}
