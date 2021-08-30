//
//  EntityFactory.swift
//  EntityFactory
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class EntityFactory {
    private unowned let game: Game
    
    public init(game: Game) {
        self.game = game
    }
    
    public func createBuilding(type: BuildingType, location: IntVector2) -> BuildingEntity {
        let building = BuildingEntity(game: game, buildingType: type, itemGrabber: nil)
        building.cellLocation = location
        building.offset = IntVector2(WorldEntity.offsetRange/2, WorldEntity.offsetRange/2)
        //TODO: ...
        return building
    }
}
