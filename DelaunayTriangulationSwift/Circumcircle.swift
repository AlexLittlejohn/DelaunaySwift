//
//  Circumcircle.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

/// Represents a bounding circle for a set of 3 vertices
internal struct CircumCircle {
    var i: Int
    var j: Int
    var k: Int
    var x: Double
    var y: Double
    var rsqr: Double
}
