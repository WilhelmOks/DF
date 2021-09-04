//
//  IFileSystem.swift
//  IFileSystem
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public protocol IFileSystem {
    func executionDirectory() -> String
    
}

extension IFileSystem {
    func graphicsDirectory() -> String {
        "\(executionDirectory())/DF/gfx"
    }
}
