//
//  MetalView.swift
//  MetalPrac
//
//  Created by hanjongwoo on 1/2/25.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    class Coordinator: NSObject, MTKViewDelegate {
        var metalView: MetalView
        
        init(metalView: MetalView) {
            self.metalView = metalView
        }
        
        var device: MTLDevice!
        var commandQueue: MTLCommandQueue!
        var renderPipelineState: MTLRenderPipelineState!
        var vertexBuffer: MTLBuffer!
        
        let vertexData: [Float] = [
            0.0,  1.0,  0.0,  // Vertex 1 (X, Y)
           -1.0, -1.0,  0.0,  // Vertex 2 (X, Y)
            1.0, -1.0,  0.0   // Vertex 3 (X, Y)
        ]
        
        func setUpMetal(view: MTKView) {
            device = MTLCreateSystemDefaultDevice()
            view.device = device
            
            commandQueue = device.makeCommandQueue()

            // 셰이더 컴파일
            let library = device.makeDefaultLibrary()
            let vertexFunction = library?.makeFunction(name: "vertex_main")
            let fragmentFunction = library?.makeFunction(name: "fragment_main")

            // 파이프라인 상태 설정
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
            
            renderPipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)

            // 정점 버퍼 생성
            vertexBuffer = device.makeBuffer(bytes: vertexData,
                                              length: MemoryLayout<Float>.size * vertexData.count,
                                              options: [])
        }
        
        func draw(in view: MTKView) {
            guard let commandBuffer = commandQueue.makeCommandBuffer(),
                  let drawable = view.currentDrawable,
                  let descriptor = view.currentRenderPassDescriptor else { return }
                  
            let passEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
            passEncoder.setRenderPipelineState(renderPipelineState)
            passEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            passEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            passEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(metalView: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MetalView>) -> MTKView {
        let view = MTKView()
        view.delegate = context.coordinator
        context.coordinator.setUpMetal(view: view)
        return view
    }
    
    func updateUIView(_ uiView: MTKView, context: UIViewRepresentableContext<MetalView>) {}
}
