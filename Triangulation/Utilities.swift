//
//  Utilities.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit
import DelaunaySwift

extension Triangle {
    func toPath() -> CGPath {
        
        let path = CGMutablePath()
        let p1 = point1.pointValue()
        let p2 = point2.pointValue()
        let p3 = point3.pointValue()
        
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p1)

        path.closeSubpath()
        
        return path
    }
}

extension Point {
    convenience public init(point: CGPoint) {
        self.init(x: Double(point.x), y: Double(point.y))
    }
    
    public func pointValue() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
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

extension UIColor {
    func randomColor() -> UIColor {
        let hue = CGFloat.random(in: 0...1) // 0.0 to 1.0
        let saturation: CGFloat = 0.5  // 0.5 to 1.0, away from white
        let brightness: CGFloat = 1.0  // 0.5 to 1.0, away from black
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color
    }
}
