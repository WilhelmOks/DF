//
//  MainWorldView.swift
//  MainWorldView
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation
import AppKit

public final class MainWorldView: WorldView {
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
    let hoverColor: Color = NSColor(red: 1, green: 1, blue: 1, alpha: 50.0/255.0).cgColor
    
    public init(viewPort: ViewPort, gameView: GameView) {
        self.viewPort = viewPort
        self.gameView = gameView
    }
    
    public func drawHoveredCell() {
        if isHovored { //TODO: make isHovered player based?
            if let playerHovoredCell = gameView.game.world.hoveredCells[gameView.game.player] {
                let cellLocation = playerHovoredCell

                let p = vpcMinusZso + cellLocation.vector2 * zoomedCellSize

                gameView.renderer.fillRectangle(location: p, size: zoomedCellSize, color: hoverColor)

                let ground = gameView.game.world.getCell(cellLocation)?.ground ?? .none
                if ground == Ground.none {
                    let chunkCoordinates = gameView.game.world.chunkFromCell(cellLocation)
                    gameView.game.world.generator.generateCellChunk(chunkCoordinates)
                }
            }
        }
    }

    public func drawBorder() {
        //GameView.Renderer.DrawRectangle(viewPortLocation, viewPortSize, borderColor, 1);
    }

    public func drawMainWorldViewFrame() {
        
    }

    public func update(elapsedTime: TimeInterval) {
        if isDragging && gameView.indirectScrollHolding {
            let delta = gameView.currentPointerPosition - gameView.indirectScrollStartPosition
            viewPort.spaceOffset += delta / viewPort.spaceZoom * elapsedTime * 10
            gameView.minimapView.viewPort.spaceOffset = viewPort.spaceOffset
        }

        destructionSelectionAnimationTime += elapsedTime
        if destructionSelectionAnimationTime >= destructionSelectionAnimationInterval {
            destructionSelectionAnimationTime -= destructionSelectionAnimationInterval
        }
    }

    public func handleHoverEvent(_ pointerPosition: Vector2) -> Bool {
        isHovored = gameView.usingMousePointer && pointerPosition.isInsideOfRect(location: viewPort.location, size: viewPort.size)
        if isHovored {
            if gameView.directScrollHolding {
                let delta = pointerPosition - gameView.currentPointerPosition
                viewPort.spaceOffset -= delta / viewPort.spaceZoom
                gameView.minimapView.viewPort.spaceOffset = viewPort.spaceOffset
                isDragging = true
            } else if gameView.indirectScrollHolding {
                //var delta = pointerPosition - GameView.IndirectScrollStartPosition;
                isDragging = true
            } else {
                let hoveredCellPosition = cellFromScreen(pointerPosition)
                gameView.game.world.hoveredCells[gameView.game.player] = hoveredCellPosition
            }
        }
        return true
    }

    public func handleLeftClick(_ pointerPosition: Vector2) -> Bool {
        let clickedCell = cellFromScreen(pointerPosition)
        print("left click cell \(clickedCell)")

        let world = gameView.game.world!

        if let clickedEntities = world.entities[clickedCell] {
            for e in clickedEntities {
                if let inventory = e.inventory {
                    print("\(type(of: e)) \(inventory)")
                }
            }
        }

        /*
        if false {
            for entities in world.entities.enumerated() {
                for entity in entities.value {
                    if let workerBot = entity as? WorkerBotEntity {
                        var from = workerBot.cellLocation
                        var to = clickedCell
                        var path = world.pathFinder.findPath(from, to, true, cellLocation => world.CellIsPassableForEntity(cellLocation, workerBot))
                        workerBot.cancelPlan()
                        workerBot.PlannedPath = new LinkedList<IntVector2>(path)
                        return true
                    }
                }
            }
        }*/

        if true {
            gameView.game.world.clickedCells[gameView.game.player] = clickedCell
        }

        return true
    }
}
