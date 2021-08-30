//
//  EntityBitmaps.swift
//  EntityBitmaps
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class EntityBitmaps: IResourceContainer {
    public private(set) var buildings: BuildingBitmaps!
    
    public private(set) var workerBot: IBitmap!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = "\(fileSystem.graphicsDirectory())/entities"
        
        (
            buildings,
            workerBot
        ) = await (
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem),
            resourceCreator.createBitmap(from: "\(path)/bot.png")
        )
    }
}
