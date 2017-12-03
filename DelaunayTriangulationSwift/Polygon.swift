//
//  Polygon.swift
//  Delaunay
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 sakrist. All rights reserved.
//

import Foundation

public enum PolygonOrientation {
    case undefined
    case clockwise
    case counterClockwise
}

public struct Polygon {
 
    public init(_ verts:[Point]) {
        var verts_ = verts
        if verts.count > 1  && verts.last != verts.first{
            verts_.append(verts.first!)
        }
        self.vertices = verts_
    }
    
    public let vertices:[Point]

    /// Test on Point inside of polygon.
    ///
    /// - Parameter vertex: test vertex
    /// - Returns: true if inside polygon, flase - outside
    public func contain(_ vertex:Point) -> Bool {
        
        // original source
        // https://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon
        
        var result = false
        let length = vertices.count
        
        var j = length - 1
        for i in 0 ..< length {
            
            let pi = vertices[i]
            let pj = vertices[j]
            
            let segment = Edge(first: pi, second: pj)
            
            if segment.contain(point: vertex) {
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
    
    public var orientation:PolygonOrientation {
        get {
            if vertices.count == 0 {
                return .undefined
            }
            
            var area:Double = 0
            var v = vertices.last!
            for i in 0..<vertices.count {
                let u = v
                v = vertices[i]
                area += (u.x + v.x) * (u.y - v.y)
            }
            if area > 0 {
                return .clockwise
            } else if area < 0 {
                return .counterClockwise
            }
            return .undefined
        }
    }
    
}
