//
//  MarkerBitmaps.swift
//  MarkerBitmaps
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class MarkerBitmaps: IResourceContainer {
    public private(set) var itemGrabberInput: IBitmap!
    public private(set) var itemGrabberOutput: IBitmap!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = "\(fileSystem.graphicsDirectory())/markers"
        
        (
            itemGrabberInput,
            itemGrabberOutput
        ) = await (
            resourceCreator.createBitmap(from: "\(path)/item_grabber_input.png"),
            resourceCreator.createBitmap(from: "\(path)/item_grabber_output.png")
        )
    }
}
