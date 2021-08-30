//
//  ChunkMap.swift
//  ChunkMap
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public final class ChunkMap<T> /*where T: AnyObject*/ {
    public let chunkSize: IntVector2

    private var chunks: Dictionary<IntVector2, T> = [:]

    public init(chunkSize: IntVector2) {
        self.chunkSize = chunkSize
    }

    public subscript(_ chunkCoordinates: IntVector2) -> T? {
        get {
            chunks[chunkCoordinates]
        }
        set {
            chunks[chunkCoordinates] = newValue
        }
    }

    public func chunk(fromCell cellCoordinates: IntVector2) -> IntVector2 {
        let x = cellCoordinates.x >= 0 ? cellCoordinates.x / chunkSize.x : (cellCoordinates.x + 1) / chunkSize.x - 1
        let y = cellCoordinates.y >= 0 ? cellCoordinates.y / chunkSize.y : (cellCoordinates.y + 1) / chunkSize.y - 1
        return .init(x: x, y: y)
    }

    public func cell(in chunk: IntVector2, cellCoordinates: IntVector2) -> IntVector2 {
        let w = chunk.x * chunkSize.x
        let h = chunk.y * chunkSize.y
        let x = chunk.x >= 0 ? cellCoordinates.x % chunkSize.x : (cellCoordinates.x - w)
        let y = chunk.y >= 0 ? cellCoordinates.y % chunkSize.y : (cellCoordinates.y - h)

        return .init(x: x, y: y)
    }

    public func allChunks() -> [Dictionary<IntVector2, T>.Element] {
        return chunks.map{$0}
    }
}
