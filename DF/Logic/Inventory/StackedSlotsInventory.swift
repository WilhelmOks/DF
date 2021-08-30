//
//  StackedSlotsInventory.swift
//  StackedSlotsInventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol StackedSlotsInventory: Inventory where TSlot == InventorySlotStack<T>, T: Equatable & Hashable {
    func maxStackSize(itemType: T) -> Int
}

public extension StackedSlotsInventory {
    func isFull() -> Bool {
        slots.allSatisfy{ slot in slot.flatMap{ $0.numberOfItems >= maxStackSize(itemType: $0.itemType) } ?? false }
    }
    
    mutating func add(itemType: T, numberOfItems: Int) -> Int {
        assert(numberOfItems > 0)
        guard numberOfItems > 0 else { return 0 }
        
        let maxStackSize = maxStackSize(itemType: itemType)
        var remainingToAdd = numberOfItems
        var added = 0;

        for i in 0..<numberOfSlots {
            if var slot = slots[i], slot.itemType == itemType, slot.numberOfItems < maxStackSize {
                let addable = maxStackSize - slot.numberOfItems
                if remainingToAdd <= addable {
                    slot.numberOfItems += remainingToAdd
                    slots[i] = slot
                    added += remainingToAdd
                    return added
                } else {
                    slot.numberOfItems += addable
                    slots[i] = slot
                    added += addable
                    remainingToAdd -= addable
                }
            }
        }

        for i in 0..<numberOfSlots {
            let slot = slots[i]
            if slot == nil {
                if remainingToAdd <= maxStackSize {
                    slots[i] = InventorySlotStack(itemType: itemType, numberOfItems: remainingToAdd)
                    added += remainingToAdd
                    return added
                } else {
                    slots[i] = InventorySlotStack(itemType: itemType, numberOfItems: maxStackSize)
                    added += maxStackSize;
                    remainingToAdd -= maxStackSize
                }
            }
        }

        if added > 0 {
            handleAdded()
        }

        return added
    }
    
    func canBeAddedCount(itemType: T) -> Int {
        let maxStackSize = maxStackSize(itemType: itemType)
        var canBeAdded = 0

        for i in 0..<numberOfSlots {
            if let slot = slots[i] {
                if slot.itemType == itemType && slot.numberOfItems < maxStackSize {
                    let addable = maxStackSize - slot.numberOfItems
                    canBeAdded += addable
                }
            } else {
                canBeAdded += maxStackSize
            }
        }

        return canBeAdded
    }
    
    func canBeAddedAny(itemType: T) -> Bool {
        let maxStackSize = maxStackSize(itemType: itemType)
        
        for i in 0..<numberOfSlots {
            if let slot = slots[i] {
                return slot.itemType == itemType && slot.numberOfItems < maxStackSize
            } else {
                return true
            }
        }
        
        return false
    }
    
    func count(itemType: T) -> Int {
        slots.compactMap{$0}.filter{ $0.itemType == itemType }.map(\.numberOfItems).sum()
    }
    
    func contains(itemType: T) -> Bool {
        slots.contains{ $0?.itemType == itemType }
    }
    
    mutating func remove(itemType: T, numberOfItems: Int) -> Int {
        var removed = 0
        var remainingToRemove = numberOfItems
        
        for i in (0..<numberOfSlots).reversed() {
            if var slot = slots[i], slot.itemType == itemType {
                if remainingToRemove <= slot.numberOfItems {
                    slot.numberOfItems -= remainingToRemove
                    if slot.numberOfItems < 1 {
                        slots[i] = nil
                    } else {
                        slots[i] = slot
                    }
                    removed += remainingToRemove
                    return removed
                } else {
                    removed += slot.numberOfItems
                    remainingToRemove -= slot.numberOfItems
                    slots[i] = nil
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
            if let slot = slots[i], slot.itemType == itemType {
                removed += slot.numberOfItems
                slots[i] = nil
            }
        }

        if removed > 0 {
            handleRemoved()
        }

        return removed
    }
    
    func distinctContents() -> [T] {
        slots.compactMap{ $0?.itemType }.uniqueElements()
    }
    
    mutating func removeOneFromSlot(_ slotIndex: Int) -> Bool {
        if var slot = slots[slotIndex] {
            slot.numberOfItems -= 1
            if slot.numberOfItems <= 0 {
                slots[slotIndex] = nil
            } else {
                slots[slotIndex] = slot
            }
            handleRemoved()
            return true
        } else {
            return false
        }
    }
}
