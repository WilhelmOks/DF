//
//  HudBitmaps.swift
//  HudBitmaps
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class HudBitmaps: IResourceContainer {
    public private(set) var scrollArrow: IBitmap!
    public private(set) var scrollArrowStart: IBitmap!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = "\(fileSystem.graphicsDirectory())/hud"
        
        (
            scrollArrow,
            scrollArrowStart
        ) = await (
            resourceCreator.createBitmap(from: "\(path)/scroll_arrow.png"),
            resourceCreator.createBitmap(from: "\(path)/scroll_arrow_start.png")
        )
    }
}
