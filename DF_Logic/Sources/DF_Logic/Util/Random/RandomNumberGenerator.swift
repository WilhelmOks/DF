//
//  RandomNumberGenerator.swift
//  RandomNumberGenerator
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation
import GameplayKit

public final class RandomNumberGenerator: IRandomNumberGenerator {
    private let mersenneTwister: GKMersenneTwisterRandomSource
    
    public init(seed: UInt64) {
        mersenneTwister = GKMersenneTwisterRandomSource(seed: seed)
    }
    
    public func next() -> Int {
        mersenneTwister.nextInt()
    }
    
    public func next(_ maxValue: Int) -> Int {
        mersenneTwister.nextInt(upperBound: maxValue)
    }
    
    public func percentChance(_ percentage: Int) -> Bool {
        if percentage <= 0 {
            return false
        }
        if percentage >= 100 {
            return true
        }
        return mersenneTwister.nextUniform() < Float(percentage) / 100.0
    }
}
