//
//  WorldCell.swift
//  WorldCell
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public struct WorldCell {
    public let ground: Ground
    public let wall: Wall

    public var groundVariant: Int
    
    static let none: WorldCell = .init(ground: .none, wall: .none, groundVariant: 0)
}

public enum Ground: Int {
    case none
    case soil
    case grass
    case sand
}

public enum Wall: Int {
    case none
    case soil
}
