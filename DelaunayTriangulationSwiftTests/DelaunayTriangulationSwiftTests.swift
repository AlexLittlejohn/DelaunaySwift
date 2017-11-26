//
//  DelaunayTriangulationSwiftTests.swift
//  DelaunayTriangulationSwiftTests
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 Alex Littlejohn. All rights reserved.
//

import XCTest
@testable import Delaunay

class DelaunayTriangulationSwiftTests: XCTestCase {
    var vertices = [Point]()
    var vertices2 = [Point]()
    var holes_ = [[Point]]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.vertices = generateVertices(CGSize.init(width: 480, height: 480), cellSize: 5)
        print("vertices.count ",vertices.count)
        
        
        var vertices_v = generateVertices()
        vertices2 = [Point]()
        var index = 0
        let count = vertices_v.count
        for i in 0..<count {
            var p = vertices_v[count-1-i]
            p.index = index 
            vertices2.append(p)
            index += 1
        }
        
        holes_ = holes()
        for i in 0..<holes_.count {
            for j in 0..<holes_[i].count {
                holes_[i][j].index = index
                index += 1
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDelaunay() {
        
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
        
        self.measure {
            _ = CDT().triangulate(vertices, holes_)
        }
        
    }
    
    func testDelaunayHighDensity() {
        
//        self.measure {
            _ = Delaunay().triangulate(vertices)
//        }
    }
    
    func testSpeed() {
        

//        measure {
            let edges = ConformingDelaunay().triangulate(vertices2, holes_)
//        }
        
//        measure {
//            let edges = CDT().triangulate(vertices_v, holes_)
//        }
        
    }
    
        
    
}
