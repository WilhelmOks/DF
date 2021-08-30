//
//  Player.swift
//  Player
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public final class Player: Identifiable {
    public let id: UUID = .init()
    public var name: String = ""
}

extension Player: Hashable, Equatable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
