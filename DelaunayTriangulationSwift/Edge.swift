//
//  Edge.swift
//  DelaunaySwift
//
//  Created by Alex Littlejohn on 2016/04/07.
//  Copyright © 2016 zero. All rights reserved.
//
//  Extendent by Volodymyr Boichentsov on 14/11/2017

struct Edge {
    let vertex1: Vertex
    let vertex2: Vertex
    
    init(first: Vertex, second: Vertex) {
        self.vertex1 = first
        self.vertex2 = second
    }
    
    func isRedundant() -> Bool {
        return vertex1 == vertex2
    }
}

extension Edge {
    func contain(vertex:Vertex) -> Bool {

        if self.isRedundant() {
            return false;
        }
        
        let aTmp = vertex2 - vertex1;
        let bTmp = vertex - vertex1;
        
        let r = aTmp.x * bTmp.y - bTmp.x * aTmp.y;
        return abs(r) < .ulpOfOne;
    }
}

extension Edge: Equatable {
    static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.vertex1 == rhs.vertex1 && lhs.vertex2 == rhs.vertex2 || lhs.vertex1 == rhs.vertex2 && lhs.vertex2 == rhs.vertex1
    }
}

extension Edge: Hashable {
    var hashValue: Int {
        var seed = UInt(0)
        hash_combine(seed: &seed, value: UInt(bitPattern: vertex1.hashValue))
        hash_combine(seed: &seed, value: UInt(bitPattern: vertex2.hashValue))
        return Int(bitPattern: seed)
    }
}
