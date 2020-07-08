//
//  Circumcircle.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

/// Represents a circle which intersects a set of 3 points
internal struct Circumcircle: Hashable {
    let point1: Point
    let point2: Point
    let point3: Point
    let x: Double
    let y: Double
    let rsqr: Double
}
