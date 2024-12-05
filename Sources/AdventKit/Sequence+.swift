//
//  Sequence+.swift
//  
//  Created by Matthew Judy on 2022-12-01.
//

import Foundation


extension Sequence where Element: AdditiveArithmetic
{
    public func sum() -> Element { reduce(.zero, +) }
}


extension Sequence where Element: Hashable
{
    public var isDistinct: Bool
    {
        var set = Set<Element>()

        return !(self.contains { !(set.insert($0).inserted) })
    }
}

