//
//  ItemsInventory.swift
//  ItemsInventory
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public protocol IItemsInventory: IInventory, IWorldEntityComponent where T == ItemType {
    
}

public final class SingleItemsInventory: SingleSlotsInventory<ItemType>, IItemsInventory {
    public unowned var worldEntity: WorldEntity
    
    public init(worldEntity: WorldEntity, numberOfSlots: Int) {
        self.worldEntity = worldEntity
        super.init(numberOfSlots: numberOfSlots)
    }
    
    public override func handleAdded() {
        //TODO: ...
    }
    
    public override func handleRemoved() {
        //TODO: ...
    }
}
