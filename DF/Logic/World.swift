//
//  World.swift
//  World
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

public class WorldEntity: Equatable {
    public static func == (lhs: WorldEntity, rhs: WorldEntity) -> Bool {
        false
    }
} //TODO: ...

public class ItemGrabberMarker: Equatable {
    public static func == (lhs: ItemGrabberMarker, rhs: ItemGrabberMarker) -> Bool {
        false
    }
} //TODO: ...

public final class World {
    public let globalSeed = 1337
    
    public let game: Game
    
    static let chunkSize = IntVector2(32, 32)
    
    public let cellChunks = ChunkMap<Map2<WorldCell>>(chunkSize: chunkSize)
    
    public let voronoiPointsChunks = ChunkMap<[IntVector2: Ground]>(chunkSize: chunkSize)
    
    public let chunkBitmaps = ChunkMap<IBitmap>(chunkSize: chunkSize)
    
    let random = RandomNumberGenerator(seed: 23456)
    
    public let pathFinder: IPathFinder
    
    public let registeredPlayers: [Player] = []
    
    public private(set) var entitiesToDestroy: [WorldEntity] = []
    public private(set) var entitiesMarkedForDestruction: ListDictionary<Player, WorldEntity> = .init()
        
    public var hoveredCells: [Player: IntVector2] = [:]
    public var clickedCells: [Player: IntVector2] = [:]
    
    public var generator: WorldGenerator!
    
    public var entities: ListDictionary<IntVector2, WorldEntity> = .init()
    
    public private(set) var itemGrabberMarkedLocations: ListDictionary<IntVector2, ItemGrabberMarker> = .init()
    
    init(game: Game) {
        self.game = game
        
        pathFinder = PathFinder()
        generator = WorldGenerator(world: self)
    }
    
    public func getAllVoronoiPoints() -> [(cellCoordinates: IntVector2, ground: Ground)] {
        var result: [(cellCoordinates: IntVector2, ground: Ground)] = []
        for chunk in voronoiPointsChunks.allChunks() {
            for points in chunk.value {
                result.append((points.key, points.value))
            }
        }
        return result
    }
    
    public func chunkFromCell(_ cell: IntVector2) -> IntVector2 {
        cellChunks.chunk(fromCell: cell)
    }
    
    public func getCell(_ coordinates: IntVector2) -> WorldCell? {
        let chunkCoordinates = cellChunks.chunk(fromCell: coordinates)
        let offset = cellChunks.cell(in: chunkCoordinates, cellCoordinates: coordinates)
        let cell = cellChunks[chunkCoordinates]?[offset]
        return cell
    }
    
    
}
