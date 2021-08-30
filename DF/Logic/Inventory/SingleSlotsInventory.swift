//
//  SingleSlotsInventory.swift
//  SingleSlotsInventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol SingleSlotsInventory: Inventory where TSlot == T, T: Equatable & Hashable {
    
}

public extension SingleSlotsInventory {
    func isFull() -> Bool {
        slots.allSatisfy{ $0 != nil }
    }
    
    mutating func add(itemType: T, numberOfItems: Int) -> Int {
        assert(numberOfItems > 0)
        guard numberOfItems > 0 else { return 0 }
        
        var remainingToAdd = numberOfItems
        var added = 0

        for i in 0..<numberOfSlots {
            if slots[i] == nil {
                slots[i] = itemType
                added += 1
                remainingToAdd -= 1
                if remainingToAdd <= 0 {
                    break
                }
            }
        }

        if added > 0 {
            handleAdded()
        }

        return added
    }
    
    func canBeAddedCount(itemType: T) -> Int {
        slots.filter{ $0 == nil }.count
    }
    
    func canBeAddedAny(itemType: T) -> Bool {
        !isFull()
    }
    
    func count(itemType: T) -> Int {
        slots.filter{ $0 == itemType }.count
    }
    
    func contains(itemType: T) -> Bool {
        slots.contains(itemType)
    }
    
    mutating func remove(itemType: T, numberOfItems: Int) -> Int {
        assert(numberOfItems > 0)
        guard numberOfItems > 0 else { return 0 }
        
        var removed = 0
        var remainingToRemove = numberOfItems

        for i in (0..<numberOfSlots).reversed() {
            let slot = slots[i]
            if slot == itemType {
                slots[i] = nil
                removed += 1
                remainingToRemove -= 1
                if remainingToRemove <= 0 {
                    break
                }
            }
        }

        if removed > 0 {
            handleRemoved()
        }

        return removed
    }
    
    mutating func remove(itemType: T) -> Int {
        var removed = 0

        for i in (0..<numberOfSlots).reversed() {
            let slot = slots[i]
            if slot == itemType {
                slots[i] = nil
                removed += 1
            }
        }

        if removed > 0 {
            handleRemoved()
        }

        return removed
    }
    
    func distinctContents() -> [T] {
        slots.compactMap{$0}.uniqueElements()
    }
    
    mutating func removeOneFromSlot(_ slotIndex: Int) -> Bool {
        let slot = slots[slotIndex]
        if slot == nil {
            return false
        } else {
            slots[slotIndex] = nil
            handleRemoved()
            return true
        }
    }
}
