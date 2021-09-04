//
//  IResourceCreator.swift
//  IResourceCreator
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public protocol IResourceCreator {
    var resourceCreator: Any { get }
    
    func createBitmap(from colors: [Color], width: Int, height: Int) -> IBitmap
    func createBitmap(from colors: [Color], size: IntVector2) -> IBitmap
    func createBitmap(from filePath: String) async -> IBitmap
}
