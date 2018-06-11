//
//  Delaunay.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//
//  Improved and Extended by Volodymyr Boichentsov on 14/11/2017

import Darwin
import Foundation

// Original
// http://paulbourke.net/papers/triangulate/

open class Delaunay : NSObject {
    
    public override init() { }
    
    /* Generates a supertraingle containing all other triangles */
    fileprivate func supertriangle(_ vertices: [Point]) -> [Point] {
        var xmin = Double(Int32.max)
        var ymin = Double(Int32.max)
        var xmax = -Double(Int32.max)
        var ymax = -Double(Int32.max)
        
        for i in 0..<vertices.count {
            if vertices[i].x < xmin { xmin = vertices[i].x }
            if vertices[i].x > xmax { xmax = vertices[i].x }
            if vertices[i].y < ymin { ymin = vertices[i].y }
            if vertices[i].y > ymax { ymax = vertices[i].y }
        }
        
        let dx = xmax - xmin
        let dy = ymax - ymin
        let dmax = max(dx, dy)
        let xmid = xmin + dx * 0.5
        let ymid = ymin + dy * 0.5
        
        return [
            Point(x: xmid - 200 * dmax, y: ymid - dmax, i: 9000000001),
            Point(x: xmid, y: ymid + 200 * dmax, i: 9000000002),
            Point(x: xmid + 200 * dmax, y: ymid - dmax, i: 9000000003)
        ]
    }
    
    fileprivate func dedup(_ e: inout [Edge]) {
        
        var e1: Edge?, e2: Edge?
        
        var j = e.count
        while j > 0 {
            j -= 1
            e1 = j < e.count ? e[j] : nil
            
            var i = j
            while i > 0 {
                i -= 1
                e2 = j < e.count ? e[i] : nil
                
                if (e1 == e2 && e1 != nil) {
                    e.removeSubrange(j...j)
                    e.removeSubrange(i...i)
                    break
                }
            }
        }
    }
    
    func _removeDuplicates(_ vertices: [Point]) -> [Point] {
        var _vertices = Array(Set(vertices))
        _vertices.sort { (p1, p2) -> Bool in
            return p1.index < p2.index
        }
        return _vertices
    }
    
    open func triangulate(_ vertices: [Point]) -> [Triangle] {

        var _vertices = _removeDuplicates(vertices) 
        
        guard _vertices.count >= 3 else {
            return [Triangle]()
        }

        let n = _vertices.count
        var open = [CircumCircle]()
        var completed = [CircumCircle]()
        var edges = [Edge]()
        
        /* Make an array of indices into the vertex array, sorted by the
        * vertices' x-position. */
        var indices = [Int](0..<n).sorted {  _vertices[$0].x < _vertices[$1].x }
        
        /* Next, find the vertices of the supertriangle (which contains all other
        * triangles) */
        
        _vertices += supertriangle(_vertices)
        
        /* Initialize the open list (containing the supertriangle and nothing
        * else) and the closed list (which is empty since we havn't processed
        * any triangles yet). */
        open.append(CircumCircle(_vertices[n], _vertices[n + 1], _vertices[n + 2]))
        
        /* Incrementally add each vertex to the mesh. */
        for i in 0..<n {
            let c = indices[i]
            
            edges.removeAll()
            
            /* For each open triangle, check to see if the current point is
            * inside it's circumcircle. If it is, remove the triangle and add
            * it's edges to an edge list. */
            for j in (0..<open.count).reversed() {
                
                /* If this point is to the right of this triangle's circumcircle,
                * then this triangle should never get checked again. Remove it
                * from the open list, add it to the closed list, and skip. */
                let dx = _vertices[c].x - open[j].c.x
                
                if dx > 0 && dx * dx > open[j].rsqr {
                    completed.append(open.remove(at: j))
                    continue
                }
                
                /* If we're outside the circumcircle, skip this triangle. */
                if !open[j].contain(_vertices[c]) {
                    continue
                }                
                
                /* Remove the triangle and add it's edges to the edge list. */
                edges += [
                    Edge(open[j].point1, open[j].point2),
                    Edge(open[j].point2, open[j].point3),
                    Edge(open[j].point3, open[j].point1)
                ]
                                
                open.remove(at: j)
            }
            
            /* Remove any doubled edges. */
            dedup(&edges)
            
            /* Add a new triangle for each edge. */
            for e in edges {
                open.append(CircumCircle(e.a, e.b, _vertices[c]))
            }
        }
        
        /* Copy any remaining open triangles to the closed list, and then
        * remove any triangles that share a vertex with the supertriangle,
        * building a list of triplets that represent triangles. */
        completed += open
        
        let ignored: Set<Point> = [_vertices[n], _vertices[n + 1], _vertices[n + 2]]
        
        let results = completed.compactMap { (circumCircle) -> Triangle? in
            
            let current: Set<Point> = [circumCircle.point1, circumCircle.point2, circumCircle.point3]
            let intersection = ignored.intersection(current)
            if intersection.count > 0 {
                return nil
            }
            
            return circumCircle.triangle()
        }
        
        /* Yay, we're done! */
        return results
    }
}
