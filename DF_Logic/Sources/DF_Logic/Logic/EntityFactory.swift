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
        building.hitPoints = HitPoints(worldEntity: building, currentHitPoints: type.maxHitpoints, maxHitpoints: type.maxHitpoints)

        if type.numberOfInventorySlots > 0 {
            if type.inventorySlotsAreStacked {
                building.inventory = StackedItemsInventory(worldEntity: building, numberOfSlots: type.numberOfInventorySlots)
            } else {
                building.inventory = SingleItemsInventory(worldEntity: building, numberOfSlots: type.numberOfInventorySlots)
            }
        }

        if type.isItemGrabber {
            building.itemGrabber = ItemGrabber(
                worldEntity: building,
                inputMarker: ItemGrabberInputMarker(location: location - IntVector2.unitX),
                outputMarker: ItemGrabberOutputMarker(location: location + IntVector2.unitX - IntVector2.unitY)
            )
        }
        return building
    }
}
