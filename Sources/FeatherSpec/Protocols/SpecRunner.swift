//
//  SpecRunner.swift
//  FeatherSpec
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import HTTPTypes
import OpenAPIRuntime

/// SpecRunner protocol
public protocol SpecRunner {
    
    /// execute 
    /// - Parameters:
    ///   - req: HTTPRequest
    ///   - body: HTTPBody
    /// - Returns: (HTTPRequest, HTTPBody)
    func execute(
        req: HTTPRequest,
        body: HTTPBody
    ) async throws -> (
        response: HTTPResponse,
        body: HTTPBody
    )
}
