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
        
        let path = CGPathCreateMutable()
        let point1 = vertice1.pointValue()
        let point2 = vertice2.pointValue()
        let point3 = vertice3.pointValue()
        
        CGPathMoveToPoint(path, nil, point1.x, point1.y)
        CGPathAddLineToPoint(path, nil, point2.x, point2.y)
        CGPathAddLineToPoint(path, nil, point3.x, point3.y)
        CGPathAddLineToPoint(path, nil, point1.x, point1.y)
        CGPathCloseSubpath(path)
        
        return path
    }
}

extension Vertice {
    func pointValue() -> CGPoint {
        return CGPoint(x: Double(x), y: Double(y))
    }
}

extension Double {
    static func random() -> Double {
        return Double(arc4random()) / 0xFFFFffff
    }
    
    static func random(min: Double, _ max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

extension CGFloat {
    static func random(min: CGFloat, _ max: CGFloat) -> CGFloat {
        return CGFloat(Double.random(Double(min), Double(max)))
    }
}

extension UIColor {
    func randomColor() -> UIColor {
        let hue = CGFloat( Double.random() )  // 0.0 to 1.0
        let saturation: CGFloat = 0.5  // 0.5 to 1.0, away from white
        let brightness: CGFloat = 1.0  // 0.5 to 1.0, away from black
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color
    }
}