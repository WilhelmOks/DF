//
//  IInventory.swift
//  IInventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol IInventory {
    associatedtype T
    
    func add(itemType: T, numberOfItems: Int) -> Int

    func canBeAddedCount(itemType: T) -> Int

    func canBeAddedAny(itemType: T) -> Bool

    func count(itemType: T) -> Int

    func contains(itemType: T) -> Bool

    func remove(itemType: T, numberOfItems: Int) -> Int

    func remove(itemType: T) -> Int
    
    func removeOneFromSlot(_ slotIndex: Int) -> Bool

    func transfer<Inv>(to targetInventory: inout Inv) -> Int where Inv: IInventory, Inv.T == Self.T

    func transfer<Inv>(to targetInventory: inout Inv, itemType: T) -> Int where Inv: IInventory, Inv.T == Self.T

    func canTransferAny<Inv>(targetInventory: Inv) -> Bool where Inv: IInventory, Inv.T == Self.T

    func canTransferAny<Inv>(targetInventory: Inv, itemType: T) -> Bool where Inv: IInventory, Inv.T == Self.T

    func distinctContents() -> [T]

    func isEmpty() -> Bool

    func isFull() -> Bool
}
