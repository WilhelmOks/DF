//
//  BuildingEntity.swift
//  BuildingEntity
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class BuildingEntity: WorldEntity, Disposable {
    public let buildingType: BuildingType
    
    public var itemGrabber: ItemGrabber?
    
    public init(game: Game, buildingType: BuildingType, itemGrabber: ItemGrabber?) {
        self.buildingType = buildingType
        self.itemGrabber = itemGrabber
        super.init(game: game)
        self.passable = false
    }
    
    public func dispose() {
        if let itemGrabber = itemGrabber {
            let _ = game.world.itemGrabberMarkedLocations.remove(value: itemGrabber.inputMarker)
            let _ = game.world.itemGrabberMarkedLocations.remove(value: itemGrabber.outputMarker)
        }

        hitPoints = nil
        inventory = nil
        itemGrabber = nil
    }
    
    public override func update(elapsedTime: TimeInterval) {
        super.update(elapsedTime: elapsedTime)
        
        itemGrabber?.update(elapsedTime: elapsedTime)
    }
}
