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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TriangleView.tapped))
        addGestureRecognizer(tapGesture)
    }
    
    func tapped() {
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let vertices = generateVertices(bounds.size, cellSize: 80)

        let start = Date().timeIntervalSince1970

        let triangles = Delaunay().triangulate(vertices)

        let end = Date().timeIntervalSince1970
        print("time: \(end - start)")

        for triangle in triangles {
            let triangleLayer = CAShapeLayer()
            triangleLayer.path = triangle.toPath()
            triangleLayer.fillColor = OSColor.randomColor().cgColor
            triangleLayer.backgroundColor = OSColor.clear.cgColor
            layer.addSublayer(triangleLayer)
        }
    }
}

