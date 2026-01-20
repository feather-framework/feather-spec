//
//  CustomError.swift
//  feather-spec
//
//  Created by Binary Birds on 2026. 01. 20..

/// Custom errors used by tests.
enum CustomError: Error {
    /// A failure with an associated integer.
    case failure(Int)
}
