//
//  Map2.swift
//  Map2
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public final class Map2<T>: IMap2 {
    private var cells: [T]
    
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int, initialCell: T) {
        self.width = width
        self.height = height
        self.cells = .init(repeating: initialCell, count: width * height)
    }
    
    public init(size: IntVector2, initialCell: T) {
        self.width = size.x
        self.height = size.y
        self.cells = .init(repeating: initialCell, count: width * height)
    }
    
    private init(width: Int, height: Int, cells: [T]) {
        self.width = width
        self.height = height
        self.cells = cells
    }
    
    public subscript(_ x: Int, _ y: Int) -> T {
        get {
            cells[x + y * width]
        }
        set {
            cells[x + y * width] = newValue
        }
    }
    
    public subscript(_ coordinates: IntVector2) -> T {
        get {
            cells[coordinates.x + coordinates.y * width]
        }
        set {
            cells[coordinates.x + coordinates.y * width] = newValue
        }
    }
    
    public func clone() -> Self {
        .init(width: width, height: height, cells: cells)
    }
    
    public func allValues() -> [T] {
        cells
    }
}
