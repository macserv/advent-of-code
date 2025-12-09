//
//  Sequence+.swift
//  AdventKit
//  
//  Created by Matthew Judy on 2022-12-01.
//


extension Sequence where Element: AdditiveArithmetic
{
    public func sum() -> Element { reduce(.zero, +) }
}


extension Sequence where Element: Hashable
{
    /// Returns `true` if all elements in the sequence are unique.
    ///
    /// Creates a ``Set`` and inserts each element of the original ``Sequence``
    /// until a non-unique element is encountered.
    ///
    /// - Returns: `true` if all elements are distinct; `false` otherwise.
    public var isDistinct: Bool
    {
        var set = Set<Element>()

        return !(self.contains { !(set.insert($0).inserted) })
    }
}
