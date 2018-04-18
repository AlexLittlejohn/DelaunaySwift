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
        let v1 = Vertex(x: 1.0, y: 1.0)
        let v2 = Vertex(x: 1.0, y: 1.0)
        
        XCTAssertTrue(v1 == v2)
        
        self.measure {
            var flag = (v1 == v2)
        }
    }
    
    func testVertexNotEqual() {
        let v1 = Vertex(x: 1.0, y: 1.0)
        let v2 = Vertex(x: 1.0, y: 1.1)
        
        XCTAssertFalse(v1 == v2)
    }
    
    func testEdgeEqual() {
        let v1 = Vertex(x: 1.0, y: 1.0)
        let v2 = Vertex(x: 1.0, y: 1.0)
        
        let e1 = Edge(vertex1: v1, vertex2: v2)
        let e2 = Edge(vertex1: v1, vertex2: v2)
        
        XCTAssertTrue(e1 == e2)
    }
    
    func testEdgeNotEqual() {
        let v1 = Vertex(x: 1.0, y: 1.0)
        let v2 = Vertex(x: 1.0, y: 1.0)
        let v3 = Vertex(x: 1.0, y: 1.1)
        
        let e1 = Edge(vertex1: v1, vertex2: v2)
        let e2 = Edge(vertex1: v2, vertex2: v3)
        
        XCTAssertFalse(e1 == e2)
    }
}
