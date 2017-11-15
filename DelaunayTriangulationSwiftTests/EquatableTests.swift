//
//  EquatableTests.swift
//  DelaunaySwift
//
//  Created by Alex Littlejohn on 2016/04/07.
//  Copyright © 2016 zero. All rights reserved.
//

import XCTest
@testable import DelaunaySwift

class EquatableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testVertexEqual() {
        for _ in 0..<1000 {
            
            let x:Double = Double(arc4random()) * 0.000001
            let y:Double = Double(arc4random()) * 0.000001
            
            let v1 = Vertex(x: x, y: y)
            let v2 = Vertex(x: x, y: y)
        
            XCTAssertTrue(v1 == v2)
        }
        
//        self.measure {
//            var flag = (v1 == v2)
//        }
    }
    
    func testVertexNotEqual() {
        for _ in 0..<1000 {
        
            var x:Double = Double(arc4random())
            let y:Double = Double(arc4random())
            if x == y {
                x = x - 1.0
            }
            
            let v1 = Vertex(x: x, y: y)
            let v2 = Vertex(x: y, y: x)
            
            XCTAssertFalse(v1 == v2)
        }
        
    }
    
    func testEdgeEqual() {
        let v1 = Vertex(x: 1.0, y: 1.0)
        let v2 = Vertex(x: 2.0, y: 1.0)
        
        let e1 = Edge(first: v1, second: v2)
        let e2 = Edge(first: v1, second: v2)
        
        XCTAssertTrue(e1 == e2)
    }
    
    func testEdgeNotEqual() {
        let v1 = Vertex(x: 1.0, y: 1.0)
        let v2 = Vertex(x: 1.0, y: 1.0)
        let v3 = Vertex(x: 1.0, y: 1.1)
        
        let e1 = Edge(first: v1, second: v2)
        let e2 = Edge(first: v2, second: v3)
        
        XCTAssertFalse(e1 == e2)
    }
    
    
    func testPolygon2D() {
        var points = [Vertex]()
        points.append(Vertex(x: 100, y: 100))
        points.append(Vertex(x: 200, y: 100))
        points.append(Vertex(x: 200, y: 200))
        points.append(Vertex(x: 200, y: 300))
        points.append(Vertex(x: 100, y: 300))
        points.append(Vertex(x: 150, y: 200))
        
        let poly = Polygon2D(points)
        
        let testPoints = [
            Vertex(x:5, y:5), // false
            Vertex(x:50, y:100), // true
            Vertex(x:90, y:120), // false
            Vertex(x:110, y:120), // true
            Vertex(x:120, y:200) // false
        ]
        let results = [ false, true, false, true, false ]
        var i = 0
        for p in testPoints {
            XCTAssertTrue(poly.contain(vertex: p) == results[i])
            i = i + 1
        }
    }
    
}
