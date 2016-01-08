//
//  TriangleView.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit
import GameplayKit
import DelaunayTriangulationSwift

/// Generate set of vertices for our triangulation to use
func generateVertices(size: CGSize, cellSize: CGFloat, variance: CGFloat = 0.75, seed: UInt64 = numericCast(arc4random())) -> [Vertice] {
    
    // How many cells we're going to have on each axis (pad by 2 cells on each edge)
    let cellsX = (size.width + 4 * cellSize) / cellSize
    let cellsY = (size.height + 4 * cellSize) / cellSize
    
    // figure out the bleed widths to center the grid
    let bleedX = ((cellsX * cellSize) - size.width)/2
    let bleedY = ((cellsY * cellSize) - size.height)/2
    
    let _variance = cellSize * variance / 4
    
    var points = [Vertice]()
    let minX = -bleedX
    let maxX = size.width + bleedX
    let minY = -bleedY
    let maxY = size.height + bleedY
    
    let generator = GKLinearCongruentialRandomSource(seed: seed)
    
    for i in minX.stride(to: maxX, by: cellSize) {
        for j in minY.stride(to: maxY, by: cellSize) {
            
            let x = i + cellSize/2 + CGFloat(generator.nextUniform()) + CGFloat.random(-_variance, _variance)
            let y = j + cellSize/2 + CGFloat(generator.nextUniform()) + CGFloat.random(-_variance, _variance)
            
            points.append(Vertice(x: Double(x), y: Double(y)))
        }
    }
    
    return points
}

class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: "tapped")
        addGestureRecognizer(tap)
    }
    
    func tapped() {
        if let s = layer.sublayers {
            for i in s {
                i.removeFromSuperlayer()
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let vertices = generateVertices(bounds.size, cellSize: 60)
        let triangles = Delaunay().triangulate(vertices)
        
        for t in triangles {
            let sub = CAShapeLayer()
            sub.path = t.toPath()
            sub.fillColor = UIColor().randomColor().CGColor
            sub.backgroundColor = UIColor.clearColor().CGColor
            layer.addSublayer(sub)
        }
    }
}

