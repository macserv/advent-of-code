//
//  Error+.swift
//
//  Created by Matthew Judy on 7/25/19.
//  Copyright © 2019 NibFile.com. All rights reserved.
//

import protocol Foundation.LocalizedError


/// Utility for improved expressiveness when intentionally using an exception
/// to break the iteration loop of a higher-order function, e.g., when
/// implementing ``AsyncIteratorProtocol.next()``.
public struct StopIterating: Error, Sendable { public init() {} }


/// A highly-expressive, general purpose error type that can be used to
/// represent most things that go wrong in a data-driven application
///
/// - Parameters:
///     - whilst:
///         The general category of fuckery in which the app was engaged
///         when it ate shit
///     - grimDetails:
///         A description of the specific clusterfuck that has caused the
///         app to eat shit, or an object you want to tattle on about it.
///
/// - Example:
///     ```
///     throw AteShit(whilst: .parsing,)
///     throw AteShit(
///         whilst: .initializing,
///         "We done f-ed up."
///     )
///     ```
///
/// - Remark:
///     I'm making a note here: your code ate shit.
public struct AteShit: LocalizedError, Sendable
{
    public enum Fuckery : String, Sendable
    {
        case initializing
        case parsing
        case converting

        case reading
        case writing

        case encoding
        case decoding
    }


    public let whilst      : Fuckery
    public let cause       : Error?
    public let grimDetails : String?



    public init(whilst: Fuckery, becauseOf cause: Error? = nil, _ grimDetails: String? = nil)
    {
        self.whilst      = whilst
        self.cause       = cause
        self.grimDetails = grimDetails
    }


    public var errorDescription: String
    {
        return [
            "[ERROR] Your code ate shit whilst \(self.whilst).",
            (self.grimDetails == nil) ? nil : "“\(self.grimDetails!)”.",
            (self.cause       == nil) ? nil : "Caused by \(type(of: self.cause)): [ \(self.cause!) ].",
        ]
            .compactMap { $0 }
            .joined(separator: "  ")
    }
}


