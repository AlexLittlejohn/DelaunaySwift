//
//  Point.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import CoreGraphics

public struct Point: Hashable {
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public init(point: CGPoint) {
        self.x = Double(point.x)
        self.y = Double(point.y)
    }
    
    public func pointValue() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    public let x: Double
    public let y: Double
    
    public func inside(_ triangle: Triangle) -> Bool {
        func sign(p: Point, v0: Point, v1: Point) -> Double {
            return (p.x - v1.x) * (v0.y - v1.y) - (v0.x - v1.x) * (p.y - v1.y)
        }
        
        let s1 = sign(p: self, v0: triangle.point1, v1: triangle.point2)
        let s2 = sign(p: self, v0: triangle.point2, v1: triangle.point3)
        let s3 = sign(p: self, v0: triangle.point3, v1: triangle.point1)
        return (s1 * s2 >= 0) && (s2 * s3 >= 0)
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
