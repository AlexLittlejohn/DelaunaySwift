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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.vertices = generateVertices(CGSize.init(width: 480, height: 480), cellSize: 5)
        print("vertices.count ",vertices.count)
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
        
    
}
