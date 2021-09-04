//
//  IRandomNumberGenerator.swift
//  IRandomNumberGenerator
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol IRandomNumberGenerator {
    /// Returns a non-negative random integer.
    func next() -> Int
    
    /// Returns a non-negative random integer that is less than the specified maximum.
    func next(_ maxValue: Int) -> Int
    
    /// Returns true if an event has occured with the specified probability.
    func percentChance(_ percentage: Int) -> Bool
}
