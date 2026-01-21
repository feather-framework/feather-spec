//
//  CustomError.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// Custom errors used by tests.
///
/// These errors help verify propagation behavior.
enum CustomError: Error {
    /// A failure with an associated integer.
    ///
    /// The associated value is used for assertion checks.
    case failure(Int)
}
