//
//  IntVector2.swift
//  IntVector2
//
//  Created by Wilhelm Oks on 25.08.21.
//

import Foundation
import simd

public typealias IntVector2 = SIMD2<Int>

public extension IntVector2 {
    init(_ v: Vector2, conversion: ((Double) -> Int)? = nil) {
        if let conversion = conversion {
            self.init(conversion(v.x), conversion(v.y))
            //x = conversion(v.x)
            //y = conversion(v.y)
        } else {
            self.init(Int(v.x), Int(v.y))
            //x = Int(v.x)
            //y = Int(v.y)
        }
    }
    
    var vector2: Vector2 {
        Vector2(x: Double(x), y: Double(y))
    }
    
    var direction9State: IntVector2 {
        IntVector2(x: x > 0 ? 1 : x < 0 ? -1 : 0, y: y > 0 ? 1 : y < 0 ? -1 : 0)
    }
    
    var description: String {
        "(\(x),\(y))"
    }
}

public extension IntVector2 {
    static let unitX: IntVector2 = .init(x: 1, y: 0)
    static let unitY: IntVector2 = .init(x: 0, y: 1)
}

public extension IntVector2 {
    static func +(lhs: IntVector2, rhs: IntVector2) -> IntVector2 {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: IntVector2, rhs: IntVector2) -> IntVector2 {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static prefix func -(v: IntVector2) -> IntVector2 {
        .init(x: -v.x, y: -v.y)
    }
    
    static func *(lhs: IntVector2, rhs: IntVector2) -> IntVector2 {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    static func *(lhs: IntVector2, rhs: Int) -> IntVector2 {
        .init(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func *(lhs: IntVector2, rhs: Double) -> Vector2 {
        .init(x: Double(lhs.x) * rhs, y: Double(lhs.y) * rhs)
    }
    
    static func /(lhs: IntVector2, rhs: IntVector2) -> IntVector2 {
        .init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    static func /(lhs: IntVector2, rhs: Int) -> IntVector2 {
        .init(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    static func /(lhs: IntVector2, rhs: Double) -> Vector2 {
        .init(x: Double(lhs.x) / rhs, y: Double(lhs.y) / rhs)
    }
}

public extension IntVector2 {
    var length: Double {
        sqrt(Double(x * x + y * y))
    }
    
    var lengthSquared: Double {
        Double(x * x + y * y)
    }
    
    func distance(to: IntVector2) -> Double {
        let dx = x - to.x
        let dy = y - to.y
        return sqrt(Double(dx * dx + dy * dy))
    }
    
    func distanceSquared(to: IntVector2) -> Double {
        let dx = x - to.x
        let dy = y - to.y
        return Double(dx * dx + dy * dy)
    }
}
