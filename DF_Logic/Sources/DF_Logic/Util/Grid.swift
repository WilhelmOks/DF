//
//  Grid.swift
//  Grid
//
//  Created by Wilhelm Oks on 25.08.21.
//

import Foundation

public enum Grid {
    public static func coordinates(in size: IntVector2) -> [IntVector2] {
        var result: [IntVector2] = []
        for y in 0..<size.y {
            for x in 0..<size.x {
                result.append(.init(x: x, y: y))
            }
        }
        return result
    }

    public static func coordinatesInRange(offset: IntVector2, size: IntVector2) -> [IntVector2] {
        let xStart = offset.x
        let yStart = offset.y
        let xEnd = xStart + size.x
        let yEnd = yStart + size.y
        var result: [IntVector2] = []
        for y in yStart..<yEnd {
            for x in xStart..<xEnd {
                result.append(.init(x: x, y: y))
            }
        }
        return result
    }

    public static func spiral(_ n: Int) -> IntVector2 {
        guard n >= 0 else { return .zero }
        let t = (sqrt(Double(n + 1)) - 1.0) / 2
        let r = Int(floor(t) + 1)
        let p = (8 * r * (r - 1)) / 2
        let en = r * 2
        let a = (1 + n - p) % (r * 8)
        switch a / (r * 2) {
        case 0: return IntVector2(x: a - r, y: -r)
        case 1: return IntVector2(x: r, y: (a % en) - r)
        case 2: return IntVector2(x: r - (a % en), y: r)
        case 3: return IntVector2(x: -r, y: r - (a % en))
        default: return .zero
        }
    }

    public static func coordinatesInSpiral(offset: IntVector2 = .zero, radius: Int) -> [IntVector2] {
        guard radius > 0 else { return [] }
        
        var result: [IntVector2] = []
        result.append(offset)

        if radius == 1 {
            return result
        }

        let sideLength = (radius - 1) * 2 + 1

        let n = sideLength * sideLength

        for i in 0..<(n-1) {
            result.append(spiral(i) + offset)
        }
        
        return result
    }
}
