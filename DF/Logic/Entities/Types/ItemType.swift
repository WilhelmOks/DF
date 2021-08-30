//
//  ItemType.swift
//  ItemType
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class ItemType {
    private let nameKey: String
    public let maxInventoryStackSize: Int
    private let defaultName = "?"
    public var name: String { ItemType.names[nameKey] ?? defaultName }
    
    public init(nameKey: String, maxInventoryStackSize: Int) {
        self.nameKey = nameKey
        self.maxInventoryStackSize = maxInventoryStackSize
    }
    
    private static let names: [String: String] = [
        "Item_Dummy" : "Dummy",
        "Item_Wood" : "Wood",
    ]
}

extension ItemType: Hashable {
    public static func == (lhs: ItemType, rhs: ItemType) -> Bool {
        lhs.nameKey == rhs.nameKey
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(nameKey)
        hasher.combine(name)
    }
}

public final class ItemTypeDefinition {
    public let dummy = ItemType(nameKey: "Item_Dummy", maxInventoryStackSize: 10)
    public let wood = ItemType(nameKey: "Item_Wood", maxInventoryStackSize: 5)
}
