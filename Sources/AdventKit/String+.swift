//
//  String+.swift
//  AdventKit
//
//  Created by Matthew Judy on 12/4/23.
//

import Foundation
import RegexBuilder


extension StringProtocol
{
    public func ranges(of string: some StringProtocol, options: String.CompareOptions = [], range searchRange: Range<Self.Index>? = nil, locale: Locale? = nil) -> [Range<Self.Index>]
    {
        var ranges     = Array<Range<Index>>()
        var startIndex = searchRange?.lowerBound ?? self.startIndex
        let endIndex   = searchRange?.upperBound ?? self.index(before:self.endIndex)

        while (startIndex < endIndex),
              let range = self[startIndex...endIndex].range(of: string, options: options, locale: locale)
        {
            ranges.append(range)
            startIndex = if (range.lowerBound < range.upperBound) { range.upperBound }
                else { index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex }
        }

        return ranges
    }


    public func indices(of string: some StringProtocol, options: String.CompareOptions = [], range searchRange: Range<Self.Index>? = nil, locale: Locale? = nil) -> [Self.Index]
    {
        self.ranges(of: string, options: options, range: searchRange, locale: locale).map(\.lowerBound)
    }


    public func index(of string: some StringProtocol, options: String.CompareOptions = [], range searchRange: Range<Self.Index>? = nil, locale: Locale? = nil) -> Index?
    {
        self.range(of: string, options: options, range: searchRange, locale: locale)?.lowerBound
    }


    public func endIndex(of string: some StringProtocol, options: String.CompareOptions = [], range searchRange: Range<Self.Index>? = nil, locale: Locale? = nil) -> Index?
    {
        self.range(of: string, options: options, range: searchRange, locale: locale)?.upperBound
    }
}



extension String
{
    public var integers: [Int]
    {
        self.compactMap { Int(String($0)) }
    }


    public func applying(replacements: [(searchString: String, replacement: String)]) -> String
    {
        replacements.reduce(self) { $0.replacingOccurrences(of: $1.0, with: $1.1) }
    }
}


extension RegexComponent where Self == CharacterClass
{
    public static func anyExcept(_ s: some Sequence<Character>) -> CharacterClass
    {
        return Self.anyOf(s).inverted
    }
}
