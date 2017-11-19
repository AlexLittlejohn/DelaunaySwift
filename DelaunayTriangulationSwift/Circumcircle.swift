//
//  CircumCircle.swift
//  Delaunay
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 sakrist. All rights reserved.
//

/// Represents a bounding circle for a set of 3 vertices
internal struct CircumCircle {
    let point1: Point
    let point2: Point
    let point3: Point
    
    /// center of circum circle
    let c: Point
    
    /// radius sqrt
    let rsqr: Double
    
    init(point1: Point, point2: Point, point3: Point) {
        
        var c = Point(x: 0, y: 0)
        
        let fabsy1y2 = abs(point1.y - point2.y)
        let fabsy2y3 = abs(point2.y - point3.y)
        
        if fabsy1y2 < Double.ulpOfOne {
            let m2 = -((point3.x - point2.x) / (point3.y - point2.y))
            let mx2 = (point2.x + point3.x) / 2.0
            let my2 = (point2.y + point3.y) / 2.0
            c.x = (point2.x + point1.x) / 2.0
            c.y = m2 * (c.x - mx2) + my2
        } else if fabsy2y3 < Double.ulpOfOne {
            let m1 = -((point2.x - point1.x) / (point2.y - point1.y))
            let mx1 = (point1.x + point2.x) / 2.0
            let my1 = (point1.y + point2.y) / 2.0
            c.x = (point3.x + point2.x) / 2.0
            c.y = m1 * (c.x - mx1) + my1
        } else {
            let m1 = -((point2.x - point1.x) / (point2.y - point1.y))
            let m2 = -((point3.x - point2.x) / (point3.y - point2.y))
            let mx1 = (point1.x + point2.x) / 2.0
            let mx2 = (point2.x + point3.x) / 2.0
            let my1 = (point1.y + point2.y) / 2.0
            let my2 = (point2.y + point3.y) / 2.0
            c.x = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2)
            
            if fabsy1y2 > fabsy2y3 {
                c.y = m1 * (c.x - mx1) + my1
            } else {
                c.y = m2 * (c.x - mx2) + my2
            }
        }
        
        self.point1 = point1
        self.point2 = point2
        self.point3 = point3
        self.c = c
        self.rsqr = point2.distanceSqrt(c)
    }
    
    init(_ point1: Point, _ point2: Point, _ point3: Point) {
        self.init(point1: point1, point2: point2, point3: point3)
    }
    
    /* Test if a point insdie of circum circle */ 
    func contain(_ p:Point) -> Bool {
        return p.distanceSqrt(c) - rsqr < Double.ulpOfOne
    }
    
    func triangle() -> Triangle {
        return Triangle(point1, point2, point3)
    }
}


