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
        let point1 = vertex1.pointValue()
        let point2 = vertex2.pointValue()
        let point3 = vertex3.pointValue()
        
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point1)

        path.closeSubpath()
        
        return path
    }
}

extension Vertex {
    func pointValue() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension Double {
    static func random() -> Double {
        return Double(arc4random()) / 0xFFFFffff
    }
    
    static func random(_ min: Double, _ max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

extension CGFloat {
    static func random(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
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
