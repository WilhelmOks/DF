//
//  HitPoints.swift
//  HitPoints
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class HitPoints: IWorldEntityComponent {
    public unowned var worldEntity: WorldEntity
    
    public var currentHitPoints: Int = 0
    public var maxHitPoints: Int = 0
    
    public init(worldEntity: WorldEntity) {
        self.worldEntity = worldEntity
    }
    
    public func take(damage damagePoints: Int, from entity: WorldEntity) {
        if currentHitPoints > 0 {
            currentHitPoints -= damagePoints
            if currentHitPoints <= 0 {
                worldEntity.game.world.entitiesToDestroy.append(worldEntity)
            }
        }
    }
}
