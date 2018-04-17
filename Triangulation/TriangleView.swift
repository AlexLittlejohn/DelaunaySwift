//
//  TriangleView.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit
import GameplayKit
import DelaunaySwift

/// Generate set of vertices for our triangulation to use
func generateVertices(_ size: CGSize, cellSize: CGFloat, variance: CGFloat = 0.75, seed: UInt64 = numericCast(arc4random())) -> [Vertex] {
    
    // How many cells we're going to have on each axis (pad by 2 cells on each edge)
    let cellsX = (size.width + 4 * cellSize) / cellSize
    let cellsY = (size.height + 4 * cellSize) / cellSize
    
    // figure out the bleed widths to center the grid
    let bleedX = ((cellsX * cellSize) - size.width)/2
    let bleedY = ((cellsY * cellSize) - size.height)/2
    
    let _variance = cellSize * variance / 4
    
    var points = [Vertex]()
    let minX = -bleedX
    let maxX = size.width + bleedX
    let minY = -bleedY
    let maxY = size.height + bleedY
    
    let generator = GKLinearCongruentialRandomSource(seed: seed)
    
    for i in stride(from: minX, to: maxX, by: cellSize) {
        for j in stride(from: minY, to: maxY, by: cellSize) {
            
            let x = i + cellSize/2 + CGFloat(generator.nextUniform()) + CGFloat.random(-_variance, _variance)
            let y = j + cellSize/2 + CGFloat(generator.nextUniform()) + CGFloat.random(-_variance, _variance)
            
            points.append(Vertex(x: Double(x), y: Double(y)))
        }
    }
    
    return points
}

class TriangleView: UIView {
    var triangles: [(Triangle, CAShapeLayer)] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        initTriangles()
    }
    
    func initTriangles() {
        for (_, triangleLayer) in triangles {
            triangleLayer.removeFromSuperlayer()
        }

        let vertices = generateVertices(bounds.size, cellSize: 80)
        let delaunayTriangles = Delaunay().triangulate(vertices)
        
        triangles = []
        for triangle in delaunayTriangles {
            let triangleLayer = CAShapeLayer()
            triangleLayer.path = triangle.toPath()
            triangleLayer.fillColor = UIColor().randomColor().cgColor
            triangleLayer.backgroundColor = UIColor.clear.cgColor
            layer.addSublayer(triangleLayer)
            
            triangles.append((triangle, triangleLayer))
        }
    }
    
    @IBAction func singleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            let tapLocation = recognizer.location(in: self)
            let vertex = Vertex(point: tapLocation)
            for (triangle, triangleLayer) in triangles {
                if vertex.inside(triangle) {
                    triangleLayer.fillColor = UIColor.black.cgColor
                }
            }
        }
    }
    
    @IBAction func doubleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            initTriangles()
        }
    }
}

