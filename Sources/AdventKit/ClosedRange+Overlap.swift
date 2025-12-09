//
//  ClosedRange+Overlap.swift
//  AdventKit
//
//  Created by Matthew Judy on 12/4/22.
//


extension ClosedRange where Bound : Comparable
{
    public func covers(_ other: Self)      -> Bool { other.clamped(to: self) == other }
    public func isCoveredBy(_ other: Self) -> Bool { self.clamped(to: other) == self }
}

