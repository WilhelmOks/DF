//
//  Renderer.swift
//  Renderer
//
//  Created by Wilhelm Oks on 18.09.21.
//

import Foundation

import Cocoa
import Metal
import MetalKit
import simd

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice
    var metalLayer: CAMetalLayer
    var pipelineState: MTLRenderPipelineState
    var commandQueue: MTLCommandQueue
    let renderPassDescriptor = MTLRenderPassDescriptor()
        
    let vertexData: [Float] = [
       0.0,  1.0, 0.0,
      -1.0, -1.0, 0.0,
       1.0, -1.0, 0.0
    ]

    var vertexBuffer: MTLBuffer
    
    var texture: MTLTexture

    init(layer: CALayer) {        
        device = MTLCreateSystemDefaultDevice()!
        
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = layer.frame  // 5
        layer.addSublayer(metalLayer)   // 6
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])! // 2
        
        // 1
        let defaultLibrary = device.makeDefaultLibrary()!
        //let fragmentProgram = defaultLibrary.makeFunction(name: "fragmentShader")
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
            
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        //pipelineStateDescriptor.sampleCount = metalKitView.sampleCount
        pipelineStateDescriptor.vertexDescriptor = Self.buildMetalVertexDescriptor()
            
        // 3
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = device.makeCommandQueue()!
        
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
          red: 0.0,
          green: 104.0/255.0,
          blue: 55.0/255.0,
          alpha: 1.0)
                
        texture = try! Self.loadTexture(device: device, textureName: "ColorMap")
    }
    
    class func loadTexture(device: MTLDevice, textureName: String) throws -> MTLTexture {
        /// Load texture data with optimal parameters for sampling

        let textureLoader = MTKTextureLoader(device: device)

        let textureLoaderOptions = [
            MTKTextureLoader.Option.textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
            MTKTextureLoader.Option.textureStorageMode: NSNumber(value: MTLStorageMode.`private`.rawValue)
        ]

        return try textureLoader.newTexture(name: textureName, scaleFactor: 1.0, bundle: nil, options: textureLoaderOptions)
    }
    
    class func buildMetalVertexDescriptor() -> MTLVertexDescriptor {
        // Create a Metal vertex descriptor specifying how vertices will by laid out for input into our render
        //   pipeline and how we'll layout our Model IO vertices

        let mtlVertexDescriptor = MTLVertexDescriptor()

        /*
        mtlVertexDescriptor.attributes[VertexAttribute.position.rawValue].format = MTLVertexFormat.float3
        mtlVertexDescriptor.attributes[VertexAttribute.position.rawValue].offset = 0
        mtlVertexDescriptor.attributes[VertexAttribute.position.rawValue].bufferIndex = BufferIndex.meshPositions.rawValue
         */

        mtlVertexDescriptor.attributes[VertexAttribute.texcoord.rawValue].format = MTLVertexFormat.float2
        mtlVertexDescriptor.attributes[VertexAttribute.texcoord.rawValue].offset = 0
        mtlVertexDescriptor.attributes[VertexAttribute.texcoord.rawValue].bufferIndex = 0 //BufferIndex.meshGenerics.rawValue

        /*
        mtlVertexDescriptor.layouts[BufferIndex.meshPositions.rawValue].stride = 12
        mtlVertexDescriptor.layouts[BufferIndex.meshPositions.rawValue].stepRate = 1
        mtlVertexDescriptor.layouts[BufferIndex.meshPositions.rawValue].stepFunction = MTLVertexStepFunction.perVertex

        mtlVertexDescriptor.layouts[BufferIndex.meshGenerics.rawValue].stride = 8
        mtlVertexDescriptor.layouts[BufferIndex.meshGenerics.rawValue].stepRate = 1
        mtlVertexDescriptor.layouts[BufferIndex.meshGenerics.rawValue].stepFunction = MTLVertexStepFunction.perVertex
         */
        
        mtlVertexDescriptor.layouts[0].stride = 12
        mtlVertexDescriptor.layouts[0].stepRate = 1
        mtlVertexDescriptor.layouts[0].stepFunction = MTLVertexStepFunction.perVertex

        
        return mtlVertexDescriptor
    }
    
    func render() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        renderEncoder.setVertexTexture(texture, index: 0)
        renderEncoder.setFragmentTexture(texture, index: 0)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func draw(in view: MTKView) {
        render()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        metalLayer.frame.size = view.frame.size
        metalLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 1
    }
}
