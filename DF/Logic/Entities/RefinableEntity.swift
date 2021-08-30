//
//  RefinableEntity.swift
//  RefinableEntity
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public final class RefinableEntity: WorldEntity, Disposable {
    //TODO: ...
    
    public let refinableType: RefinableType
    
    public init(game: Game, refinableType: RefinableType) {
        self.refinableType = refinableType
        super.init(game: game)
        self.passable = false
    }
    
    public func dispose() {
        //TODO: ...
    }
}
