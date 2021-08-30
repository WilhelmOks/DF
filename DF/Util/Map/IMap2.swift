//
//  IMap2.swift
//  IMap2
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public protocol IMap2: AnyObject {
    associatedtype T
    
    var width: Int { get }
    var height: Int { get }

    subscript(_ x: Int, _ y: Int) -> T { get set }
    subscript(_ coordinates: IntVector2) -> T { get set }

    func clone() -> Self

    func allValues() -> [T]
}
