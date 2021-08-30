//
//  Inventory.swift
//  Inventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol Inventory: IInventory, CustomStringConvertible {    
    var slots: [T?] { get set }
    
    func handleAdded()
    func handleRemoved()
}

public extension Inventory {
    var numberOfSlots: Int { slots.count }
    
    subscript(_ slotIndex: Int) -> T? {
        get {
            slots[slotIndex]
        }
        set {
            let oldSlot = slots[slotIndex]
            slots[slotIndex] = newValue

            if oldSlot != nil {
                handleRemoved()
            }
            if newValue != nil {
                handleAdded()
            }
        }
    }
    
    func isEmpty() -> Bool {
        slots.allSatisfy{ $0 == nil }
    }
    
    func hasEmptySlots() -> Bool {
        slots.contains{ $0 == nil }
    }
    
    func firstEmptySlotIndex() -> Int? {
        slots.firstIndex{ $0 == nil }
    }
    
    func transfer<Inv>(to targetInventory: inout Inv) -> Int where Inv: Inventory, Inv.T == Self.T {
        var transferred = 0
        let itemTypes = distinctContents()
        for itemType in itemTypes {
            transferred += transfer(to: &targetInventory, itemType: itemType)
        }
        return transferred
    }
    
    func transfer<Inv>(to targetInventory: inout Inv, itemType: T) -> Int where Inv: Inventory, Inv.T == Self.T {
        let removed = remove(itemType: itemType)
        let transferred = targetInventory.add(itemType: itemType, numberOfItems: removed)
        let toPutBack = removed - transferred
        if toPutBack > 0 {
            let _ = add(itemType: itemType, numberOfItems: toPutBack)
        }
        return transferred
    }
    
    func canTransferAny<Inv>(targetInventory: Inv) -> Bool where Inv: Inventory, Inv.T == Self.T {
        distinctContents().contains{ targetInventory.canBeAddedAny(itemType: $0) }
    }
    
    func canTransferAny<Inv>(targetInventory: Inv, itemType: T) -> Bool where Inv: Inventory, Inv.T == Self.T {
        if !contains(itemType: itemType) {
            return false
        } else {
            return targetInventory.canBeAddedAny(itemType: itemType)
        }
    }
    
    var description: String {
        "Inventory Slots:\n" + slots.map{ ($0 as? CustomStringConvertible)?.description ?? "" }.joined(separator: "\n")
    }
}
