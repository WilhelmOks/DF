//
//  DepositItemsAction.swift
//  DepositItemsAction
//
//  Created by Wilhelm Oks on 04.09.21.
//

import Foundation

public final class DepositItemsAction: ActionBase {
    public weak var targetEntity: WorldEntity?
    
    public init(targetEntity: WorldEntity) {
        self.targetEntity = targetEntity
    }
}
