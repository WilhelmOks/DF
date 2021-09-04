//
//  StackedItemsInventory.swift
//  StackedItemsInventory
//
//  Created by Wilhelm Oks on 04.09.21.
//

import Foundation

public final class StackedItemsInventory: StackedSlotsInventory<ItemType>, IItemsInventory {
    public unowned var worldEntity: WorldEntity
    
    public init(worldEntity: WorldEntity, numberOfSlots: Int) {
        self.worldEntity = worldEntity
        super.init(numberOfSlots: numberOfSlots)
    }
    
    public override func maxStackSize(itemType: ItemType) -> Int {
        itemType.maxInventoryStackSize
    }
    
    public override func handleAdded() {
        //TODO: ...
    }
    
    public override func handleRemoved() {
        //TODO: ...
    }
}

public typealias ItemStack = InventorySlotStack<ItemType>
