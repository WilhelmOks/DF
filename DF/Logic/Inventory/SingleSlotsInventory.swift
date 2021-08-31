//
//  SingleSlotsInventory.swift
//  SingleSlotsInventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public class SingleSlotsInventory<IT>: Inventory<IT, IT> where IT: Equatable & Hashable {
    public override func isFull() -> Bool {
        slots.allSatisfy{ $0 != nil }
    }
    
    public override func add(itemType: IT, numberOfItems: Int) -> Int {
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
    
    public override func canBeAddedCount(itemType: IT) -> Int {
        slots.filter{ $0 == nil }.count
    }
    
    public override func canBeAddedAny(itemType: IT) -> Bool {
        !isFull()
    }
    
    public override func count(itemType: IT) -> Int {
        slots.filter{ $0 == itemType }.count
    }
    
    public override func contains(itemType: IT) -> Bool {
        slots.contains(itemType)
    }
    
    public override func remove(itemType: IT, numberOfItems: Int) -> Int {
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
    
    public override func remove(itemType: IT) -> Int {
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
    
    public override func distinctContents() -> [IT] {
        slots.compactMap{$0}.uniqueElements()
    }
    
    public override func removeOneFromSlot(_ slotIndex: Int) -> Bool {
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
