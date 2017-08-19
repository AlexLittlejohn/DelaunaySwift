//
//  Edge.swift
//  DelaunaySwift
//
//  Created by Alex Littlejohn on 2016/04/07.
//  Copyright © 2016 zero. All rights reserved.
//


struct Edge {
    let vertex1: Vertex
    let vertex2: Vertex
}

extension Edge: Equatable {}

func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.vertex1 == rhs.vertex1 && lhs.vertex2 == rhs.vertex2 || lhs.vertex1 == rhs.vertex2 && lhs.vertex2 == rhs.vertex1
}

extension Edge: Hashable {
    var hashValue: Int {
        return Int((vertex1.x+vertex1.y+vertex2.x+vertex2.y)*1000000.0)
    }
}
