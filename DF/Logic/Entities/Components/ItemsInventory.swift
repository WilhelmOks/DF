//
//  ItemsInventory.swift
//  ItemsInventory
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public protocol IItemsInventory: IInventory, IWorldEntityComponent where T == ItemType {
    
}

/*
public final class SingleItemsInventory: SingleSlotsInventory, IItemsInventory {
    public var slots: [ItemType?]
    
    public unowned var worldEntity: WorldEntity
    
    public init(worldEntity: WorldEntity, numberOfSlots: Int) {
        self.worldEntity = worldEntity
        slots = .init(repeating: nil, count: numberOfSlots)
    }
    
    public func handleAdded() {
        //TODO: ...
    }
    
    public func handleRemoved() {
        //TODO: ...
    }
}
*/
