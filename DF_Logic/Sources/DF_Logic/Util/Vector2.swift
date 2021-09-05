//
//  Vector2.swift
//  Vector2
//
//  Created by Wilhelm Oks on 25.08.21.
//

import Foundation
import simd

public typealias Vector2 = SIMD2<Double>

public extension Vector2 {
    var description: String {
        "(\(x),\(y))"
    }
    
    @inlinable var length: Double {
        simd_length(self)
    }
    
    @inlinable var lengthSquared: Double {
        simd_length_squared(self)
    }
    
    @inlinable func distance(to: Vector2) -> Double {
        simd_distance(self, to)
    }
    
    @inlinable func distanceSquared(to: Vector2) -> Double {
        simd_distance_squared(self, to)
    }
}

public extension Vector2 {
    static let unitX: Vector2 = .init(x: 1, y: 0)
    static let unitY: Vector2 = .init(x: 0, y: 1)
}

public extension Vector2 {
    @inlinable func angleDelta(to: Vector2) -> Double {
        atan2(self.x * to.y - self.y * to.x, self.x * to.x + self.y * to.y)
    }
    
    @inlinable func rotated(by angleDelta: Double) -> Vector2 {
        let x = cos(angleDelta)
        let y = sin(angleDelta)
        return Vector2(x * self.x - y * self.y, y * self.x + x * self.y)
    }
}
