//
//  Collection+.swift
//
//  Created by Matthew Judy on 12/4/23.
//

import Foundation


extension Collection
{
    public var lastIndex: Int?
    {
        guard ( self.count > 0 ) else { return nil }
        return (self.count - 1)
    }


    public func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }

    
    public func stride(from: Index? = nil, through: Index? = nil, by: Int) -> AnySequence<Element>
    {
        var index    = from    ?? self.startIndex
        let endIndex = through ?? self.endIndex

        return AnySequence(
            AnyIterator
            {
                guard (index < endIndex) else { return nil }
                defer { index = self.index(index, offsetBy: by, limitedBy: endIndex) ?? endIndex }
                return self[index]
            }
        )
    }
}

