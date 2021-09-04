//
//  WorldEntity.swift
//  WorldEntity
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public class WorldEntity: Entity, Identifiable {
    public let id = UUID()
    
    public unowned let game: Game
    
    public var variant: Int = 0
    
    public var cellLocation: IntVector2 = .zero
    
    //TODO: remove the int offset stuff
    public static let offsetRange = 10000
    public var offset: IntVector2 = .zero
    private let offsetRange2 = Vector2(Double(offsetRange), Double(offsetRange))
    public var realOffset: Vector2 { (offset.vector2 - offsetRange2 * 0.5) / offsetRange2 }
    
    public var hitPoints: HitPoints?
    
    //TODO: public let inventory: IItemsInventory?
    
    public var passable: Bool = false
    
    public init(game: Game) {
        self.game = game
    }
    
    public func deal(damage damagePoints: Int, to entity: WorldEntity) {
        //TODO: entity.hitPoints?.take(damage: damagePoints, from: self)
    }
    
    public func update(elapsedTime: TimeInterval) {
        
    }
}

extension WorldEntity: Equatable {
    public static func == (lhs: WorldEntity, rhs: WorldEntity) -> Bool {
        lhs.id == rhs.id
    }
}
