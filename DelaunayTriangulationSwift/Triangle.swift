//
//  Triangle.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

/// A simple struct representing 3 vertices
public struct Triangle {
    
    public init(vertice1: Vertice, vertice2: Vertice, vertice3: Vertice) {
        self.vertice1 = vertice1
        self.vertice2 = vertice2
        self.vertice3 = vertice3
    }
    
    public let vertice1: Vertice
    public let vertice2: Vertice
    public let vertice3: Vertice
}
