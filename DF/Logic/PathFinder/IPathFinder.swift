//
//  IPathFinder.swift
//  IPathFinder
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol IPathFinder {
    var possibleOffsets: [IntVector2] { get }
    var possibleDiagonalOffsets: [IntVector2] { get }
    
    func findPath(start: IntVector2, end: IntVector2, includingEnd: Bool, isPassable: (IntVector2) -> Bool) -> [IntVector2]
}
