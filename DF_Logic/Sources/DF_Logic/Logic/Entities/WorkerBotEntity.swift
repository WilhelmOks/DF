//
//  WorkerBotEntity.swift
//  WorkerBotEntity
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class WorkerBotEntity: MobileEntity {
    public var owner: Player?
    private var planAssignmentTimer: ActionTimer?
    
    public override init(game: Game, seed: UInt64) {
        super.init(game: game, seed: seed)
        
        planAssignmentTimer = ActionTimer(worldEntity: self, intervalInSeconds: 1, action: assignNewPlan)
        passable = true
        hitPoints = HitPoints.init(worldEntity: self, currentHitPoints: 100, maxHitpoints: 100)
        inventory = SingleItemsInventory(worldEntity: self, numberOfSlots: 2)
    }

    private func assignNewPlan() {
        if inventory?.isFull() ?? false {
            let depositItems = findContainerToDepositItemsAndAssignPlan()
            if !depositItems {
                let _ = findTreeToAttackAndAssignPlan()
            }
        } else {
            let pickupItem = findItemToPickupAndAssignPlan()
            if !pickupItem {
                let _ = findTreeToAttackAndAssignPlan()
            }
        }
    }

    public override func handleNewCellLocation(_ newLocation: IntVector2) {
        super.handleNewCellLocation(newLocation)
        calculateNextOffsetTarget()
    }

    private func findItemToPickupAndAssignPlan() -> Bool {
        let item = game.world.itemEntities.filter{ $0.targetedByEntity == nil }.min{ $0.cellLocation.distanceSquared(to: cellLocation) }
        return item != nil
    }

    private func findContainerToDepositItemsAndAssignPlan() -> Bool {
        guard let inventory = self.inventory else { return false }
        let container = game.world.containerEntities
            .filter{ inventory.canTransferAny(targetInventory: $0.inventory) }
            .min{ $0.cellLocation.distanceSquared(to: cellLocation) }
        if let container = container {
            if inventory.canTransferAny(targetInventory: container.inventory) {
                assignDepositItemsPlan(targetEntity: container)
                return true
            }
        }
        return false
    }

    private func findTreeToAttackAndAssignPlan() -> Bool {
        let entities = game.world.entitiesMarkedForDestruction.enumerated().flatMap{ $0.element.value }
        let entityToAttack = entities
            .filter{ ($0 as? RefinableEntity)?.isTargetOfEntities.isEmpty ?? true }
            .min{ $0.cellLocation.distanceSquared(to: cellLocation) }
        if let entityToAttack = entityToAttack {
            assignAttackEntityPlan(entity: entityToAttack)
            return true
        }
        return false
    }

    public override func update(elapsedTime: TimeInterval) {
        super.update(elapsedTime: elapsedTime)

        if plannedAction == nil && plannedPath.isEmpty {
            planAssignmentTimer?.update(elapsedTime: elapsedTime)
        }

        if isAttacking {
            attackDurationTimer?.update(elapsedTime: elapsedTime)
        }
    }
}
