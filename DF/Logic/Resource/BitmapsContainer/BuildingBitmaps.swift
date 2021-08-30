//
//  BuildingBitmaps.swift
//  BuildingBitmaps
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class BuildingBitmaps: IResourceContainer {
    public private(set) var container: IBitmap!
    public private(set) var itemGrabberBase: IBitmap!
    public private(set) var itemGrabberHand: IBitmap!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = "\(fileSystem.graphicsDirectory())/entities/buildings"
        
        (
            container,
            itemGrabberBase,
            itemGrabberHand
        ) = await (
            resourceCreator.createBitmap(from: "\(path)/container.png"),
            resourceCreator.createBitmap(from: "\(path)/item_grabber_base.png"),
            resourceCreator.createBitmap(from: "\(path)/item_grabber_hand.png")
        )
    }
}
