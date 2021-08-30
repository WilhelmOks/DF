//
//  BuildingType.swift
//  BuildingType
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class BuildingType {
    public let cellRange: IntVector2
    public let maxHitpoints: Int
    public let numberOfInventorySlots: Int
    public let inventorySlotsAreStacked: Bool
    public let isItemGrabber: Bool
    
    public init(cellRange: IntVector2, maxHitpoints: Int, numberOfInventorySlots: Int, inventorySlotsAreStacked: Bool, isItemGrabber: Bool) {
        self.cellRange = cellRange
        self.maxHitpoints = maxHitpoints
        self.numberOfInventorySlots = numberOfInventorySlots
        self.inventorySlotsAreStacked = inventorySlotsAreStacked
        self.isItemGrabber = isItemGrabber
    }
}

public final class BuildingTypeDefinition {
    public let container = BuildingType(
        cellRange: IntVector2.one,
        maxHitpoints: 100,
        numberOfInventorySlots: 1,
        inventorySlotsAreStacked: true,
        isItemGrabber: false
    )
    
    public let inserter = BuildingType(
        cellRange: IntVector2.one,
        maxHitpoints: 20,
        numberOfInventorySlots: 0,
        inventorySlotsAreStacked: false,
        isItemGrabber: true
    )
}
