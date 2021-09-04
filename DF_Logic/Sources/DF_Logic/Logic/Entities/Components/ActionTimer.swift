//
//  ActionTimer.swift
//  ActionTimer
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class ActionTimer: IWorldEntityComponent, Disposable {
    public unowned var worldEntity: WorldEntity
    
    private let timePartsPerSecond = 1000
    private let interval: Int
    private var currentTime = 0
    private var action: (() -> ())?
    
    public init(worldEntity: WorldEntity, intervalInSeconds: Double, action: @escaping () -> ()) {
        self.worldEntity = worldEntity
        self.interval = Int(intervalInSeconds * Double(timePartsPerSecond))
        self.action = action
    }
    
    public func dispose() {
        action = nil
    }
    
    public func resetTimer() {
        currentTime = 0
    }
    
    public func update(elapsedTime: TimeInterval) {
        currentTime += Int(elapsedTime * Double(timePartsPerSecond))
        
        if currentTime >= interval {
            action?()
            currentTime -= interval
        }
    }
}
