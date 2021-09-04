//
//  InventorySlotStack.swift
//  InventorySlotStack
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public struct InventorySlotStack<T>: CustomStringConvertible {
    //public typealias IT = T
    
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
