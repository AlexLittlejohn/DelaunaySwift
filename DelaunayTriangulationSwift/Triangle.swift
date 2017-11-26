//
//  Triangle.swift
//  Delaunay
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 sakrist. All rights reserved.

import CoreGraphics

/// A simple struct representing 3 vertices
public struct Triangle {
    
    let centroid: Point
    public let point1: Point
    public let point2: Point
    public let point3: Point
    
    public init(point1: Point, point2: Point, point3: Point) {
        self.point1 = point1
        self.point2 = point2
        self.point3 = point3
        self.centroid = (point1 + point2 + point3)/3.0
    }
    
    public init(_ point1: Point, _ point2: Point, _ point3: Point) {
        self.init(point1: point1, point2: point2, point3: point3)
    }
    
    // Check wether point p is within triangle abc or on its border.
    func contain(_ p:Point) -> Bool {
        let u = point1 - point2
        let v = point1 - point3
        let vxu = v.cross(u)
        let uxv = -vxu
        
        let w = point1 - p
        let vxw = v.cross(w)
        if (vxu * vxw < 0) {
            return false
        }
        let uxw = u.cross(w)
        if (uxv * uxw < 0) {
            return false
        }
        return abs(uxw) + abs(vxw) <= abs(uxv)
    }
    
    public func v1() -> CGPoint {
        return point1.pointValue()
    }
    
    public func v2() -> CGPoint {
        return point2.pointValue()
    }
    
    public func v3() -> CGPoint {
        return point3.pointValue()
    }
    
}

extension Triangle: Equatable { 
    static public func ==(lhs: Triangle, rhs: Triangle) -> Bool {
        let inds = [lhs.point1.index, lhs.point2.index, lhs.point3.index]
        return inds.contains(rhs.point1.index) && inds.contains(rhs.point2.index) && inds.contains(rhs.point3.index) 
    }
}
