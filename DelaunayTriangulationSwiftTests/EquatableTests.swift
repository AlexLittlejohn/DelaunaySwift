//
//  EquatableTests.swift
//  DelaunaySwift
//
//  Created by Alex Littlejohn on 2016/04/07.
//  Copyright © 2016 zero. All rights reserved.
//

import XCTest
@testable import Delaunay

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
            
            let v1 = Point(x: x, y: y)
            let v2 = Point(x: x, y: y)
        
            XCTAssertTrue(v1 == v2)
        }
    }
    
    func testVertexNotEqual() {
        for _ in 0..<1000 {
        
            var x:Double = Double(arc4random())
            let y:Double = Double(arc4random())
            if x == y {
                x = x - 1.0
            }
            
            let v1 = Point(x: x, y: y)
            let v2 = Point(x: y, y: x)
            
            XCTAssertFalse(v1 == v2)
        }
        
    }
    
    func testEdgeEqual() {
        let v1 = Point(x: 1.0, y: 1.0)
        let v2 = Point(x: 2.0, y: 1.0)
        
        let e1 = Edge(first: v1, second: v2)
        let e2 = Edge(first: v1, second: v2)
        
        XCTAssertTrue(e1 == e2)
    }
    
    func testEdgeNotEqual() {
        let v1 = Point(x: 1.0, y: 1.0)
        let v2 = Point(x: 1.0, y: 1.0)
        let v3 = Point(x: 1.0, y: 1.1)
        
        let e1 = Edge(first: v1, second: v2)
        let e2 = Edge(first: v2, second: v3)
        
        XCTAssertFalse(e1 == e2)
    }
    
    func testTriangle() {
        let tri = Triangle(Point(x: 100, y: 100), Point(x: 150, y: 200), Point(x: 200, y: 100))
        
        XCTAssertTrue(tri.contain(Point(x: 100, y: 100)))
        
        XCTAssertFalse(tri.contain(Point(x: 100, y: 99)))
        
        XCTAssertTrue(tri.contain(Point(x: 150, y: 110)))
        
        XCTAssertFalse(tri.contain(Point(x: 150, y: 300)))
        
        XCTAssertTrue(tri.contain(Point(x: 125, y: 150)))
        
        XCTAssertFalse(tri.contain(Point(x: 124, y: 150)))
        
        XCTAssertTrue(tri.contain(Point(x: 175, y: 150)))
        
        XCTAssertFalse(tri.contain(Point(x: 176, y: 150)))
    }
    
    func testCircumCircle() {
        let tri = CircumCircle(Point(x: 100, y: 100), Point(x: 150, y: 200), Point(x: 200, y: 100))
        
        XCTAssertTrue(tri.contain(Point(x: 100, y: 100)))
        XCTAssertFalse(tri.contain(Point(x: 100, y: 99)))
        
        XCTAssertTrue(tri.contain(Point(x: 150, y: 200)))
        XCTAssertFalse(tri.contain(Point(x: 150, y: 201)))
        
        XCTAssertTrue(tri.contain(Point(x: 200, y: 100)))
        XCTAssertFalse(tri.contain(Point(x: 200, y: 99)))
        
        XCTAssertTrue(tri.contain(Point(x: 150, y: 110)))
        XCTAssertFalse(tri.contain(Point(x: 150, y: 300)))
        XCTAssertTrue(tri.contain(Point(x: 125, y: 150)))
        XCTAssertTrue(tri.contain(Point(x: 124, y: 150)))
        XCTAssertTrue(tri.contain(Point(x: 175, y: 150)))
        XCTAssertTrue(tri.contain(Point(x: 176, y: 150)))
        XCTAssertFalse(tri.contain(Point(x: 200, y: 200)))
    }
    
    
    func testPolygon2D() {
        var points = [Point]()
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 200, y: 100))
        points.append(Point(x: 200, y: 200))
        points.append(Point(x: 200, y: 300))
        points.append(Point(x: 100, y: 300))
        points.append(Point(x: 150, y: 200))
        
        let poly = Polygon(points)
        
        let testPoints = [
            Point(x:5, y:5), // false
            Point(x:50, y:100), // false
            Point(x:90, y:120), // false
            Point(x:110, y:120), // true
            Point(x:120, y:200) // false
        ]
        let results = [ false, false, false, true, false ]
        var i = 0
        for p in testPoints {
            print(poly.contain(p))
            XCTAssertTrue(poly.contain(p) == results[i])
            i = i + 1
        }
    }
    
}
