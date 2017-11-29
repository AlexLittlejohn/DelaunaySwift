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
    var next:PointNode? {
        didSet {
            _edge = nil
        }
    }
    
    var edges = [Edge]()
    
    fileprivate var _edge:Edge?
    
    var edge:Edge {
        get {
            if _edge == nil {
                _edge = Edge(point, next?.point ?? Point(x:0, y:0)) 
            }
            return _edge!
        }
    }
    
    init(_ point:Point, _ next:PointNode? = nil, _ prev:PointNode? = nil) {
        self.point = point
        self.next = next
        self.prev = prev
    }
    
}
