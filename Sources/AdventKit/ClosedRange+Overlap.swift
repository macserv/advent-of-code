//
//  ClosedRange+Overlap.swift
//
//  Created by Matthew Judy on 12/4/22.
//

import Foundation


extension ClosedRange where Bound : Comparable
{
    public func covers(_ other: Self) -> Bool
    {
        return (other.clamped(to: self) == other)
    }


    public func isCoveredBy(_ other: Self) -> Bool
    {
        return (self.clamped(to: other) == self)
    }
}

