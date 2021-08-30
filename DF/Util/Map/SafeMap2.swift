//
//  SafeMap2.swift
//  SafeMap2
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public final class SafeMap2<T>: IMap2 {
    private var cells: [T]
    private let outsideCell: T
    
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int, outsideCell: T, initialCell: T) {
        self.width = width
        self.height = height
        self.outsideCell = outsideCell
        self.cells = .init(repeating: initialCell, count: width * height)
    }
    
    public init(size: IntVector2, outsideCell: T, initialCell: T) {
        self.width = size.x
        self.height = size.y
        self.outsideCell = outsideCell
        self.cells = .init(repeating: initialCell, count: width * height)
    }
    
    private init(width: Int, height: Int, outsideCell: T, cells: [T]) {
        self.width = width
        self.height = height
        self.outsideCell = outsideCell
        self.cells = cells
    }
    
    public subscript(_ x: Int, _ y: Int) -> T {
        get {
            getCell(x: x, y: y)
        }
        set {
            setCell(x: x, y: y, cell: newValue)
        }
    }
    
    public subscript(_ coordinates: IntVector2) -> T {
        get {
            getCell(x: coordinates.x, y: coordinates.y)
        }
        set {
            setCell(x: coordinates.x, y: coordinates.y, cell: newValue)
        }
    }
    
    public func getCell(x: Int, y: Int) -> T {
        if x >= 0 && y >= 0 && x < width && y < height {
            return cells[x + y * width]
        } else {
            return outsideCell
        }
    }

    public func getCell(_ location: IntVector2) -> T {
        getCell(x: location.x, y: location.y)
    }
    
    public func setCell(x: Int, y: Int, cell: T) {
        if x >= 0 && y >= 0 && x < width && y < height {
            cells[x + y * width] = cell
        }
    }

    public func setCell(position: IntVector2, cell: T) {
        setCell(x: position.x, y: position.y, cell: cell)
    }
    
    public func clone() -> Self {
        .init(width: width, height: height, outsideCell: outsideCell, cells: cells)
    }
    
    public func allValues() -> [T] {
        cells
    }
}
