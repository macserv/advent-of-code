//
//  File.swift
//  
//
//  Created by Matthew Judy on 12/26/22.
//

extension RangeReplaceableCollection
{
    public func every(from: Index? = nil, through: Index? = nil, nth: Int) -> Self
    {
        return Self(stride(from: from, through: through, by: nth))
    }
}

extension Collection
{
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
