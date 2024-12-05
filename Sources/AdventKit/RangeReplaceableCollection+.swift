//
//  RangeReplaceableCollection+.swift
//
//  Created by Matthew Judy on 12/26/22.
//

import Foundation


extension RangeReplaceableCollection
{
    public func every(from: Index? = nil, through: Index? = nil, nth: Int) -> Self
    {
        return Self(stride(from: from, through: through, by: nth))
    }


    public func rotatedLeft(by distance: Int) -> SubSequence
    {
        // Handle subarrays, which don't necessarily start at 0.
        let spliceIndex = self.index(self.startIndex, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex

        // Create two new slices using the splice index, and join them.
        return (self[spliceIndex...] + self[..<spliceIndex])
    }


    public func rotatedRight(by distance: Int) -> SubSequence
    {
        // As above, so below.
        let spliceIndex = self.index(self.endIndex, offsetBy: (-(distance)), limitedBy: self.startIndex) ?? self.startIndex
        return (self[spliceIndex...] + self[..<spliceIndex])
    }
}

