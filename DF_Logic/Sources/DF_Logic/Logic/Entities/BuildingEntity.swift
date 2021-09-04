//
//  BuildingEntity.swift
//  BuildingEntity
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class BuildingEntity: WorldEntity, Disposable {
    public let buildingType: BuildingType
    
    public let itemGrabber: ItemGrabber?
    
    public init(game: Game, buildingType: BuildingType, itemGrabber: ItemGrabber?) {
        self.buildingType = buildingType
        self.itemGrabber = itemGrabber
        super.init(game: game)
        self.passable = false
    }
    
    public func dispose() {
        //TODO: ...
        /*
        if(ItemGrabber != null)
        {
            Game.World.ItemGrabberMarkedLocations.RemoveValue(ItemGrabber.InputMarker);
            Game.World.ItemGrabberMarkedLocations.RemoveValue(ItemGrabber.OutputMarker);

            ItemGrabber.WorldEntity = null;
            ItemGrabber.InputMarker = null;
            ItemGrabber.OutputMarker = null;
            ItemGrabber = null;
        }

        if(HitPoints != null)
        {
            HitPoints.WorldEntity = null;
            HitPoints = null;
        }

        if(Inventory != null)
        {
            Inventory.WorldEntity = null;
            Inventory = null;
        }

        Game = null;
        */
    }
    
    public override func update(elapsedTime: TimeInterval) {
        super.update(elapsedTime: elapsedTime)
        
        //TODO: itemGrabber?.update(elapsedTime: elapsedTime)
    }
}
