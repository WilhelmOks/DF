//
//  WorldGenerator.swift
//  WorldGenerator
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation
import AppKit

public final class WorldGenerator {
    public unowned let world: World
    
    let possibleGrounds: [Ground] = [.soil, .sand, .sand]
    
    init(world: World) {
        self.world = world
    }
    
    public func generateCellChunk(_ chunkCoordinates: IntVector2) {
        let chunkSalt = 171945928
        let chunkSeed = chunkCoordinates.hashValue ^ chunkSalt ^ world.globalSeed
        let rng = RandomNumberGenerator(seed: UInt64(chunkSeed))

        let cellChunkSize = world.cellChunks.chunkSize
        let chunk = Map2<WorldCell>(size: cellChunkSize, initialCell: .none)

        var voronoiPointsIncludingNeighbors: [IntVector2: Ground] = [:]

        for chunkDiff in Grid.coordinatesInRange(offset: -IntVector2.one, size: IntVector2(3, 3)) { //TODO: make extra function for this case
            let vc = chunkCoordinates + chunkDiff

            /*var points = world.voronoiPointsChunks[vc]
            if points == nil {
                points = generateVoronoiPointsForChunk(vc)
            }*/
            
            let points = world.voronoiPointsChunks[vc] ?? generateVoronoiPointsForChunk(vc)

            for point in points {
                voronoiPointsIncludingNeighbors[point.key] = point.value
            }
        }

        for coordinate in Grid.coordinates(in: cellChunkSize) {
            let absCoord = coordinate + chunkCoordinates * cellChunkSize
            //var points = voronoiPointsIncludingNeighbors.Where(p => p.Key.DistanceTo(absCoord) < 2 * ChunkSize.X);
            let points = voronoiPointsIncludingNeighbors
            let pointsFound = !points.isEmpty
            assert(pointsFound)
            let min = points.min(by: { p in p.key.distanceSquared(to: absCoord) })!
            let ground = min.value

            if ground == .soil {
                let distanceToVoronoidFit = min.key.distance(to: absCoord)
                let treePercentChance = Int(1.0 / distanceToVoronoidFit * 100.0)
                let shouldPlaceTree = rng.percentChance(treePercentChance)
                if shouldPlaceTree {
                    let variant = rng.next(world.game.resources.bitmaps.treesTest.regions.count)
                    let offset = IntVector2(rng.next(WorldEntity.offsetRange), rng.next(WorldEntity.offsetRange)) - IntVector2(WorldEntity.offsetRange / 2, WorldEntity.offsetRange / 2)
                    let tree = RefinableEntity(game: world.game, refinableType: world.game.refinableTypes.tree)
                    tree.variant = variant
                    tree.offset = offset
                    tree.cellLocation = absCoord
                    tree.hitPoints = HitPoints(worldEntity: tree, currentHitPoints: 100, maxHitpoints: 100)
                    world.addEntity(tree)
                }
            }

            let numberOfVariations = world.game.resources.bitmaps.tiles.worldGround[ground]?.numberOfVariations ?? 0

            chunk[coordinate] = WorldCell(
                ground: pointsFound ? ground : .none,
                wall: ground == .soil ? .soil : .none,
                groundVariant: rng.next(numberOfVariations)
            )
        }

        world.cellChunks[chunkCoordinates] = chunk

        let colors = chunk.allValues().map{ v in v.ground == .sand ? NSColor.yellow.cgColor : NSColor.brown.cgColor }
        let bitmap = world.game.resourceCreator.createBitmap(from: colors, size: cellChunkSize)

        world.chunkBitmaps[chunkCoordinates] = bitmap
        //debug print elapsed time
    }
    
    func generateVoronoiPointsForChunk(_ chunk: IntVector2) -> [IntVector2: Ground] {
        let voronoiChunkSalt = 326907365
        let chunkSeed = chunk.hashValue ^ voronoiChunkSalt ^ world.globalSeed
        let rng = RandomNumberGenerator(seed: UInt64(chunkSeed))
        let randomPicker = RandomPicker(rng)

        var voronoiPoints: [IntVector2: Ground] = [:]

        var numberOfVoronoiPoints = World.chunkSize.x * World.chunkSize.y / 100
        if numberOfVoronoiPoints == 0 {
            numberOfVoronoiPoints = 1
        }
        for _ in 0..<numberOfVoronoiPoints {
            let point = IntVector2(rng.next(World.chunkSize.x), rng.next(World.chunkSize.y)) + chunk * World.chunkSize
            voronoiPoints[point] = randomPicker.pick(from: possibleGrounds)
        }

        world.voronoiPointsChunks[chunk] = voronoiPoints

        return voronoiPoints
    }
}
