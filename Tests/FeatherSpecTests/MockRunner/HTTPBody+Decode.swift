//
//  HTTPBody+Decode.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import Foundation
import HTTPTypes
import OpenAPIRuntime

/// Test-only decoding helpers for `HTTPBody`.
///
/// These utilities are tailored to the mock response format.
extension HTTPBody {

    /// Errors thrown when decoding an `HTTPBody`.
    ///
    /// These map missing or invalid content-length values.
    enum DecodeError: Error {
        /// The response is missing a `Content-Length` header.
        case missingContentLength
        /// The `Content-Length` header could not be parsed.
        case invalidContentLength
    }

    /// Decodes the body as JSON into the requested type.
    ///
    /// The response is used to determine the expected byte length.
    func decode<T>(
        _ type: T.Type,
        with response: HTTPResponse
    ) async throws -> T where T: Decodable {
        guard let lengthValue = response.headerFields[.contentLength] else {
            throw DecodeError.missingContentLength
        }
        guard let length = Int(lengthValue) else {
            throw DecodeError.invalidContentLength
        }
        let data = try await Data(collecting: self, upTo: Int(length))
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
