//
//  Error.swift
//
//  Created by Matthew Judy on 7/25/19.
//  Copyright © 2019 NibFile.com. All rights reserved.
//

import Foundation


public struct AteShit<DetailType: Sendable>: LocalizedError
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
    public let grimDetails : DetailType?


    /// I'm making a note here: the app ate shit.
    ///
    ///     throw AteShit(whilst: .initializing,
    ///         "We done fucked up.")
    ///
    /// - Parameters:
    ///     - whilst:
    ///         The general category of fuckery in which the app was engaged
    ///         when it ate shit
    ///     - grimDetails:
    ///         A description of the specific clusterfuck that has caused the
    ///         app to eat shit, or an object you want to tattle on about it.
    ///
    public init(whilst: Fuckery, _ grimDetails: DetailType? = nil)
    {
        self.whilst      = whilst
        self.grimDetails = grimDetails
    }


    public var errorDescription: String
    {
        let description = "[ERROR] The app ate shit whilst \(self.whilst)"

        switch self.grimDetails
        {
            case .none: return description
            case .some(let accessory): return description.appending(": '\(String(describing: accessory))'")
        }
    }
}


