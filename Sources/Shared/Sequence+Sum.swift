//
//  Sequence+Sum.swift
//  
//  Created by Matthew Judy on 12/2/22.
//

import Foundation


extension Sequence where Element: AdditiveArithmetic
{
    public func sum() -> Element { reduce(.zero, +) }
}


