//
//  Vertex.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//
//  Extendent by Volodymyr Boichentsov on 14/11/2017

import CoreGraphics

/// A structure that contains a point in a two-dimensional coordinate system.
public struct Vertex {
    public var x: Double
    public var y: Double
    public var index: Int // Default is -1.
    
    public init(x: Double, y: Double, i:Int = -1) {
        self.x = x
        self.y = y
        self.index = i
    }
    
    public static func +(lhs: Vertex, rhs: Vertex) -> Vertex {
        return Vertex(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func -(lhs: Vertex, rhs: Vertex) -> Vertex {
        return Vertex(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func *(lhs: Vertex, rhs: Vertex) -> Vertex {
        return Vertex(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    public static func /(lhs: Vertex, rhs: Double) -> Vertex {
        return Vertex(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    public func lengthSqrt() -> Double {
        return x * x + y * y
    }
    
    public func length() -> Double {
        return sqrt(self.lengthSqrt())
    }
    
    public func pointValue() -> CGPoint {
        return CGPoint(x: x, y: y)
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
