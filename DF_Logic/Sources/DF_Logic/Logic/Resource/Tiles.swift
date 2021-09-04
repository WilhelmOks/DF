//
//  Tiles.swift
//  Tiles
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class Tiles: IResourceContainer {
    public private(set) var worldGround: [Ground: TileWithVariations] = [:]
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = fileSystem.graphicsDirectory()
        
        async let a0 = resourceCreator.createBitmap(from: "\(path)/a0.png")
        async let a1 = resourceCreator.createBitmap(from: "\(path)/a1.png")
        async let a2 = resourceCreator.createBitmap(from: "\(path)/a2.png")
        async let a3 = resourceCreator.createBitmap(from: "\(path)/a3.png")
        
        async let w0 = resourceCreator.createBitmap(from: "\(path)/w0.png")
        async let w1 = resourceCreator.createBitmap(from: "\(path)/w1.png")
        async let w2 = resourceCreator.createBitmap(from: "\(path)/w2.png")
        async let w3 = resourceCreator.createBitmap(from: "\(path)/w3.png")
        async let w4 = resourceCreator.createBitmap(from: "\(path)/w0.png")
        async let w5 = resourceCreator.createBitmap(from: "\(path)/w1.png")
        
        (
            worldGround[.sand],
            worldGround[.earth]
        ) = await (
            TileWithVariations(tiles: [a0, a1, a2, a3]),
            TileWithVariations(tiles: [w0, w1, w2, w3, w4, w5])
        )
    }
}
