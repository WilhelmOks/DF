//
//  WorldView.swift
//  WorldView
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation
import AppKit

public protocol WorldView: BaseView {
    var viewPort: ViewPort { get }
    var gameView: GameView { get }
    
    var gridColor: Color { get }
    var bgColor: Color { get }
    
    var drawGrid: Bool { get }
    var drawVoronoiPoints: Bool { get }
    
    var viewPortLocation: Vector2 { get set }
    var viewPortSize: Vector2 { get set }
    var viewPortHalfSize: Vector2 { get set }
    var viewPortCenter: Vector2 { get set }
    
    var zoomedSpaceOffset: Vector2 { get set }
    var vpcMinusZso: Vector2 { get set }
    var zoomedCellSize: Vector2 { get set }
    var zoomedCellSizeHalf: Vector2 { get set }
    
    var destructionSelectionAnimationTime: Double { get set }
    var destructionSelectionAnimationInterval: Double { get }
    
    func drawBorder()
    func drawMainWorldViewFrame()
    func drawHoveredCell()
}

public let worldViewCellSize = IntVector2(64, 64)

public extension WorldView {
    mutating func prepareToDraw() {
        viewPortLocation = viewPort.location.vector2
        viewPortSize = viewPort.size.vector2
        viewPortHalfSize = viewPort.size.vector2 * 0.5
        viewPortCenter = viewPortLocation + viewPortHalfSize

        let zoom = viewPort.spaceZoom
        zoomedSpaceOffset = IntVector2(viewPort.spaceOffset * zoom, conversion: { v in Int(floor(v)) }).vector2
        zoomedCellSize = worldViewCellSize * zoom
        zoomedCellSizeHalf = zoomedCellSize * 0.5

        vpcMinusZso = viewPortCenter - zoomedSpaceOffset

        let _ = gameView.currentPointerPosition
    }

    mutating func draw() {
        prepareToDraw()

        let renderer = gameView.renderer

        let startCell = cellFromScreen(viewPortLocation - Vector2.one)
        let endCell = cellFromScreen(viewPortLocation + viewPortSize + Vector2.one)
        let cellRange = endCell - startCell + IntVector2.one

        renderer.beginClippingRect(location: viewPort.location, size: viewPort.size)
        do {
            renderer.fillRectangle(location: viewPortLocation, size: viewPortSize, color: bgColor)

            drawWorldCells(startCell: startCell, cellRange: cellRange)

            if drawGrid {
                drawGrid(startCell: startCell, endCell: endCell)
            }

            if drawVoronoiPoints {
                drawVoronoiPoints()
            }

            drawEntities(startCell: startCell, cellRange: cellRange)

            drawMainWorldViewFrame()

            drawHoveredCell()

            drawBorder()
        }
        renderer.endClippingRect()
    }
    
    func drawWorldCells(startCell: IntVector2, cellRange: IntVector2) {
        let zoomedCellSize1 = zoomedCellSize + Vector2.one

        gameView.renderer.beginSpriteBatch()

        for cellLocation in Grid.coordinatesInRange(offset: startCell, size: cellRange) {
            let p = vpcMinusZso + cellLocation.vector2 * zoomedCellSize

            let cell = gameView.game.world.getCell(cellLocation)
            let ground = cell?.ground ?? Ground.none

            if let cell = cell {
                let variant = cell.groundVariant
                if let tile = gameView.game.resources.bitmaps.tiles.worldGround[ground]?[variant] {
                    if ground == Ground.sand || ground == Ground.soil {
                        gameView.renderer.drawBitmapFromSpriteBatch(tile, location: p, size: zoomedCellSize1)
                    }
                }
            } else if isDragging {
                let chunkCoordinates = gameView.game.world.chunkFromCell(cellLocation)
                gameView.game.world.generator.generateCellChunk(chunkCoordinates)
            }
        }

        gameView.renderer.endSpriteBatch()
    }
    
