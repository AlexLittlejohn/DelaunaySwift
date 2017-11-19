//
//  Edge.swift
//  Delaunay
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 sakrist. All rights reserved.

struct Edge {
    let a: Point
    let b: Point
    
    init(first: Point, second: Point) {
        self.a = first
        self.b = second
    }
    
    init(_ first: Point, _ second: Point) {
        self.a = first
        self.b = second
    }
    
    /// Test if a and b is equal, then edge is reduntal
    ///
    /// - Returns: bool value
    func isRedundant() -> Bool {
        return a == b
    }
    
    /// Returns boolean indicating whether edges ab and cd intersect.
    ///
    /// - Parameter edge: another edge for test
    func intersect(edge:Edge) -> Bool {
        // The edges intersect only if the endpoints of one edge are on the opposite
        // sides of the other (both ways).
        let u = self.a - self.b
        let su = u.cross(self.a - edge.a) * u.cross(self.a - edge.b)
        // If su is positive, the endpoints c and d are on the same side of
        // edge ab.
        if (su > 0) {
            return false;
        }
        let v = edge.a - edge.b
        let sv = v.cross(edge.a - self.a) * v.cross(edge.a - self.b)
        if (sv > 0) {
            return false
        }
        // We still have to check for collinearity.
        if (su == 0 && sv == 0) {
            let abLenSq = a.distanceSqrt(b)
            return a.distanceSqrt(edge.a) <= abLenSq || a.distanceSqrt(edge.b) <= abLenSq
        }
        return true;
    }
    
    // Point to edge distance
    func distanceSqrt(_ point:Point) -> Double {
        let uv = a - b
        let uvLenSq = uv.lengthSqrt()
        let uvxpu = uv.cross(point - a)
        return uvxpu * uvxpu / uvLenSq
    }
}

extension Edge {
    func contain(point:Point) -> Bool {
        if self.isRedundant() {
            return false
        }
        return (point.x - a.x) / (b.x - a.x) == (point.y - a.y) / (b.y - a.y)
    }
}


//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.

extension Edge: Equatable {
    static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return (lhs.a == rhs.a && lhs.b == rhs.b) || (lhs.a == rhs.b && lhs.b == rhs.a)
    }
}

extension Edge: Hashable {
    var hashValue: Int {
        var seed = UInt(0)
        let preHashValue:Int = a.hashValue / b.hashValue + b.hashValue / a.hashValue
        hash_combine(seed: &seed, value: UInt(bitPattern: preHashValue))
        return Int(bitPattern: seed)
    }
}
