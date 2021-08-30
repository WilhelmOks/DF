//
//  Entity.swift
//  Entity
//
//  Created by Wilhelm Oks on 30.08.21.
//

import Foundation

public protocol Entity {
    var game: Game { get }
    
    func update(elapsedTime: TimeInterval)
}
