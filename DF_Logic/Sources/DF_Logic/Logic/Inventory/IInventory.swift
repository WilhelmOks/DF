//
//  IInventory.swift
//  IInventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol IInventory {
    //associatedtype T
    associatedtype IT
    
    func add(itemType: IT, numberOfItems: Int) -> Int

    func canBeAddedCount(itemType: IT) -> Int

    func canBeAddedAny(itemType: IT) -> Bool

    func count(itemType: IT) -> Int

    func contains(itemType: IT) -> Bool

    func remove(itemType: IT, numberOfItems: Int) -> Int

    func remove(itemType: IT) -> Int
    
    func removeOneFromSlot(_ slotIndex: Int) -> Bool

    func transfer<Inv>(to targetInventory: inout Inv) -> Int where Inv: IInventory, Inv.IT == Self.IT

    func transfer<Inv>(to targetInventory: inout Inv, itemType: IT) -> Int where Inv: IInventory, Inv.IT == Self.IT

    func canTransferAny<Inv>(targetInventory: Inv) -> Bool where Inv: IInventory, Inv.IT == Self.IT

    func canTransferAny<Inv>(targetInventory: Inv, itemType: IT) -> Bool where Inv: IInventory, Inv.IT == Self.IT

    func distinctContents() -> [IT]

    func isEmpty() -> Bool

    func isFull() -> Bool
}
