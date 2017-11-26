//
//  PointNode.swift
//  Delaunay
//
//  Created by Volodymyr Boichentsov on 19/11/2017.
//  Copyright © 2017 sakrist. All rights reserved.
//

import Foundation

class PointNode {
    
    let point:Point
    var prev:PointNode?
    var next:PointNode?
    
    var edges = [Edge]()
    
    var edge:Edge {
        get {
            return Edge(point, next?.point ?? Point(x:0, y:0))
        }
    }
    
    init(_ point:Point, _ next:PointNode? = nil, _ prev:PointNode? = nil) {
        self.point = point
        self.next = next
        self.prev = prev
    }
    
}
