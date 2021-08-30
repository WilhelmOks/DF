//
//  EffectBitmaps.swift
//  EffectBitmaps
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class EffectBitmaps: IResourceContainer {
    public private(set) var beam: IBitmap!
    public private(set) var shadow: IBitmap!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = "\(fileSystem.graphicsDirectory())/entities/effects"
        
        (
            beam,
            shadow
        ) = await (
            resourceCreator.createBitmap(from: "\(path)/beam.png"),
            resourceCreator.createBitmap(from: "\(path)/shadow.png")
        )
    }
}
