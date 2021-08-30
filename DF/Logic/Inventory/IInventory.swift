//
//  IInventory.swift
//  IInventory
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol IInventory {
    associatedtype T
    
    mutating func add(itemType: T, numberOfItems: Int) -> Int

    func canBeAddedCount(itemType: T) -> Int

    func canBeAddedAny(itemType: T) -> Bool

    func count(itemType: T) -> Int

    func contains(itemType: T) -> Bool

    mutating func remove(itemType: T, numberOfItems: Int) -> Int

    mutating func remove(itemType: T) -> Int
    
    mutating func removeOneFromSlot(_ slotIndex: Int) -> Bool

    mutating func transferTo<Inv>(targetInventory: Inv) -> Int where Inv: IInventory

    mutating func transferTo<Inv>(targetInventory: Inv, itemType: T) -> Int where Inv: IInventory

    func canTransferAny<Inv>(targetInventory: Inv) -> Bool where Inv: IInventory

    func canTransferAny<Inv>(targetInventory: Inv, itemType: T) -> Bool where Inv: IInventory

    func distinctContents() -> [T]

    func isEmpty() -> Bool

    func isFull() -> Bool
}
