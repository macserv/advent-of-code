//
//  Sequence+Sum.swift
//  
//  Created by Matthew Judy on 2022-12-01.
//

import Foundation


extension Sequence where Element: AdditiveArithmetic
{
    public func sum() -> Element { reduce(.zero, +) }
}


