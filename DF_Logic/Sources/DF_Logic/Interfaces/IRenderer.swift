//
//  IRenderer.swift
//  IRenderer
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public protocol IRenderer {
    func beginClippingRect(location: IntVector2, size: IntVector2)
    func endClippingRect()
    
    func beginSpriteBatch()
    func endSpriteBatch()
    
    func fillRectangle(location: Vector2, size: Vector2, color: Color)
    func drawRectangle(location: Vector2, size: Vector2, color: Color, thickness: Double)
    
    func drawLine(start: Vector2, end: Vector2, color: Color, thickness: Double)
    
    func drawBitmap(_ bitmap: IBitmap, location: Vector2, size: Vector2)
    func drawBitmap(_ bitmap: IBitmap, location: Vector2, size: Vector2, rotationAboutCenter: Double)
    
    func drawBitmapFromSpriteBatch(_ bitmap: IBitmap, location: Vector2, size: Vector2)
    func drawBitmapFromSpriteBatch(_ bitmap: IBitmap, location: Vector2, size: Vector2, rotationAngle: Double, rotationPoint: Vector2)
    
    func drawBitmapFromSpriteSheetBatch(spriteSheet: SpriteSheet, index: Int, location: Vector2, size: Vector2, tint: SIMD4<Float>?)
}
