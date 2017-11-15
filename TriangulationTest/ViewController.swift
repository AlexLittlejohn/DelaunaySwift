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
        
//        triangleTest2()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func triangleTest2() {
        let vertices = generateVertices(self.view.frame.size, cellSize: 10)
        print("vertices.count ", vertices.count)
        let start = Date().timeIntervalSince1970
        let triangles = Delaunay().triangulate(vertices)
        let end = Date().timeIntervalSince1970
        print("time sec: \(end - start)")  
        
        presentResult(triangles)
    }
    
    
    func triangleTest() {
        
        var vertices = generateVertices()
        var index = 0
        for i in 0..<vertices.count {
            vertices[i].index = index
            index += 1
        }
        var holes_ = holes()
        for i in 0..<holes_.count {
            for j in 0..<holes_[i].count {
                holes_[i][j].index = index
                index += 1
            }
        }

        let start = Date().timeIntervalSince1970
        let triangles = CDT().triangulate(vertices, holes_)
        let end = Date().timeIntervalSince1970
        print("time: \(end - start)")  
        
        presentResult(triangles)
    }
    
    func presentResult(_ triangles:[Triangle]) {
        for triangle in triangles {
            let triangleLayer = CAShapeLayer()
            triangleLayer.path = triangle.toPath()
            triangleLayer.fillColor = OSColor().randomColor().cgColor
            triangleLayer.backgroundColor = OSColor.clear.cgColor
            self.view.layer?.addSublayer(triangleLayer)
        }
    }
 

}

