//
//  SmoothViewPort.swift
//  SmoothViewPort
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

public final class SmoothViewPort: ViewPort {
    var spaceZoomSpeed: Double = 0
        
    public func accelerateSpaceZoom(_ zoomChange: Double) {
        spaceZoomSpeed += zoomChange
    }
    
    public func update(elapsedTime: TimeInterval) {
        let maxSpaceZoom: Double = 4
        let minSpaceZoom: Double = 0.25 * 0.5
        
        intermediateSpaceZoom *= pow(10, spaceZoomSpeed * 0.015 * elapsedTime)
        spaceZoomSpeed *= pow(10, -9.0 * elapsedTime)
        
        if intermediateSpaceZoom < minSpaceZoom {
            intermediateSpaceZoom = minSpaceZoom
        } else if intermediateSpaceZoom > maxSpaceZoom {
            intermediateSpaceZoom = maxSpaceZoom
        }
    }
}
