//
//  Shaders.metal
//  MetalPrac
//
//  Created by hanjongwoo on 1/2/25.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertex_main(const device float *vertex_array [[buffer(0)]], uint id [[vertex_id]]) {
    return float4(vertex_array[id * 3], vertex_array[id * 3 + 1], vertex_array[id * 3 + 2], 1.0);
}

fragment float4 fragment_main() {
    return float4(1.0, 0.0, 0.0, 1.0);
}


