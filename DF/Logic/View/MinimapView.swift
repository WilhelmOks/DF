//
//  MinimapView.swift
//  MinimapView
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation
import AppKit

public final class MinimapView: WorldView {
    public let viewPort: ViewPort //TODO: make unowned?
    public let gameView: GameView //TODO: make unowned?
    
    public var drawVoronoiPoints: Bool = false
    public let drawGrid: Bool = false
    
    public let gridColor: Color = NSColor.gray.cgColor
    public let bgColor: Color = NSColor.black.cgColor
    
    public var isHovored: Bool = false
    public var isDragging: Bool = false
    
    public var viewPortLocation: Vector2 = .zero
    public var viewPortSize: Vector2 = .zero
    public var viewPortHalfSize: Vector2 = .zero
    public var viewPortCenter: Vector2 = .zero
    
    public var zoomedSpaceOffset: Vector2 = .zero
    public var vpcMinusZso: Vector2 = .zero
    public var zoomedCellSize: Vector2 = .zero
    public var zoomedCellSizeHalf: Vector2 = .zero
    
    public var destructionSelectionAnimationTime: Double = 0
    public let destructionSelectionAnimationInterval: Double = 1.5
    
    let borderColor: Color = NSColor.green.cgColor
    let mainWorldViewFrameColor: Color = NSColor.white.cgColor
    
    var hoveredCellPosition: IntVector2 = .zero
    
    public init(viewPort: ViewPort, gameView: GameView) {
        self.viewPort = viewPort
        self.gameView = gameView
    }
    
    public func drawWorldCells(startCell: IntVector2, cellRange: IntVector2) {
        let world = gameView.game.world!
        
        let startChunk = world.chunkFromCell(startCell)
        let endChunk = world.chunkFromCell(startCell + cellRange)
        let chunkRange = endChunk - startChunk + IntVector2.one

        let zoomedCellChunkSize = zoomedCellSize * World.chunkSize.vector2

        gameView.renderer.beginSpriteBatch()

        for chunkLocation in Grid.coordinatesInRange(offset: startChunk, size: chunkRange) {
            let p = vpcMinusZso + chunkLocation.vector2 * zoomedCellChunkSize

            /*
            let ground = world.getCell(chunkLocation)?.ground ?? Ground.none
            Color groundColor;
            switch (ground)
            {
                case Ground.Earth: groundColor = Colors.Brown; break;
                case Ground.Grass: groundColor = Colors.DarkGreen; break;
                case Ground.Sand: groundColor = Colors.SandyBrown; break;
            }*/

            if let chunkBitmap = world.chunkBitmaps[chunkLocation] {
                gameView.renderer.drawBitmapFromSpriteBatch(chunkBitmap, location: p, size: zoomedCellChunkSize + Vector2.one)
            }
        }

        gameView.renderer.endSpriteBatch()
    }

    public func drawHoveredCell() {
        if isHovored {
            let p = vpcMinusZso + hoveredCellPosition.vector2 * zoomedCellSize;
            gameView.renderer.fillRectangle(location: p, size: zoomedCellSize, color: NSColor.red.cgColor)
        }
    }

    public func drawBorder() {
        gameView.renderer.drawRectangle(location: viewPortLocation, size: viewPortSize, color: borderColor, thickness: 4)
    }

    public func drawMainWorldViewFrame() {
        let bounds = gameView.mainWorldView.visualWorldBounds()
        let start = screenFromWorld(bounds.topLeft)
        let end = screenFromWorld(bounds.bottomDown)

        gameView.renderer.drawRectangle(location: start, size: end - start, color: mainWorldViewFrameColor, thickness: 2)
    }

    public func drawGrid(startCell: IntVector2, endCell: IntVector2) {

    }

    public func drawEntities(startCell: IntVector2, cellRange: IntVector2) {

    }

    public func update(elapsedTime: TimeInterval) {
        
    }

    public func handleHoverEvent(_ pointerPosition: Vector2) -> Bool {
        isHovored = (gameView.usingMousePointer && pointerPosition.isInsideOfRect(location: viewPort.location, size: viewPort.size))
        if isHovored || isDragging {
            if gameView.directScrollHolding {
                let delta = pointerPosition - gameView.currentPointerPosition
                viewPort.spaceOffset -= delta / viewPort.spaceZoom
                gameView.mainWorldView.viewPort.spaceOffset = viewPort.spaceOffset
                isDragging = true
            } else if gameView.indirectScrollHolding {
                isDragging = true
            } else {
                hoveredCellPosition = cellFromScreen(pointerPosition)
            }
        }
        return isHovored || isDragging
    }

    public func handleLeftClick(_ pointerPosition: Vector2) -> Bool {
        if viewPort.rect.contains(pointerPosition) {
            let clickedCell = cellFromScreen(pointerPosition)
            print("left click minimap cell \(clickedCell)")
            return true
        } else {
            return false
        }
    }
}
