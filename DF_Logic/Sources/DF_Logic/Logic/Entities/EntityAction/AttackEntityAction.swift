//
//  AttackEntityAction.swift
//  AttackEntityAction
//
//  Created by Wilhelm Oks on 04.09.21.
//

import Foundation

public final class AttackEntityAction: ActionBase {
    public weak var entityToAttack: WorldEntity?
    
    public init(entityToAttack: WorldEntity) {
        self.entityToAttack = entityToAttack
    }
}
