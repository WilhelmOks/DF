//
//  ViewPort.swift
//  ViewPort
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

public class ViewPort {
    public var location: IntVector2
    public var size: IntVector2
    
    public var rect: Rect { location.rect(withSize: size) }
    
    var intermediateSpaceZoom: Double = 1
    public var spaceZoom: Double {
        get {
            /// return `intermediateSpaceZoom` rounded to 3 decimal places:
            var input = Decimal(intermediateSpaceZoom)
            var result: Decimal = 1
            NSDecimalRound(&result, &input, 3, .plain)
            return (result as NSDecimalNumber).doubleValue
        }
        set {
            intermediateSpaceZoom = newValue
        }
    }
    
    var intermediateSpaceOffset: Vector2 = .zero
    public var spaceOffset: Vector2 {
        get { intermediateSpaceOffset }
        set { intermediateSpaceOffset = newValue }
    }
    
    public init(location: IntVector2, size: IntVector2) {
        self.location = location
        self.size = size
    }
}
