//
//  MobileEntity.swift
//  MobileEntity
//
//  Created by Wilhelm Oks on 04.09.21.
//

import Foundation

public class MobileEntity: WorldEntity {
    private let random: RandomNumberGenerator
    
    public var nextOffsetTarget: IntVector2 = .zero
    
    public private(set) var maxVelocity = 40
    
    public var plannedPath: [IntVector2] = []
    
    public var plannedAction: ActionBase?
    
    public var attackIntervalTimer: ActionTimer?
    public var attackDurationTimer: ActionTimer?
    
    public private(set) var isAttacking: Bool = false
    
    public init(game: Game, seed: UInt64) {
        random = RandomNumberGenerator(seed: seed)

        super.init(game: game)
        
        offset = randomOffset()
        calculateNextOffsetTarget()

        attackDurationTimer = ActionTimer(worldEntity: self, intervalInSeconds: 0.18, action: handleAttackEnded)
    }

    func randomOffset() -> IntVector2 {
        IntVector2(random.next(MobileEntity.offsetRange), random.next(MobileEntity.offsetRange)) - IntVector2(MobileEntity.offsetRange / 2, MobileEntity.offsetRange / 2)
    }

    func calculateNextOffsetTarget() {
        switch plannedAction {
        case let pickupItemAction as PickupItemAction where pickupItemAction.item?.cellLocation == cellLocation:
            nextOffsetTarget = pickupItemAction.item?.offset ?? .zero
            return
        default:
            nextOffsetTarget = randomOffset()
        }
    }

    func moveIntoDirection(direction: IntVector2, elapsedTime: TimeInterval) {
        var v = (direction * MobileEntity.offsetRange * 2 - offset + nextOffsetTarget).vector2
        v = v / v.length * Double(MobileEntity.offsetRange) * elapsedTime * Double(maxVelocity) * 0.1
        offset = offset + IntVector2(v)
    }

    private func performActions() {
        let touchDist = MobileEntity.offsetRange / 10

        switch plannedAction {
        case let itemPickupAction as PickupItemAction:
            if let item = itemPickupAction.item {
                if item.cellLocation == self.cellLocation && item.offset.distance(to: offset) < Double(touchDist) {
                    let added = inventory?.add(itemType: item.itemType, numberOfItems: 1) ?? 0
                    if added > 0 {
                        game.world.entitiesToDestroy.append(item)
                    }
                }
            }
        case let depositItemsAction as DepositItemsAction:
            if let container = depositItemsAction.targetEntity, var containerInventory = container.inventory {
                let cellOffset = container.cellLocation - self.cellLocation
                if cellOffset == .zero || game.world.pathFinder.possibleOffsets.contains(cellOffset) {
                    let _ = inventory?.transfer(to: &containerInventory)
                    cancelPlan()
                }
            }
        default:
            break
        }
    }
    
    public func cancelPlan() {
        switch plannedAction {
        case let pickupItemAction as PickupItemAction:
            pickupItemAction.item?.targetedByEntity = nil
        case let attackEntityAction as AttackEntityAction:
            if let refinableEntity = attackEntityAction.entityToAttack as? RefinableEntity {
                refinableEntity.isTargetOfEntities.removeAll{ $0 == self }
            }
        default:
            break
        }
        plannedAction = nil
        plannedPath = []
    }

    public func assignDepositItemsPlan(targetEntity: WorldEntity) {
        cancelPlan()

        let offset = targetEntity.cellLocation - self.cellLocation

        func assignPlannedAction() {
            plannedAction = DepositItemsAction(targetEntity: targetEntity)
        }

        if game.world.pathFinder.possibleOffsets.contains(offset) {
            assignPlannedAction()
        } else {
            plannedPath = game.world.pathFinder.findPath(start: cellLocation, end: targetEntity.cellLocation, includingEnd: false, isPassable: { location in game.world.cellIsPassableForEntity(location: location, entity: self) })
            if !plannedPath.isEmpty {
                assignPlannedAction()
            } else {
                print("Trying to assign DepositItemsAction: Path not found or too long.")
            }
        }
    }