    func drawEntities(startCell: IntVector2, cellRange: IntVector2) {
        let world = gameView.game.world!
        let bitmaps = gameView.game.resources.bitmaps!
        
        gameView.renderer.beginSpriteBatch()

        //entity shadows:
        for cellLocation in Grid.coordinatesInRange(offset: startCell - IntVector2.one * 2, size: cellRange + IntVector2.one * 4) {
            if let entities = world.entities[cellLocation] {
                let p = vpcMinusZso + cellLocation.vector2 * zoomedCellSize + zoomedCellSizeHalf

                for entity in entities {
                    switch entity {
                    case let workerBot as WorkerBotEntity:
                        let offset = workerBot.realOffset * zoomedCellSizeHalf
                        let shadowBitmap = bitmaps.effects.shadow!
                        let shadowRenderSize = shadowBitmap.sizeInPixels.vector2 * viewPort.spaceZoom
                        gameView.renderer.drawBitmapFromSpriteBatch(shadowBitmap, location: p + offset, size: shadowRenderSize)
                    default:
                        break
                    }
                }
            }
        }

        //entities:
        for cellLocation in Grid.coordinatesInRange(offset: startCell - IntVector2.one * 2, size: cellRange + IntVector2.one * 4) {
            if let entities = world.entities[cellLocation] {
                let p = vpcMinusZso + cellLocation.vector2 * zoomedCellSize + zoomedCellSizeHalf

                for entity in entities {
                    switch entity {
                    case let buildingEntity as BuildingEntity:
                        if buildingEntity.buildingType === gameView.game.buildingTypes.inserter {
                            do { //base
                                let bitmap = bitmaps.entities.buildings.itemGrabberBase!
                                let offset = buildingEntity.realOffset * zoomedCellSizeHalf
                                let renderOffset = Vector2(-32, -32) * viewPort.spaceZoom
                                let renderSize = bitmap.sizeInPixels.vector2 * viewPort.spaceZoom * 1.0
                                gameView.renderer.drawBitmapFromSpriteBatch(bitmap, location: p + offset + renderOffset, size: renderSize)
                            }

                            do { //hand
                                let bitmap = bitmaps.entities.buildings.itemGrabberHand!
                                var offset = buildingEntity.realOffset * zoomedCellSizeHalf
                                offset += (buildingEntity.itemGrabber?.handLocation ?? .zero) * zoomedCellSize
                                let renderOffset = Vector2(-32, -32) * viewPort.spaceZoom
                                let renderSize = bitmap.sizeInPixels.vector2 * viewPort.spaceZoom * 1.0
                                gameView.renderer.drawBitmapFromSpriteBatch(bitmap, location: p + offset + renderOffset, size: renderSize)
                            }
                        } else {
                            let bitmap = bitmaps.entities.buildings.container!
                            let offset = buildingEntity.realOffset * zoomedCellSizeHalf
                            let renderOffset = Vector2(-19, -27) * viewPort.spaceZoom
                            let renderSize = bitmap.sizeInPixels.vector2 * viewPort.spaceZoom * 1.3
                            gameView.renderer.drawBitmapFromSpriteBatch(bitmap, location: p + offset + renderOffset, size: renderSize)
                        }
                    case let refinableEntity as RefinableEntity where refinableEntity.refinableType === gameView.game.refinableTypes.tree:
                        let variant = refinableEntity.variant
                        let sheet = bitmaps.treesTest!
                        let offset = refinableEntity.realOffset * zoomedCellSizeHalf + zoomedCellSizeHalf * 0.5
                        let tintValue = Float(sin((destructionSelectionAnimationTime / destructionSelectionAnimationInterval) * Double.pi * 2) * 0.5 + 0.5)
                        var tint = SIMD4<Float>.one //Vector4.One;
                        if !gameView.game.world.entitiesMarkedForDestruction.keys(containing: refinableEntity).isEmpty {
                            tint = SIMD4<Float>(1.0, 1.0 - tintValue * 0.5, 1.0 - tintValue * 0.5, 1.0)
                        }
                        gameView.renderer.drawBitmapFromSpriteSheetBatch(spriteSheet: sheet, index: variant, location: p + offset, size: sheet.regions[variant].size * viewPort.spaceZoom/* * 0.7f*/, tint: tint)
                    case let workerBot as WorkerBotEntity:
                        let bitmap = bitmaps.entities.workerBot!
                        let offset = workerBot.realOffset * zoomedCellSizeHalf
                        let dummyLevitationAnimationOffset = (sin((destructionSelectionAnimationTime / destructionSelectionAnimationInterval) * Double.pi * 2) * 0.5 + 0.5) * viewPort.spaceZoom * 2.5
                        let elevationOffset = zoomedCellSizeHalf.y + dummyLevitationAnimationOffset
                        let renderSize = bitmap.sizeInPixels.vector2 * viewPort.spaceZoom
                        gameView.renderer.drawBitmapFromSpriteBatch(bitmap, location: p + offset + Vector2(0, -elevationOffset), size: renderSize)

                        if workerBot.isAttacking, let attackEntityAction = workerBot.plannedAction as? AttackEntityAction, let entityToAttack = attackEntityAction.entityToAttack {
                            let attackEffect = bitmaps.effects.beam!
                            let diff = (entityToAttack.cellLocation - workerBot.cellLocation).vector2 * worldViewCellSize.vector2 + (entityToAttack.realOffset - workerBot.realOffset) * worldViewCellSize.vector2 * 0.5
                            let rotationAngle = atan2(diff.y, diff.x)
                            gameView.renderer.drawBitmapFromSpriteBatch(attackEffect, location: p + offset + Vector2(0, -elevationOffset) + renderSize * 0.5 + Vector2(0, -3) * viewPort.spaceZoom, size: attackEffect.sizeInPixels.vector2 * viewPort.spaceZoom, rotationAngle: rotationAngle, rotationPoint: Vector2(0, Double(attackEffect.sizeInPixels.y) * 0.5))
                        }
                    case let itemEntity as ItemEntity:
                        let bitmap = bitmaps.items.wood!
                        let offset = itemEntity.realOffset * zoomedCellSizeHalf
                        //var bitmapCenterOffset = bitmap.SizeInPixels * (0.5f * ViewPort.SpaceZoom);
                        gameView.renderer.drawBitmapFromSpriteBatch(bitmap, location: p + offset/* - bitmapCenterOffset*/, size: bitmap.sizeInPixels.vector2 * viewPort.spaceZoom)
                    default:
                        break
                    }
                }
            }
        }

        //markers:
        for cellLocation in Grid.coordinatesInRange(offset: startCell - IntVector2.one * 2, size: cellRange + IntVector2.one * 4) {
            if let markers = world.itemGrabberMarkedLocations[cellLocation] {
                let p = vpcMinusZso + cellLocation.vector2 * zoomedCellSize + zoomedCellSizeHalf

                for marker in markers {
                    switch marker {
                    case is ItemGrabberInputMarker:
                        let offset = -zoomedCellSizeHalf;
                        let bitmap = bitmaps.markers.itemGrabberInput!
                        let renderSize = bitmap.sizeInPixels.vector2 * viewPort.spaceZoom
                        gameView.renderer.drawBitmapFromSpriteBatch(bitmap, location: p + offset, size: renderSize)

                    case is ItemGrabberOutputMarker:
                        let offset = -zoomedCellSizeHalf
                        let bitmap = bitmaps.markers.itemGrabberOutput!
                        let renderSize = bitmap.sizeInPixels.vector2 * viewPort.spaceZoom
                        gameView.renderer.drawBitmapFromSpriteBatch(bitmap, location: p + offset, size: renderSize)
                        
                    default:
                        break
                    }
                }
            }
        }

        gameView.renderer.endSpriteBatch()
    }
    
