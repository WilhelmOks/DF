//
//  FileSystem.swift
//  FileSystem
//
//  Created by Wilhelm Oks on 05.09.21.
//

import Foundation
import DF_Logic

class FileSystem: IFileSystem {
    func executionDirectory() -> String {
        FileManager.default.currentDirectoryPath
    }
}
