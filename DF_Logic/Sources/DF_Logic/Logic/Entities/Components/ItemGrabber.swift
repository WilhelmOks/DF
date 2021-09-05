//
//  ItemGrabber.swift
//  ItemGrabber
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class ItemGrabber: IWorldEntityComponent {
    public unowned var worldEntity: WorldEntity
    
    private static let angleEpsilonDegrees: Double = 1
    private static let angleEpsilon: Double = Double.pi * angleEpsilonDegrees / 180.0
    
    private static let armAngularVelocityDegreesPerSecond: Double = 70
    private static let armAngularVelocityRadiansPerSecond: Double = Double.pi * armAngularVelocityDegreesPerSecond / 180.0
    
    public let inputMarker: ItemGrabberInputMarker
    public let outputMarker: ItemGrabberOutputMarker
    
    public private(set) var handLocation = -Vector2.unitX
    
    private var outputMode = true
    
    public init(worldEntity: WorldEntity, inputMarker: ItemGrabberInputMarker, outputMarker: ItemGrabberOutputMarker) {
        self.worldEntity = worldEntity
        self.inputMarker = inputMarker
        self.outputMarker = outputMarker
        
        self.inputMarker.itemGrabber = self
        self.outputMarker.itemGrabber = self
    }
    
    public func update(elapsedTime: TimeInterval) {
        let markerLocation = outputMode ? outputMarker.location : inputMarker.location
        let vMarker = (markerLocation - worldEntity.cellLocation).vector2
        let vHand = handLocation

        let angleDelta = vHand.angleDelta(to: vMarker)
        let angleDeltaAbs = abs(angleDelta)
        if angleDeltaAbs > ItemGrabber.angleEpsilon {
            let sign: Double = angleDelta < 0 ? -1 : angleDelta > 0 ? 1 : 0

            var aStep = elapsedTime * ItemGrabber.armAngularVelocityRadiansPerSecond
            if aStep > angleDeltaAbs {
                aStep = angleDeltaAbs
            }
            handLocation = handLocation.rotated(by: aStep * sign)
        } else {
            outputMode = !outputMode
        }
    }
}

public class ItemGrabberMarker: Equatable {
    public let id = UUID()
    public unowned var itemGrabber: ItemGrabber!
    public private(set) var location: IntVector2
    
    public init(location: IntVector2) {
        self.location = location
    }
    
    public static func == (lhs: ItemGrabberMarker, rhs: ItemGrabberMarker) -> Bool {
        lhs.id == rhs.id
    }
}

public final class ItemGrabberInputMarker: ItemGrabberMarker {}
public final class ItemGrabberOutputMarker: ItemGrabberMarker {}
