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
}

public enum Ground: Int {
    case none
    case earth //TODO: rename to soil?
    case grass
    case sand
}

public enum Wall: Int {
    case none
    case earth //TODO: rename to soil?
}
