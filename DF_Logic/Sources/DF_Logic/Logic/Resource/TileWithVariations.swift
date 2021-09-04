//
//  TileWithVariations.swift
//  TileWithVariations
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class TileWithVariations {
    public let tiles: [IBitmap]
    
    public var numberOfVariations: Int { tiles.count }
    
    public init(tiles: [IBitmap]) {
        self.tiles = tiles
    }
    
    public subscript(_ variation: Int) -> IBitmap {
        get {
            tiles[variation]
        }
    }
}
