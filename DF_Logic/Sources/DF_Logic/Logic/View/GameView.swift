//
//  GameView.swift
//  GameView
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation
import AppKit

public final class GameView: BaseView {
    public var renderer: IRenderer
    public unowned var game: Game
    
    public var isHovored: Bool = false
    public var isDragging: Bool = false
    
    public private(set) var canvasSize: Vector2 = .zero
    
    public let borderColor: Color = NSColor.blue.cgColor
    
    let worldViewPort = SmoothViewPort(location: .zero, size: .one)
    
    public private(set) var mainWorldView: MainWorldView!
    public private(set) var minimapView: MinimapView!
    
    public private(set) var directScrollHolding = false {
        didSet {
            if !directScrollHolding {
                mainWorldView.isDragging = false
                minimapView.isDragging = false
            }
            let _ = handleHoverEvent(currentPointerPosition)
        }
    }
    
    public private(set) var indirectScrollHolding = false {
        didSet {
            if !indirectScrollHolding {
                mainWorldView.isDragging = false
                minimapView.isDragging = false
            }
            let _ = handleHoverEvent(currentPointerPosition)
        }
    }
    
    public var indirectScrollStartPosition: Vector2 = .init()
    public var currentPointerPosition: Vector2 = .init()
    
    public var usingMousePointer: Bool = false
    
    public init(renderer: IRenderer, game: Game) {
        self.renderer = renderer
        self.game = game
        
        mainWorldView = MainWorldView(viewPort: worldViewPort, gameView: self)
        minimapView = MinimapView(viewPort: ViewPort(location: .zero, size: .init(200, 200)), gameView: self)
        
        //mainWorldView.gameView = self //TODO: make gameView unowned
        
        //mainWorldView.viewPort = worldViewPort //TODO: make viewPort unowned?
        mainWorldView.viewPort.spaceOffset = worldViewCellSize * World.chunkSize * 0.5
        mainWorldView.viewPort.spaceZoom = 1.0
        
        //minimapView.gameView = self //TODO: make gameView unowned
        //minimapView.viewPort = ViewPort(location: .zero, size: .init(200, 200))
        minimapView.viewPort.spaceOffset = worldViewPort.spaceOffset
        minimapView.viewPort.spaceZoom = 0.025
    }
    
    public func prepareToDraw(canvasSize: Vector2) {
        self.canvasSize = canvasSize

        worldViewPort.location = IntVector2.zero
        worldViewPort.size = IntVector2(canvasSize) - worldViewPort.location * 2

        let minimapMargin = 10
        minimapView.viewPort.location = IntVector2(Int(canvasSize.x) - minimapMargin - minimapView.viewPort.size.x, minimapMargin)
    }
    
    public func draw() {
        //DrawingSession.DrawRectangle(2, 2, CanvasSize.X-4, CanvasSize.Y-4, borderColor, 1);
        //DrawingSession.DrawRectangle(0, 0, CanvasSize.X-1, CanvasSize.Y-1, borderColor, 1);

        mainWorldView.draw()
        minimapView.draw()

        let inderectScrollDelta = currentPointerPosition - indirectScrollStartPosition

        if mainWorldView.isDragging && indirectScrollHolding && inderectScrollDelta.lengthSquared != 0 {
            let scrollArrow = game.resources.bitmaps!.hud.scrollArrow!
            let rotation = atan2(inderectScrollDelta.y, inderectScrollDelta.x)
            let arrowSize = scrollArrow.sizeInPixels.vector2

            let scrollArrowStart = game.resources.bitmaps!.hud.scrollArrowStart!
            let startSize = scrollArrowStart.sizeInPixels.vector2

            renderer.drawBitmap(scrollArrowStart, location: indirectScrollStartPosition - startSize * 0.5, size: startSize)

            renderer.drawBitmap(scrollArrow, location: currentPointerPosition - arrowSize * 0.5, size: arrowSize, rotationAboutCenter: rotation)
            
            /*
            Renderer.BeginSpriteBatch();
            var index = 0;
            Renderer.DrawBitmapFromSpriteSheetBatch(
                Game.Resources.Bitmaps.TreesTest,
                index,
                CurrentPointerPosition,
                Game.Resources.Bitmaps.TreesTest.Regions[index].SourceRect.Size() * MainWorldView.ViewPort.SpaceZoom
            );
            Renderer.EndSpriteBatch();
            */
        }
    }
    
    public func update(elapsedTime: TimeInterval) {
        if usingMousePointer {
            let _ = handleHoverEvent(currentPointerPosition)
        }
        worldViewPort.update(elapsedTime: elapsedTime)
        mainWorldView.update(elapsedTime: elapsedTime)
        minimapView.update(elapsedTime: elapsedTime)
    }
    
    public func processNewPointerPosition(_ position: Vector2) {
        let _ = handleHoverEvent(position)
    }

    public func processWheelDelta(_ wheelDelta: Int) {
        worldViewPort.accelerateSpaceZoom(Double(wheelDelta))
    }
    
    public func handleHoverEvent(_ pointerPosition: Vector2) -> Bool {
        usingMousePointer = true
        minimapView.isHovored = false
        mainWorldView.isHovored = false
        let handledByMinimap = !mainWorldView.isDragging && minimapView.handleHoverEvent(pointerPosition)
        if !handledByMinimap {
            let handledByMainWorldView = !minimapView.isDragging && mainWorldView.handleHoverEvent(pointerPosition)
            let _ = handledByMainWorldView
        }
        currentPointerPosition = pointerPosition
        return true
    }

    public func handleLeftClick(_ pointerPosition: Vector2) -> Bool {
        let handledByMinimap = minimapView.handleLeftClick(pointerPosition)
        if(!handledByMinimap) {
            let handledByMainWorldView = mainWorldView.handleLeftClick(pointerPosition)
            let _ = handledByMainWorldView
        }
        return true
    }
}
