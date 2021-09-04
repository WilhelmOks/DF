//
//  Inventory.swift
//  Inventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public class Inventory<IT>: IInventory, CustomStringConvertible {
    public typealias T = InventorySlotStack<IT>
    
    public var slots: [T?]
    
    public init(numberOfSlots: Int) {
        slots = .init(repeating: nil, count: numberOfSlots)
    }

    public func handleAdded() {
        //needs to be overridden
    }
    
    public func handleRemoved() {
        //needs to be overridden
    }
    
    public func distinctContents() -> [IT] {
        //needs to be overridden
        []
    }
    
    public func add(itemType: IT, numberOfItems: Int) -> Int {
        //needs to be overridden
        0
    }
    
    public func remove(itemType: IT) -> Int {
        //needs to be overridden
        0
    }
    
    public func canBeAddedAny(itemType: IT) -> Bool {
        //needs to be overridden
        false
    }
    
    public func contains(itemType: IT) -> Bool {
        //needs to be overridden
        false
    }
    
    public func canBeAddedCount(itemType: IT) -> Int {
        //needs to be overridden
        0
    }
    
    public func count(itemType: IT) -> Int {
        //needs to be overridden
        0
    }
    
    public func remove(itemType: IT, numberOfItems: Int) -> Int {
        //needs to be overridden
        0
    }
    
    public func removeOneFromSlot(_ slotIndex: Int) -> Bool {
        //needs to be overridden
        false
    }
    
    public func isFull() -> Bool {
        //needs to be overridden
        false
    }
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
    
    func transfer<Inv>(to targetInventory: inout Inv) -> Int where Inv : IInventory, IT == Inv.IT {
        var transferred = 0
        let itemTypes = distinctContents()
        for itemType in itemTypes {
            transferred += transfer(to: &targetInventory, itemType: itemType)
        }
        return transferred
    }
    
    func transfer<Inv>(to targetInventory: inout Inv, itemType: IT) -> Int where Inv: IInventory, Inv.IT == IT {
        let removed = remove(itemType: itemType)
        let transferred = targetInventory.add(itemType: itemType, numberOfItems: removed)
        let toPutBack = removed - transferred
        if toPutBack > 0 {
            let _ = add(itemType: itemType, numberOfItems: toPutBack)
        }
        return transferred
    }
    
    func canTransferAny<Inv>(targetInventory: Inv?) -> Bool where Inv: IInventory, Inv.IT == IT {
        guard let targetInventory = targetInventory else { return false }
        return distinctContents().contains{ targetInventory.canBeAddedAny(itemType: $0) }
    }
    
    func canTransferAny<Inv>(targetInventory: Inv?, itemType: IT) -> Bool where Inv: IInventory, Inv.IT == IT {
        guard let targetInventory = targetInventory else { return false }
        if !contains(itemType: itemType) {
            return false
        } else {
            return targetInventory.canBeAddedAny(itemType: itemType)
        }
    }
    
    var description: String {
        "Inventory Slots:\n" + slots.map{ $0?.description ?? "" }.joined(separator: "\n")
    }
}
