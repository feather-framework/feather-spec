//
//  SpecError.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

import HTTPTypes

/// Spec error definitions.
///
/// These errors are raised when expectations fail.
extension Spec {

    /// An enumeration that represents errors that can occur in a Spec context.
    ///
    /// Each case corresponds to a specific expectation failure.
    public enum Failure: Error {
        /// Represents an error that occurs due to a missing HTTP header.
        ///
        /// This is thrown when an expected header is not present.
        /// - Parameter: HTTPField.Name - The name of the HTTP field that caused the error.
        case header(HTTPField.Name)

        /// Represents an error that occurs due to an issue with the HTTP response status code.
        ///
        /// This is thrown when the received status does not match the expectation.
        /// - Parameter: HTTPResponse.Status - The HTTP status code that caused the error.
        case status(HTTPResponse.Status)
    }
}
