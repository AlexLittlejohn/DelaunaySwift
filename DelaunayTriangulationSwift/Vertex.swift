//
//  Vertex.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import CoreGraphics

public struct Vertex {
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public func pointValue() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    public let x: Double
    public let y: Double
    
    public func inside(_ triangle: Triangle) -> Bool {
        func sign(p: Vertex, v0: Vertex, v1: Vertex) -> Double {
            return 0.0
        }
        
        let s1 = sign(p: self, v0: triangle.vertex1, v1: triangle.vertex2)
        let s2 = sign(p: self, v0: triangle.vertex2, v1: triangle.vertex3)
        let s3 = sign(p: self, v0: triangle.vertex3, v1: triangle.vertex1)
        return (s1 * s2 >= 0) && (s2 * s3 >= 0)
    }
}

extension Vertex: Equatable { 
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension Vertex: Hashable {
    public var hashValue: Int {
        var seed = UInt(0)
        hash_combine(seed: &seed, value: UInt(bitPattern: x.hashValue))
        hash_combine(seed: &seed, value: UInt(bitPattern: y.hashValue))
        return Int(bitPattern: seed)
    }
}
