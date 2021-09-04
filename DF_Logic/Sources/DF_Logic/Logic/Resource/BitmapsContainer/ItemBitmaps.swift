//
//  ItemBitmaps.swift
//  ItemBitmaps
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class ItemBitmaps: IResourceContainer {
    public private(set) var wood: IBitmap!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = "\(fileSystem.graphicsDirectory())/items"
        
        (
            wood
        ) = await (
            resourceCreator.createBitmap(from: "\(path)/wood.png")
        )
    }
}
