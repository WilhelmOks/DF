//
//  GameViewController.swift
//  DF_Metal
//
//  Created by Wilhelm Oks on 11.09.21.
//

import Cocoa
import Metal
import MetalKit
import simd

class GameViewController: NSViewController {
    var renderer: Renderer!
    var mtkView: MTKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mtkView = self.view as? MTKView else {
            print("View attached to GameViewController is not an MTKView")
            return
        }
        
        renderer = Renderer(layer: self.view.layer!)
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)

        mtkView.delegate = renderer
    }
    
}
