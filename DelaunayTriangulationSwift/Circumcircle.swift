//
//  Circumcircle.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

/// Represents a bounding circle for a set of 3 vertices
internal struct Circumcircle {
    let vertex1: Vertex
    let vertex2: Vertex
    let vertex3: Vertex
    let c: Vertex
    let rsqr: Double
    
    init(vertex1: Vertex, vertex2: Vertex, vertex3: Vertex, c: Vertex) {
        self.vertex1 = vertex1
        self.vertex2 = vertex2
        self.vertex3 = vertex3
        self.c = c
        self.rsqr = (vertex2 - c).lengthSqrt()
    }
}


