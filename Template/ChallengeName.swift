//
//  <#ChallengeName#>.swift
//
//  Created by Author on <#YYYY-MM-DD#>.
//


import ArgumentParser
import Foundation
import Shared


/**
 Day <#Day Number#> : <#Challenge Name#>

 # Part One

 <#Challenge Documentation#>
 */
@main
struct <#ChallengeName#>: ParsableCommand
{
    /// <#Enumeration for argument which activates "Part Two" behavior#>
    enum Mode: String, ExpressibleByArgument, CaseIterable
    {
        case modeA
        case modeB
    }

    @Option(help: "<#Argument used to activate “Part Two” behavior.#>")
    var mode: Mode
}


// MARK: - Command Execution

extension <#ChallengeName#>
{
    mutating func run() throws
    {
        while let inputLine = readLine()
        {
            print("\(inputLine)")
        }
    }
}

