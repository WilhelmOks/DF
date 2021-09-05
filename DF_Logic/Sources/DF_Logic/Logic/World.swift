//
//  World.swift
//  World
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

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
    
    public var generator: WorldGenerator!
    
    public var entities: ListDictionary<IntVector2, WorldEntity> = .init()
    
    public var entitiesToDestroy: [WorldEntity] = []
    public private(set) var entitiesMarkedForDestruction: ListDictionary<Player, WorldEntity> = .init()
        
    public var hoveredCells: [Player: IntVector2] = [:]
    public var clickedCells: [Player: IntVector2] = [:]
    
    public var itemEntities: [ItemEntity] = []
    public var treeEntities: [WorldEntity] = []
    public var containerEntities: [BuildingEntity] = []
    
    public private(set) var itemGrabberMarkedLocations: ListDictionary<IntVector2, ItemGrabberMarker> = .init()
    
    private var workerBotsAdded = false
    
    init(game: Game) {
        self.game = game
        
        pathFinder = PathFinder()
        generator = WorldGenerator(world: self)
    }
    
    private func addTestEntities() {
        for location in Grid.coordinatesInRange(offset: IntVector2(7, 8), size: IntVector2(3, 3)) {
            let bot = WorkerBotEntity(game: game, seed: UInt64(random.next()))
            bot.owner = nil
            bot.cellLocation = location
            addEntity(bot)
        }

        addEntity(game.entityFactory.createBuilding(type: game.buildingTypes.container, location: IntVector2(4, 4)))
        addEntity(game.entityFactory.createBuilding(type: game.buildingTypes.container, location: IntVector2(6, 6)))

        addEntity(game.entityFactory.createBuilding(type: game.buildingTypes.inserter, location: IntVector2(5, 4)))
    }
        
    public func addEntity(_ entity: WorldEntity) {
        entities.add(value: entity, forKey: entity.cellLocation)
        
        switch entity {
        case let buildingEntity as BuildingEntity:
            if let itemGrabber = buildingEntity.itemGrabber {
                itemGrabberMarkedLocations.add(value: itemGrabber.inputMarker, forKey: itemGrabber.inputMarker.location)
                itemGrabberMarkedLocations.add(value: itemGrabber.outputMarker, forKey: itemGrabber.outputMarker.location)
            }
        default:
            break
        }
    }
    
    public func removeEntity(_ entity: WorldEntity) {
        let location = entity.cellLocation

        if entities[location] == nil {
            fatalError("tried to remove entity \(entity) from location \(location) with no entities")
        }
        
        let _ = entities.remove(value: entity, forKey: location)
        
        switch entity {
        case let itemEntity as ItemEntity:
            itemEntity.targetedByEntity?.cancelPlan() //TODO: do this in Dispose()
        case let refinableEntity as RefinableEntity:
            refinableEntity.dispose()
        case let buildingEntity as BuildingEntity:
            buildingEntity.dispose()
        default:
            break
        }

        let _ = entitiesMarkedForDestruction.remove(value: entity)
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
        let offset = cellChunks.cell(inChunk: chunkCoordinates, cellCoordinates: coordinates)
        let cell = cellChunks[chunkCoordinates]?[offset]
        return cell
    }
    
    private func setCell(coordinates: IntVector2, cell: WorldCell) {
        let chunkCoordinates = cellChunks.chunk(fromCell: coordinates)
        let chunk = cellChunks[chunkCoordinates]
        if let chunk = chunk {
            let offset = cellChunks.cell(inChunk: chunkCoordinates, cellCoordinates: coordinates)
            chunk[offset] = cell
        }
    }
    
    public static func cellIsNeighbor(_ cellPosition1: IntVector2, _ cellPosition2: IntVector2) -> Bool {
        let ds = cellPosition1.distanceSquared(to: cellPosition2)
        return ds > 0 && ds < 3
    }
    
    public func cellIsPassableForEntity(location: IntVector2, entity: WorldEntity) -> Bool {
        let entities = entities[location] ?? []
        return entities.isEmpty || entities.contains(entity) || entities.allSatisfy{ $0.passable }
    }
    
    func reassignEntityCellPosition(entity: MobileEntity, oldPosition: IntVector2) {
        let offsetRange2 = WorldEntity.offsetRange * 2

        var change = false
        var newPosition = oldPosition

        if entity.offset.x >= WorldEntity.offsetRange {
            change = true
            entity.offset -= IntVector2(offsetRange2, 0)
            newPosition = oldPosition + IntVector2.unitX
        } else if entity.offset.x <= -WorldEntity.offsetRange {
            change = true
            entity.offset += IntVector2(offsetRange2, 0)
            newPosition = oldPosition - IntVector2.unitX
        } else if entity.offset.y >= WorldEntity.offsetRange {
            change = true
            entity.offset -= IntVector2(0, offsetRange2)
            newPosition = oldPosition + IntVector2.unitY
        } else if entity.offset.y <= -WorldEntity.offsetRange {
            change = true
            entity.offset += IntVector2(0, offsetRange2)
            newPosition = oldPosition - IntVector2.unitY
        }

        if change {
            removeEntity(entity)
            entity.handleNewCellLocation(newPosition)
            addEntity(entity)
            //Debug.WriteLine($"old: {oldPosition}, new {newPosition}");
        }
    }
    
    public func update(elapsedTime: TimeInterval) {
        if !workerBotsAdded {
            addTestEntities()
            workerBotsAdded = true
        }

        itemEntities.removeAll()
        treeEntities.removeAll()
        containerEntities.removeAll()

        var mobileEntities: [MobileEntity] = []

        for entities in entities.pairs() {
            //let cellLocation = entities.key

            for entity in entities.value {
                switch entity {
                case let mobileEntity as MobileEntity:
                    mobileEntities.append(mobileEntity)
                case let itemEntity as ItemEntity:
                    itemEntities.append(itemEntity)
                case let treeEntity as RefinableEntity where treeEntity.refinableType === game.refinableTypes.tree:
                    treeEntities.append(treeEntity)
                case let buildingEntity as BuildingEntity where buildingEntity.buildingType === game.buildingTypes.container:
                    containerEntities.append(buildingEntity)
                default:
                    break
                }
            }
        }

        for entities in entities.pairs() {
            //let cellLocation = entities.key

            for entity in entities.value {
                entity.update(elapsedTime: elapsedTime)
            }
        }

        for entity in mobileEntities {
            reassignEntityCellPosition(entity: entity, oldPosition: entity.cellLocation)
        }

        for entity in entitiesToDestroy {
            let targetedBy = (entity as? RefinableEntity)?.isTargetOfEntities

            removeEntity(entity)

            switch entity {
            case let refinableEntity as RefinableEntity where refinableEntity.refinableType === game.refinableTypes.tree:
                let wood = ItemEntity(game: game, itemType: game.itemTypes.wood)
                wood.cellLocation = entity.cellLocation
                wood.offset = entity.offset
                addEntity(wood)

                let firstTargetetBy = targetedBy?.first
                if firstTargetetBy?.inventory?.canBeAddedAny(itemType: wood.itemType) ?? false {
                    firstTargetetBy?.assignPickupItemPlan(item: wood)
                }

                /*
                if (false) {
                    foreach (var mobileEntity in mobileEntities) {
                        if (mobileEntity is WorkerBotEntity && mobileEntity.PlannedAction == null && !mobileEntity.PlannedPath.Any()) {
                            mobileEntity.AssignPickupItemPlan(wood)
                            break;
                        }
                    }
                }*/
            default:
                break
            }
        }
        entitiesToDestroy.removeAll()

        for clickedCellTuple in clickedCells {
            let clickingPlayer = clickedCellTuple.key
            let clickedCell = clickedCellTuple.value

            if let clickedEntities = entities[clickedCell] {
                let removed = entitiesMarkedForDestruction.remove(values: clickedEntities)
                for pair in removed.pairs() {
                    for entity in pair.value {
                        switch entity {
                        case let refinableEntity as RefinableEntity:
                            for targetingEntity in refinableEntity.isTargetOfEntities {
                                targetingEntity.cancelPlan()
                            }
                        default:
                            break
                        }
                    }
                }
                let cancelledDestruction = !removed.isEmpty

                if !cancelledDestruction {
                    let refinableEntities = clickedEntities.filter{ entity in entity is RefinableEntity }
                    entitiesMarkedForDestruction.add(values: refinableEntities, forKey: clickingPlayer)
                }
            }
        }
        clickedCells.removeAll()
    }
}
