//
//  InventorySlotStack.swift
//  InventorySlotStack
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

//public class InventorySlotStack<T>: CustomStringConvertible {
public struct InventorySlotStack<T>: CustomStringConvertible {
    public var itemType: T
    public var numberOfItems: Int

    public init(itemType: T, numberOfItems: Int) {
        self.itemType = itemType
        self.numberOfItems = numberOfItems
    }
    
    public var description: String {
        "\(numberOfItems) \(itemType)"
    }
}
