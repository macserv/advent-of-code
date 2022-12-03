//
//  <#ChallengeName#>.swift
//
//  Created by Author on <#YYYY-MM-DD#>.
//


import ArgumentParser
import Foundation
import Shared


/// <#Enumeration for argument which activates "Part Two" behavior#>
enum Mode: String, ExpressibleByArgument, CaseIterable
{
    case modeA
    case modeB
}


/**
 Day 3: <#Challenge Name#>

 # Part One

 <#Challenge Documentation#>
 */
@main
struct <#ChallengeName#>: AsyncParsableCommand
{
    @Option(help: "<#Argument used to activate “Part Two” behavior.#>")
    var mode: Mode
}


// MARK: - Command Execution

extension <#ChallengeName#>
{
    mutating func run() async throws
    {
        while let inputLine = readLine()
        {
            print("inputLine")
        }
    }
}

