//
//  SpriteSheet.swift
//  SpriteSheet
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class SpriteSheet {
    public let bitmap: IBitmap
    public let regions: [Region]
    
    public init(bitmap: IBitmap, regions: [Region]) {
        self.bitmap = bitmap
        self.regions = regions
    }
    
    public struct Region {
        public let start: IntVector2
        public let end: IntVector2
        public let referencePoint: IntVector2
        
        public var size: IntVector2 { end - start }
        
        public init(start: IntVector2, end: IntVector2, referencePoint: IntVector2) {
            self.start = start
            self.end = end
            self.referencePoint = referencePoint
        }
        
        public init(startX: Int, startY: Int, endX: Int, endY: Int, referencePointX: Int, referencePointY: Int) {
            start = IntVector2(startX, startY)
            end = IntVector2(endX, endY)
            referencePoint = IntVector2(referencePointX, referencePointY)
        }
        
        public init(_ startX: Int, _ startY: Int, _ endX: Int, _ endY: Int, _ referencePointX: Int, _ referencePointY: Int) {
            start = IntVector2(startX, startY)
            end = IntVector2(endX, endY)
            referencePoint = IntVector2(referencePointX, referencePointY)
        }
    }
}
