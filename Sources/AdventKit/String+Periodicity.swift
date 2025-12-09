//
//  String+Periodicity.swift
//  AdventKit
//
//  Created by Matthew Judy on 12/8/25.
//


public extension StringProtocol
{
    /// Determines if the String is "periodic," i.e., it could be created by
    /// repeating a substring of any length (in its entirety) at least once.
    var isPeriodic: Bool
    {
        guard ( self.count > 1 ) else { return false }
        return (1 ... Int(self.count / 2))  // Max period is half the count.
            .filter { self.count % $0 == 0 }
            .reduce(false) { $0 || self.isPeriodic(period: $1) }
    }


    /// Determines if the String is "n-periodic," i.e., it could be created by
    /// repeating a substring of `n` length (in its entirety) at least once.
    func isPeriodic(period: Int) -> Bool
    {
        guard ( self.count > 1 ), ( period > 0 ), ( self.count % period == 0 ) else { return false }
        return ( self == String(
            repeating: String(self.prefix(period)),
            count: (self.count / period)
        ) )
    }
}


public extension UnsignedInteger
{
    /// Determines if the UnsignedInteger is "periodic," i.e., its String value
    /// could be created by repeating a substring of any length (in its
    /// entirety) at least once.
    var isPeriodic: Bool { String(self).isPeriodic }

    /// Determines if the UnsignedInteger is "n-periodic," i.e., its String
    /// value could be created by repeating a substring of `n` length (in its
    /// entirety) at least once.
    func isPeriodic(period: Int) -> Bool { String(self).isPeriodic(period: period) }
}
