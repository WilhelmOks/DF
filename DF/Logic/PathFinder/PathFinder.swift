//
//  PathFinder.swift
//  PathFinder
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public final class PathFinder: IPathFinder {
    public let possibleOffsets = [IntVector2(0, 1), IntVector2(1, 0), IntVector2(0, -1), IntVector2(-1, 0)]
    public let possibleDiagonalOffsets = [IntVector2(1, 1), IntVector2(1, -1), IntVector2(-1, 1), IntVector2(-1, -1)]

    public func findPath(start: IntVector2, end: IntVector2, includingEnd: Bool, isPassable: (IntVector2) -> Bool) -> [IntVector2] {
        var stepsToTry = 1000

        var passableCache = Dictionary<IntVector2, Bool>()

        func isPassableCached(_ location: IntVector2) -> Bool {
            var result = passableCache[location]
            if result == nil
            {
                result = isPassable(location)
                passableCache[location] = result
            }
            return result ?? false
        }

        func neighborsOf(location: IntVector2, includingDiagonals: Bool) -> [IntVector2] {
            var result: [IntVector2] = []
            for offset in possibleOffsets {
                let neighbor = location + offset
                if isPassableCached(neighbor) {
                    result.append(neighbor)
                }
            }
            if includingDiagonals {
                for offset in possibleDiagonalOffsets {
                    if isPassableCached(location + offset) && isPassableCached(location + IntVector2(offset.x, 0)) && isPassableCached(location + IntVector2(0, offset.y)) {
                        result.append(location + offset)
                    }
                }
            }
            return result
        }

        if !isPassableCached(start) || start == end {
            return []
        }

        if includingEnd && !isPassableCached(end) {
            return []
        } else if !includingEnd && neighborsOf(location: end, includingDiagonals: false).contains(start) {
            return []
        }

        let squareRootOf2: Float = 1.41421356237

        func neighborCosts(current: IntVector2, neighbor: IntVector2) -> Float {
            let diff = current - neighbor
            return diff.x == 0 || diff.y == 0 ? 1 : squareRootOf2
        }

        func estimatedCosts(s: IntVector2, e: IntVector2) -> Float {
            Float(s.distance(to: e))
        }

        var closed: [IntVector2] = []
        var open: [IntVector2] = [start]
        var from: [IntVector2: IntVector2] = [:]
        var gScore: [IntVector2: Float] = [:]
        gScore[start] = 0
        var fScore: [IntVector2: Float] = [:]
        fScore[start] = estimatedCosts(s: start, e: end)

        while !open.isEmpty && stepsToTry > 0 {
            let current = open.min(by: { fScore[$0] ?? .infinity })!
            if includingEnd && current == end {
                return Array(reconstructPath(from: from, current: current).reversed().dropFirst())
            } else if !includingEnd && neighborsOf(location: end, includingDiagonals: false).contains(current) {
                return Array(reconstructPath(from: from, current: current).reversed().dropFirst())
            }

            open.removeAll{ $0 == current }
            closed.append(current)

            for neighbor in neighborsOf(location: current, includingDiagonals: true) {
                if closed.contains(neighbor) {
                    continue
                }
                let costForNeighbor = neighborCosts(current: current, neighbor: neighbor)
                let tgScore = (gScore[current] ?? .infinity) + costForNeighbor
                if !open.contains(neighbor) {
                    open.append(neighbor)
                } else if tgScore >= gScore[neighbor] ?? .infinity {
                    continue
                }

                from[neighbor] = current
                gScore[neighbor] = tgScore
                //fScore[neighbor] = gScore[neighbor] + estimatedCosts(s: neighbor, e: end)
                fScore[neighbor] = tgScore + estimatedCosts(s: neighbor, e: end)
            }

            stepsToTry -= 1
        }

        return []
    }

    private func reconstructPath(from: [IntVector2: IntVector2], current: IntVector2) -> [IntVector2] {
        var next: IntVector2? = current
        var path: [IntVector2] = [current]
        while next != nil {
            next = from[current]
            if let value = next {
                path.append(value)
            }
        }
        return path
    }
}
