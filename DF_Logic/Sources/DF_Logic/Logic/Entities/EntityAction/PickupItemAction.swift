//
//  File.swift
//  File
//
//  Created by Wilhelm Oks on 04.09.21.
//

import Foundation

public final class PickupItemAction: ActionBase {
    public weak var item: ItemEntity?
    
    public init(item: ItemEntity) {
        self.item = item
    }
}
