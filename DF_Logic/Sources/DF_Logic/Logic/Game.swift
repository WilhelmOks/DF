//
//  Game.swift
//  Game
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

public final class Game {
    public let itemTypes: ItemTypeDefinition = .init()
    public let buildingTypes: BuildingTypeDefinition = .init()
    public let refinableTypes: RefinableTypeDefinition = .init()
    
    public let resourceCreator: IResourceCreator! = nil //TODO: ...
    public let resources: Resources = .init()
    
    public private(set) var world: World!
    public private(set) var entityFactory: EntityFactory!
    public private(set) var player: Player
    
    private var loaded = false
    
    public init() {
        player = Player()
        player.name = "Dummy"
        
        world = World(game: self)
        
        entityFactory = EntityFactory(game: self)
    }
    
    public func loadWorld() {
        world.generator.generateCellChunk(.zero)
        loaded = true
    }
    
    public func update(elapsedTime: TimeInterval) {
        if !loaded {
            loadWorld()
        }
        world.update(elapsedTime: elapsedTime)
    }
}