    public func assignPickupItemPlan(item: ItemEntity) {
        cancelPlan()

        if item.cellLocation == self.cellLocation {
            item.targetedByEntity = self
            plannedAction = PickupItemAction(item: item)
            calculateNextOffsetTarget()
        } else {
            plannedPath = game.world.pathFinder.findPath(start: cellLocation, end: item.cellLocation, includingEnd: true, isPassable: { location in game.world.cellIsPassableForEntity(location: location, entity: self) })
            if !plannedPath.isEmpty {
                item.targetedByEntity = self
                plannedAction = PickupItemAction(item: item)
            } else {
                print("Trying to assign PickupItemAction: Path not found or too long.")
            }
        }
    }

    public func assignAttackEntityPlan(entity: WorldEntity) {
        cancelPlan()

        let offset = entity.cellLocation - self.cellLocation

        func assignPlannedAction() {
            plannedAction = AttackEntityAction(entityToAttack: entity)
            if let refinableEntity = entity as? RefinableEntity {
                refinableEntity.isTargetOfEntities.append(self)
            }
            attackIntervalTimer?.dispose()
            attackIntervalTimer = ActionTimer(worldEntity: self, intervalInSeconds: 0.3, action: { [weak self] in
                guard let self = self else { return }
                self.attack(entity: entity)
                let stillTheSamePlan: Bool
                if let attackEntityAction = self.plannedAction as? AttackEntityAction, entity == attackEntityAction.entityToAttack, self.game.world.entities.contains(value: entity, forKey: entity.cellLocation) {
                    stillTheSamePlan = true
                } else {
                    stillTheSamePlan = false
                }
                
                if !stillTheSamePlan {
                    self.plannedAction = nil
                    self.attackIntervalTimer?.dispose()
                    self.attackIntervalTimer = nil
                }
            })
        }

        if game.world.pathFinder.possibleOffsets.contains(offset) {
            assignPlannedAction()
        } else {
            plannedPath = game.world.pathFinder.findPath(start: cellLocation, end: entity.cellLocation, includingEnd: false, isPassable: { location in game.world.cellIsPassableForEntity(location: location, entity: self) })
            if !plannedPath.isEmpty {
                assignPlannedAction()
            } else {
                print("Trying to assign AttackEntityAction: Path not found or too long.")
            }
        }
    }

    private func attack(entity: WorldEntity) {
        isAttacking = true
        attackDurationTimer?.resetTimer()

        deal(damage: 5, to: entity) //TODO: decide how many damage points to deal
    }

    private func handleAttackEnded() {
        isAttacking = false
    }

    public func handleNewCellLocation(_ newLocation: IntVector2) {
        if !plannedPath.isEmpty && plannedPath.first == newLocation {
            plannedPath.removeFirst()
        }
        cellLocation = newLocation
    }

    public override func update(elapsedTime: TimeInterval) {
        super.update(elapsedTime: elapsedTime)
        if !plannedPath.isEmpty {
            if let nextLocation = plannedPath.first, World.cellIsNeighbor(nextLocation, cellLocation) {
                let direction = (nextLocation - cellLocation).direction9State
                moveIntoDirection(direction: direction, elapsedTime: elapsedTime)
            }
        } else {
            let distToTarget = (nextOffsetTarget - offset).length
            let travelDistNextStep = Double(MobileEntity.offsetRange) * elapsedTime * Double(maxVelocity) * 0.1
            if distToTarget > travelDistNextStep {
                moveIntoDirection(direction: .zero, elapsedTime: elapsedTime)
            }

            if plannedAction is AttackEntityAction {
                attackIntervalTimer?.update(elapsedTime: elapsedTime)
            }
        }

        performActions()
    }
}
