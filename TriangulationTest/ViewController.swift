//
//  ViewController.swift
//  TriangulationTest
//
//  Created by Volodymyr Boichentsov on 13/11/2017.
//  Copyright © 2017 zero. All rights reserved.
//

import Cocoa
import DelaunaySwift

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        triangleTest()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func generateVertices() -> [Vertex] {
    
        var points = [Vertex]()
        points.append(Vertex(x: 100, y: 100))
        points.append(Vertex(x: 200, y: 100))
        points.append(Vertex(x: 200, y: 200))
        points.append(Vertex(x: 150, y: 200))
        points.append(Vertex(x: 100, y: 300))
        points.append(Vertex(x: 200, y: 300))
        
        return points
    }
    
    
    func triangleTest() {
        
        let vertices = generateVertices()
        
        let start = Date().timeIntervalSince1970
        
        let triangles = Delaunay().triangulate(vertices)
        
        let end = Date().timeIntervalSince1970
        print("time: \(end - start)")
        
        for triangle in triangles {
            let triangleLayer = CAShapeLayer()
            triangleLayer.path = triangle.toPath()
            triangleLayer.fillColor = OSColor().randomColor().cgColor
            triangleLayer.backgroundColor = OSColor.clear.cgColor
            self.view.layer?.addSublayer(triangleLayer)
        }
    }
 

}

