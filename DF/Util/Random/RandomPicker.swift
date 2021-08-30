//
//  RandomPicker.swift
//  RandomPicker
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public final class RandomPicker {
    let randomNumberGenerator: IRandomNumberGenerator

    public init(_ randomNumberGenerator: IRandomNumberGenerator) {
        self.randomNumberGenerator = randomNumberGenerator
    }

    public func pick<T>(from values: [T]) -> T {
        return values[randomNumberGenerator.next(values.count)]
    }
    
    public func pick<T>(from values: T...) -> T {
        return values[randomNumberGenerator.next(values.count)]
    }
}
