//
//  ItemEntity.swift
//  ItemEntity
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public class ItemEntity: WorldEntity {
    public let itemType: ItemType
    public var targetedByEntity: MobileEntity?
    
    public init(game: Game, itemType: ItemType) {
        self.itemType = itemType
        super.init(game: game)
    }
}