    func drawGrid(startCell: IntVector2, endCell: IntVector2) {
        for x in startCell.x...endCell.x {
            let cellLocation = IntVector2(x, startCell.y).vector2
            let cellLocation2 = IntVector2(x, endCell.y + 1).vector2
            let p = vpcMinusZso + cellLocation * zoomedCellSize
            let p2 = vpcMinusZso + cellLocation2 * zoomedCellSize
            gameView.renderer.drawLine(start: p, end: p2, color: gridColor, thickness: 1)
        }

        for y in startCell.y...endCell.y {
            let cellLocation = IntVector2(startCell.x, y).vector2
            let cellLocation2 = IntVector2(endCell.x + 1, y).vector2
            let p = vpcMinusZso + cellLocation * zoomedCellSize
            let p2 = vpcMinusZso + cellLocation2 * zoomedCellSize
            gameView.renderer.drawLine(start: p, end: p2, color: gridColor, thickness: 1)
        }
    }
    
    func drawVoronoiPoints() {
        for point in gameView.game.world.getAllVoronoiPoints() {
            let cellLocation = point.cellCoordinates
            let color: Color
            switch point.ground {
            case Ground.soil: color = NSColor.red.cgColor
            case Ground.grass: color = NSColor.green.cgColor
            case Ground.sand: color = NSColor.yellow.cgColor
            default: color = .black
            }
            let p = vpcMinusZso + cellLocation.vector2 * zoomedCellSize
            gameView.renderer.fillRectangle(location: p + Vector2.one, size: zoomedCellSize - Vector2.one, color: color)
        }
    }
    
    func screenFromWorld(_ worldCoordinates: Vector2) -> Vector2 {
        (viewPort.location.vector2 + viewPort.size * 0.5) + worldCoordinates * viewPort.spaceZoom - viewPort.spaceOffset * viewPort.spaceZoom //TODO: optimize
    }
    
    func worldFromScreen(_ screenCoordinates: Vector2) -> Vector2 {
        (screenCoordinates - vpcMinusZso) / viewPort.spaceZoom
    }
    
    func cellFromWorld(_ worldCoordinates: Vector2) -> IntVector2 {
        IntVector2(worldCoordinates / worldViewCellSize.vector2, conversion: { Int(floor($0)) })
    }
    
    func cellFromScreen(_ screenCoordinates: Vector2) -> IntVector2 {
        let worldCoordinate = worldFromScreen(screenCoordinates)
        return cellFromWorld(worldCoordinate)
    }
    
    func visualWorldBounds() -> (topLeft: Vector2, bottomDown: Vector2) {
        (topLeft: worldFromScreen(viewPort.location.vector2), bottomDown: worldFromScreen((viewPort.location + viewPort.size).vector2))
    }
}
