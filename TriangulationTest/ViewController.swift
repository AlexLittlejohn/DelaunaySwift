//
//  ViewController.swift
//  TriangulationTest
//
//  Created by Volodymyr Boichentsov on 13/11/2017.
//  Copyright © 2017 zero. All rights reserved.
//

import Cocoa
import Delaunay

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
        
        let vertices_v = generateVertices()
        var vertices = [Point]()
        var index = 0
        let count = vertices_v.count
        for i in 0..<count {
            var p = vertices_v[count-1-i]
            p.index = index 
            vertices.append(p)
            index += 1
        }
        var holes_ = holes()
        for i in 0..<holes_.count {
            for j in 0..<holes_[i].count {
                holes_[i][j].index = index
                index += 1
            }
        }
        
        let start0 = Date().timeIntervalSince1970
        let triangles2 = ConformingDelaunay().triangulate(vertices, holes_)
        let end0 = Date().timeIntervalSince1970
        print("ConformingDelaunay time: \(end0 - start0)")
        print("count: \(triangles2.count)")
         presentResult(triangles2)
        
        
        let start = Date().timeIntervalSince1970
        
        let triangles = CDT().triangulate(vertices, holes_)
        let end = Date().timeIntervalSince1970
        print("CDT time: \(end - start)")
        print("count: \(triangles.count)")
//        
//        presentResult(triangles)
    }
    
    func presentResult(_ triangles:[Triangle]) {
        
        for triangle in triangles {
            add(tri: triangle)
        }
    }
    
    func add(tri:Triangle) {
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = tri.toPath()
        triangleLayer.opacity = 0.5
        triangleLayer.borderWidth = 0.5
        triangleLayer.strokeColor = OSColor.black.cgColor
        triangleLayer.borderColor = OSColor.black.cgColor
        triangleLayer.fillColor = OSColor.gray.cgColor
        triangleLayer.fillColor = OSColor.randomColor().cgColor
        triangleLayer.backgroundColor = OSColor.clear.cgColor
        self.view.layer?.addSublayer(triangleLayer)
    }
 

}

