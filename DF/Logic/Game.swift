//
//  Game.swift
//  Game
//
//  Created by Wilhelm Oks on 29.08.21.
//

import Foundation

public final class Game {
    public let resources: Resources = .init()
    
    public private(set) var world: World!
    public private(set) var player: Player
    
    public init() {
        player = Player()
        player.name = "Dummy"
        
        world = World(game: self)
    }
}
