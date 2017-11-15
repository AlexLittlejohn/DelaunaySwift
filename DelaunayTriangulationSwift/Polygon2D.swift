//
//  Polygon.swift
//  DelaunaySwift
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 sakrist. All rights reserved.
//

import Foundation

public struct Polygon2D {
 
    public init(_ verts:[Vertex]) {
        self.vertices = verts
    }
    
    public var vertices:[Vertex] = [Vertex]()

    /// Test on Vertex inside of polygon.
    ///
    /// - Parameter vertex: test vertex
    /// - Returns: true if inside polygon, flase - outside
    public func contain(vertex:Vertex) -> Bool {
        
        // original source
        // https://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon
        
        var result = false
        let length = vertices.count
        
        var j = length - 1
        for i in 0 ..< length {
            
            let pi = vertices[i]
            let pj = vertices[j]
            
            let segment = Edge(first: pi, second: pj)
            
            if segment.contain(vertex: vertex) {
                return true
            }
            
            if (abs(pi.y - pj.y) <= .ulpOfOne && 
                abs(pj.y - vertex.y) <= .ulpOfOne && 
                (pi.x >= vertex.x) != (pj.x >= vertex.x)) {
                return true
            }

            if ((pi.y > vertex.y) != (pj.y > vertex.y)) {
                
                let c = (pj.x - pi.x) * (vertex.y - pi.y) / (pj.y - pi.y) + pi.x;
                if (abs(vertex.x - c) <= .ulpOfOne) {
                    return true
                }
                
                if (vertex.x < c) {
                    result = !result
                }
            }
            j = i
        }
        return result;
    }
    
}
