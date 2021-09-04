//
//  IResourceContainer.swift
//  IResourceContainer
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public protocol IResourceContainer {
    init()
    func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async
}

public extension IResourceContainer {
    static func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async -> Self {
        let bitmapsContainer = Self.init()
        await bitmapsContainer.load(resourceCreator: resourceCreator, fileSystem: fileSystem)
        return bitmapsContainer
    }
}
