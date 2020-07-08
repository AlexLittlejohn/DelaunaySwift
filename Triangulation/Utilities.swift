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
    func pointValue() -> CGPoint {
        return CGPoint(x: x, y: y)
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
