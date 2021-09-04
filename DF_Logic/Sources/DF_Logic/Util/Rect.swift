//
//  Rect.swift
//  Rect
//
//  Created by Wilhelm Oks on 25.08.21.
//

import Foundation
import CoreGraphics

public typealias Rect = CGRect

public extension Rect {
    var x: Double { minX }
    var y: Double { minY }
    
    var location: Vector2 { .init(x: minX, y: minY) }
    var sizeVector: Vector2 { .init(x: size.width, y: size.height) }
    
    func contains(_ point: Vector2) -> Bool {
        self.contains(.init(x: point.x, y: point.y))
    }
}

public extension IntVector2 {
    func rect(withEndPoint endPoint: IntVector2) -> Rect {
        let size = endPoint - self
        return .init(x: self.x, y: self.y, width: size.x, height: size.y)
    }
    
    func rect(withSize size: IntVector2) -> Rect {
        .init(x: self.x, y: self.y, width: size.x, height: size.y)
    }
}

public extension Vector2 {
    func rect(withEndPoint endPoint: Vector2) -> Rect {
        let size = endPoint - self
        return .init(x: self.x, y: self.y, width: size.x, height: size.y)
    }
    
    func rect(withSize size: Vector2) -> Rect {
        .init(x: self.x, y: self.y, width: size.x, height: size.y)
    }
}

public extension Vector2 {
    func isInside(of rect: Rect) -> Bool {
        isInsideOfRect(location: rect.location, size: rect.sizeVector)
    }
    
    func isInsideOfRect(location: Vector2, size: Vector2) -> Bool {
        self.x >= location.x && self.x <= location.x + size.x &&
        self.y >= location.y && self.y <= location.y + size.y
    }
    
    func isInsideOfRect(location: IntVector2, size: IntVector2) -> Bool {
        let locationX = Double(location.x)
        let locationY = Double(location.y)
        return self.x >= locationX && self.x <= locationX + Double(size.x) &&
               self.y >= locationY && self.y <= locationY + Double(size.y)
    }
}
