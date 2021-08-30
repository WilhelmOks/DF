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
    /*
    public func transfer<Inv>(to targetInventory: inout Inv) -> Int where Inv : IInventory, ItemType == Inv.T {
        var transferred = 0
        let itemTypes = distinctContents()
        for itemType in itemTypes {
            transferred += transfer(to: &targetInventory, itemType: itemType)
        }
        return transferred
    }
    
    public func transfer<Inv>(to targetInventory: inout Inv, itemType: ItemType) -> Int where Inv : IInventory, ItemType == Inv.T {
        /*
        let removed = remove(itemType: itemType)
        let transferred = targetInventory.add(itemType: itemType, numberOfItems: removed)
        let toPutBack = removed - transferred
        if toPutBack > 0 {
            let _ = add(itemType: itemType, numberOfItems: toPutBack)
        }
        return transferred
         */
        return 0
    }
    
    public func canTransferAny<Inv>(targetInventory: Inv) -> Bool where Inv : IInventory, ItemType == Inv.T {
        distinctContents().contains{ targetInventory.canBeAddedAny(itemType: $0) }
    }
    
    public func canTransferAny<Inv>(targetInventory: Inv, itemType: ItemType) -> Bool where Inv : IInventory, ItemType == Inv.T {
        if !contains(itemType: itemType) {
            return false
        } else {
            return targetInventory.canBeAddedAny(itemType: itemType)
        }
    }
*/
    
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
