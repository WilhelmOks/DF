//
//  ItemsInventory.swift
//  ItemsInventory
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public protocol IItemsInventory: IInventory, IWorldEntityComponent where IT == ItemType {
    
}

/*
public class ItemsInventory: Inventory<ItemType>, IItemsInventory {
    public var worldEntity: WorldEntity
    
    
}*/
