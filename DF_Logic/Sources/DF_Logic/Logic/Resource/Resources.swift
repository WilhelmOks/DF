//
//  Resources.swift
//  Resources
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class Resources: IResourceContainer {
    public private(set) var bitmaps: Bitmaps!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        (
            bitmaps
        ) = await (
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem)
        )
    }
}
