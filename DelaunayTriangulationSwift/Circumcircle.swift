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
    let center: Point
    
    /// radius sqrt
    let rsqr: Double
    
    
    
    init(point1: Point, point2: Point, point3: Point) {
        self.point1 = point1
        self.point2 = point2
        self.point3 = point3
        var cP = CircumCircle.center2(point1, point2, point3)
        if !cP.x.isFinite || !cP.y.isFinite {
            cP = CircumCircle.center2(point2, point1, point3)
            if !cP.x.isFinite || !cP.y.isFinite {
                cP = CircumCircle.center2(point1, point3, point2)
            }
        }
        self.center = cP
        
        self.rsqr = point2.distanceSqrt(center)
    }
    
    init(_ point1: Point, _ point2: Point, _ point3: Point) {
        self.init(point1: point1, point2: point2, point3: point3)
    }
    
    // currently no in use, see center2 function 
    fileprivate static func center(_ point1: Point, _ point2: Point, _ point3: Point) -> Point {
        var cPoint = Point(x: 0, y: 0)
        let fabsy1y2 = abs(point1.y - point2.y)
        let fabsy2y3 = abs(point2.y - point3.y)
        
        if fabsy1y2 < Double.ulpOfOne {
            let m2 = -((point3.x - point2.x) / (point3.y - point2.y))
            let mx2 = (point2.x + point3.x) / 2.0
            let my2 = (point2.y + point3.y) / 2.0
            cPoint.x = (point2.x + point1.x) / 2.0
            cPoint.y = m2 * (cPoint.x - mx2) + my2
        } else if fabsy2y3 < Double.ulpOfOne {
            let m1 = -((point2.x - point1.x) / (point2.y - point1.y))
            let mx1 = (point1.x + point2.x) / 2.0
            let my1 = (point1.y + point2.y) / 2.0
            cPoint.x = (point3.x + point2.x) / 2.0
            cPoint.y = m1 * (cPoint.x - mx1) + my1
        } else {
            let m1 = -((point2.x - point1.x) / (point2.y - point1.y))
            let m2 = -((point3.x - point2.x) / (point3.y - point2.y))
            let mx1 = (point1.x + point2.x) / 2.0
            let mx2 = (point2.x + point3.x) / 2.0
            let my1 = (point1.y + point2.y) / 2.0
            let my2 = (point2.y + point3.y) / 2.0
            cPoint.x = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2)
            
            if fabsy1y2 > fabsy2y3 {
                cPoint.y = m1 * (cPoint.x - mx1) + my1
            } else {
                cPoint.y = m2 * (cPoint.x - mx2) + my2
            }
        }
        return cPoint
    }
    
    fileprivate static func center2(_ point1: Point, _ point2: Point, _ point3: Point) -> Point {
        // Taken from https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
        let d = 2.0 * ((point1.x - point3.x) * (point2.y - point3.y) - (point2.x - point3.x) * (point1.y - point3.y))
        let ka = ((point1.x - point3.x) * (point1.x + point3.x) + (point1.y - point3.y) * (point1.y + point3.y))
        let kb = ((point2.x - point3.x) * (point2.x + point3.x) + (point2.y - point3.y) * (point2.y + point3.y))
        let xp = ka * (point2.y - point3.y) - kb * (point1.y - point3.y)
        let yp = kb * (point1.x - point3.x) - ka * (point2.x - point3.x)
        if !d.isFinite {
            return Point(x:0.0, y:0.0)
        }
        return Point(x:xp / d, y:yp / d)
    }
    
    /* Test if a point insdie of circum circle */ 
    func contain(_ p:Point) -> Bool {
        return p.distanceSqrt(center) - rsqr < Double.ulpOfOne
    }
    
    func triangle() -> Triangle {
        return Triangle(point1, point2, point3)
    }
    
    func constructEdges() -> [Edge] {
        return [ Edge(point1, point2), Edge(point2, point3), Edge(point3, point1)]
    }
    
}


