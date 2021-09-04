//
//  WorldGenerator.swift
//  WorldGenerator
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

public final class WorldGenerator {
    public unowned let world: World
    
    let possibleGrounds: [Ground] = [.earth, .sand, .sand]
    
    init(world: World) {
        self.world = world
    }
    
    public func generateCellChunk(_ chunkCoordinates: IntVector2) {
        //TODO: ...
    }
    
    func generateVoronoiPointsForChunk(_ chunk: IntVector2) -> [IntVector2: Ground] {
        return [:] //TODO: ...
    }
}
