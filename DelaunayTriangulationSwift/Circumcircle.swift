//
//  Circumcircle.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

/// Represents a bounding circle for a set of 3 vertices
internal struct CircumCircle {
    var vertex1: Vertex
    var vertex2: Vertex
    var vertex3: Vertex
    var x: Double
    var y: Double
    var rsqr: Double
}
