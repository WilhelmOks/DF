//
//  IBitmap.swift
//  IBitmap
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public protocol IBitmap {
    var bitmap: Any { get }
    var sizeInPixels: IntVector2 { get }
}
