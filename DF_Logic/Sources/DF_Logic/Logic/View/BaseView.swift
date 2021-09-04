//
//  BaseView.swift
//  BaseView
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

public protocol BaseView {
    var isHovored: Bool { get set }
    var isDragging: Bool { get set }
    
    func handleLeftClick(_ pointerPosition: Vector2) -> Bool
    func handleHoverEvent(_ pointerPosition: Vector2) -> Bool
    
    func update(elapsedTime: TimeInterval)
}
